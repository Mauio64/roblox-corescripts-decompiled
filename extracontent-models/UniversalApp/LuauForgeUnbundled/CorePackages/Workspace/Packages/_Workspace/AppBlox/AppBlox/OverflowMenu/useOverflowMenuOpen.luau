local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SignalsReact").useSignalState
local getOverflowMenuSignalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/OverflowMenu/getOverflowMenuSignalStore")

local function useOverflowMenuOpen(p2): boolean
	return useSignalState(getOverflowMenuSignalStore().getActiveMenuKey) == p2
end

return useOverflowMenuOpen
