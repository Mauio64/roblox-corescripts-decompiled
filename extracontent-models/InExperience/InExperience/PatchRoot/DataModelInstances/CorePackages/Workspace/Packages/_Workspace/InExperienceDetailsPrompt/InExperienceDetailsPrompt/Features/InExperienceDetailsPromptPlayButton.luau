local parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(parent.React)
local DataHydration = require(parent.DataHydration)

local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function InExperienceDetailsPromptPlayButton(props)
	local v = useTokens()

	if
		not props.rootPlaceId
		or not props.playability and props.playabilityRetrievalStatus ~= DataHydration.DataStatus.Failed
	then
		return React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v.Size.Size_1000),
			radius = Radius.Medium
		})
	end

	if not props.playability then
		return React.createElement(Button, {
			LayoutOrder = 1,
			width = UDim.new(1, 0),
			icon = IconName.PlayLarge,
			variant = ButtonVariant.Emphasis,
			onActivated = props.onJoin
		})
	end

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = 1,
		width = UDim.new(1, 0),
		text = 0,
		icon = 0,
		variant = 0,
		onActivated = 0,
		isDisabled = 0
	}
	local text

	if not props.playability.isPlayable then
		text = props.playButtonUnavailableText
	end

	v2.text = text
	local icon

	if props.playability.isPlayable then
		icon = IconName.PlayLarge
	else
		icon = IconName.CircleSlash
	end

	v2.icon = icon
	local variant

	if props.playability.isPlayable then
		variant = ButtonVariant.Emphasis
	else
		variant = ButtonVariant.Standard
	end

	v2.variant = variant
	v2.onActivated = props.onJoin
	v2.isDisabled = not props.playability.isPlayable
	return createElement(Button, v2)
end

return InExperienceDetailsPromptPlayButton
