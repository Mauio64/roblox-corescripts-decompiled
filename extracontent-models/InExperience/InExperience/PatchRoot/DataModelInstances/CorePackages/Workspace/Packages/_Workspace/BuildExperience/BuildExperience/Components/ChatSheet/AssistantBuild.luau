local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceInGameShell = SharedFlags.FFlagBuildExperienceInGameShell
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local GetAssistantBuildStore = require(BuildExperience.Stores.GetAssistantBuildStore)
local GetPlayButtonStore = require(BuildExperience.Stores.GetPlayButtonStore)

local EducationalTooltip = Foundation.EducationalTooltip
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local View = Foundation.View

local function AssistantBuild(props)
	local v = useLocalization({
		disabledTitle = LocalizationStrings.CHAT_ASSISTANT_DISABLED,
		portraitRequired = LocalizationStrings.CHAT_PORTRAIT_REQUIRED
	})

	local assistantBuildStore = GetAssistantBuildStore()
	local playButtonStore = GetPlayButtonStore()
	local isDisabled = SignalsReact.useSignalState(assistantBuildStore.getIsDisabled)
	local isOpen = SignalsReact.useSignalState(assistantBuildStore.getIsDisabledTooltipOpen)
	local v2

	if FFlagBuildExperienceInGameShell then
		v2 = SignalsReact.useSignalState(assistantBuildStore.getIsOverlayVisible)
	end

	local onActivated = React.useCallback(function()
		if isDisabled then
			assistantBuildStore.setIsDisabledTooltipOpen(not isOpen)
			return
		end

		assistantBuildStore.setIsDisabledTooltipOpen(false)
		playButtonStore.setIsActive(true)
	end, { assistantBuildStore, isDisabled, isOpen, playButtonStore })
	local onPressedOutside = React.useCallback(function()
		assistantBuildStore.setIsDisabledTooltipOpen(false)
	end, { assistantBuildStore })

	React.useEffect(function()
		if isDisabled then
			playButtonStore.setIsActive(false)
		else
			assistantBuildStore.setIsDisabledTooltipOpen(false)
		end
	end, { assistantBuildStore, isDisabled, playButtonStore })

	local createElement = React.createElement
	local icon

	if FFlagBuildExperienceInGameShell then
		if v2 then
			icon = IconName.TwoArrowsFromCenter
		else
			icon = IconName.TwoArrowsToCenter
		end
	else
		icon = IconName.Nebula
	end

	local v3 = {
		icon = icon,
		variant = props.variant,
		size = InputSize.Medium,
		isCircular = true,
		isDisabled = isDisabled,
		onActivated = 0,
		testId = "build-header-play-button"
	}
	local onActivated2

	if FFlagBuildExperienceInGameShell then
		onActivated2 = assistantBuildStore.activate
	else
		onActivated2 = onActivated
	end

	v3.onActivated = onActivated2
	local element = createElement(IconButton, v3)

	local createElement2 = React.createElement

	if FFlagBuildExperienceInGameShell then
		onActivated = assistantBuildStore.activate
	end

	local element2 = createElement2(
		View,
		{ onActivated = onActivated, tag = "auto-xy", testId = "build-header-play-button-disabled" },
		{ Button = element }
	)

	local createElement3 = React.createElement
	local v4 = {
		LayoutOrder = props.layoutOrder,
		tag = "auto-xy",
		testId = props.testId or "assistant-build"
	}
	local tooltip

	if isDisabled then
		tooltip = React.createElement(EducationalTooltip, {
			align = PopoverAlign.Start,
			isOpen = isOpen,
			onPressedOutside = onPressedOutside,
			side = PopoverSide.Bottom,
			text = v.portraitRequired,
			testId = "build-assistant-disabled-tooltip",
			title = v.disabledTitle
		}, { Button = element2 })
	end

	if isDisabled then
		element = nil
	end

	return createElement3(View, v4, { Tooltip = tooltip, Button = element })
end

return React.memo(AssistantBuild)
