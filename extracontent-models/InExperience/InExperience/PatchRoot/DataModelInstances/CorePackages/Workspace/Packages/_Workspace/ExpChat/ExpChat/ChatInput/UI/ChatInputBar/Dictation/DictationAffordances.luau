local Parent = script:FindFirstAncestor("ExpChat").Parent
local Foundation = require(Parent.Foundation)

return {
	deriveMicSendButton = function(p1, t1: {[any]: any}) -- line: 56
		-- upvalues: Foundation (copy)
		local idleSendIcon = t1.idleSendIcon
		local idleSendVariant = t1.idleSendVariant
		local idleSendActivated = t1.idleSendActivated
		local v8 = t1.idleSendDisabled or false
		local v9 = false

		if p1.isRecording then
			idleSendActivated = p1.onMicTap
			v8 = false
		elseif p1.isTranscribing then
			v8 = true
		elseif p1.isListening then
			idleSendIcon = Foundation.Enums.IconName.X
			idleSendVariant = Foundation.Enums.ButtonVariant.Standard
			idleSendActivated = p1.dictation.cancel
			v8 = false
		elseif t1.hasEmptyInputText and p1.isDictationEligible then
			if t1.isTextBoxFocused then
				v8 = true
			else
				idleSendIcon = Foundation.Enums.IconName.Microphone
				idleSendVariant = Foundation.Enums.ButtonVariant.Utility
				idleSendActivated = p1.onMicTap
				v8 = false
				v9 = true
			end
		end

		return {
			icon = idleSendIcon,
			variant = idleSendVariant,
			isDisabled = v8,
			onActivated = idleSendActivated,
			useLongPressOverlay = v9 and p1.micGestureHandlers ~= nil
		}
	end,
	deriveBackgroundColors = function(p2, t2: {[any]: any}) -- line: 115
		if p2.isListening then
			return {
				color3 = t2.listeningColor3,
				baseTransparency = t2.listeningTransparency
			}
		end

		return {
			color3 = t2.defaultColor3,
			baseTransparency = t2.defaultTransparency
		}
	end,
	shouldPreventFade = function(p3) -- line: 131
		return p3.isRecording or (p3.isTranscribing or p3.isListening)
	end
}
