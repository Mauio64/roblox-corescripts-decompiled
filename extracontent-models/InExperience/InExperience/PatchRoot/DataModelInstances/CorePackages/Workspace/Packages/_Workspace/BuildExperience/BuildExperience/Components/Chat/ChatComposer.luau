local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local ChatActionsRow = require(script.Parent.ChatActionsRow)
local TextArea = require(BuildExperience.FoundationFork.TextArea)
local useReleaseFocusOnDownSwipe = require(script.Parent.useReleaseFocusOnDownSwipe)
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize

local function trimMessage(s1: string) -- line: 36
	return string.gsub(s1, "^%s*(.-)%s*$", "%1")
end
local function ChatComposer(t1: {[any]: any}) -- line: 40
	-- upvalues: React (copy), Signals (copy), useReleaseFocusOnDownSwipe (copy), TextArea (copy), InputSize (copy), View (copy), ChatActionsRow (copy)
	local v15 = React.useRef(nil)
	local v16 = React.useMemo(function() -- line: 42
		-- upvalues: Signals (copy)
		local v21, v22 = Signals.createSignal(true)

		return {
			getIsComposerEmpty = v21,
			setIsComposerEmpty = v22
		}
	end, {})
	local v17 = t1.isAssistantResponding and t1.canSendWhileResponding ~= true
	local v18 = t1.composerErrorText ~= nil
	local v19 = React.useCallback(function(s2: string) -- line: 53
		-- upvalues: v16 (copy), t1 (copy)
		v16.setIsComposerEmpty(string.gsub(s2, "^%s*(.-)%s*$", "%1") == "")
		t1.onChanged(s2)
	end, {
		t1.onChanged,
		v16
	})
	local v20 = React.useCallback(function() -- line: 58
		-- upvalues: t1 (copy), v16 (copy)
		if t1.onSend() then
			v16.setIsComposerEmpty(true)
		end
	end, {
		t1.onSend,
		v16
	})

	useReleaseFocusOnDownSwipe(v15, t1.textBoxRef)

	return React.createElement(TextArea, {
		label = "",
		text = t1.text,
		onChanged = v19,
		hint = t1.composerErrorText,
		hasError = v18,
		placeholder = t1.placeholder or "",
		width = UDim.new(1, 0),
		size = InputSize.Large,
		maxLines = t1.maxLines or 5,
		isDisabled = v17,
		onReturnPressed = v20,
		textBoxRef = t1.textBoxRef,
		ref = v15,
		composerDebug = t1.composerDebug,
		LayoutOrder = t1.LayoutOrder,
		trailingElement = React.createElement(View, {
			tag = "auto-xy padding-x-xsmall padding-y-small"
		}, {
			Actions = React.createElement(ChatActionsRow, {
				isAssistantResponding = t1.isAssistantResponding,
				canStopAssistantResponse = t1.canStopAssistantResponse,
				canSendWhileResponding = t1.canSendWhileResponding,
				getIsComposerEmpty = v16.getIsComposerEmpty,
				isSendDisabled = v18,
				onSend = v20,
				onStop = t1.onStop
			})
		})
	})
end

return ChatComposer
