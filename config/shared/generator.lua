---@class Config
Config = Config or {}

---@class Config.Generator contains generation functions
---for various entities in the game.
Config.Generator = {}

---Generates a new random citizen ID.
---@nodiscard
---@return string citizenId the generated citizen ID
function Config.Generator.citizenId()
    return StringUtils.randomString("CITIZEN-AAAAAA-0000")
end

---Generates a new random account ID.
---@nodiscard
---@return string accountId the generated account ID
function Config.Generator.bankingId()
    return StringUtils.randomString("BID-AA00-0000-0000")
end

---Generates a new random transaction ID.
---@nodiscard
---@return string transactionId the generated transaction ID
function Config.Generator.transactionId()
    return "TRANSACTION" .. StringUtils.randomString("-AAAA0000-AAAA0000-AAAA0000")
end

