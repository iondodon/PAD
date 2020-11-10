package com.utm.md.orders.dto;

import com.utm.md.orders.model.Item;
import lombok.Data;

import java.util.Collection;
import java.util.UUID;

@Data
public class OrdeerDto {
    private UUID id;
    private Collection<Item> items;
    private Boolean isPrepared;
}
