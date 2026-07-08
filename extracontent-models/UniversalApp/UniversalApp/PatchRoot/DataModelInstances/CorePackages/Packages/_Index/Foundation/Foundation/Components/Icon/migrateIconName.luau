local Parent = script:FindFirstAncestor("Foundation").Parent
local Migration = require(Parent.BuilderIcons).Migration

local function migrateIconName(s1: string) -- line: 7
	-- upvalues: Migration (copy)
	return Migration.uiblox[s1]
end

return migrateIconName
