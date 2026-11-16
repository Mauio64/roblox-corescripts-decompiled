local parent = script:FindFirstAncestor("ExpChatIntegration").Parent

local React = require(parent.React)

local useChatPlatform = require(script.Parent.useChatPlatform)

local function useChatInputBarOnFocus()
	local getTransparencyStore = useChatPlatform().getTransparencyStore

	return {
		onFocusGained = React.useCallback(function()
			getTransparencyStore(false).setTextboxFocus()
		end, { getTransparencyStore }),
		onFocusLost = React.useCallback(function()
			getTransparencyStore(false).clearTextboxFocus()
		end, { getTransparencyStore })
	}
end

return useChatInputBarOnFocus
