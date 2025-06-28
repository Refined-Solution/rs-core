---@diagnostic disable: param-type-mismatch
local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local client = SIMULATOR_CREATE(simulation, "CLIENT")
local client2 = SIMULATOR_CREATE(simulation, "CLIENT")
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)

local Character = ENVIRONMENT_GET_VAR(env, "Character")
local HPlayer = ENVIRONMENT_GET_VAR(env, "HPlayer")
local Player = ENVIRONMENT_GET_VAR(env, "Player")

Test.new('Character should exist', function()
    return Test.assert(Character ~= nil, "Character should not be nil")
end)

Test.new('Character.new should create a new core character', function()
    -- when
    local character = Character.new("my", "name", "01/01/2000", false)

    -- then
    return Test.assert(character.citizenId ~= nil and character.citizenId ~= "", "Character.new should create a new core character")
end)

Test.new('Character.load should use provided citizenId', function()
    -- given
    local id = "test_citizen_id"

    -- when
    local character = Character.load(id)

    -- then
    return Test.assert(character.citizenId == id, "Character.load should use the provided citizenId")
end)

Test.new('Character:getData should return correct data', function (self)
    -- given
    local character = Character.new("A", "B", "01/01/2000", false)

    -- when
    local data = character:getData()

    -- then
    return Test.assert(type(data.citizenId) == "string", "data.citizenId should be a string") and
              Test.assert(data.firstName == "A", "data.firstName should be 'A'") and
              Test.assert(data.lastName == "B", "data.lastName should be 'B'") and
              Test.assert(data.dateOfBirth == "01/01/2000", "data.dateOfBirth should be '01/01/2000'") and
              Test.assert(data.gender == false, "data.gender should be false")
end)

Test.new('Character:isFemale should return correct value', function (self)
    -- given
    local character = Character.new("A", "B", "01/01/2000", true)
    local character2 = Character.new("C", "D", "01/01/2000", false)

    -- when
    local isFemale = character:isFemale()
    local isFemale2 = character2:isFemale()

    -- then
    return  Test.assert(isFemale == true, "Character:isFemale should return correct value") and
            Test.assert(isFemale2 == false, "Character:isFemale should return correct value")
end)

Test.new('Character:wake should set the character as active for the rplayer', function()
    -- given
    local character = Character.new("my", "name", "01/01/2000", false)
    local hPlayer = HPlayer.__of(client)
    local rplayer = Player.new(hPlayer.__guid__)

    -- when
    local success = character:wake(rplayer)

    -- then
    return Test.assert(success == true and character.possesedBy == rplayer, "Character should be set as active for the rplayer")
end)

Test.new('Character:wake should not set the character as active if already possessed', function()
    -- given
    local character = Character.new("my", "name", "01/01/2000", false)
    local rplayer1 = Player.new(HPlayer.__of(client).__guid__)
    local rplayer2 = Player.new(HPlayer.__of(client2).__guid__)

    -- when
    character:wake(rplayer1)
    local success = character:wake(rplayer2)

    -- then
    return Test.assert(success == false and character.possesedBy == rplayer1, "Character should not be set as active for another rplayer if already possessed")
end)

Test.new('Character:sleep should mark the character as inactive', function()
    -- given
    local character = Character.new("my", "name", "01/01/2000", false)
    local hPlayer = HPlayer.__of(client)
    local rplayer = Player.new(hPlayer.__guid__)
    -- when
    character:wake(rplayer)
    character:sleep()

    -- then
    return Test.assert(character.possesedBy == nil, "Character should be marked as inactive after sleep")
end)

Test.new('Character:getBanking should return the banking account', function()
    -- given
    local character = Character.new("my", "name", "01/01/2000", false)

    -- when
    local banking = character:getBanking()

    -- then
    return Test.assert(banking ~= nil, "Character:getBanking should return the banking account") and
           Test.assert(banking.id == character.bid, "Character:getBanking should return the correct banking account for the character")
end)

Test.new('Character:getInventory should return the inventory', function()
    -- given
    local character = Character.new("my", "name", "01/01/2000", false)

    -- when
    local inventory = character:getInventory()

    -- then
    return Test.assert(inventory ~= nil, "Character:getInventory should return the inventory") and
           Test.assert(inventory.id == character.invId, "Character:getInventory should return the correct inventory for the character") and
           Test.assertEqual(inventory.slotCount, 40, "Character:getInventory should return the inventory with the correct slot count") and
           Test.assertEqual(inventory.maxWeight, 50000, "Character:getInventory should return the inventory with the correct max weight")
end)
