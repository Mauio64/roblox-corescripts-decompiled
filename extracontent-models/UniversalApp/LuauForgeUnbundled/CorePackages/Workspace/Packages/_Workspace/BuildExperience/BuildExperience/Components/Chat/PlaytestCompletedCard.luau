local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local ChatCardPriority = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardPriority")
local useChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/useChatCardEmphasis")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")

local FFlagBuildExperiencePlaytestCardPublishCta = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePlaytestCardPublishCta")

local button = Foundation.Button
local iconName = Foundation.Enums.IconName
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local function PlaytestCompletedCard(props)
	local v6 = {
		description = LocalizationStrings.CHAT_COMPLETED_GAME_CREATION_DESCRIPTION,
		playtest = LocalizationStrings.CHAT_PLAYTEST,
		publish = 0,
		title = 0
	}
	local v7 = if FFlagBuildExperiencePlaytestCardPublishCta then LocalizationStrings.BUILD_MENU_PUBLISH else nil
	v6.publish = v7
	v6.title = LocalizationStrings.CHAT_COMPLETED_GAME_CREATION_TITLE
	local v8 = useLocalization(v6)

	local isLoading = props.isLoading == true
	local isPlaytestDisabled = props.isPlaytestDisabled == true
	local v9

	if FFlagBuildExperienceChatCardEmphasis then
		local v11 = if not isPlaytestDisabled then ChatCardPriority.PlaytestCompleted else nil
		v9 = useChatCardEmphasis(v11)
	end

	local onPublish = props.onPublish
	local v10

	if FFlagBuildExperiencePlaytestCardPublishCta and onPublish ~= nil then
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v14 = {
			LayoutOrder = 1,
			text = v8.playtest,
			icon = iconName.PlaySmall,
			size = inputSize.Small,
			variant = 0,
			fillBehavior = 0,
			isLoading = 0,
			isDisabled = 0,
			onActivated = 0,
			testId = "playtest-completed-card-playtest-button"
		}
		local v15 = if v9 == false then buttonVariant.SoftEmphasis else buttonVariant.Emphasis
		v14.variant = v15
		v14.fillBehavior = fillBehavior.Fill
		v14.isLoading = isLoading
		v14.isDisabled = isPlaytestDisabled
		v14.onActivated = props.onPlaytest
		v10 = createElement(
			view,
			{
				LayoutOrder = 3,
				tag = "row gap-small size-full-0 auto-y",
				testId = "playtest-completed-card-actions"
			},
			{
				Playtest = createElement2(button, v14),
				Publish = React.createElement(button, {
					LayoutOrder = 2,
					text = v8.publish,
					size = inputSize.Small,
					variant = buttonVariant.Standard,
					fillBehavior = fillBehavior.Fill,
					isDisabled = props.isPublishDisabled == true,
					onActivated = onPublish,
					testId = "playtest-completed-card-publish-button"
				})
			}
		)
	else
		local createElement = React.createElement
		local v12 = {
			LayoutOrder = 3,
			text = v8.playtest,
			icon = iconName.PlaySmall,
			size = inputSize.Small,
			variant = 0,
			width = 0,
			isLoading = 0,
			isDisabled = 0,
			onActivated = 0,
			testId = "playtest-completed-card-playtest-button"
		}
		local v13 = if v9 == false then buttonVariant.SoftEmphasis else buttonVariant.Emphasis
		v12.variant = v13
		v12.width = UDim.new(1, 0)
		v12.isLoading = isLoading
		v12.isDisabled = isPlaytestDisabled
		v12.onActivated = props.onPlaytest
		v10 = createElement(button, v12)
	end

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		testId = props.testId or "playtest-completed-card",
		tag = "col gap-medium size-full-0 auto-y padding-medium stroke-standard stroke-emphasis radius-medium clip"
	}, {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.title or v8.title,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Description = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.description or v8.description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		}),
		Actions = v10
	})
end

return PlaytestCompletedCard
