local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)

local isBuilderIcon = require(Foundation.Utility.isBuilderIcon)

local function getBuilderIconVariant(p)
	if not pcall(function()
		return p.Text
	end) then
		return nil
	end

	if not isBuilderIcon(p.Text) then
		return nil
	end

	if p.FontFace.Weight == Enum.FontWeight.Bold then
		return BuilderIcons.IconVariant.Filled
	end

	return BuilderIcons.IconVariant.Regular
end

return getBuilderIconVariant
