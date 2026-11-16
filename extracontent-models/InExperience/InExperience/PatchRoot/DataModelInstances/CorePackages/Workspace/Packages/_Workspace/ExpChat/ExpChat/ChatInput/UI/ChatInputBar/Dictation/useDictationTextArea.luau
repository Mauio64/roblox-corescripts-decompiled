local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)

local FFlagExpChatComposerInputBarFigmaParity = require(ExpChat.Flags.FFlagExpChatComposerInputBarFigmaParity)

local Localization = require(ExpChat.Localization)

require(script.Parent.useDictationInputBar)

local function lerp(p: number, p2: number, p3: number) -- 4 equivalent calls inferred from this helper
	return p + (p2 - p) * p3
end

local function useDictationTextArea(data, p)
	local v = Localization.useLocalization({
		transcribingText = "CoreScripts.TextChat.ChatWindow.Transcribing"
	})

	local text = (not v.transcribingText or v.transcribingText == "") and "Transcribing..." or v.transcribingText
	local isAudioActive

	if data then
		isAudioActive = data.dictation.bindings.isAudioActive
	else
		isAudioActive = nil
	end

	local chatInputBarSettings

	if data then
		chatInputBarSettings = data.chatInputBarSettings
	end

	local state

	if data then
		state = data.state
	end

	local v2

	if data then
		v2 = data.isTranscribing
	else
		v2 = false
	end

	local v3 = p.showPlaceholderText and not FFlagExpChatComposerInputBarFigmaParity and 0.5 or 0

	local textTransparency = React.useMemo(function()
		if isAudioActive == nil then
			return p.transparencyValue:map(function(p2: number)
				return lerp(v3, 1, p2) -- inferred equivalent call
			end)
		end

		return React.joinBindings({ fade = p.transparencyValue, hide = isAudioActive }):map(function(p2)
			return lerp(p2.hide and 1 or v3, 1, p2.fade) -- inferred equivalent call
		end)
	end, { p.transparencyValue, isAudioActive, v3 })

	local v4 = not chatInputBarSettings and 0 or chatInputBarSettings.TextStrokeTransparency
	local textStrokeTransparency = React.useMemo(function()
		if isAudioActive == nil then
			return p.transparencyValue:map(function(p2: number)
				return lerp(v4, 1, p2) -- inferred equivalent call
			end)
		end

		return React.joinBindings({ fade = p.transparencyValue, hide = isAudioActive }):map(function(p2)
			return lerp(p2.hide and 1 or v4, 1, p2.fade) -- inferred equivalent call
		end)
	end, { p.transparencyValue, isAudioActive, v4 })
	local customTextBoxRef

	if data then
		customTextBoxRef = data.customTextBoxRef
	else
		customTextBoxRef = nil
	end

	local textBoxRef

	if data then
		textBoxRef = data.textBoxRef
	else
		textBoxRef = nil
	end

	local placeholderColor3

	if chatInputBarSettings then
		placeholderColor3 = chatInputBarSettings.PlaceholderColor3
	else
		placeholderColor3 = nil
	end

	local textColor3

	if chatInputBarSettings then
		textColor3 = chatInputBarSettings.TextColor3
	else
		textColor3 = nil
	end

	React.useEffect(function()
		if customTextBoxRef == nil or textBoxRef == nil then
			return
		end

		local current

		if customTextBoxRef.current then
			current = customTextBoxRef.current
		else
			current = textBoxRef.current
		end

		if current == nil then
			return
		end

		if v2 then
			current.Text = text
			current.TextEditable = false
			current.TextColor3 = placeholderColor3
		else
			current.TextEditable = true
			current.TextColor3 = textColor3

			if current.Text == text then
				current.Text = ""
			end
		end
	end, { state, v2, text, customTextBoxRef, textBoxRef, placeholderColor3, textColor3 })

	return { textTransparency = textTransparency, textStrokeTransparency = textStrokeTransparency }
end

return useDictationTextArea
