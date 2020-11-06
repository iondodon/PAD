package com.utm.md.orders.dto;

import lombok.*;

import java.util.UUID;

@Data
public class ItemDto {
    @Setter(AccessLevel.NONE)
    private UUID id;

    private String name;

    private Float price;
}
