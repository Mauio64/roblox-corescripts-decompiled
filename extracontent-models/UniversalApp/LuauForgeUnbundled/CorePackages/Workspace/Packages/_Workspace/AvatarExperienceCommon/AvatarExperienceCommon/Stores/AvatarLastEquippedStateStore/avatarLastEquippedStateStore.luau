local v5 = nil
local v6 = false
local v7 = true

return {
	getAvatarLastEquippedState = function()
		return v5
	end,
	setAvatarLastEquippedState = function(p2)
		v5 = p2
	end,
	getChangedLayeredMakeupSorting = function()
		return v6
	end,
	setChangedLayeredMakeupSorting = function(p2)
		v6 = p2
	end,
	getShouldRevertLastEquippedState = function()
		return v7
	end,
	setShouldRevertLastEquippedState = function(p2)
		v7 = p2
	end
}
