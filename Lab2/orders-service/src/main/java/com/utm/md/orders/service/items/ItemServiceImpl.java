package com.utm.md.orders.service.items;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.utm.md.orders.dto.ItemDto;
import com.utm.md.orders.model.Item;
import com.utm.md.orders.repository.ItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import javax.transaction.Transactional;
import java.util.Collection;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ItemServiceImpl implements ItemService {
    private final ObjectMapper objectMapper;
    private final ItemRepository itemRepository;

    @Override
    @Transactional
    public void createItem(ItemDto itemDto) {
        ObjectMapper objectMapper = new ObjectMapper();
        Item item  = objectMapper.convertValue(itemDto, Item.class);
        itemRepository.save(item);
    }

    @Override
    @Transactional
    public Collection<ItemDto> getAllItems() {
        Collection<Item> items = itemRepository.findAll();
        return items.stream().map(
                (item) -> objectMapper.convertValue(item, ItemDto.class)
        ).collect(Collectors.toList());
    }

    @Override
    public ItemDto deleteItem(UUID itemID) {
        Item item = itemRepository.getOne(itemID);
        Assert.notNull(item, "Item not found");
        itemRepository.delete(item);
        return objectMapper.convertValue(item, ItemDto.class);
    }
}
