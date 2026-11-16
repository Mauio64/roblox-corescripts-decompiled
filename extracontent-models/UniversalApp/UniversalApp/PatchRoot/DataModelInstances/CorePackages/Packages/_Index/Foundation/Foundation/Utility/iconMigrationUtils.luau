local Foundation = script:FindFirstAncestor("Foundation")
local parent = script.Parent
local parent2 = Foundation.Parent

local BuilderIcons = require(parent2.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox

local isBuilderIcon = require(parent.isBuilderIcon)

local function isMigrated(p: string): boolean -- 2 equivalent calls inferred from this helper
	return uiblox[p] ~= nil
end

local IconMigrationUtils = {}
IconMigrationUtils.isMigrated = isMigrated

function IconMigrationUtils.isBuilderOrMigratedIcon(p: string)
	return isBuilderIcon(p) or isMigrated(p) -- inferred equivalent call
end

function IconMigrationUtils.normalizeIconName(name: string)
	if not isMigrated(name) then -- inferred equivalent call
		return { name = name, variant = nil }
	end

	local v = uiblox[name]
	return { name = v.name, variant = v.variant }
end

return IconMigrationUtils
