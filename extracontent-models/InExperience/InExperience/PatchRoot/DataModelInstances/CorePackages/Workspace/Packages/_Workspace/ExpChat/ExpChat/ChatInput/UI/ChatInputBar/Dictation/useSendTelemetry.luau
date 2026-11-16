local parent = script:FindFirstAncestor("ExpChat").Parent

local React = require(parent.React)

require(script.Parent.DictationMode)
local DictationAnalytics = require(script.Parent.DictationAnalytics)

local function classifyEditType(current: string, text: string)
	if #text == 0 then
		return DictationAnalytics.EditTypes.FullClear
	end

	if #text > #current and string.sub(text, 1, #current) == current then
		return DictationAnalytics.EditTypes.Addition
	end

	if #text < #current and string.sub(current, 1, #text) == text then
		return DictationAnalytics.EditTypes.Deletion
	end

	return DictationAnalytics.EditTypes.Mixed
end

local function useSendTelemetry(data)
	local enabled = data.enabled
	local textBoxRef = data.textBoxRef
	local customTextBoxRef = data.customTextBoxRef

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(false)

	local stageTranscription = React.useCallback(function(current: string, mode)
		if not enabled then
			return
		end

		ref2.current = current
		ref.current = { mode = mode, outcome = DictationAnalytics.Outcomes.Full, textStt = current }
	end, { enabled })

	local consumeOnSend = React.useCallback(function(textSent: string)
		if not enabled then
			return nil
		end

		local current = ref.current
		ref.current = nil

		if current == nil then
			return nil
		end

		ref3.current = true
		current.textSent = textSent
		return current
	end, { enabled })

	React.useEffect(function()
		if not enabled then
			return
		end

		local current = customTextBoxRef.current or textBoxRef.current

		if current == nil then
			return
		end

		local textChangedConnection = current:GetPropertyChangedSignal("Text"):Connect(function()
			local current2 = ref2.current

			if current2 == nil then
				return
			end

			if ref3.current then
				ref3.current = false
				ref2.current = nil
			else
				local text = current.Text

				if text == current2 then
					return
				end

				if ref.current then
					ref.current.outcome = DictationAnalytics.Outcomes.Partial
				end

				DictationAnalytics.fire(DictationAnalytics.Events.TextEdit, {
					[DictationAnalytics.Properties.SttMode] = DictationAnalytics.Modes.Standard,
					[DictationAnalytics.Properties.EditType] = classifyEditType(current2, text)
				})
			end
		end)
		return function()
			textChangedConnection:Disconnect()
		end
	end, { enabled, textBoxRef, customTextBoxRef })

	return { stageTranscription = stageTranscription, consumeOnSend = consumeOnSend }
end

return useSendTelemetry
