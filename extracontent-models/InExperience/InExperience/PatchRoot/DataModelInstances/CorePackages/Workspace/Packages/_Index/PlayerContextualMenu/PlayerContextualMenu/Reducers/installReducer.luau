local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local parent = PlayerContextualMenu.Parent
local Rodux = require(parent.Rodux)
local UserBlocking = require(PlayerContextualMenu.Rodux.UserBlocking)

local FFlagUserBlockingApiPlayerContextMenuEnabled = require(PlayerContextualMenu.Flags.FFlagUserBlockingApiPlayerContextMenuEnabled)

return function()
	local combineReducers = Rodux.combineReducers
	local isBlockedByMe

	if not FFlagUserBlockingApiPlayerContextMenuEnabled then
		isBlockedByMe = require(script.Parent.IsBlockedByMe)
	end

	local userBlocking

	if FFlagUserBlockingApiPlayerContextMenuEnabled then
		userBlocking = UserBlocking.installReducer()
	end

	return combineReducers({ IsBlockedByMe = isBlockedByMe, UserBlocking = userBlocking })
end
