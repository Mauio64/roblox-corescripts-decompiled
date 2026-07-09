local Parent = script:FindFirstAncestor("ExpChatIntegration").Parent
local React = require(Parent.React)
local useChatPlatform = require(script.Parent.useChatPlatform)

local function useChatInputBarOnFocus() -- line: 8
	-- upvalues: useChatPlatform (copy), React (copy)
	local getTransparencyStore = useChatPlatform().getTransparencyStore
	local v6 = React.useCallback(function() -- line: 14
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).setTextboxFocus()
	end, { getTransparencyStore })
	local v7 = React.useCallback(function() -- line: 17
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).clearTextboxFocus()
	end, { getTransparencyStore })

	return {
		onFocusGained = v6,
		onFocusLost = v7
	}
end

return useChatInputBarOnFocus
