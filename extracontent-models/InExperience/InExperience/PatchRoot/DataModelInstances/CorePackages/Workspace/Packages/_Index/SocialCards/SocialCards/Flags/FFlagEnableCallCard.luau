local parent = script:FindFirstAncestor("SocialCards").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV

return game:DefineFastFlag("EnableCallCard", false) and FFlagFriendsCallingClientGate_DEV
