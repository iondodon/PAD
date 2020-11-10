package com.utm.md.orders.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.utm.md.orders.model.Ordeer;
import lombok.*;

import java.util.Collection;
import java.util.UUID;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class ItemDto {
    private UUID id;
    private String name;
    private Collection<Ordeer> ordeers;
    private Float price;
}
