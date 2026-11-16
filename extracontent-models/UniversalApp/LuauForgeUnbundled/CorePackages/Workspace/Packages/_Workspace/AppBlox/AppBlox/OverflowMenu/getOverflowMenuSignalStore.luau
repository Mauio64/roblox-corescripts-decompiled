local createOverflowMenuSignalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/OverflowMenu/createOverflowMenuSignalStore")

local overflowMenuSignalStore = nil

local function getOverflowMenuSignalStore()
	if overflowMenuSignalStore == nil then
		overflowMenuSignalStore = createOverflowMenuSignalStore()
	end

	return overflowMenuSignalStore
end

return getOverflowMenuSignalStore
