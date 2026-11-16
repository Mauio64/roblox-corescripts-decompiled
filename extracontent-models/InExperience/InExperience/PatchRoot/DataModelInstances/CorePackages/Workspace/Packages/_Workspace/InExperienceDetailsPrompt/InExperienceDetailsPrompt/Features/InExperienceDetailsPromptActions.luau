local parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(parent.React)
local DataHydration = require(parent.DataHydration)
local GameLaunch = require(parent.GameLaunch)
local LaunchErrorLocalizationKeys = GameLaunch.LaunchErrorLocalizationKeys
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local InExperienceDetailsPromptPlayButton = require(script.Parent.InExperienceDetailsPromptPlayButton)

local Foundation = require(parent.Foundation)
local Sheet = Foundation.Sheet
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppIedpFixPlayButton = SharedFlags.FFlagLuaAppIedpFixPlayButton

local function InExperienceDetailsPromptActions(props)
	local v = useTokens()
	local playabilityError

	if props.playability and not props.playability.isPlayable and props.playability.playabilityStatus then
		playabilityError = LaunchErrorLocalizationKeys[props.playability.playabilityStatus]
	end

	local v2 = useLocalization({
		playButtonUnavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		playabilityError = playabilityError
	})

	local createElement = React.createElement
	local actions = Sheet.Actions
	local createElement2 = React.createElement
	local v3

	if FFlagLuaAppIedpFixPlayButton then
		v3 = {
			PlayButton = React.createElement(InExperienceDetailsPromptPlayButton, {
				playability = props.playability,
				onJoin = props.onJoin,
				rootPlaceId = props.rootPlaceId,
				playabilityRetrievalStatus = props.playabilityRetrievalStatus,
				playButtonUnavailableText = v2.playButtonUnavailable
			}),
			Text = 0
		}
		local text

		if props.playability and not props.playability.isPlayable and v2.playabilityError then
			text = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v2.playabilityError,
				tag = "text-body-small content-default text-truncate-split auto-xy"
			})
		end

		v3.Text = text
	elseif props.playability then
		v3 = { PlayButton = 0, Text = 0 }
		local createElement3 = React.createElement
		local v4 = {
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
			text = v2.playButtonUnavailable
		end

		v4.text = text
		local icon

		if props.playability.isPlayable then
			icon = IconName.PlayLarge
		else
			icon = IconName.CircleSlash
		end

		v4.icon = icon
		local variant

		if props.playability.isPlayable then
			variant = ButtonVariant.Emphasis
		else
			variant = ButtonVariant.Standard
		end

		v4.variant = variant

		v4.onActivated = props.onJoin
		v4.isDisabled = not props.playability.isPlayable
		v3.PlayButton = createElement3(Button, v4)
		local text2

		if not (props.playability.isPlayable or not v2.playabilityError) then
			text2 = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v2.playabilityError,
				tag = "text-body-small content-default text-truncate-split auto-xy"
			})
		end

		v3.Text = text2
	else
		v3 = { PlayButton = 0 }
		local playButton

		if props.playabilityRetrievalStatus == DataHydration.DataStatus.Failed then
			playButton = React.createElement(Button, {
				LayoutOrder = 1,
				width = UDim.new(1, 0),
				icon = IconName.PlayLarge,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onJoin
			})
		else
			playButton = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v.Size.Size_1000),
				radius = Radius.Medium
			})
		end

		v3.PlayButton = playButton
	end

	return createElement(actions, nil, {
		View = createElement2(View, { tag = "col gap-small size-full-0 auto-y" }, v3)
	})
end

return InExperienceDetailsPromptActions
