local fFlagBuildExperienceInGameShell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceInGameShell
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local GetAssistantBuildStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAssistantBuildStore")
local GetPlayButtonStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetPlayButtonStore")

local educationalTooltip = Foundation.EducationalTooltip
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local view = Foundation.View

local function AssistantBuild(props)
	local v5 = useLocalization({
		disabledTitle = LocalizationStrings.CHAT_ASSISTANT_DISABLED,
		portraitRequired = LocalizationStrings.CHAT_PORTRAIT_REQUIRED
	})

	local v6 = GetAssistantBuildStore()
	local v7 = GetPlayButtonStore()
	local v8 = SignalsReact.useSignalState(v6.getIsDisabled)
	local v9 = SignalsReact.useSignalState(v6.getIsDisabledTooltipOpen)
	local v10

	if fFlagBuildExperienceInGameShell then
		v10 = SignalsReact.useSignalState(v6.getIsOverlayVisible)
	end

	local v11 = React.useCallback(function()
		if v8 then
			v6.setIsDisabledTooltipOpen(not v9)
			return
		end

		v6.setIsDisabledTooltipOpen(false)
		v7.setIsActive(true)
	end, { v6, v8, v9, v7 })
	local v12 = React.useCallback(function()
		v6.setIsDisabledTooltipOpen(false)
	end, { v6 })

	React.useEffect(function()
		if v8 then
			v7.setIsActive(false)
		else
			v6.setIsDisabledTooltipOpen(false)
		end
	end, { v6, v8, v7 })

	local createElement = React.createElement
	local v15

	if fFlagBuildExperienceInGameShell then
		v15 = if v10 then iconName.TwoArrowsFromCenter else iconName.TwoArrowsToCenter
	else
		v15 = iconName.Nebula
	end

	local v14 = {
		icon = v15,
		variant = props.variant,
		size = inputSize.Medium,
		isCircular = true,
		isDisabled = v8,
		onActivated = 0,
		testId = "build-header-play-button"
	}

	local v16 = if fFlagBuildExperienceInGameShell then v6.activate else v11
	v14.onActivated = v16
	local element = createElement(iconButton, v14)

	local createElement2 = React.createElement

	if fFlagBuildExperienceInGameShell then
		v11 = v6.activate
	end

	local element2 = createElement2(
		view,
		{
			onActivated = v11,
			tag = "auto-xy",
			testId = "build-header-play-button-disabled"
		},
		{ Button = element }
	)

	local createElement3 = React.createElement
	local v20 = {
		LayoutOrder = props.layoutOrder,
		tag = "auto-xy",
		testId = props.testId or "assistant-build"
	}

	local v22 = if v8 then React.createElement(educationalTooltip, {
		align = popoverAlign.Start,
		isOpen = v9,
		onPressedOutside = v12,
		side = popoverSide.Bottom,
		text = v5.portraitRequired,
		testId = "build-assistant-disabled-tooltip",
		title = v5.disabledTitle
	}, { Button = element2 }) else nil

	if v8 then
		element = nil
	end

	return createElement3(view, v20, { Tooltip = v22, Button = element })
end

return React.memo(AssistantBuild)
