package com.utm.md.orders.model;

import lombok.*;

import javax.persistence.*;
import java.util.Collection;
import java.util.UUID;

@Entity
@NoArgsConstructor
@Data
@Table(name = "ordeers", schema = "pbl_orders_service")
public class Ordeer {
    @Id
    @GeneratedValue
    @Setter(AccessLevel.NONE)
    private UUID id;

    @OneToMany(cascade = CascadeType.PERSIST)
    private Collection<Item> items;

    private Boolean isPrepared;
}
