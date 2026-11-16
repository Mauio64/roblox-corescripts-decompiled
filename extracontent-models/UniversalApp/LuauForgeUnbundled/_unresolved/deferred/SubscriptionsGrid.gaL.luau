local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useScreenSize = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useScreenSize

local UIBlox = require(CorePackages.Packages.UIBlox)

local gridMetrics = UIBlox.App.Grid.GridMetrics
local defaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView

local module = require("@luauforge/deferred/gaM")

require("@luauforge/bundled/fXM")

local module2 = require("@luauforge/deferred/gaQ")

local fFlagEnableDevSubsFastFollowFixes = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableDevSubsFastFollowFixes

local function getTiles(data, universeId, p2, creatorName, creatorVerified)
	local tiles = {}
	local gameSubscriptionProduct = data.GameSubscriptionProducts[universeId]

	if gameSubscriptionProduct == nil then
		return tiles
	end

	local subscriptionProductsThumbnails = data.SubscriptionProductsThumbnails
	local subscriptionStatuses = data.SubscriptionStatuses

	for k, v5 in gameSubscriptionProduct do
		local v6 = not subscriptionProductsThumbnails[tostring(v5.iconImageAssetId)] and ""
			or subscriptionProductsThumbnails[tostring(v5.iconImageAssetId)].url

		local v7 = if v5.subscriptionTargetKey and subscriptionStatuses[v5.subscriptionTargetKey] then subscriptionStatuses[v5.subscriptionTargetKey].isSubscribed else false

		table.insert(tiles, {
			subscriptionProduct = v5,
			thumbnailString = v6,
			screenSize = p2,
			isSubscribed = v7,
			creatorName = creatorName,
			creatorVerified = creatorVerified
		})
	end

	return tiles
end

local function SubscriptionsGrid(props)
	local v5 = useScreenSize()
	local creatorName = props.creatorName
	local creatorVerified = props.creatorVerified
	local v6 = useSelector((React.useCallback(function(p2)
		return getTiles(p2, props.universeId, v5, creatorName, creatorVerified)
	end, { props.universeId, v5, creatorName, creatorVerified })))
	local v7 = useDesignTokens()

	local v8 = if fFlagEnableDevSubsFastFollowFixes then v7.Size.Size_400 else v7.Size.Size_600

	return React.createElement(defaultMetricsGridView, {
		renderItem = function(p2)
			return React.createElement(module, p2)
		end,
		getItemHeight = function(): number
			if module2() then
				return 136
			end

			return 224
		end,
		getItemMetrics = gridMetrics.getLargeMetrics,
		itemPadding = Vector2.new(v8, v8),
		items = v6,
		LayoutOrder = props.layoutOrder
	})
end

return SubscriptionsGrid
