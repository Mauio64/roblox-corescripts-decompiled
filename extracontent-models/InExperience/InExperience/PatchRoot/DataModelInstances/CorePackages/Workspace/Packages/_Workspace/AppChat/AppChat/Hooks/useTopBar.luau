local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)

local function useTopBar(p: string)
	local topBarStore = GetTopBarStore(false)

	return {
		setScreenTopBar = React.useCallback(function(p2)
			topBarStore.setScreenTopBar(p, p2)
		end, { p }),
		clearScreenTopBar = React.useCallback(function()
			topBarStore.clearScreenTopBar(p)
		end, { p })
	}
end

return useTopBar
