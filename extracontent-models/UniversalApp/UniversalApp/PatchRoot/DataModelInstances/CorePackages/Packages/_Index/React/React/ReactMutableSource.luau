local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)

require(ParentParent.Shared)

local function createMutableSource(p1, p2) -- line: 18
	-- upvalues: ReactGlobals (copy)
	local t1 = {
		_workInProgressVersionPrimary = nil,
		_workInProgressVersionSecondary = nil,
		_getVersion = p2,
		_source = p1
	}

	if ReactGlobals.__DEV__ then
		t1._currentPrimaryRenderer = nil
		t1._currentSecondaryRenderer = nil
	end

	return t1
end

return createMutableSource
