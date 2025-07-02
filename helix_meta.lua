---@meta HELIX

---@class Package
Package = {}

---@param path string the path to the file that should be loaded
---at this point in the program
function Package.Require(path) end

---@class Events
Events = {}

---Calls the given event with the given arguments.
---@param event string the name of the event to call
---@vararg any the arguments to pass to the event handler
function Events.Call(event, ...) end

---Calls the given event on the server.
---@param event string the name of the event to call
---@vararg any the arguments to pass to the event handler
function Events.CallRemote(event, ...) end

---Calls the given event on the given client.
---@param event string the name of the event to call
---@param rplayer Player the rplayer to call the event on
---@vararg any the arguments to pass to the event handler
function Events.CallRemote(event, rplayer, ...) end

---Subscribes to the given event.
---@param event string the name of the event to subscribe to
---@param callback fun(...: any) the function to call when the event is triggered
function Events.Subscribe(event, callback) end

---Subscribes to the given event over the network.
---@param event string the name of the event to subscribe to
---@param callback fun(...: any) the function to call when the event is triggered
function Events.SubscribeRemote(event, callback) end

---@class Player
Player = {}

---Adds an event handler for the given event on the rplayer.
---@param event string the name of the event to subscribe to
---@param callback fun(...: any) the function to call when the event is triggered
---@overload fun(event: 'Spawn', callback: fun(rplayer: Player))
function Player.Subscribe(event, callback) end

---@nodiscard
---@return string name the name of the rplayer
function Player:GetName() end

---Returns the rplayers identifier.
---@nodiscard
---@return string identifier the identifier of the rplayer
function Player:GetIdentifier() end

---@class HPlayer
HPlayer = {}

---Returns the HPlayer object for the player with the given index
---@nodiscard
---@param player number the index of the player to get the HPlayer object for
---@return HPlayer? hplayer the HPlayer object for the given player index, or nil
function HPlayer.GetByIndex(player) end

---Returns the identifier of this HPlayer.
---@nodiscard
---@return string identifier the identifier of this HPlayer
function HPlayer:GetIdentifier() end

---Returns the name of this HPlayer.
---@nodiscard
---@return string name the name of this HPlayer
function HPlayer:GetName() end

---Triggers the given event on the client with the given player id.
---@param event string the name of the event to trigger
---@param player number the player id to trigger the event on
---@vararg any the arguments to pass to the event handler
function TriggerClientEvent(event, player, ...) end

---Triggers the given event on the server.
---@param event string the name of the event to trigger
---@vararg any the arguments to pass to the event handler
function TriggerServerEvent(event, ...) end

---Registers a client event that can be triggered by the server.
---@param event string the name of the event to register
---@param callback fun(...: any) the function to call when the event is triggered
function RegisterClientEvent(event, callback) end

---Registers a server event that can be triggered by the client.
---@param event string the name of the event to register
---@param callback fun(player: number, ...: any) the function to call when the event is triggered
function RegisterServerEvent(event, callback) end
