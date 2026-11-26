local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")

local FFlagBuildExperienceGateSendDuringResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceGateSendDuringResponse")
local StopAssistantResponseDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/StopAssistantResponseDialog")

local iconButton = Foundation.IconButton

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function constantSource(): number
	return 0
end

local function ChatActionsRow(props)
	local v5 = React.useCallback(function(callback)
		if props.getIsComposerEmpty ~= nil then
			return props.getIsComposerEmpty(callback)
		end

		if typeof(callback) == "function" then
			callback(constantSource)
		end

		return props.isComposerEmpty == true
	end, { props.getIsComposerEmpty, props.isComposerEmpty })
	local v6 = SignalsReact.useSignalState(v5)
	local v7 = not (props.canStopAssistantResponse == false) and props.canSendWhileResponding ~= true
	local v8

	if props.isAssistantResponding then
		v8 = v7
	else
		v8 = FFlagBuildExperienceModelPicker

		if v8 then
			v8 = props.canStopAssistantResponse == true and v7
		end
	end

	local v9 = props.isAssistantResponding ~= true or props.canSendWhileResponding == true

	local v10 = not v8
		and (FFlagBuildExperienceGateSendDuringResponse and not v9 or v6 and props.hasAttachments ~= true and true or props.isSendDisabled == true)

	local state, setState = React.useState(false)
	local v11 = React.useCallback(function()
		setState(false)
	end, {})
	local v12 = React.useCallback(function()
		setState(false)
		props.onStop()
	end, { props.onStop })

	React.useEffect(function()
		if not v8 then
			setState(false)
		end
	end, { v8 })

	local createElement = React.createElement
	local v14 = {
		LayoutOrder = props.LayoutOrder,
		icon = 0,
		size = 0,
		variant = 0,
		isCircular = true,
		isDisabled = 0,
		onActivated = 0
	}
	local v15 = if v8 then iconName.StopSmall else iconName.ArrowWideShortUp
	v14.icon = v15
	v14.size = inputSize.Small
	local v16

	if v8 then
		v16 = buttonVariant.Standard
	elseif v6 and props.hasAttachments ~= true then
		v16 = buttonVariant.Standard
	else
		v16 = buttonVariant.Emphasis
	end

	v14.variant = v16

	v14.isDisabled = v10 or v8 and props.isStopDisabled == true
	function v14.onActivated()
		if v8 then
			setState(true)
		else
			props.onSend()
		end
	end

	local element = createElement(iconButton, v14)

	local createElement2 = React.createElement
	local fragment = React.Fragment

	local v19 = if state and v8 then React.createElement(StopAssistantResponseDialog, {
		onCancel = v11,
		onConfirm = v12
	}) else nil
	return createElement2(fragment, nil, { Action = element, StopDialog = v19 })
end

return ChatActionsRow
