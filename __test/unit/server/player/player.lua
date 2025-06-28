---@diagnostic disable: param-type-mismatch
local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local client = SIMULATOR_CREATE(simulation, "CLIENT")
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)

local HPlayer = ENVIRONMENT_GET_VAR(env, "HPlayer")
local Player = ENVIRONMENT_GET_VAR(env, "Player")
local Core = ENVIRONMENT_GET_VAR(env, "Core")

Test.new('Player should exist', function()
    return Test.assert(Player ~= nil, "Player should not be nil")
end)

Test.new('Player should have no active character by default', function()
    -- given
    local hPlayer = HPlayer.__of(client)
    local rplayer = Player.new(hPlayer.__guid__)

    -- when
    local activeCharacter = rplayer:getActiveCharacter()

    -- then
    return Test.assert(activeCharacter == nil, "Player should have no active character by default")
end)

Test.new('Player:setActiveCharacter should set the active character', function()
    -- given
    local rplayer = HPlayer.__of(client)
    local rplayer = Player.new(rplayer.__guid__)
    local Character = ENVIRONMENT_GET_VAR(env, "Character")
    local character = Character.new("my", "name", "01/01/2000", false)

    -- when
    rplayer:setActiveCharacter(character)

    -- then
    return Test.assert(rplayer:getActiveCharacter() == character, "Player should have the active character set") and
           Test.assert(character.possesedBy == rplayer, "Character should be possessed by the Player")
end)

Test.new('Player:isInCharacter should return correct state', function()
    -- given
    local rplayer = HPlayer.__of(client)
    local rplayer = Player.new(rplayer.__guid__)
    local Character = ENVIRONMENT_GET_VAR(env, "Character")
    local character = Character.new("my", "name", "01/01/2000", false)

    -- then
    if not Test.assert(rplayer:isInCharacter() == false, "Player should not be in character by default") then
        return false
    end

    -- when
    rplayer:setActiveCharacter(character)

    -- then
    return Test.assert(rplayer:isInCharacter() == true, "Player should be in character")
end)

Test.new('Player:logout should clear active character', function()
    -- given
    local rplayer = HPlayer.__of(client)
    local rplayer = Player.new(rplayer.__guid__)
    local Character = ENVIRONMENT_GET_VAR(env, "Character")
    local character = Character.new("my", "name", "01/01/2000", false)

    -- when
    rplayer:setActiveCharacter(character)
    rplayer:logout()

    -- then
    return Test.assert(rplayer:getActiveCharacter() == nil, "Player should have no active character after logout") and
           Test.assert(character.possesedBy == nil, "Character should not be possessed by any Player after logout")
end)

Test.new("Player:getIdentifier should return the rplayer's identifier", function()
    -- given
    local client2 = SIMULATOR_CREATE(simulation, "CLIENT")
    local rplayer = Core.getPlayers()[1]

    -- when
    local identifier = rplayer:getIdentifier()
    local expectedIdentifier = HPlayer.GetByIndex(rplayer.player):GetIdentifier()

    -- then
    return Test.assertEqual(identifier, expectedIdentifier, "Player:getIdentifier should return the rplayer's identifier")
end)

Test.new('Player:getName should return the rplayer\'s name', function()
    -- given
    local rplayer = Core.getPlayers()[1]

    -- when
    local name = rplayer:getName()
    local expectedName = HPlayer.GetByIndex(rplayer.player):GetName()

    -- then
    return Test.assert(name == expectedName, "Player:getName should return the rplayer's name")
end)
