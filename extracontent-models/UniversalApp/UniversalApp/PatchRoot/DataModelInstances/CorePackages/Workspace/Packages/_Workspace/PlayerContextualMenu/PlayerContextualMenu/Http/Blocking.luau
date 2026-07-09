local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local PlayerContextualMenuParent = PlayerContextualMenu.Parent
local NetworkingBlocking = require(PlayerContextualMenuParent.LuaSocialLibrariesDeps).NetworkingBlocking
local UserBlockingNetworking = require(PlayerContextualMenuParent.UserBlockingNetworking)
local RoduxNetworking = require(script.Parent.RoduxNetworking)

if require(PlayerContextualMenu.Flags.FFlagUserBlockingApiPlayerContextMenuEnabled) then
	return (UserBlockingNetworking.config({
		roduxNetworking = RoduxNetworking
	}))
end

return (NetworkingBlocking.config({
	roduxNetworking = RoduxNetworking
}))
