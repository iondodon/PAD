package com.utm.md.orders.dto;

import com.utm.md.orders.model.Item;
import lombok.AccessLevel;
import lombok.Data;
import lombok.Setter;

import java.util.Collection;
import java.util.UUID;

@Data
public class OrdeerDto {
    @Setter(AccessLevel.NONE)
    private UUID id;

    private Collection<Item> items;

    private Boolean isPrepared;
}
