---@class TargetManager
TargetManager = {}
TargetManager.__index = TargetManager

---@type table<string, Target>
local targets = {}

---Registers a new target to the list of targets.
---@param target Target the target to register
local function registerTarget(target)
    targets[target.name] = target
end

---Creates a new target with the given options and registers it.
---@param name string a unique name for the target
---@param entity entity? an entity to attach the target to
---@param location vector3? the location of the target, if an entity is provided,
---                        this will be the offset from the entity's position
---@param options table<string, {label: string, callback: fun()}> the options available for this target
---@param interactRange number? the range at which rplayers can interact with this target, this will also
---                             be the distance at which the target will be displayed to the rplayer, if
---                             the display parameter is not set to false and the display policy is not set to 'none'
---@param display boolean? if true, the target will be displayed to the rplayer, defaults to true
function TargetManager.addTarget(name, entity, location, options, interactRange, display)
    if display == nil then
        display = true
    end

    local target = Target(name, entity, location)

    for optionName, option in pairs(options) do
        target:addOption(optionName, option.label, option.callback)
    end

    target.interactRange = interactRange or Config.target.interactRange
    target.visible = display

    registerTarget(target)
end

---Updates all the targets in the list of known targets.
---@return boolean inRange true if at least one of the targets is within
---                        range and therefore needs to be updated every frame
function TargetManager.updateTargets()
    -- TODO: this requires more intel on the HELIX API
    -- to find the rplayers location and with that the
    -- targets in range.
    return false
end

---Called when the rplayer pressed the ineract button.
---This will try to find the target the rplayer is trying to interact with
---and then open the interaction menu for that target.
function TargetManager.interactButtonPressed()
    --TODO: this requires more intel on the HELIX API
    -- to find the rplayers location and with that the
    -- targets in range.
end
