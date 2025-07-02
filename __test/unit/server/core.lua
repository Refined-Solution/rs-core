local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local client = SIMULATOR_CREATE(simulation, "CLIENT")

local env = ENVIRONMENT_GET(server, resource)
local HPlayer = ENVIRONMENT_GET_VAR(env, "HPlayer")
local Core = ENVIRONMENT_GET_VAR(env, "Core")
local LogSystem = ENVIRONMENT_GET_VAR(env, "LogSystem")

Test.new('Core should exist', function()
    return Test.assert(Core ~= nil, "Core should not be nil")
end)

Test.new('Core should have all required functions', function (self)
    return
        Test.assert(Core.getPlayer ~= nil, "Core should have 'getPlayer' function") and
        Test.assert(Core.addFunction ~= nil, "Core should have 'addFunction' function")
end)

Test.new('Core.addFunction should add a function to an object', function (self)
    -- given
    local objName = "Core"
    local funcName = "testFunction"
    local func = function() return "Hello, World!" end

    -- when
    Core.addFunction(objName, funcName, func)

    -- then
    local obj = ENVIRONMENT_GET_VAR(env, objName)
    return Test.assert(obj[funcName] ~= nil, "Function '" .. funcName .. "' should be added to object '" .. objName .. "'") and
           Test.assert(obj[funcName]() == "Hello, World!", "Function '" .. funcName .. "' should return 'Hello, World!'")
end)

Test.new("Core.setModule should set a module", function (self)
    -- given
    local moduleName = "TestModule"
    local module = {
        testFunction = function() return "Test" end
    }

    -- when
    Core.setModule(moduleName, module)

    -- then
    local obj = ENVIRONMENT_GET_VAR(env, moduleName)
    return Test.assert(obj ~= nil, "Module '" .. moduleName .. "' should be set") and
           Test.assert(obj.testFunction ~= nil, "Module '" .. moduleName .. "' should have 'testFunction'") and
           Test.assert(obj.testFunction() == "Test", "Module '" .. moduleName .. "' should return 'Test' from 'testFunction'")
end)

Test.new("Core.setModule should replace existing module", function (self)
    -- given
    local moduleName = "Inventory"
    local newModule = {
        testFunction = function() return "New Test" end
    }
    local current = ENVIRONMENT_GET_VAR(env, moduleName)

    -- when
    Core.setModule(moduleName, newModule)
    local obj = ENVIRONMENT_GET_VAR(env, moduleName)

    -- then
    return Test.assert(obj ~= current, "Module '" .. moduleName .. "' should be replaced")
end)

Test.new('Core.hasModule should return true for existing module', function (self)
    -- given
    local moduleName = "Inventory"
    local moduleName2 = "NonExistentModule"

    -- when
    local hasModule = Core.hasModule(moduleName)
    local hasModule2 = Core.hasModule(moduleName2)

    -- then
    return Test.assert(hasModule, "Core should have module '" .. moduleName .. "'") and
           Test.assert(not hasModule2, "Core should not have module '" .. moduleName2 .. "'")
end)

Test.new('Core.getPlayers should return all online rplayers', function (self)
    -- given
    local rplayers = Core.getPlayers()

    -- when
    local size = #rplayers

    -- then
    return Test.assert(size > 0, "Core should return at least one rplayer") and
           Test.assert(type(rplayers[1]) == "table", "Core should return rplayers as table")
end)

Test.new('Core.getPlayer should return the correct rplayer', function (self)
    -- given
    local rplayer = HPlayer.__of(client)
    local identifier = rplayer:GetIdentifier()

    -- when
    local rplayer = Core.getPlayer(rplayer)
    -- then
    return Test.assert(rplayer ~= nil and rplayer:getIdentifier() == identifier, "Core should return correct rplayer for Core.getPlayer")
end)

Test.new('Player should be registered on spawn', function (self)
    -- given
    local size = #Core.getPlayers()

    -- when
    local client2 = SIMULATOR_CREATE(simulation, "CLIENT")
    local sizeNow = #Core.getPlayers()

    -- then
    return Test.assert(sizeNow == size + 1, "Player should be registered on spawn")
end)

Test.new('Player should be unregistered on disconnect', function (self)
    -- given
    local client2 = SIMULATOR_CREATE(simulation, "CLIENT")
    local size = #Core.getPlayers()

    -- when
    SIMULATOR_DESTROY(client2)
    local sizeNow = #Core.getPlayers()

    -- then
    return Test.assert(sizeNow == size - 1, "Player should be unregistered on disconnect")
end)

Test.new('Player join should create a log entry', function (self)
    -- given
    local currentSize = #Core.LogSystem.current
    local client2 = SIMULATOR_CREATE(simulation, "CLIENT")

    -- when
    local nowSize = #Core.LogSystem.current

    --then
    return Test.assert(nowSize == currentSize + 1, "Log entry should be created on rplayer join")
end)
