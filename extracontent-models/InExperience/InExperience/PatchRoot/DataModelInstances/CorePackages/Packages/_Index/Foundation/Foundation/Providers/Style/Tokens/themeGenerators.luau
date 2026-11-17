local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local ColorMode = require(Foundation.Enums.ColorMode)
local RbxDesignFoundations = require(parent.RbxDesignFoundations)
local ThemeName = require(Foundation.Enums.ThemeName)

return {
	getGenerator = function(p, p2)
		local themes = RbxDesignFoundations.themes

		local v = (themes[p] or themes[ThemeName.Default])()
		return if p2 == ColorMode.Light then v.Light else v.Dark
	end
}
