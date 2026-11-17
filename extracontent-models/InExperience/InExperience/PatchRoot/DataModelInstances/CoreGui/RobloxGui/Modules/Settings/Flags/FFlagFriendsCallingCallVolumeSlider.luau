local CorePackages = game:GetService("CorePackages")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV

return game:DefineFastFlag("FriendsCallingCallVolumeSlider", false) and FFlagFriendsCallingClientGate_DEV
