local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Immutable = require(Modules.Common.Immutable)
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local useTextSizeOffset = require(CorePackages.Packages.UIBlox).Core.Style.useTextSizeOffset
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens

local function BuilderIconElement(t1: {[any]: any}) -- line: 14
	-- upvalues: useTextSizeOffset (copy), useTokens (copy), Immutable (copy), BuilderIcons (copy), React (copy)
	local fullProps = t1.fullProps
	local migrationLookup = t1.migrationLookup
	local elementType = t1.elementType
	local v14 = useTextSizeOffset()
	local v15 = useTokens()
	local v16 = Immutable.RemoveFromDictionary(fullProps, "Image", "ImageRectOffset", "ImageRectSize", "SliceCenter", "SliceScale", "ResampleMode", "ScaleType", "TileSize")
	local Size = v16.Size
	local v18 = Size.X.Offset ~= 0 and Size.Y.Scale ~= 0 or Size.Y.Offset ~= 0 and Size.X.Scale ~= 0

	if not v18 and v16.Size.X.Offset ~= v16.Size.Y.Offset then
		local v19 = math.min(v16.Size.X.Offset, v16.Size.Y.Offset)

		v16.Size = UDim2.fromOffset(v19, v19)
	end

	v16.TextSize = v16.Size.Y.Offset

	if v16.TextSize == 0 or v18 then
		v16.TextScaled = true
	else
		local TextSize = v16.TextSize
		local Size_100 = v15.Size.Size_100

		v16.TextSize = math.round(TextSize / Size_100) * Size_100
	end

	v16.Text = migrationLookup.name
	v16.FontFace = BuilderIcons.Font[migrationLookup.variant]
	v16.Image = nil
	v16.TextColor3 = v16.ImageColor3 or v15.Color.Content.Emphasis.Color3
	v16.TextTransparency = v16.ImageTransparency or v15.Color.Content.Emphasis.Transparency
	v16.ImageColor3 = nil
	v16.ImageTransparency = nil

	if v14 > 0 then
		return React.createElement(elementType, v16, {
			Children = React.createElement(React.Fragment, nil, v16.children),
			UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
				MaxTextSize = v16.TextSize
			})
		})
	end

	return React.createElement(elementType, v16)
end

return BuilderIconElement
