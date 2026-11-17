local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local AccessoryType = require(Foundation.Enums.AccessoryType)
local AvatarIcon = require(Foundation.Components.AvatarIcon)
local Icon = require(Foundation.Components.Icon)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

require(script.Parent.useMetadataVariants)

local function MetadataAccessoryElement(props)
	local variant = props.variant
	local v

	if type(props.config) == "string" then
		v = { iconName = props.config }
	else
		v = props.config
	end

	if v.type == AccessoryType.Avatar then
		return React.createElement(View, {
			tag = variant.avatarTag,
			LayoutOrder = props.LayoutOrder
		}, {
			Avatar = React.createElement(AvatarIcon, {
				userId = v.userId,
				size = variant.avatarSize,
				testId = props.testId
			})
		})
	end

	return React.createElement(Icon, {
		name = v.iconName,
		variant = v.iconVariant,
		size = variant.iconSize,
		style = variant.style,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

return MetadataAccessoryElement
