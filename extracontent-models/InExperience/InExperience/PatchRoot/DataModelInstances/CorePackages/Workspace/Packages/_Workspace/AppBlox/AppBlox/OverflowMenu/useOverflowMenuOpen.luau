local AppBlox = script:FindFirstAncestor("AppBlox")

local parent = AppBlox.Parent
local SignalsReact = require(parent.SignalsReact)

local useSignalState = SignalsReact.useSignalState
local getOverflowMenuSignalStore = require(AppBlox.OverflowMenu.getOverflowMenuSignalStore)

local function useOverflowMenuOpen(p: string): boolean
	return useSignalState(getOverflowMenuSignalStore().getActiveMenuKey) == p
end

return useOverflowMenuOpen
