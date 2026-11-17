local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local InputSize = require(Foundation.Enums.InputSize)

local Icon = require(Foundation.Components.Icon)
local IconButton = require(Foundation.Components.IconButton)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)

local useTokens = require(Foundation.Providers.Style.useTokens)

local Thumbnail = require(script.Parent.Thumbnail)
local useUpsellContentVariants = require(script.Parent.useUpsellContentVariants)

local icon = BuilderIcons.Icon

local function UpsellContent(props)
	local v = useUpsellContentVariants(useTokens(), props.density)
	local v2 = props.onActivated ~= nil

	local createElement = React.createElement
	local v3 = {
		tag = v.container.tag,
		LayoutOrder = 1,
		testId = `{props.testId}--upsell-content`
	}
	local thumbnail

	if props.thumbnail then
		thumbnail = React.createElement(Thumbnail, {
			thumbnail = props.thumbnail,
			density = props.density,
			testId = props.testId,
			LayoutOrder = 1
		})
	end

	local createElement2 = React.createElement
	local v4 = {
		tag = v.content.tag,
		LayoutOrder = 2,
		testId = `{props.testId}--upsell-content--body`
	}
	local title

	if props.title then
		title = React.createElement(Text, {
			Text = props.title,
			tag = v.title.tag,
			LayoutOrder = 1,
			testId = `{props.testId}--title`
		})
	end

	local description

	if props.description then
		description = React.createElement(Text, {
			Text = props.description,
			TextTruncate = Enum.TextTruncate.AtEnd,
			sizeConstraint = v.description.sizeConstraint,
			tag = v.description.tag,
			LayoutOrder = 2,
			testId = `{props.testId}--description`
		})
	end

	local v5 = {
		Thumbnail = thumbnail,
		Content = createElement2(View, v4, { Title = title, Description = description }),
		Chevron = 0,
		Close = 0
	}
	local chevron

	if v2 then
		chevron = React.createElement(Icon, {
			name = icon.ChevronSmallRight,
			LayoutOrder = 3,
			testId = `{props.testId}--chevron`
		})
	end

	v5.Chevron = chevron
	local close

	if props.onClose and not v2 then
		close = React.createElement(IconButton, {
			onActivated = props.onClose,
			icon = icon.X,
			variant = ButtonVariant.Utility,
			size = InputSize.Small,
			isCircular = true,
			LayoutOrder = 4,
			testId = `{props.testId}--close`
		})
	end

	v5.Close = close
	return createElement(View, v3, v5)
end

return UpsellContent
