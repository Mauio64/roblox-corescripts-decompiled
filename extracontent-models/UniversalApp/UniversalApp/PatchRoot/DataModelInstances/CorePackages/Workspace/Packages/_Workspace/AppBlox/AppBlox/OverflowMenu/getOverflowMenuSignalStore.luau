local AppBlox = script:FindFirstAncestor("AppBlox")
local createOverflowMenuSignalStore = require(AppBlox.OverflowMenu.createOverflowMenuSignalStore)
local u3 = nil

local function getOverflowMenuSignalStore() -- line: 8
	-- upvalues: u3 (ref), createOverflowMenuSignalStore (copy)
	if u3 == nil then
		u3 = createOverflowMenuSignalStore()
	end

	return u3
end

return getOverflowMenuSignalStore
