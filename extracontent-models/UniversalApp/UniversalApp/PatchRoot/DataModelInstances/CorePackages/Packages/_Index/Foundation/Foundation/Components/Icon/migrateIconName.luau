local parent = script:FindFirstAncestor("Foundation").Parent
local BuilderIcons = require(parent.BuilderIcons)

local Migration = BuilderIcons.Migration

local function migrateIconName(p: string)
	return Migration.uiblox[p]
end

return migrateIconName
