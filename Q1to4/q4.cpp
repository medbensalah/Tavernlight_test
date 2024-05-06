void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }
}

#include <memory> // for std::unique_ptr for automatic memory management

// return int for error code
uint8_t Game::addItemToPlayer(const std::string& recipient, uint16_t itemId) {
    std::unique_ptr<Player> player = g_game.getPlayerByName(recipient);

    if (!player) {
        player = std::make_unique<Player>(nullptr);
        if (!IOLoginData::loadPlayerByName(player.get(), recipient)) {
            return 1; // failure to add item
        }
    }

    std::unique_ptr<Item> item = Item::CreateItem(itemId);
    if (!item) {
        return 2; // failure to add item
    }

    // Add item to player's inbox
    //given that getInbox returns a reference (does not copy data because that's not allowed for unique_ptr)
    g_game.internalAddItem(player->getInbox(), item.get(), INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player.get());
    }

    return 0; // success
}
