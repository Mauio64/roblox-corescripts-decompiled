local parent = script:FindFirstAncestor("DictationCore").Parent

local Foundation = require(parent.Foundation)

require(script.Parent.useLongPress)
local DictationAffordances = {}

function DictationAffordances.deriveMicSendButton(data, data2)
	local icon = data2.idleSendIcon
	local variant = data2.idleSendVariant
	local onActivated = data2.idleSendActivated
	local isDisabled = data2.idleSendDisabled or false
	local v = false

	if data.isRecording then
		onActivated = data.onMicTap
		isDisabled = false
	elseif data.isTranscribing then
		isDisabled = true
	elseif data.isListening then
		icon = Foundation.Enums.IconName.X
		variant = Foundation.Enums.ButtonVariant.Standard
		onActivated = data.dictation.cancel
		isDisabled = false
	elseif data2.hasEmptyInputText and data.isDictationEligible then
		if data2.isTextBoxFocused then
			isDisabled = true
		else
			if data.isMicInUseElsewhere then
				icon = Foundation.Enums.IconName.MicrophoneSlash
			else
				icon = Foundation.Enums.IconName.Microphone
			end

			variant = Foundation.Enums.ButtonVariant.Utility
			onActivated = data.onMicTap
			isDisabled = data.isMicInUseElsewhere == true
			v = true
		end
	end

	return {
		icon = icon,
		variant = variant,
		isDisabled = isDisabled,
		onActivated = onActivated,
		useLongPressOverlay = v and not isDisabled and data.micGestureHandlers ~= nil
	}
end

function DictationAffordances.deriveBackgroundColors(p, data)
	if p.isListening then
		return { color3 = data.listeningColor3, baseTransparency = data.listeningTransparency }
	end

	return { color3 = data.defaultColor3, baseTransparency = data.defaultTransparency }
end

function DictationAffordances.shouldPreventFade(data)
	return data.isRecording or data.isTranscribing or data.isListening
end

return DictationAffordances
