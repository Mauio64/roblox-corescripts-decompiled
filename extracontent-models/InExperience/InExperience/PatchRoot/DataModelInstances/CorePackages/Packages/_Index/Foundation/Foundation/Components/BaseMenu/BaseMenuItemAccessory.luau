local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Avatar = require(Foundation.Components.Avatar)
local Badge = require(Foundation.Components.Badge)
local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local Flags = require(Foundation.Utility.Flags)
local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon
local normalizeIconName = iconMigrationUtils.normalizeIconName

local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
require(Foundation.Providers.Style.Tokens)

local AccessoryType = require(Foundation.Enums.AccessoryType)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
require(Foundation.Enums.InputSize)

local v = { colorNamespace = ColorNamespace.Color, isIconSize = true }

local function Accessory(props)
	local accessory = props.accessory

	if accessory == nil then
		return nil
	end

	local formatted = `align-x-center align-y-center {props.iconVariant.tag}`

	if accessory.type == AccessoryType.Avatar then
		return React.createElement(View, {
			LayoutOrder = props.LayoutOrder,
			tag = formatted,
			testId = props.testId
		}, {
			Avatar = React.createElement(PresentationContext.Provider, { value = v }, {
				Avatar = React.createElement(Avatar, {
					userId = accessory.userId,
					backplateStyle = props.tokens.Color.Shift.Shift_200,
					size = props.size
				})
			})
		})
	end

	if accessory.type == "Hint" then
		return React.createElement(
			View,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "row align-y-center auto-xy padding-x-xsmall radius-small bg-shift-200",
				testId = props.testId
			},
			{
				Text = React.createElement(Text, {
					Text = accessory.text,
					tag = "auto-xy text-caption-medium content-muted"
				})
			}
		)
	end

	if accessory.type == "Badge" then
		return React.createElement(Badge, {
			LayoutOrder = props.LayoutOrder,
			text = accessory.text,
			icon = accessory.icon,
			variant = accessory.variant,
			testId = props.testId
		})
	end

	if Flags.FoundationBaseMenuAccessorySizing and not isBuilderOrMigratedIcon(accessory.iconName) then
		return React.createElement(View, {
			LayoutOrder = props.LayoutOrder,
			tag = formatted,
			testId = props.testId
		}, {
			Media = React.createElement(Image, {
				Image = accessory.iconName,
				ScaleType = Enum.ScaleType.Crop,
				tag = "size-full-full radius-xsmall",
				testId = `{props.testId}--media`
			})
		})
	end

	local v2

	if Flags.FoundationBaseMenuAccessorySizing then
		v2 = normalizeIconName(accessory.iconName)
	end

	local createElement = React.createElement
	local v3 = { LayoutOrder = props.LayoutOrder, tag = formatted, testId = props.testId }

	local createElement2 = React.createElement
	local name

	if Flags.FoundationBaseMenuAccessorySizing then
		name = v2.name
	else
		name = accessory.iconName
	end

	local variant

	if Flags.FoundationBaseMenuAccessorySizing then
		variant = v2.variant or accessory.iconVariant
	else
		variant = accessory.iconVariant
	end

	return createElement(View, v3, {
		Icon = createElement2(Icon, {
			name = name,
			variant = variant,
			style = props.iconVariant.style,
			size = props.iconVariant.size
		})
	})
end

return Accessory
