local AppBlox = script:FindFirstAncestor("AppBlox")
local AppBloxParent = AppBlox.Parent
local useSignalState = require(AppBloxParent.SignalsReact).useSignalState
local getOverflowMenuSignalStore = require(AppBlox.OverflowMenu.getOverflowMenuSignalStore)

local function useOverflowMenuOpen(s1: string) -- line: 9
	-- upvalues: getOverflowMenuSignalStore (copy), useSignalState (copy)
	local getActiveMenuKey = getOverflowMenuSignalStore().getActiveMenuKey

	return s1 == useSignalState(getActiveMenuKey)
end

return useOverflowMenuOpen
