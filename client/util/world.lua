---@class World
World = {}
World.__index = World

---Checks if the rplayer is looking at the specified location.
---@nodiscard
---@param location vector3 the location to check if the rplayer is looking at
---@return boolean isLookingAt true if the rplayer is looking at the location, false otherwise
function World.isLookingAt(location)
    -- TODO: Implement the logic to check if the rplayer is looking at the specified location.
    -- This requires more intel on the HELIX API
    return false
end
