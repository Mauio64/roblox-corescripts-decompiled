local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)

local function TopBarFromStore(p)
	local screenName = p.screenName
	local render = p.render

	local topBarStore = GetTopBarStore(false)
	local screenTopBar = topBarStore.getScreenTopBar(screenName)
	local v = SignalsReact.useSignalState(screenTopBar)

	return render((React.useMemo(function()
		return {
			getScreenTopBar = function(p2: string)
				if p2 == screenName then
					return v
				end

				return topBarStore.getScreenTopBar(p2)(false)
			end,
			setScreenTopBar = topBarStore.setScreenTopBar
		}
	end, { screenName, v, topBarStore.getScreenTopBar, topBarStore.setScreenTopBar })))
end

return TopBarFromStore
