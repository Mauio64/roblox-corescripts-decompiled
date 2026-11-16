local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/React")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DataHydration")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/Foundation")
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function InExperienceDetailsPromptPlayButton(props)
	local v5 = useTokens()

	if
		not props.rootPlaceId
		or not props.playability and props.playabilityRetrievalStatus ~= DataHydration.DataStatus.Failed
	then
		return React.createElement(skeleton, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v5.Size.Size_1000),
			radius = radius.Medium
		})
	end

	if not props.playability then
		return React.createElement(button, {
			LayoutOrder = 1,
			width = UDim.new(1, 0),
			icon = iconName.PlayLarge,
			variant = buttonVariant.Emphasis,
			onActivated = props.onJoin
		})
	end

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = 1,
		width = UDim.new(1, 0),
		text = 0,
		icon = 0,
		variant = 0,
		onActivated = 0,
		isDisabled = 0
	}
	local v8 = if not props.playability.isPlayable then props.playButtonUnavailableText else nil
	v7.text = v8
	local v9 = if props.playability.isPlayable then iconName.PlayLarge else iconName.CircleSlash
	v7.icon = v9
	local v10 = if props.playability.isPlayable then buttonVariant.Emphasis else buttonVariant.Standard
	v7.variant = v10
	v7.onActivated = props.onJoin
	v7.isDisabled = not props.playability.isPlayable
	return createElement(button, v7)
end

return InExperienceDetailsPromptPlayButton
