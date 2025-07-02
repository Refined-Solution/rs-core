---@class Player
---@field player number the helix rplayer object
---@field activeCharacter Character?
---@field data Cache the data cache for this rplayer
Player = {}

---Creates a new entry in the database for this rplayer.
---@param rplayer Player the rplayer to create an entry for
local function create(rplayer)
    -- TODO: implement the database creation logic
    --       this requires more intel on the HELIX scripting API
end

---Loads the data for the given rplayer from the database.
---@nodiscard
---@param rplayer Player the rplayer to load data for
---@return boolean success true if the data was loaded successfully, false otherwise
local function load(rplayer)
    -- TODO: implement the database loading logic
    --       this requires more intel on the HELIX scripting API
    return true
end

---Loads the groups for the given rplayer.
---@nodiscard
---@param rplayer Player the rplayer to refresh groups for
---@return table<number> groups the ids of the discord roles the rplayer has
local function getGroups(rplayer)
    -- TODO: implement the discord group refresh logic
    --       this requires more intel on the HELIX scripting API
    return {}
end

setmetatable(Player, {
    __call = function (t, player)
        local rplayer = {}
        setmetatable(rplayer, Player)
        rplayer.player = player
        rplayer.data = Cache() --[[@as Cache]]

        -- we may need to add all the functions here since metatables might not work.
        -- at least they didn't work in fivem when sharing this object with other scripts.

        return rplayer
    end
})
Player.__index = Player

---Loads the rplayer object for the given rplayer.
---If the rplayer does not have an entry in the database, it will return nil.
---@nodiscard
---@param source number the helix rplayer object
---@return Player? rplayer the loaded Player instance or nil if the rplayer does not have an entry
function Player.load(source)
    local rplayer = Player(source)
    if not load(rplayer) then
        return nil
    end
    return rplayer
end

---Creates a new Player Object that will be saved directly into the database.
---@nodiscard
---@param player number the player server id
---@return Player rplayer the new Player instance
function Player.new(player)
    local rplayer = Player(player) --[[@as Player]]
    create(rplayer)
    rplayer:trigger('rs:core:rplayer:new')
    Events.Call('rs:core:rplayer:new', rplayer)
    return rplayer
end

---Returns the character the rplayer is currently playing.
---This will return nil if the rplayer is currently not playing any character.
---@nodiscard
---@return Character? activeCharacter the character that is currently active for the rplayer.
function Player:getActiveCharacter()
    return self.activeCharacter
end

---Sets the character the rplayer is currently playing. This will only work
---if the character isn't currently used by another rplayer.
---@param character Character? the character to set as active for this rplayer.
---@return boolean success true if the character was successfully set as active for the rplayer, false otherwise.
function Player:setActiveCharacter(character)
    if self.activeCharacter then
        self.activeCharacter:sleep()
        self.activeCharacter = nil
    end

    if (character and character:wake(self)) or (not character) then
        self.activeCharacter = character
        return true
    end
    return false
end

---Returns whether or not the rplayer is currently in a character.
---Players are not in a character when they just joined the server, and are currently in the
---multicharacter selection menu.
---@nodiscard
---@return boolean inCharacter true if the rplayer is currently in a character, false otherwise.
function Player:isInCharacter()
    return self.activeCharacter ~= nil
end

---Returns the identifier of this rplayer.
---@nodiscard
---@return string identifier the identifier of this rplayer
function Player:getIdentifier()
    return self.data:get('identifier', function ()
        return HPlayer.GetByIndex(self.player):GetIdentifier()
    end)
end

---Checks if this rplayer has the given group.
---Groups are synchronized with the Discord roles of the rplayer.
---@nodiscard
---@param group number the role id to check for (NOT THE NAME!)
---@return boolean hasGroup true if the rplayer has the group, false otherwise
function Player:hasGroup(group)
    local groups = self.data:get('groups', function ()
        return Collection(getGroups(self))
    end) --[[@as Collection]]
    return groups:contains(group)
end

---Returns the name of this rplayer.
---@nodiscard
---@return string name the name of this rplayer
function Player:getName()
    return HPlayer.GetByIndex(self.player):GetName()
end

---Triggers the given event on this rplayer.
---@param event string the name of the event to trigger
---@param ... any the arguments to pass to the event handler
function Player:trigger(event, ...)
    TriggerClientEvent(event, self.player, ...)
end

---Called when the rplayer leaves the server.
---This will save the current character and do all the necessary cleanup.
function Player:logout()
    self:setActiveCharacter(nil)
end
