package com.utm.md.orders.service.items;

import com.utm.md.orders.dto.ItemDto;

import java.util.Collection;

public interface ItemService {
    void createItem(ItemDto item);
    Collection<ItemDto> getAllItems();
}
