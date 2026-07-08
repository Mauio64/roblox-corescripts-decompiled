local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local BuilderIcons = require(FoundationParent.BuilderIcons)
local BuilderIconsFont = BuilderIcons.Font
local IconVariant = BuilderIcons.IconVariant
local IconSize = require(Foundation.Enums.IconSize)
local Image = require(Foundation.Components.Image)
local Text = require(Foundation.Components.Text)
local Logger = require(Foundation.Utility.Logger)
local isBuilderIcon = require(Foundation.Utility.isBuilderIcon)
local migrateFontSize = require(script.Parent.migrateFontSize)
local migrateIconName = require(script.Parent.migrateIconName)
local useIconSize = require(Foundation.Utility.useIconSize)
local useTextSizeOffset = require(Foundation.Providers.Style.useTextSizeOffset)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Components.Types)

local t1 = {
	testId = "--foundation-icon",
	size = IconSize.Medium,
	variant = IconVariant.Regular
}

local function Icon(p1, p2) -- line: 46
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useTextSizeOffset (copy), migrateIconName (copy), useIconSize (copy), isBuilderIcon (copy), migrateFontSize (copy), Logger (copy), React (copy), Image (copy), withCommonProps (copy), Text (copy), BuilderIconsFont (copy)
	local v23 = withDefaults(p1, t1)
	local v24 = useTokens()
	local v25 = useTextSizeOffset()
	local v26 = migrateIconName(v23.name)
	local v27 = useIconSize(v23.size, isBuilderIcon(v23.name))
	local variant = v23.variant
	local name = v23.name
	local v30 = if typeof(v27) ~= "table" then v27.Y.Offset else nil

	if not isBuilderIcon(name) and v26 then
		if typeof(v27) == "table" then
			error("Binding size isn't supported when migrating a UIBlox icon, use Builder Icons directly")
		end

		variant = v26.variant or variant
		name = v26.name
		v30 = migrateFontSize(v30, v24)
	end

	local v31 = v23.style or v24.Color.Content.Default

	if not isBuilderIcon(name) and not v26 then
		if p1.variant ~= nil then
			Logger:warning("variant is not supported when using FoundationImages, consider using BuilderIcons")
		end

		return (React.createElement(Image, withCommonProps(v23, {
			imageStyle = v31,
			Image = name,
			Size = v27,
			ref = p2,
			Rotation = v23.Rotation
		}), v23.children))
	end

	return React.createElement(Text, withCommonProps(v23, {
		textStyle = v31,
		Text = name,
		fontStyle = {
			Font = BuilderIconsFont[variant],
			FontSize = v30
		},
		TextScaled = typeof(v27) == "table",
		Size = v27,
		ref = p2,
		Rotation = v23.Rotation
	}), {
		UITextSizeConstraint = if not (v25 > 0) or not v30 then nil else React.createElement("UITextSizeConstraint", {
			MaxTextSize = v30
		}),
		Children = React.createElement(React.Fragment, nil, v23.children)
	})
end

return React.memo(React.forwardRef(Icon))
