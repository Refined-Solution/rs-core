local simulation = SIMULATION_CREATE("HELIX")
local resource = RESOURCE_LOAD(simulation, "./")
local server = SIMULATION_GET_SERVER(simulation)
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local Config = ENVIRONMENT_GET_VAR(env, "Config")

Test.new('Config should exist', function()
    return Test.assert(Config ~= nil, "Config should not be nil")
end)

Test.new('config.inventory should be a table', function()
    return Test.assert(type(Config.inventory) == "table", "Config.inventory should be a table")
end)

Test.new('config.inventory.slotCount should be 40 by default', function()
    return Test.assert(type(Config.inventory.slotCount) == "number", "Config.inventory.slotCount should be a number") and
           Test.assertEqual(Config.inventory.slotCount, 40, "Config.inventory.slotCount should be 40 by default")
end)

Test.new('config.inventory.maxWeight should be 50000 by default', function()
    return Test.assert(type(Config.inventory.maxWeight) == "number", "Config.inventory.maxWeight should be a number") and
           Test.assertEqual(Config.inventory.maxWeight, 50000, "Config.inventory.maxWeight should be 50000 by default")
end)

Test.new('Config.generateCharacterId should return a string <= 16 characters', function()
    -- when
    local citizenId = Config.generateCharacterId()

    -- then
    return Test.assert(type(citizenId) == "string" and #citizenId <= 16, "Config generateCharacterId should return a string with length <= 16")
end)

Test.new('Config.generateBankingAccountId should return a string <= 32 characters', function()
    -- when
    local bankingId = Config.generateBankingAccountId()

    -- then
    return Test.assert(type(bankingId) == "string" and #bankingId <= 32, "Config generateBankingAccountId should return a string with length <= 32")
end)

Test.new('Config.generateTransactionId should return a string <= 32 characters', function()
    -- when
    local transactionId = Config.generateTransactionId()

    -- then
    return Test.assert(type(transactionId) == "string" and #transactionId <= 32, "Config generateTransactionId should return a string with length <= 32")
end)

