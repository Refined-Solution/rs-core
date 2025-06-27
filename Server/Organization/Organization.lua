---@class Organization
---@field id number the unique id of the Organization
---@field label string the display name of the Organization
---@field accountId string the id of the Organizations primary bank account
---@field funding number the amount of money the Organization will
---                      receive every time interval. Funding is
---                      automatically added to the Organizations
---                      primary bank account.
Organization = {}
setmetatable(Organization, {
    ---Creates a new Organization object.
    ---@param id number the unique id of the Organization
    ---@param label string the display name of the Organization
    __call = function (cls, id, label, accountId)
        local obj = {}
        setmetatable(obj, Organization)
        obj.id = id
        obj.label = label
        obj.accountId = accountId
        return obj
    end
})
Organization.__index = Organization

local Organizations = Cache()

---Inserts a new Organization into the database.
---This will create a new entry in the database.
---@nodiscard
---@param label string the display name of the Organization
---@param accountId string the id of the Organizations primary bank account
---@return number id the unique id of the created Organization
local function insert(label, accountId)
    --TODO: Implement the database insertion logic
    -- This requires more intel on the HELIX scripting API
    return 0
end

---Selects an Organization from the database.
---This will return the Organization object for the given id.
---@nodiscard
---@param id number the unique id of the Organization to select
---@return string label the display name of the Organization
---@return string accountId the id of the Organizations primary bank account
local function select(id)
    -- TODO: Implement the database selection logic
    -- This requires more intel on the HELIX scripting API
    return "", ""
end

---Updates the Organization in the database.
---This will update the entry in the database with the given Organization object.
---@param organization Organization the Organization object to update
local function update(organization)
    -- TODO: Implement the database update logic
    -- This requires more intel on the HELIX scripting API
end

---Creates a new Organization. This will create a new entry in the database.
---@nodiscard
---@param label string the display name of the Organization
---@return Organization Organization the created Organization object
function Organization.new(label)
    local account = Account.new()
    local id = insert(label, account.id)
    local org = Organization(id, label, account.id)
    Organizations:set(id, org)
    return org
end

---Returns the Organsiation object for the given id.
---@nodiscard
---@param id number the unique id of the Organization to load
---@return Organization? Organization the loaded Organization object or nil if the Organization does not have an entry
function Organization.load(id)
    return Organizations:get(id, function()
        local label, accountId = select(id)
        return Organization(id, label, accountId)
    end)
end

---Returns the banking account of this Organization.
---@nodiscard
---@return Account account the banking account of this Organization
function Organization:getAccount()
    local account = Account.load(self.accountId)
    if not account then
        error(
            StringUtils.format(
                "Organization {id} does not have a valid account. (tried '{accountId}')",
                { id = self.id, accountId = self.accountId }
            )
        )
    end
    return account
end

---Grants the funding to the Organizations primary bank account.
---This will add the funding amount to the Organizations primary bank account.
function Organization:grantFunding()
    local account = self:getAccount()
    account:addBalance(self.funding, Translator.translate(
        "rs.core.organization.funding_transaction_description",
        { organization = self.label }
    ))
end

---Sets the funding amount for this Organization.
---This will update the funding amount in the database.
---@param funding number the new funding amount for this Organization
function Organization:setFunding(funding)
    if funding < 0 then
        error (
            StringUtils.format(
                "Funding for Organization {id} cannot be negative. (tried {funding})",
                { id = self.id, funding = funding }
            )
        )
    end
    self.funding = funding
    update(self)
end

function Organization:__tostring()
    return StringUtils.format("Organization[{id}]({label})", {
        id = self.id,
        label = self.label
    })
end
