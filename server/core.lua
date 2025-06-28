---@diagnostic disable: undefined-field
---@class Server.Core
Core = {}
Core.LogSystem = LogSystem()

---@type table<string, Player> the mapping of rplayer identifiers to their corresponding Player objects.
local rplayersByIdentifier = {}

---Called when a rplayer joins the server.
---This creates the rplayer object and adds it to the rplayer mappings.
---@param rplayer Player the rplayer that just joined the server.
local function onJoin(source)
    local rplayer = Player.load(source)
    if not rplayer then
       rplayer = Player.new(source)
    end
    rplayersByIdentifier[rplayer:getIdentifier()] = rplayer
    Log.info("Player {name} joined with identifier {identifier}.", {name = rplayer:getName(), identifier = rplayer:getIdentifier()})
    Core.LogSystem:createEntry(
        "rs-core",
        { "join", "rplayer", "rplayer:quit" },
        StringUtils.format("Player {name} joined the server with identifier {identifier}.", {
            name = rplayer:getName(),
            identifier = rplayer:getIdentifier()
        }),
        {
            identifier = rplayer:getIdentifier(),
            rplayerName = rplayer:getName(),
        }
    )
end

---Called when a rplayer quits the server.
---This removes the rplayer object from the rplayer mappings and logs out the rplayer.
---@param player number the rplayer that is quitting the server.
local function onQuit(player)
    Log.info("Player {name} left the server.", {name = HPlayer.GetByIndex(player):GetName()})
    Core.LogSystem:createEntry(
        "rs-core",
        { "quit", "rplayer", "rplayer:quit" },
        StringUtils.format("Player {name} left the server.", {name = HPlayer.GetByIndex(player):GetName()}),
        {
            identifier = HPlayer.GetByIndex(player):GetIdentifier(),
            rplayerName = HPlayer.GetByIndex(player):GetName(),
        }
    )
    local rplayer = rplayersByIdentifier[HPlayer.GetByIndex(player):GetIdentifier()]
    if not rplayer then return end
    rplayer:logout()
    rplayersByIdentifier[rplayer:getIdentifier()] = nil
end

---Returns a list of all rplayers that are currently online.
---@nodiscard
---@return Player[] rplayers the list of all online rplayers.
function Core.getPlayers()
    local rplayerList = {}
    for _, rplayer in pairs(rplayersByIdentifier) do
        table.insert(rplayerList, rplayer)
    end
    return rplayerList
end

---Returns the Player object for the given Player object or identifier. This will only return rplayers
---that are currently online. To get an offline rplayer, you should use the static functions in the Player class.
---@nodiscard
---@param rplayer Player|string the rplayer or rplayer identifier to get the Player object for.
---@return Player? crplayer the core rplayer object for the given rplayer.
function Core.getPlayer(rplayer)
    local isIdentifier = type(rplayer) == 'string'
    if isIdentifier then
        return rplayersByIdentifier[rplayer]
    else
        ---@cast rplayer Player
        return rplayersByIdentifier[rplayer:GetIdentifier()]
    end
end

---Adds the given function to the given object. This allowes to replace a single function in a module. This can be used to
---usefull if the function to replace is in a big module, e.g. the inventory system, and you only want to
---replace a single function in it, e.g. the function that handles the item usage and add a log message or something like that.
---@param object string the name of the object to add the function to ("<object>.<object>" to select a nested object)
---@param name string the name of the function to add
---@param func fun(...) : ... the function to add
function Core.addFunction(object, name, func)
    local objNames = StringUtils.split(object, ".")
    local obj = _G
    for _, objName in ipairs(objNames) do
        obj = obj[objName]
    end
    obj[name] = func
end

---With this function new modules can be added or old ones can be replaced. This can be used to e.g. override the
---inventory system or add a new module as a library to the core that may is required by another module / resource.
---@param name string the name of the module to set. This can be a nested module like "Core.Module.SubModule".
---@param module table the module to set, which should contain functions and properties.
function Core.setModule(name, module)
    local objNames = StringUtils.split(name, ".")
    local parent = nil
    local obj = _G
    for _, objName in ipairs(objNames) do
        if not obj[objName] then
            obj[objName] = {}
        end
        parent = obj
        obj = obj[objName]
    end
    parent[objNames[#objNames]] = module
end

---Checks if the given module is registered to the core. This can be used in scripts that require a specific module
---that is not guaranteed to be present, e.g. a module that is only available, if a specific resource is started.
---@nodiscard
---@param name string the name of the module to check. This can be a nested module like "Core.Module.SubModule".
---@return boolean isRegistered true if the module is registered, false otherwise.
function Core.hasModule(name)
    local objNames = StringUtils.split(name, ".")
    local obj = _G
    for _, objName in ipairs(objNames) do
        if not obj[objName] then
            return false
        end
        obj = obj[objName]
    end
    return true
end

---Registers a new item in the core item registry. This allowes the creation
---of itemsstacks of the given type.
---@param name string the name of the item
---@param label string the display name of the item
---@param description string the description of the item
---@param weight number the weight of the item
function Core.registerItem(name, label, description, weight)
    ItemStack.createConstructor(name, label, description, weight)
end

Events.Subscribe('Spawn', onJoin)
Events.Subscribe('Destroy', onQuit)
