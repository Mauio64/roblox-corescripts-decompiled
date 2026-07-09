local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local PlayerContextualMenuParent = PlayerContextualMenu.Parent
local Rodux = require(PlayerContextualMenuParent.Rodux)
local UserBlocking = require(PlayerContextualMenu.Rodux.UserBlocking)
local FFlagUserBlockingApiPlayerContextMenuEnabled = require(PlayerContextualMenu.Flags.FFlagUserBlockingApiPlayerContextMenuEnabled)

return function() -- line: 9
	-- upvalues: Rodux (copy), FFlagUserBlockingApiPlayerContextMenuEnabled (copy), UserBlocking (copy)
	return Rodux.combineReducers({
		IsBlockedByMe = if FFlagUserBlockingApiPlayerContextMenuEnabled then nil else require(script.Parent.IsBlockedByMe),
		UserBlocking = if not FFlagUserBlockingApiPlayerContextMenuEnabled then nil else UserBlocking.installReducer()
	})
end
