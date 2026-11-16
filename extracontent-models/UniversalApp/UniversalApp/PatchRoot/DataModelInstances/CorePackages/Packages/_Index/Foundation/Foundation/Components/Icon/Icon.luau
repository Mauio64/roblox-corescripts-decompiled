local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BuilderIcons = require(parent.BuilderIcons)
local Font = BuilderIcons.Font
local IconVariant = BuilderIcons.IconVariant

local IconSize = require(Foundation.Enums.IconSize)
local Image = require(Foundation.Components.Image)
local Text = require(Foundation.Components.Text)

local Flags = require(Foundation.Utility.Flags)
local Logger = require(Foundation.Utility.Logger)
local devAssert = require(Foundation.Utility.devAssert)
local isBuilderIcon = require(Foundation.Utility.isBuilderIcon)
local migrateFontSize = require(script.Parent.migrateFontSize)
local migrateIconName = require(script.Parent.migrateIconName)
local useIconSize = require(Foundation.Utility.useIconSize)
local useTextSizeOffset = require(Foundation.Providers.Style.useTextSizeOffset)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Components.Types)

local v = { size = IconSize.Medium, variant = IconVariant.Regular, testId = "--foundation-icon" }

local function Icon(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = useTextSizeOffset()
	local v5 = migrateIconName(v2.name)
	local size = useIconSize(v2.size, isBuilderIcon(v2.name))

	local variant = v2.variant
	local name = v2.name
	local offset

	if typeof(size) ~= "table" then
		offset = size.Y.Offset
	end

	local v6 = false

	if not isBuilderIcon(name) and v5 then
		if typeof(size) == "table" then
			if Flags.FoundationDevOnlyPropAsserts then
				devAssert(
					false,
					"Binding size isn't supported when migrating a UIBlox icon, use Builder Icons directly"
				)
			else
				error("Binding size isn't supported when migrating a UIBlox icon, use Builder Icons directly")
			end
		else
			variant = v5.variant or variant
			name = v5.name
			offset = migrateFontSize(offset, v3)
			v6 = true
		end
	end

	local style = v2.style or v3.Color.Content.Default

	if isBuilderIcon(name) or v6 then
		local createElement = React.createElement

		local v7 = withCommonProps(v2, {
			textStyle = style,
			Text = name,
			fontStyle = { Font = Font[variant], FontSize = offset },
			TextScaled = typeof(size) == "table",
			Size = size,
			ref = ref,
			Rotation = v2.Rotation
		})
		local uiTextSizeConstraint

		if v4 > 0 and offset then
			uiTextSizeConstraint = React.createElement("UITextSizeConstraint", {
				MaxTextSize = offset
			})
		end

		return createElement(Text, v7, {
			UITextSizeConstraint = uiTextSizeConstraint,
			Children = React.createElement(React.Fragment, nil, v2.children)
		})
	end

	if p.variant ~= nil then
		Logger:warning("variant is not supported when using FoundationImages, consider using BuilderIcons")
	end

	return (React.createElement(Image, withCommonProps(v2, {
		imageStyle = style,
		Image = name,
		Size = size,
		ref = ref,
		Rotation = v2.Rotation
	}), v2.children))
end

return React.memo(React.forwardRef(Icon))
