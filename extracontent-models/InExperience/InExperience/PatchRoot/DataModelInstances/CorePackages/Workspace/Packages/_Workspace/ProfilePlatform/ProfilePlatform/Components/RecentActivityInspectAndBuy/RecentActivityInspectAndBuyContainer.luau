local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local RecentActivityInspectAndBuyView = require(script.Parent.RecentActivityInspectAndBuyView)
local useRecentActivityInspectAndBuyViewModel = require(script.Parent.useRecentActivityInspectAndBuyViewModel)

local v = {}

local function RecentActivityInspectAndBuyContainer()
	local v2 = useNavigation()

	local onClose = React.useCallback(function()
		v2.goBack()
	end, { v2 })

	local v3 = useRecentActivityInspectAndBuyViewModel({
		assetIds = v2.getParam("assetIds") or v,
		onClose = onClose
	})

	return React.createElement(RecentActivityInspectAndBuyView, v3)
end

return RecentActivityInspectAndBuyContainer
