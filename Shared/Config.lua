---@class Config
Config = {}

---@type string the language to use.
Config.language = "de"

---@class Config.log
Config.log = {
    ---@type boolean if true, debug messages will be logged to the console.
    debug = true,

    ---@type boolean if true, info messages will be logged to the console.
    info = true,

    ---@type boolean if true, warning messages will be logged to the console.
    warn = true,

    ---@type boolean if true, error messages will be logged to the console.
    error = true
}

---@type string? the guild ID of the discord server this server is connected to.
---This is where the player groups are synchronized with.
Config.guildId = nil

---@class Config.inventory
Config.inventory = {
    ---@type number the amount of slots in the default player inventory.
    slotCount = 5 * 8,

    ---@type number the maximum weight this inventory can hold.
    ---This is the maximum weight of all items in the inventory combined.
    maxWeight = 50000
}

---@class Config.useDefault
Config.useDefault = {

    ---@type boolean if true, the default admin menu wil be used.
    ---If you don't want to use the default admin menu, set this to false
    adminMenu = true,

}

---@class Config.target
Config.target = {
    ---@type 'only-closest'|'all'|'none' the display policy for targets.
    ---If set to 'only-closest', only the closest target will be displayed.
    ---If set to 'all', all targets within the players range will be displayed.
    ---If set to 'none' targets won't be marked as interactable (you can still interact, it just won't be marked).
    ---None can also be set manually for each target if required.
    displayPolicy = "only-closest",

    ---@type number the range at which players can interact with targets by default (can be overridden by the target).
    ---This is the distance at which the targets will be displayed to the player.
    interactRange = 5.0,

    ---@type string the key that is used to interact with targets.
    interactKey = 'ALT',
}

---Generates a random character ID in the format "CITIZEN-AAAAAA-0000".
---This ID will be used to uniquely identify a character in the game and by default
---also shown on the players id card.
---DO NOT MAKE THIS LONGER THAN 16 CHARACTERS, AS THIS IS THE MAXIMUM LENGTH.
---@return string citizenId the generated character / citizen ID
function Config.generateCharacterId()
    return "CITIZEN-" .. StringUtils.randomString("AAAA")
                      .. StringUtils.randomString("0000")
end

---Generates a ranodm banking account ID in the format "BID-AA00-0000-0000".
---This ID will be used to uniquely identify a banking account in the game.
---@return string bankingAccountId the generated banking account ID
function Config.generateBankingAccountId()
    return "BID-" .. StringUtils.randomString("AA")
                  .. StringUtils.randomString("00")
                  .. "-"
                  .. StringUtils.randomString("0000")
                  .. "-"
                  .. StringUtils.randomString("0000")
end

---Generates a random transaction ID in the format "TID-AAAA0000-AAAA0000-AAAA0000".
---This ID will be used to uniquely identify a transaction in the game.
---@return string transactionId the generated transaction ID
function Config.generateTransactionId()
    return "TID-" .. StringUtils.randomString("AAAA")
                  .. StringUtils.randomString("0000")
                  .. "-"
                  .. StringUtils.randomString("AAAA")
                  .. StringUtils.randomString("0000")
                  .. "-"
                  .. StringUtils.randomString("AAAA")
                  .. StringUtils.randomString("0000")
end
