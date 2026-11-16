local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local parent = PlayerContextualMenu.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local NetworkingBlocking = LuaSocialLibrariesDeps.NetworkingBlocking
local UserBlockingNetworking = require(parent.UserBlockingNetworking)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

local FFlagUserBlockingApiPlayerContextMenuEnabled = require(PlayerContextualMenu.Flags.FFlagUserBlockingApiPlayerContextMenuEnabled)

if FFlagUserBlockingApiPlayerContextMenuEnabled then
	return (UserBlockingNetworking.config({ roduxNetworking = RoduxNetworking }))
end

return (NetworkingBlocking.config({ roduxNetworking = RoduxNetworking }))
