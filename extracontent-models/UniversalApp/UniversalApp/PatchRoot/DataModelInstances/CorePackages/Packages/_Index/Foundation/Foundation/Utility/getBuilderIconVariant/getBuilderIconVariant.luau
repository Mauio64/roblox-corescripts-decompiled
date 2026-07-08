local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local isBuilderIcon = require(Foundation.Utility.isBuilderIcon)

local function getBuilderIconVariant(p1) -- line: 8
	-- upvalues: isBuilderIcon (copy), BuilderIcons (copy)
	if not pcall(function() -- line: 9
		-- upvalues: p1 (copy)
		return p1.Text
	end) then
		return nil
	end

	if not isBuilderIcon(p1.Text) then
		return nil
	end

	if p1.FontFace.Weight == Enum.FontWeight.Bold then
		return BuilderIcons.IconVariant.Filled
	end

	return BuilderIcons.IconVariant.Regular
end

return getBuilderIconVariant
