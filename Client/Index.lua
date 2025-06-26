Package.Require('Client/Target/Target.lua')

Events.SubscribeRemote("rs:core:character:wake", function (...)
end)

Events.SubscribeRemote("rs:core:character:sleep", function (...)
end)
Events.SubscribeRemote('rs:core:player:new', function()
end)