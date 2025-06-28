---@class Config
Config = Config or {}

---@class Config.Discord
Config.Discord = {}

---@type string the id of your discord server.
---This is used to synchronize the rplayer groups with the discord server.
Config.Discord.GuildId = ""

---@type string the token of your discord bot.
---This is used to connect to the discord server to send
---messages and check the rplayer groups.
Config.Discord.BotToken = ""
