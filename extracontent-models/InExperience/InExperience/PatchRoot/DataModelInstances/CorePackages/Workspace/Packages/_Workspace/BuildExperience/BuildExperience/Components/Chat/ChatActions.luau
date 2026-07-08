local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local ChatComposer = require(script.Parent.ChatComposer)
local View = Foundation.View

local function ChatActions(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), View (copy), ChatComposer (copy)
	return React.createElement(View, {
		tag = "col gap-small size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, {
		Composer = React.createElement(ChatComposer, {
			LayoutOrder = 1,
			text = t1.composerText,
			composerErrorText = t1.composerErrorText,
			onChanged = t1.onComposerChanged,
			placeholder = t1.placeholder,
			textBoxRef = t1.textBoxRef,
			isAssistantResponding = t1.isAssistantResponding,
			onSend = t1.onSend,
			onStop = t1.onStop,
			maxLines = t1.maxLines,
			composerDebug = t1.composerDebug
		})
	})
end

return ChatActions
