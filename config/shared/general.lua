---@class Config
Config = Config or {}

---@class Config.General
Config.General = {}

---@type string the language the server should use.  
---This will be used to determine the language of the translations.
Config.General.language = "en"

---@type {debug: boolean, info: boolean, warn: boolean, error: boolean}
---Enable or disable the logs you want to see in the console. It isrecommended
---for live servers to only enable error, warn and info logs.
---Debug logs are only useful for development and debugging purposes.
Config.General.Log = {
    debug = true,
    info = true,
    warn = true,
    error = true
}
