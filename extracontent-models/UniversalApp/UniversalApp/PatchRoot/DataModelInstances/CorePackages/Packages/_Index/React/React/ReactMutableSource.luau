local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
require(parent.Shared)

local function createMutableSource(source, getVersion)
	local mutableSource = {
		_getVersion = getVersion,
		_source = source,
		_workInProgressVersionPrimary = nil,
		_workInProgressVersionSecondary = nil
	}

	if ReactGlobals.__DEV__ then
		mutableSource._currentPrimaryRenderer = nil
		mutableSource._currentSecondaryRenderer = nil
	end

	return mutableSource
end

return createMutableSource
