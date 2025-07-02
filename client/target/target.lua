---@class Target
---@field name string the unique name of the target
---@field entity entity? the entity this target is attached to, if any
---@field location vector3 the location of the target, if an entity is provided,
---                        this will be the offset from the entity's position
---@field options table<string, {label: string, callback: fun()}> the options available for this target
---@field interactRange number the range at which rplayers can interact with this target, this will also
---                            be the distance at which the target will be displayed to the rplayer, if
---                            the display parameter is not set to false and the display policy is not set to 'none'
---@field visible boolean if true, the target will be displayed to the rplayer
Target = {}
setmetatable(Target, {
    ---@nodiscard
    ---@param cls Target
    ---@param name string a unique name for the target
    ---@param entity entity? an entity to attach the target to
    ---@param location vector3? the location of the target, if an entity is provided,
    ---                        this will be the offset from the entity's position
    ---@return Target target the new target object
    __call = function (cls, name, entity, location)
        local target = {}
        setmetatable(target, Target)
        target.name = name
        target.entity = entity
        target.location = location or {0, 0, 0} -- TODO: correct?
        target.options = {}
        target.interactRange = Config.target.interactRange
        target.visible = true
        return target
    end
})
Target.__index = Target

---Creates a new interactable targetable object.
---@nodiscard
---@param name string a unique name for the target
---@param entity entity? an entity to attach the target to
---@param location vector3? the location of the target, if an entity is provided,
---                        this will be the offset from the entity's position
---@return Target target the new target object
function Target.new(name, entity, location)
    local target = Target(name, entity, location)
    return target
end

---Adds the given option to the target.
---@param name string a unique name for the option
---@param label string the label for this option
---@param callback fun() the callback to call when the option is selected
function Target:addOption(name, label, callback)
    self.options[name] = {
        label = label,
        callback = callback
    }
end

---Removes the option with the given name from the target.
---@param name string the name of the option to remove
function Target:removeOption(name)
    self.options[name] = nil
end

---Displays the options for the target on the screen.
---This will also enable UI focus.
function Target:display()
    -- TODO: Send the target to the UI to display it
    -- This requires more intel on the HELIX API
end

---Called when this target should be updated.
---This is called every second, or every frame, depending on the rplayers distance
---to this target.
---@param rplayerLocation vector3 the location of the rplayer
---@return boolean inRange if true, the target is within range of the rplayer and the rplayer
---                        is looking at the target, otherwise false
---@return number distance the distance to the target
function Target:onUpdate(rplayerLocation)
    -- TODO: Requires more intel on the HELIX API
    return false, 0.0
end
