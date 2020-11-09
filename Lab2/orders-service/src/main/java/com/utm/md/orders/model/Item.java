package com.utm.md.orders.model;

import lombok.*;

import javax.persistence.*;
import java.util.Collection;
import java.util.UUID;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data
@Table(name = "items", schema = "pbl_orders_service")
public class Item {
    @Id
    @GeneratedValue
    @Setter(AccessLevel.NONE)
    private UUID id;

    @ManyToMany(mappedBy = "items")
    private Collection<Ordeer> ordeers;

    private String name;

    private Float price;
}
