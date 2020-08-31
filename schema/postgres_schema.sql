create type listing_status_enum as enum ('Active', 'Pending', 'Sold', 'Off_Market');
create type listing_set_type_enum as enum ('listing-set', 'named-query');
create type listing_update_type_enum as enum ('new', 'price', 'status', 'openhouse');
create type notification_type_enum as enum ('cobuyer:invited', 'cobuyer:accepted', 'cobuyer:rejected', 'cobuyer:removed', 'collection:added', 'collection:removed', 'collection:edited', 'savedSearch:cobuyerCreated', 'savedSearch:agentCreated', 'guide:shared', 'guide:stepComplete', 'guide:stepIncomplete');
create table listing_set
(
    listing_set_id     varchar(80)           not null
        constraint listing_set_pk
            primary key,
    listing_set_type   listing_set_type_enum not null,
    listing_set_name   varchar(120) not null,
    listing_set_config jsonb
);

create table user_listing_set
(
    user_id        varchar(80) not null,
    listing_set_id varchar(80) not null
        constraint user_listing_set_listing_set_listing_set_id_fk
            references listing_set,
    constraint user_collection_pk
        primary key (user_id, listing_set_id)
);

create index user_listing_set_user_id_listing_set_id_index
    on user_listing_set (user_id, listing_set_id);

create index user_listing_set_collection_id_index
    on user_listing_set (listing_set_id);

create table listing
(
    listing_id varchar(80) not null
        constraint listing_pk
            primary key,
    address    jsonb       not null,
    price      money,
    sqft       integer,
    bedrooms   integer,
    bathrooms  numeric(2),
    images     varchar(1000)[],
    status     listing_status_enum
);

create table listing_set_listing
(
    listing_set_id varchar(80) not null
        constraint listing_set_listing_listing_set_listing_set_id_fk
            references listing_set,
    listing_id     varchar(80) not null
        constraint listing_set_listing_listing_listing_id_fk
            references listing,
    constraint listing_set_listing_pk
        primary key (listing_set_id, listing_id)
);

create index listing_set_listing_listing_set_id_index
    on listing_set_listing (listing_set_id);

create table listing_update
(
    id             serial                   not null
        constraint listing_update_pk
            primary key,
    ts             timestamp                not null,
    update_type    listing_update_type_enum not null,
    listing_id     varchar(80)              not null
        constraint listing_update_listing_listing_id_fk
            references listing,
    update_details jsonb
);

create index listing_update_listing_id_ts_index
    on listing_update (listing_id, ts);

create table open_house
(
    id              serial not null
        constraint open_house_pk
            primary key,
    listing_id      varchar(80)
        constraint open_house_listing_listing_id_fk
            references listing,
    start_date_time timestamp,
    end_date_time   timestamp,
    description     varchar(1000)
);

create index open_house_listing_id_end_date_time_index
    on open_house (listing_id, end_date_time);

create table user_profile
(
    user_id            varchar(80)           not null
        constraint user_profile_pk
            primary key,
    home_id            varchar(80),
    address            varchar(256),
    sqft               integer,
    bedrooms           integer,
    bathrooms          numeric(2),
    has_mortgage       boolean default false not null,
    loan_amount        integer,
    loan_interest_rate numeric(2),
    loan_term          integer,
    loan_start         date
);

create table notification
(
    id                   serial                              not null
        constraint notification_pk
            primary key,
    ts                   timestamp default CURRENT_TIMESTAMP not null,
    user_id              varchar(80)                         not null
        constraint notification_user_profile_user_id_fk
            references user_profile,
    has_read             boolean   default false             not null,
    notification_type    notification_type_enum              not null,
    notification_content varchar(256)                        not null,
    payload              jsonb,
    is_priority          boolean,
    notification_heading varchar(256)
);

create index notification_user_id_has_read_ts_index
    on notification (user_id, has_read, ts);

create table mortgage_rate_history
(
    id        serial                    not null
        constraint mortgage_rate_history_pk
            primary key,
    country   char(3)                   not null,
    rundate   date default CURRENT_DATE not null,
    price_15y numeric(5),
    price_30y numeric(5),
    rate_15y  numeric(3),
    rate_30y  numeric(3)
);
create index mortgage_rate_history_country_rundate_index
    on mortgage_rate_history (country, rundate);


