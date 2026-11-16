local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local ColorMode = require(Foundation.Enums.ColorMode)
local Flags = require(Foundation.Utility.Flags)
local RbxDesignFoundations = require(parent.RbxDesignFoundations)
local ThemeName = require(Foundation.Enums.ThemeName)

return {
	getGenerator = function(p, p2)
		local themes

		if Flags.FoundationFontFaceMigration then
			themes = RbxDesignFoundations.themes
		else
			local RbxDesignFoundationsV4 = require(parent.RbxDesignFoundationsV4)
			themes = RbxDesignFoundationsV4.themes
		end

		local v = (themes[p] or themes[ThemeName.Default])()
		return if p2 == ColorMode.Light then v.Light else v.Dark
	end
}
