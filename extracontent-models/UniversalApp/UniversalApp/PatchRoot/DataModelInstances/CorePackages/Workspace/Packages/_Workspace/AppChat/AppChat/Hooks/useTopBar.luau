local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)

local function useTopBar(s1: string) -- line: 14
	-- upvalues: GetTopBarStore (copy), React (copy)
	local v7 = GetTopBarStore(false)
	local v8 = React.useCallback(function(p1) -- line: 17
		-- upvalues: v7 (copy), s1 (copy)
		v7.setScreenTopBar(s1, p1)
	end, { s1 })
	local v9 = React.useCallback(function() -- line: 21
		-- upvalues: v7 (copy), s1 (copy)
		v7.clearScreenTopBar(s1)
	end, { s1 })

	return {
		setScreenTopBar = v8,
		clearScreenTopBar = v9
	}
end

return useTopBar
