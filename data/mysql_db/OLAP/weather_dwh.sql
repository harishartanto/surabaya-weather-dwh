create table if not exists dim_location
(
    sk                 int auto_increment
        primary key,
    prov_id            int            null,
    city_id            int            null,
    district_id        int            null,
    prov_name          varchar(64)    null,
    city_name          varchar(64)    null,
    district_name      varchar(64)    null,
    district_lat_dd    decimal(11, 8) null,
    district_long_dd   decimal(11, 8) null,
    district_elevation decimal(5, 1)  null,
    last_update        datetime       null
);

create index loc_city_key
    on dim_location (city_name);

create index loc_prov_key
    on dim_location (prov_name);

create table if not exists dim_rainfall
(
    sk                 int           not null
        primary key,
    rainfall_intensity varchar(24)   null,
    pcp_min            decimal(5, 1) null,
    pcp_max            decimal(5, 1) null,
    last_update        datetime      null
);

create index rainfall_key
    on dim_rainfall (rainfall_intensity);

create table if not exists dim_time
(
    sk    int auto_increment
        primary key,
    date  date null,
    year  int  null,
    month int  null,
    day   int  null
);

create index month_key
    on dim_time (month);

create index year_key
    on dim_time (year);

create table if not exists dim_weather_condition
(
    sk                int auto_increment
        primary key,
    weather_code      int      null,
    weather_code_desc text     null,
    last_update       datetime null
);

create index weather_code_key
    on dim_weather_condition (weather_code);

create table if not exists fact_weather
(
    id                varchar(24)   not null
        primary key,
    temperature_avg   decimal(3, 1) null,
    humidity_avg      int           null,
    precipitation_sum decimal(4, 1) null,
    daylight_duration decimal(7, 2) null,
    daylight_percent  decimal(4, 1) null,
    wind_speed        decimal(4, 1) null,
    wind_direction    int           null,
    time_sk           int           null,
    location_sk       int           null,
    rainfall_sk       int           null,
    weather_sk        int           null,
    last_update       datetime      null,
    constraint fact_weather_dim_location_fk
        foreign key (location_sk) references dim_location (sk)
            on update cascade,
    constraint fact_weather_dim_rainfall_fk
        foreign key (rainfall_sk) references dim_rainfall (sk)
            on update cascade,
    constraint fact_weather_dim_time_fk
        foreign key (time_sk) references dim_time (sk)
            on update cascade,
    constraint fact_weather_dim_weather_condition_fk
        foreign key (weather_sk) references dim_weather_condition (sk)
            on update cascade
);

create index location_key
    on fact_weather (location_sk);

create index rainfall_key
    on fact_weather (rainfall_sk);

create index time_key
    on fact_weather (time_sk);

create index weather_key
    on fact_weather (weather_sk);


