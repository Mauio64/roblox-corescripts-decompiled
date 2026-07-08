local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local GetAssistantBuildStore = require(BuildExperience.Stores.GetAssistantBuildStore)
local GetPlayButtonStore = require(BuildExperience.Stores.GetPlayButtonStore)
local EducationalTooltip = Foundation.EducationalTooltip
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local View = Foundation.View

local function AssistantBuild(t1: {[any]: any}) -- line: 27
	-- upvalues: GetAssistantBuildStore (copy), GetPlayButtonStore (copy), SignalsReact (copy), React (copy), IconButton (copy), IconName (copy), InputSize (copy), View (copy), EducationalTooltip (copy), PopoverAlign (copy), PopoverSide (copy)
	local v17 = GetAssistantBuildStore()
	local v18 = GetPlayButtonStore()
	local v19 = SignalsReact.useSignalState(v17.getIsDisabled)
	local v20 = SignalsReact.useSignalState(v17.getIsDisabledTooltipOpen)
	local v21 = React.useCallback(function() -- line: 33
		-- upvalues: v19 (copy), v17 (copy), v20 (copy), v18 (copy)
		if v19 then
			v17.setIsDisabledTooltipOpen(not v20)

			return
		end

		v17.setIsDisabledTooltipOpen(false)
		v18.setIsActive(true)
	end, {
		v17,
		v19,
		v20,
		v18
	})

	React.useEffect(function() -- line: 42
		-- upvalues: v19 (copy), v18 (copy), v17 (copy)
		if v19 then
			v18.setIsActive(false)

			return
		end

		v17.setIsDisabledTooltipOpen(false)
	end, {
		v17,
		v19,
		v18
	})

	local v22 = React.createElement(IconButton, {
		isCircular = true,
		testId = "build-header-play-button",
		icon = IconName.Nebula,
		variant = t1.variant,
		size = InputSize.Medium,
		isDisabled = v19,
		onActivated = v21
	})
	local v23 = React.createElement(View, {
		tag = "auto-xy",
		testId = "build-header-play-button-disabled",
		onActivated = v21
	}, {
		Button = v22
	})

	return React.createElement(View, {
		tag = "auto-xy",
		LayoutOrder = t1.layoutOrder,
		testId = t1.testId or "assistant-build"
	}, {
		Tooltip = if not v19 then nil else React.createElement(EducationalTooltip, {
			text = "Return device to portrait to chat with assistant",
			title = "Assistant disabled",
			align = PopoverAlign.Start,
			isOpen = v20,
			side = PopoverSide.Bottom
		}, {
			Button = v23
		}),
		Button = if v19 then nil else v22
	})
end

return React.memo(AssistantBuild)
