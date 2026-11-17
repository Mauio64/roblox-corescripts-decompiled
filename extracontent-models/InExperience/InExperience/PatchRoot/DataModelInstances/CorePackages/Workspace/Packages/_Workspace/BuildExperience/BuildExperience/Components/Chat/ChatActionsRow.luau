local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)

local FFlagBuildExperienceGateSendDuringResponse = require(BuildExperience.Flags.FFlagBuildExperienceGateSendDuringResponse)
local StopAssistantResponseDialog = require(script.Parent.StopAssistantResponseDialog)

local IconButton = Foundation.IconButton

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function constantSource(): number
	return 0
end

local function ChatActionsRow(props)
	local v = React.useCallback(function(callback)
		if props.getIsComposerEmpty ~= nil then
			return props.getIsComposerEmpty(callback)
		end

		if typeof(callback) == "function" then
			callback(constantSource)
		end

		return props.isComposerEmpty == true
	end, { props.getIsComposerEmpty, props.isComposerEmpty })
	local v2 = SignalsReact.useSignalState(v)
	local v3

	if props.canStopAssistantResponse == false then
		v3 = false
	else
		v3 = props.canSendWhileResponding ~= true
	end

	local v4

	if props.isAssistantResponding then
		v4 = v3
	else
		v4 = FFlagBuildExperienceModelPicker

		if v4 then
			v4 = props.canStopAssistantResponse == true and v3
		end
	end

	local v5 = props.isAssistantResponding ~= true or props.canSendWhileResponding == true

	local v6 = not v4
		and (FFlagBuildExperienceGateSendDuringResponse and not v5 or v2 and props.hasAttachments ~= true and true or props.isSendDisabled == true)

	local state, setState = React.useState(false)
	local onCancel = React.useCallback(function()
		setState(false)
	end, {})
	local onConfirm = React.useCallback(function()
		setState(false)
		props.onStop()
	end, { props.onStop })

	React.useEffect(function()
		if not v4 then
			setState(false)
		end
	end, { v4 })

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		icon = 0,
		size = 0,
		variant = 0,
		isCircular = true,
		isDisabled = 0,
		onActivated = 0
	}
	local icon

	if v4 then
		icon = IconName.StopSmall
	else
		icon = IconName.ArrowWideShortUp
	end

	v7.icon = icon
	v7.size = InputSize.Small
	local variant

	if v4 then
		variant = ButtonVariant.Standard
	elseif v2 and props.hasAttachments ~= true then
		variant = ButtonVariant.Standard
	else
		variant = ButtonVariant.Emphasis
	end

	v7.variant = variant

	v7.isDisabled = v6 or v4 and props.isStopDisabled == true
	function v7.onActivated()
		if v4 then
			setState(true)
		else
			props.onSend()
		end
	end

	local element = createElement(IconButton, v7)

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local stopDialog

	if state and v4 then
		stopDialog = React.createElement(StopAssistantResponseDialog, {
			onCancel = onCancel,
			onConfirm = onConfirm
		})
	end

	return createElement2(fragment, nil, { Action = element, StopDialog = stopDialog })
end

return ChatActionsRow
