local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local Organization = ENVIRONMENT_GET_VAR(env, "Organization")

Test.new('Organization should exist', function()
    return Test.assert(Organization ~= nil, "Organization should not be nil")
end)

Test.new('Organization() should create a new organization object', function (self)
    local org = Organization(0, "Test Organization", "test_account_id")
    return Test.assert(org ~= nil, "Organization object should not be nil") and
           Test.assertEqual(org.id, 0, "Organization id should be 0") and
           Test.assertEqual(org.label, "Test Organization", "Organization label should be 'Test Organization'") and
           Test.assertEqual(org.accountId, "test_account_id", "Organization accountId should be 'test_account_id'")
end)

Test.new('Organization.new() should create a new organization', function (self)
    local org = Organization.new("New Organization")

    local foundOrg = Organization.load(org.id)

    return Test.assert(foundOrg ~= nil, "Organization should be found after creation") and
           Test.assertEqual(foundOrg.id, org.id, "Found organization id should match created organization id") and
           Test.assertEqual(foundOrg.label, "New Organization", "Found organization label should match created organization label") and
           Test.assertEqual(foundOrg.accountId, org.accountId, "Found organization accountId should match created organization accountId")
end)

Test.new('Organization.load() should load an existing organization', function (self)
    local org = Organization.new("Load Test Organization")
    local loadedOrg = Organization.load(org.id)

    return Test.assert(loadedOrg ~= nil, "Loaded organization should not be nil") and
           Test.assertEqual(loadedOrg.id, org.id, "Loaded organization id should match created organization id") and
           Test.assertEqual(loadedOrg.label, "Load Test Organization", "Loaded organization label should match created organization label") and
           Test.assertEqual(loadedOrg.accountId, org.accountId, "Loaded organization accountId should match created organization accountId")
end)

Test.new('Organization:getAccount() should return the organization\'s account', function (self)
    local org = Organization.new("Account Test Organization")
    local account = org:getAccount()

    return Test.assert(account ~= nil, "Organization account should not be nil") and
           Test.assertEqual(account.id, org.accountId, "Organization account id should match organization's accountId")
end)

Test.new('Organization:grantFunding() should add funds to the organization\'s account', function (self)
    local org = Organization.new("Funding Test Organization")
    org:setFunding(1000)
    local initialBalance = org:getAccount().balance

    org:grantFunding()

    local updatedBalance = org:getAccount().balance
    return Test.assertEqual(updatedBalance, initialBalance + 1000, "Organization account balance should be increased by 1000")
end)

Test.new('Organization:setFunding() should update the organization\'s funding', function (self)
    local org = Organization.new("Funding Update Test Organization")
    org:setFunding(5000)

    return Test.assertEqual(org.funding, 5000, "Organization funding should be set to 5000")
end)

Test.new('Organization:__tostring() should return a string representation of the organization', function (self)
    local org = Organization.new("String Test Org.")
    local str = tostring(org)

    return Test.assertEqual(str, "Organization[".. tostring(org.id) .."](" .. org.label .. ")", "Organization string representation should match expected format")
end)
