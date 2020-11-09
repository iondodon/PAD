package com.utm.md.orders.service.items;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.utm.md.orders.dto.ItemDto;
import com.utm.md.orders.model.Item;
import com.utm.md.orders.repository.ItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ItemServiceImpl implements ItemService {
    private final ObjectMapper objectMapper;
    private final ItemRepository itemRepository;

    @Override
    public void createItem(ItemDto itemDto) {
        ObjectMapper objectMapper = new ObjectMapper();
        Item item  = objectMapper.convertValue(itemDto, Item.class);
        itemRepository.save(item);
    }

    @Override
    public Collection<ItemDto> getAllItems() {
        Collection<Item> items = itemRepository.findAll();
        Collection<ItemDto> itemDtos = items.stream().map(
                (item) -> objectMapper.convertValue(item, ItemDto.class)
        ).collect(Collectors.toList());
        return itemDtos;
    }
}
