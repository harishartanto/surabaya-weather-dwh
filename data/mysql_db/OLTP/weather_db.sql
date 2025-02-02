create table if not exists province
(
    prov_id      int            not null comment 'Administrative region code level I (province) of the Ministry of Home Affairs'
        primary key,
    prov_name    varchar(64)    null comment 'Province name',
    prov_lat_dd  decimal(11, 8) null comment 'Province latitude in decimal degrees',
    prov_long_dd decimal(11, 8) null comment 'Province longitude in decimal degrees',
    created      datetime       null,
    updated      datetime       null
);

create table if not exists city
(
    city_id      int            not null comment 'Administrative region code level II of the Ministry of Home Affairs'
        primary key,
    prov_id      int            null,
    city_name    varchar(64)    null,
    city_lat_dd  decimal(11, 8) null comment 'City latitude in decimal degrees',
    city_long_dd decimal(11, 8) null comment 'City longitude in decimal degrees',
    created      datetime       null,
    updated      datetime       null,
    constraint city_province_fk
        foreign key (prov_id) references province (prov_id)
            on update cascade
);

create definer = root@localhost trigger trigger_city_insert
    before insert
    on city
    for each row
begin
    set new.created = sysdate();
    set new.updated = sysdate();
end;

create definer = root@localhost trigger trigger_city_updated
    before update
    on city
    for each row
begin
    set new.updated = sysdate();
end;

create table if not exists district
(
    district_id        int            not null comment 'Administrative region code level III of the Ministry of Home Affairs'
        primary key,
    city_id            int            not null,
    district_name      varchar(64)    not null,
    district_lat_dd    decimal(11, 8) not null comment 'District latitude in decimal degrees',
    district_long_dd   decimal(11, 8) not null comment 'District longitude in decimal degrees',
    district_elevation decimal(5, 1)  not null,
    created            datetime       not null,
    updated            datetime       not null,
    constraint district_city_fk
        foreign key (city_id) references city (city_id)
            on update cascade
);

create definer = root@localhost trigger trigger_district_insert
    before insert
    on district
    for each row
begin
    set new.created = sysdate();
    set new.updated = sysdate();
end;

create definer = root@localhost trigger trigger_district_update
    before update
    on district
    for each row
begin
    set new.updated = sysdate();
end;

create definer = root@localhost trigger trigger_province_insert
    before insert
    on province
    for each row
begin
    set new.created = sysdate();
    set new.updated = sysdate();
end;

create definer = root@localhost trigger trigger_province_update
    before update
    on province
    for each row
begin
    set new.updated = sysdate();
end;

create table if not exists weather_condition
(
    weather_code      int      not null comment 'WMO Code 4677'
        primary key,
    weather_code_desc text     null comment 'WMO code 4677 description',
    created           datetime null,
    updated           datetime null
)
    comment 'WMO Code 4677:  Present weather reported from a manned station';

create definer = root@localhost trigger trigger_weather_code_insert
    before insert
    on weather_condition
    for each row
begin
    set new.created = sysdate();
    set new.updated = sysdate();
end;

create definer = root@localhost trigger trigger_weather_code_update
    before update
    on weather_condition
    for each row
begin
    set new.updated = sysdate();
end;

create table if not exists weather_daily
(
    weather_id        int auto_increment
        primary key,
    district_id       int           not null,
    weather_code      int           not null comment 'The most severe weather condition on a given day as a numeric code. Follow WMO weather interpretation codes.',
    date              date          not null,
    temperature_avg   decimal(3, 1) null comment 'Average daily air temperature at 2 meters above ground',
    humidity_avg      int           null comment 'Maximum, minimum and mean daily relative humidity at 2 meters above ground.',
    precipitation_sum decimal(4, 1) null comment 'Sum of daily precipitation (including rain, showers and snowfall)',
    daylight_duration decimal(7, 2) null comment 'Number of seconds of daylight per day',
    wind_speed        decimal(4, 1) null comment 'Maximum wind speed on a day',
    wind_direction    int           null comment 'Dominant wind direction',
    created           datetime      null,
    updated           datetime      null,
    constraint weather_daily_code_fk
        foreign key (weather_code) references weather_condition (weather_code)
            on update cascade,
    constraint weather_daily_location_fk
        foreign key (district_id) references district (district_id)
            on update cascade
);

create definer = root@localhost trigger trigger_weather_daily_insert
    before insert
    on weather_daily
    for each row
begin
    set new.created = sysdate();
    set new.updated = sysdate();
end;

create definer = root@localhost trigger trigger_weather_daily_updated
    before update
    on weather_daily
    for each row
begin
    set new.updated = sysdate();
end;


