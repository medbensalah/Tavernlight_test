-- Q1: Moved the storage released check to releaseStorage function
--     to avoid code duplication in case it is called elsewhere
--     and to ensure separation of concern as that check is related to releasing storage not logging out

local function releaseStorage(player)
    if player:getStorageValue(1000) == 1 then
        player:setStorageValue(1000, -1)
    end
end

function onLogout(player)
        addEvent(releaseStorage, 1000, player)
    return true
end

-- Q2: 1- used prepared statement to prevent SQL injection
--     2- added error handling to check if the query was returned a result
--     3- looping over the result set as the original code only fetches the first row
function printSmallGuildNames(memberCount)
  -- This method prints names of all guilds with less than memberCount max members

  local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < ?"

  -- Prepare the statement
  local preparedStmt = db:prepare(selectGuildQuery)

  -- Bind the member count parameter
  preparedStmt:setInt(1, memberCount)

  -- Execute the prepared statement
  local results = preparedStmt:execute()

  -- Error handling
  if results then 
    while result:next() do
      local guildName = result:getDataString("name")
      print(guildName)
    end
  else
    print("Error fetching guild names")
  end

  -- Close the prepared statement
  preparedStmt:close()
end


-- Q3: 1- added error handling to check for aparty
--     2- added error handling to check if the member was in the party
--     3- added return statement to exit the function after removing the member
--     4- added check by getting the member name from the current value of the loop rather than creating a player instance
function do_sth_with_PlayerParty(playerId, membername)
    local player = Player(playerId)
    local party = player:getParty()
    if not party then
        print("Player is not in a party.")
        return
    end
    
    local partyMembers = party:getMembers()
    for _, member in pairs(partyMembers) do
        if member:getName() == membername then
            party:removeMember(member)
            return
        end
    end
    
    print(f"Member {memberName} is not in player {playerId}'s party.")
end