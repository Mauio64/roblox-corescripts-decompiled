local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local composerLockSignal = require(BuildExperience.Chat.composerLockSignal)
local ChatActionsRow = require(script.Parent.ChatActionsRow)
local TextArea = require(BuildExperience.FoundationFork.TextArea)
local useReleaseFocusOnDownSwipe = require(script.Parent.useReleaseFocusOnDownSwipe)
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize

local function trimMessage(s1: string) -- line: 37
	return string.gsub(s1, "^%s*(.-)%s*$", "%1")
end
local function ChatComposer(t1: {[any]: any}) -- line: 41
	-- upvalues: React (copy), Signals (copy), SignalsReact (copy), composerLockSignal (copy), useReleaseFocusOnDownSwipe (copy), TextArea (copy), InputSize (copy), View (copy), ChatActionsRow (copy)
	local v17 = React.useRef(nil)
	local v18 = React.useMemo(function() -- line: 43
		-- upvalues: Signals (copy)
		local v24, v25 = Signals.createSignal(true)

		return {
			getIsComposerEmpty = v24,
			setIsComposerEmpty = v25
		}
	end, {})
	local v19 = SignalsReact.useSignalState(composerLockSignal.getComposerMode) == "tool_response"
	local v20 = t1.isAssistantResponding and not v19
	local v21 = t1.composerErrorText ~= nil
	local v22 = React.useCallback(function(s2: string) -- line: 57
		-- upvalues: v18 (copy), t1 (copy)
		v18.setIsComposerEmpty(string.gsub(s2, "^%s*(.-)%s*$", "%1") == "")
		t1.onChanged(s2)
	end, {
		t1.onChanged,
		v18
	})
	local v23 = React.useCallback(function() -- line: 62
		-- upvalues: t1 (copy), v18 (copy)
		if t1.onSend() then
			v18.setIsComposerEmpty(true)
		end
	end, {
		t1.onSend,
		v18
	})

	useReleaseFocusOnDownSwipe(v17, t1.textBoxRef)

	return React.createElement(TextArea, {
		label = "",
		text = t1.text,
		onChanged = v22,
		hint = t1.composerErrorText,
		hasError = v21,
		placeholder = t1.placeholder or "",
		width = UDim.new(1, 0),
		size = InputSize.Large,
		maxLines = t1.maxLines or 5,
		isDisabled = v20,
		onReturnPressed = v23,
		textBoxRef = t1.textBoxRef,
		ref = v17,
		composerDebug = t1.composerDebug,
		LayoutOrder = t1.LayoutOrder,
		trailingElement = React.createElement(View, {
			tag = "auto-xy padding-x-xsmall padding-y-small"
		}, {
			Actions = React.createElement(ChatActionsRow, {
				isAssistantResponding = t1.isAssistantResponding,
				canSendWhileResponding = v19,
				getIsComposerEmpty = v18.getIsComposerEmpty,
				isSendDisabled = v21,
				onSend = v23,
				onStop = t1.onStop
			})
		})
	})
end

return ChatComposer
