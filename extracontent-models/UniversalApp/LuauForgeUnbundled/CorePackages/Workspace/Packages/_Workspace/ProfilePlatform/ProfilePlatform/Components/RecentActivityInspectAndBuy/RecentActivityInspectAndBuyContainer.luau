local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation

local RecentActivityInspectAndBuyView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/RecentActivityInspectAndBuy/RecentActivityInspectAndBuyView")
local useRecentActivityInspectAndBuyViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/RecentActivityInspectAndBuy/useRecentActivityInspectAndBuyViewModel")

local v5 = {}

local function RecentActivityInspectAndBuyContainer()
	local v6 = useNavigation()

	local v7 = React.useCallback(function()
		v6.goBack()
	end, { v6 })

	local v9 = useRecentActivityInspectAndBuyViewModel({
		assetIds = v6.getParam("assetIds") or v5,
		onClose = v7
	})

	return React.createElement(RecentActivityInspectAndBuyView, v9)
end

return RecentActivityInspectAndBuyContainer
