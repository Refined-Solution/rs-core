---@class Config
Config = Config or {}

---@class Config.inventory
Config.inventory = {
    ---@type number the amount of slots in the default rplayer inventory.
    slotCount = 5 * 8,

    ---@type number the maximum weight this inventory can hold.
    ---This is the maximum weight of all items in the inventory combined.
    maxWeight = 50000
}

---@class Config.target
Config.target = {
    ---@type 'only-closest'|'all'|'none' the display policy for targets.
    ---If set to 'only-closest', only the closest target will be displayed.
    ---If set to 'all', all targets within the rplayers range will be displayed.
    ---If set to 'none' targets won't be marked as interactable (you can still interact, it just won't be marked).
    ---None can also be set manually for each target if required.
    displayPolicy = "only-closest",

    ---@type number the range at which rplayers can interact with targets by default (can be overridden by the target).
    ---This is the distance at which the targets will be displayed to the rplayer.
    interactRange = 5.0,

    ---@type string the key that is used to interact with targets.
    interactKey = 'ALT',
}
