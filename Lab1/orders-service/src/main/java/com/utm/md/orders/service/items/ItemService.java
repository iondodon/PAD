package com.utm.md.orders.service.items;

import com.utm.md.orders.dto.ItemDto;

import java.util.Collection;
import java.util.UUID;

public interface ItemService {
    void createItem(ItemDto item);
    Collection<ItemDto> getAllItems();
    ItemDto deleteItem(UUID itemID);
}
