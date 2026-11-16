local AppBlox = script:FindFirstAncestor("AppBlox")
local createOverflowMenuSignalStore = require(AppBlox.OverflowMenu.createOverflowMenuSignalStore)

local overflowMenuSignalStore = nil

local function getOverflowMenuSignalStore()
	if overflowMenuSignalStore == nil then
		overflowMenuSignalStore = createOverflowMenuSignalStore()
	end

	return overflowMenuSignalStore
end

return getOverflowMenuSignalStore
