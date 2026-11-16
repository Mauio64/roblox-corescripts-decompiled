local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dww")
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function BuilderIconElement(props)
	local fullProps = props.fullProps
	local migrationLookup = props.migrationLookup
	local elementType = props.elementType
	local v5 = useTextSizeOffset()
	local v6 = useTokens()

	local v7 = module.RemoveFromDictionary(
		fullProps,
		"Image",
		"ImageRectOffset",
		"ImageRectSize",
		"SliceCenter",
		"SliceScale",
		"ResampleMode",
		"ScaleType",
		"TileSize"
	)

	local size = v7.Size
	local v8

	if size.X.Offset == 0 or size.Y.Scale == 0 then
		v8 = not (size.Y.Offset == 0) and size.X.Scale ~= 0
	else
		v8 = true
	end

	if not v8 and v7.Size.X.Offset ~= v7.Size.Y.Offset then
		local v9 = math.min(v7.Size.X.Offset, v7.Size.Y.Offset)
		v7.Size = UDim2.fromOffset(v9, v9)
	end

	v7.TextSize = v7.Size.Y.Offset

	if v7.TextSize == 0 or v8 then
		v7.TextScaled = true
	else
		local textSize = v7.TextSize
		local size_100 = v6.Size.Size_100

		v7.TextSize = math.round(textSize / size_100) * size_100
	end

	v7.Text = migrationLookup.name
	v7.FontFace = BuilderIcons.Font[migrationLookup.variant]
	v7.Image = nil
	v7.TextColor3 = v7.ImageColor3 or v6.Color.Content.Emphasis.Color3
	v7.TextTransparency = v7.ImageTransparency or v6.Color.Content.Emphasis.Transparency
	v7.ImageColor3 = nil
	v7.ImageTransparency = nil

	if v5 > 0 then
		return React.createElement(elementType, v7, {
			Children = React.createElement(React.Fragment, nil, v7.children),
			UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
				MaxTextSize = v7.TextSize
			})
		})
	end

	return React.createElement(elementType, v7)
end

return BuilderIconElement
