local Foundation = script:FindFirstAncestor("Foundation")
local scriptParent = script.Parent
local FoundationParent = Foundation.Parent
local uiblox = require(FoundationParent.BuilderIcons).Migration.uiblox
local isBuilderIcon = require(scriptParent.isBuilderIcon)

return {
	isMigrated = function(s1: string) -- line: 10
		-- upvalues: uiblox (copy)
		return uiblox[s1] ~= nil
	end,
	isBuilderOrMigratedIcon = function(s2: string) -- line: 13
		-- upvalues: isBuilderIcon (copy), uiblox (copy)
		return isBuilderIcon(s2) or uiblox[s2] ~= nil
	end
}
