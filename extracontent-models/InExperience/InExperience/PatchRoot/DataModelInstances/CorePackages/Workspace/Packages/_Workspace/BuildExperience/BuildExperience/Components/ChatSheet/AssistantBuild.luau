local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
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

local function AssistantBuild(t1: {[any]: any}) -- line: 28
	-- upvalues: GetAssistantBuildStore (copy), GetPlayButtonStore (copy), SignalsReact (copy), React (copy), IconButton (copy), IconName (copy), InputSize (copy), View (copy), EducationalTooltip (copy), PopoverAlign (copy), PopoverSide (copy), LocalizationStrings (copy)
	local v18 = GetAssistantBuildStore()
	local v19 = GetPlayButtonStore()
	local v20 = SignalsReact.useSignalState(v18.getIsDisabled)
	local v21 = SignalsReact.useSignalState(v18.getIsDisabledTooltipOpen)
	local v22 = React.useCallback(function() -- line: 34
		-- upvalues: v20 (copy), v18 (copy), v21 (copy), v19 (copy)
		if v20 then
			v18.setIsDisabledTooltipOpen(not v21)

			return
		end

		v18.setIsDisabledTooltipOpen(false)
		v19.setIsActive(true)
	end, {
		v18,
		v20,
		v21,
		v19
	})

	React.useEffect(function() -- line: 43
		-- upvalues: v20 (copy), v19 (copy), v18 (copy)
		if v20 then
			v19.setIsActive(false)

			return
		end

		v18.setIsDisabledTooltipOpen(false)
	end, {
		v18,
		v20,
		v19
	})

	local v23 = React.createElement(IconButton, {
		isCircular = true,
		testId = "build-header-play-button",
		icon = IconName.Nebula,
		variant = t1.variant,
		size = InputSize.Medium,
		isDisabled = v20,
		onActivated = v22
	})
	local v24 = React.createElement(View, {
		tag = "auto-xy",
		testId = "build-header-play-button-disabled",
		onActivated = v22
	}, {
		Button = v23
	})

	return React.createElement(View, {
		tag = "auto-xy",
		LayoutOrder = t1.layoutOrder,
		testId = t1.testId or "assistant-build"
	}, {
		Tooltip = if not v20 then nil else React.createElement(EducationalTooltip, {
			align = PopoverAlign.Start,
			isOpen = v21,
			side = PopoverSide.Bottom,
			text = LocalizationStrings.CHAT_PORTRAIT_REQUIRED,
			title = LocalizationStrings.CHAT_ASSISTANT_DISABLED
		}, {
			Button = v24
		}),
		Button = if v20 then nil else v23
	})
end

return React.memo(AssistantBuild)
