---A core character holds all the information about a character.
---@class Character
---@field possesedBy Player? the rplayer that is currently playing this character.
---@field citizenId string the unique id of the character.
---@field firstName string the first name of the character.
---@field lastName string the last name of the character.
---@field dateOfBirth string the date of birth of the character in the format YYYY-MM
---@field gender boolean false: male, true: female
---@field bid string the bid of the rplayers primary banking account.
---@field invId number the id of the rplayers primary inventory.
---@field cache Cache cached data for this character.
Character = {}
setmetatable(Character, {
    __call = function(t, id)
        local character = {}
        setmetatable(character, Character)
        character.citizenId = id
        character.firstName = ''
        character.lastName = ''
        character.dateOfBirth = ''
        character.gender = false
        character.bid = ''
        character.invId = 0
        character.cache = Cache()
        return character
    end
})
Character.__index = Character

---@class Character.Data
---@field citizenId string the unique id of the character.
---@field firstName string the first name of the character.
---@field lastName string the last name of the character.
---@field dateOfBirth string the date of birth of the character in the format YYYY-MM
---@field gender boolean true if the character is Female

---@type Cache
local characters = Cache()

---Creates a new entry in the database for this character.
---@param character Character the character to create an entry for
local function create(character)
    -- TODO: implement the database creation logic
    --       this requires more intel on the HELIX scripting API
end

---Loads the data for the given character from the database.
---This will return true if the character was loaded successfully, false otherwise.
---@nodiscard
---@param character Character the character to load data for
---@return boolean success true if the data was loaded successfully, false otherwise
local function load(character)
    -- TODO: implement the database loading logic
    --       this requires more intel on the HELIX scripting API
    return true
end

---Loads the core character object for the given citizenId.
---@nodiscard
---@param citizenId string the unique id of the character to load.
---@return Character? character the loaded Character instance or nil if the character does not have an entry.
function Character.load(citizenId)
    return characters:get(citizenId, function()
        local character = Character(citizenId)
        if load(character) then
            return character
        end
    end)
end

---Creates a new core character object and saves it into the database.
---This will generate a new citizenId for the character.
---@nodiscard
---@param firstName string the first name of the character.
---@param lastName string the last name of the character.
---@param dateOfBirth string the date of birth of the character in the format YYYY-MM
---@param gender boolean true if this character is female
---@return Character ccharacter the new core character object.
function Character.new(firstName, lastName, dateOfBirth, gender)
    local id = Config.Generator.citizenId()
    local character = Character(id)
    character.firstName = firstName
    character.lastName = lastName
    character.dateOfBirth = dateOfBirth
    character.gender = gender
    local account = Account.new()
    character.bid = account.id
    local inventory = Inventory.new(Config.inventory.slotCount, Config.inventory.maxWeight)
    character.invId = inventory.id
    return character
end

---Marks this character as active for the given rplayer.
---A character can only be active for one rplayer at a time.
---@param rplayer Player the rplayer to set this character as active for.
---@return boolean success true if the character was successfully set as active for the rplayer, false otherwise.
function Character:wake(rplayer)
    if self.possesedBy then
        return false
    end

    self.possesedBy = rplayer
    rplayer:trigger('rs:core:character:wake', self:getData())
    Core.LogSystem:createEntry(
        "rs-core",
        { "wake", "character", "character:wake" },
        StringUtils.format("Player {name} is now playing {character}.", {
            name = rplayer:getName(),
            character = self:getName()
        }),
        {
            rplayerIdentifier = rplayer:getIdentifier(), characterId = self.citizenId,
            rplayerName = rplayer:getName(), characterName = self:getName()
        }
    )
    return true
end

---Returns the full name of this character.
---@nodiscard
---@return string name the full name of this character.
function Character:getName()
    return self.firstName .. ' ' .. self.lastName
end

---Returns the banking account of this character.
---@nodiscard
---@return Account banking the banking account of this character.
function Character:getBanking()
    return self.cache:get('banking', function ()
        return Account.load(self.bid)
    end)
end

---Returns the inventory of this character.
---@nodiscard
---@return Inventory inventory the inventory of this character.
function Character:getInventory()
    return self.cache:get('inventory', function ()
        return Inventory.load(self.invId)
    end)
end

---Returns the data of this character.
---This data can be used to be sent to the client.
---@nodiscard
---@return Character.Data data the data of this character.
function Character:getData()
    return {
        citizenId = self.citizenId,
        firstName = self.firstName,
        lastName = self.lastName,
        dateOfBirth = self.dateOfBirth,
        gender = self.gender
    }
end

---Checks if this character is a female.
---@nodiscard
---@return boolean isFemale true if the character is Female.
function Character:isFemale()
    return self.gender
end

---Marks this character as inactive.
---This will remove the rplayer that is currently playing this character.
function Character:sleep()
    local rplayer = self.possesedBy
    self.possesedBy = nil
    if rplayer then
        rplayer:trigger('rs:core:character:sleep', self:getData())
        Core.LogSystem:createEntry(
            "rs-core",
            { "sleep", "character", "character:sleep" },
            StringUtils.format("Player {name} is now playing {character}.", {
                name = rplayer:getName(),
                character = self:getName()
            }),
            {
                rplayerIdentifier = rplayer:getIdentifier(), characterId = self.citizenId,
                rplayerName = rplayer:getName(), characterName = self:getName()
            }
        )
    end
end
