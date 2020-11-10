package com.utm.md.orders.model;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.*;

import javax.persistence.*;
import java.util.Collection;
import java.util.UUID;

@Entity
@NoArgsConstructor
@Data
@Table(name = "ordeers", schema = "pbl_orders_service")
@JsonIdentityInfo(
        generator = ObjectIdGenerators.PropertyGenerator.class,
        property = "id"
)
public class Ordeer {
    @Id
    @GeneratedValue
    @Setter(AccessLevel.NONE)
    private UUID id;

    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(
            name = "ordeers_items",
            schema = "pbl_orders_service",
            joinColumns = { @JoinColumn(name = "ordeer_id") },
            inverseJoinColumns = { @JoinColumn(name = "item_id") }
    )
    @JsonIgnore
    private Collection<Item> items;

    private Boolean isPrepared;
}
