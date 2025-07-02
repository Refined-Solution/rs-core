local simulation = SIMULATION_CREATE("HELIX")
local resource = RESOURCE_LOAD(simulation, "./")
local server = SIMULATION_GET_SERVER(simulation)
local client = SIMULATOR_CREATE(simulation, "CLIENT")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(client, resource)
local Target = ENVIRONMENT_GET_VAR(env, "Target")

Test.new('Target should exist', function()
    return Test.assert(Target ~= nil, "Target should not be nil")
end)

Test.new('Target() should create a new target', function()
    -- when
    local target = Target("test_target")

    -- then
    return Test.assertEqual(type(target), "table", "Target should be a table") and
           Test.assertEqual(getmetatable(target), Target, "Target should have the Target metatable") and
           Test.assertEqual(target.name, "test_target", "Target name should be 'test_target'") and
           Test.assertEqual(target.entity, nil, "Target entity should be nil by default") and
           Test.assertEqual(target.location, {0, 0, 0}, "Target location should be {0, 0, 0} by default") and
           Test.assertEqual(type(target.options), "table", "Target options should be a table") and
           Test.assertEqual(target.interactRange, 5.0, "Target interactRange should match Config.target.interactRange") and
           Test.assertEqual(target.visible, true, "Target visible should be true by default")
end)

Test.new('Target:addOption() should add an option to the target', function()
    -- given
    local target = Target("test_target")
    local func1 = function() end

    -- when
    target:addOption("option1", "Option 1", func1)

    -- then
    return Test.assertEqual(type(target.options), "table", "Target options should be a table") and
           Test.assertEqual(target.options["option1"], {label = "Option 1", callback = func1}, "Target option label should be 'Option 1'")
end)

Test.new('Target:removeOption() should remove an option from the target', function()
    -- given
    local target = Target("test_target")
    target:addOption("option1", "Option 1", function() end)

    -- when
    target:removeOption("option1")

    -- then
    return Test.assertEqual(type(target.options), "table", "Target options should be a table") and
           Test.assertEqual(target.options["option1"], nil, "Target options should have 0 options after removal")
end)