local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/React")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DataHydration")
local launchErrorLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/GameLaunch").LaunchErrorLocalizationKeys
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/Localization").Hooks.useLocalization
local InExperienceDetailsPromptPlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/InExperienceDetailsPrompt/Features/InExperienceDetailsPromptPlayButton")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/Foundation")
local sheet = Foundation.Sheet
local view = Foundation.View
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local fFlagLuaAppIedpFixPlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/SharedFlags").FFlagLuaAppIedpFixPlayButton

local function InExperienceDetailsPromptActions(props)
	local v5 = useTokens()
	local v6

	if props.playability and not props.playability.isPlayable and props.playability.playabilityStatus then
		v6 = launchErrorLocalizationKeys[props.playability.playabilityStatus]
	end

	local v7 = useLocalization({
		playButtonUnavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		playabilityError = v6
	})

	local createElement = React.createElement
	local actions = sheet.Actions
	local createElement2 = React.createElement
	local v12

	if fFlagLuaAppIedpFixPlayButton then
		v12 = {
			PlayButton = React.createElement(InExperienceDetailsPromptPlayButton, {
				playability = props.playability,
				onJoin = props.onJoin,
				rootPlaceId = props.rootPlaceId,
				playabilityRetrievalStatus = props.playabilityRetrievalStatus,
				playButtonUnavailableText = v7.playButtonUnavailable
			}),
			Text = 0
		}

		local v13 = if props.playability and not props.playability.isPlayable and v7.playabilityError then React.createElement(text, {
			LayoutOrder = 2,
			Text = v7.playabilityError,
			tag = "text-body-small content-default text-truncate-split auto-xy"
		}) else nil
		v12.Text = v13
	elseif props.playability then
		v12 = { PlayButton = 0, Text = 0 }
		local createElement3 = React.createElement
		local v14 = {
			LayoutOrder = 1,
			width = UDim.new(1, 0),
			text = 0,
			icon = 0,
			variant = 0,
			onActivated = 0,
			isDisabled = 0
		}
		local v15 = if not props.playability.isPlayable then v7.playButtonUnavailable else nil
		v14.text = v15
		local v16 = if props.playability.isPlayable then iconName.PlayLarge else iconName.CircleSlash
		v14.icon = v16
		local v17 = if props.playability.isPlayable then buttonVariant.Emphasis else buttonVariant.Standard
		v14.variant = v17

		v14.onActivated = props.onJoin
		v14.isDisabled = not props.playability.isPlayable
		v12.PlayButton = createElement3(button, v14)

		local v18 = if not (props.playability.isPlayable or not v7.playabilityError) then React.createElement(text, {
			LayoutOrder = 2,
			Text = v7.playabilityError,
			tag = "text-body-small content-default text-truncate-split auto-xy"
		}) else nil
		v12.Text = v18
	else
		v12 = { PlayButton = 0 }

		local v13 = if props.playabilityRetrievalStatus == DataHydration.DataStatus.Failed then React.createElement(button, {
			LayoutOrder = 1,
			width = UDim.new(1, 0),
			icon = iconName.PlayLarge,
			variant = buttonVariant.Emphasis,
			onActivated = props.onJoin
		}) else React.createElement(skeleton, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v5.Size.Size_1000),
			radius = radius.Medium
		})
		v12.PlayButton = v13
	end

	return createElement(actions, nil, {
		View = createElement2(view, { tag = "col gap-small size-full-0 auto-y" }, v12)
	})
end

return InExperienceDetailsPromptActions
