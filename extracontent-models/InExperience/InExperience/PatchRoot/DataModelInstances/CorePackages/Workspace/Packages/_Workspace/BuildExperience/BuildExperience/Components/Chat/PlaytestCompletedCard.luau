local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local ChatCardPriority = require(script.Parent.ChatCardEmphasis.ChatCardPriority)
local useChatCardEmphasis = require(script.Parent.ChatCardEmphasis.useChatCardEmphasis)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)

local FFlagBuildExperiencePlaytestCardPublishCta = require(BuildExperience.Flags.FFlagBuildExperiencePlaytestCardPublishCta)

local Button = Foundation.Button
local IconName = Foundation.Enums.IconName
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function PlaytestCompletedCard(props)
	local v = {
		description = LocalizationStrings.CHAT_COMPLETED_GAME_CREATION_DESCRIPTION,
		playtest = LocalizationStrings.CHAT_PLAYTEST,
		publish = 0,
		title = 0
	}
	local publish

	if FFlagBuildExperiencePlaytestCardPublishCta then
		publish = LocalizationStrings.BUILD_MENU_PUBLISH
	end

	v.publish = publish
	v.title = LocalizationStrings.CHAT_COMPLETED_GAME_CREATION_TITLE
	local v2 = useLocalization(v)

	local isLoading = props.isLoading == true
	local isPlaytestDisabled = props.isPlaytestDisabled == true
	local v3

	if FFlagBuildExperienceChatCardEmphasis then
		local v4

		if not isPlaytestDisabled then
			v4 = ChatCardPriority.PlaytestCompleted
		end

		v3 = useChatCardEmphasis(v4)
	end

	local onPublish = props.onPublish
	local actions

	if FFlagBuildExperiencePlaytestCardPublishCta and onPublish ~= nil then
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v4 = {
			LayoutOrder = 1,
			text = v2.playtest,
			icon = IconName.PlaySmall,
			size = InputSize.Small,
			variant = 0,
			fillBehavior = 0,
			isLoading = 0,
			isDisabled = 0,
			onActivated = 0,
			testId = "playtest-completed-card-playtest-button"
		}
		local variant

		if v3 == false then
			variant = ButtonVariant.SoftEmphasis
		else
			variant = ButtonVariant.Emphasis
		end

		v4.variant = variant
		v4.fillBehavior = FillBehavior.Fill
		v4.isLoading = isLoading
		v4.isDisabled = isPlaytestDisabled
		v4.onActivated = props.onPlaytest
		actions = createElement(
			View,
			{
				LayoutOrder = 3,
				tag = "row gap-small size-full-0 auto-y",
				testId = "playtest-completed-card-actions"
			},
			{
				Playtest = createElement2(Button, v4),
				Publish = React.createElement(Button, {
					LayoutOrder = 2,
					text = v2.publish,
					size = InputSize.Small,
					variant = ButtonVariant.Standard,
					fillBehavior = FillBehavior.Fill,
					isDisabled = props.isPublishDisabled == true,
					onActivated = onPublish,
					testId = "playtest-completed-card-publish-button"
				})
			}
		)
	else
		local createElement = React.createElement
		local v4 = {
			LayoutOrder = 3,
			text = v2.playtest,
			icon = IconName.PlaySmall,
			size = InputSize.Small,
			variant = 0,
			width = 0,
			isLoading = 0,
			isDisabled = 0,
			onActivated = 0,
			testId = "playtest-completed-card-playtest-button"
		}
		local variant

		if v3 == false then
			variant = ButtonVariant.SoftEmphasis
		else
			variant = ButtonVariant.Emphasis
		end

		v4.variant = variant
		v4.width = UDim.new(1, 0)
		v4.isLoading = isLoading
		v4.isDisabled = isPlaytestDisabled
		v4.onActivated = props.onPlaytest
		actions = createElement(Button, v4)
	end

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		testId = props.testId or "playtest-completed-card",
		tag = "col gap-medium size-full-0 auto-y padding-medium stroke-standard stroke-emphasis radius-medium clip"
	}, {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.title or v2.title,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Description = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.description or v2.description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		}),
		Actions = actions
	})
end

return PlaytestCompletedCard
