create table pbl_orders_service.items (id uuid not null, name varchar(255), price float4, primary key (id))
create table pbl_orders_service.ordeers (id uuid not null, is_prepared boolean, primary key (id))
create table ordeers_items (ordeer_id uuid not null, items_id uuid not null)
alter table if exists ordeers_items add constraint UK_rvw54ykhvw8cgbrrpcm2elwut unique (items_id)
alter table if exists ordeers_items add constraint FK7wo8835bf932aq6uqxx0es3gm foreign key (items_id) references pbl_orders_service.items
alter table if exists ordeers_items add constraint FKbdkhbgv5tsxpcu8eyebwwhteb foreign key (ordeer_id) references pbl_orders_service.ordeers
create table pbl_orders_service.items (id uuid not null, name varchar(255), price float4, primary key (id))
create table pbl_orders_service.ordeers (id uuid not null, is_prepared boolean, primary key (id))
create table ordeers_items (ordeer_id uuid not null, items_id uuid not null)
alter table if exists ordeers_items add constraint UK_rvw54ykhvw8cgbrrpcm2elwut unique (items_id)
alter table if exists ordeers_items add constraint FK7wo8835bf932aq6uqxx0es3gm foreign key (items_id) references pbl_orders_service.items
alter table if exists ordeers_items add constraint FKbdkhbgv5tsxpcu8eyebwwhteb foreign key (ordeer_id) references pbl_orders_service.ordeers
create table pbl_orders_service.items (id uuid not null, name varchar(255), price float4, primary key (id))
create table pbl_orders_service.ordeers (id uuid not null, is_prepared boolean, primary key (id))
create table ordeers_items (ordeer_id uuid not null, items_id uuid not null)
alter table if exists ordeers_items add constraint UK_rvw54ykhvw8cgbrrpcm2elwut unique (items_id)
alter table if exists ordeers_items add constraint FK7wo8835bf932aq6uqxx0es3gm foreign key (items_id) references pbl_orders_service.items
alter table if exists ordeers_items add constraint FKbdkhbgv5tsxpcu8eyebwwhteb foreign key (ordeer_id) references pbl_orders_service.ordeers
