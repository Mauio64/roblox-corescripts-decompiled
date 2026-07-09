local u1 = nil
local u2 = false
local u3 = true

return {
	getAvatarLastEquippedState = function() -- line: 25
		-- upvalues: u1 (ref)
		return u1
	end,
	setAvatarLastEquippedState = function(t1: {[any]: any}) -- line: 29
		-- upvalues: u1 (ref)
		u1 = t1
	end,
	getChangedLayeredMakeupSorting = function() -- line: 33
		-- upvalues: u2 (ref)
		return u2
	end,
	setChangedLayeredMakeupSorting = function(b1: boolean) -- line: 37
		-- upvalues: u2 (ref)
		u2 = b1
	end,
	getShouldRevertLastEquippedState = function() -- line: 41
		-- upvalues: u3 (ref)
		return u3
	end,
	setShouldRevertLastEquippedState = function(b2: boolean) -- line: 45
		-- upvalues: u3 (ref)
		u3 = b2
	end
}
