local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.BuilderIcons)
local React = require(parent.React)

local Avatar = require(Foundation.Components.Avatar)
local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local AvatarSize = require(Foundation.Enums.AvatarSize)
local CardDensity = require(Foundation.Enums.CardDensity)
local IconSize = require(Foundation.Enums.IconSize)
require(Foundation.Enums.UserPresence)

local function Thumbnail(props)
	local v = useTokens()
	local v2

	if props.density == CardDensity.Compact then
		v2 = v.Size.Size_1200
	else
		v2 = v.Size.Size_1600
	end

	local thumbnail = props.thumbnail
	local content

	if thumbnail.type == "Avatar" then
		local createElement = React.createElement
		local v3 = { userId = thumbnail.userId, size = 0, userPresence = 0, testId = 0 }
		local size

		if props.density == CardDensity.Compact then
			size = AvatarSize.Large
		else
			size = AvatarSize.XLarge
		end

		v3.size = size
		v3.userPresence = thumbnail.userPresence
		v3.testId = `{props.testId}--thumbnail-avatar`
		content = createElement(Avatar, v3)
	elseif thumbnail.type == "Image" then
		content = React.createElement(Image, {
			Image = thumbnail.image,
			ScaleType = Enum.ScaleType.Crop,
			tag = "size-full radius-medium",
			testId = `{props.testId}--thumbnail-image`
		})
	elseif thumbnail.type == "Icon" then
		local createElement = React.createElement
		local name

		if typeof(thumbnail.icon) == "table" then
			name = thumbnail.icon.name
		else
			name = thumbnail.icon
		end

		local variant

		if typeof(thumbnail.icon) == "table" then
			variant = thumbnail.icon.variant
		end

		content = createElement(Icon, {
			name = name,
			variant = variant,
			size = IconSize.Large,
			testId = `{props.testId}--thumbnail-icon`
		})
	else
		content = React.createElement(
			View,
			{
				tag = "align-x-center align-y-center size-full clip",
				testId = `{props.testId}--thumbnail-slot`
			},
			thumbnail.children
		)
	end

	return React.createElement(
		View,
		{
			tag = "align-x-center align-y-center",
			Size = UDim2.fromOffset(v2, v2),
			LayoutOrder = props.LayoutOrder,
			testId = `{props.testId}--thumbnail`
		},
		{ Content = content }
	)
end

return Thumbnail
