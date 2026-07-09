local CorePackages = game:GetService("CorePackages")
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local TopBarConstants = require(script.Parent.Parent.TopBarConstants)
local t1 = {
	[FormFactor.COMPACT] = {
		IconButtonSize = 34
	},
	[FormFactor.WIDE] = {
		IconButtonSize = 44
	}
}

local function getIconButtonSize(p1) -- line: 22
	-- upvalues: t1 (copy), TopBarConstants (copy)
	local v7 = t1[p1]

	return v7 and v7.IconButtonSize or TopBarConstants.DEFAULT_ICON_BUTTON_SIZE
end

return getIconButtonSize
