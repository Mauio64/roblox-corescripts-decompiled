local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useScreenSize = require(CorePackages.Workspace.Packages.RobloxAppHooks).useScreenSize
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local GridMetrics = UIBlox.App.Grid.GridMetrics
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local SubscriptionTile = require(Modules.LuaApp.Components.Subscription.SubscriptionTile)

require(Modules.LuaApp.Models.SubscriptionApi.SubscriptionProductInfoModel)

local GetFFlagEnableDevSubsInRobux = require(Modules.LuaApp.Flags.GetFFlagEnableDevSubsInRobux)
local FFlagEnableDevSubsFastFollowFixes = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableDevSubsFastFollowFixes

local function getTiles(p1, p2, p3, p4, p5) -- line: 37
	local t1 = {}
	local v22 = p1.GameSubscriptionProducts[p2]

	if v22 == nil then
		return t1
	end

	local SubscriptionProductsThumbnails = p1.SubscriptionProductsThumbnails
	local SubscriptionStatuses = p1.SubscriptionStatuses

	for _, v26 in v22 do
		local s1 = ""
		local v28 = false

		if SubscriptionProductsThumbnails[tostring(v26.iconImageAssetId)] then
			s1 = SubscriptionProductsThumbnails[tostring(v26.iconImageAssetId)].url
		end

		if v26.subscriptionTargetKey and SubscriptionStatuses[v26.subscriptionTargetKey] then
			v28 = SubscriptionStatuses[v26.subscriptionTargetKey].isSubscribed
		end

		table.insert(t1, {
			subscriptionProduct = v26,
			thumbnailString = s1,
			screenSize = p3,
			isSubscribed = v28,
			creatorName = p4,
			creatorVerified = p5
		})
	end

	return t1
end
local function SubscriptionsGrid(t2: {[any]: any}) -- line: 68
	-- upvalues: useScreenSize (copy), React (copy), getTiles (copy), useSelector (copy), useDesignTokens (copy), FFlagEnableDevSubsFastFollowFixes (copy), FFlagRenameDeprecatedUIBloxTokens (copy), DefaultMetricsGridView (copy), SubscriptionTile (copy), GetFFlagEnableDevSubsInRobux (copy), GridMetrics (copy)
	local v30 = useScreenSize()
	local creatorName = t2.creatorName
	local creatorVerified = t2.creatorVerified
	local v33 = React.useCallback(function(p6) -- line: 72
		-- upvalues: getTiles (copy), t2 (copy), v30 (copy), creatorName (copy), creatorVerified (copy)
		return (getTiles(p6, t2.universeId, v30, creatorName, creatorVerified))
	end, {
		t2.universeId,
		v30,
		creatorName,
		creatorVerified
	})
	local v34 = useSelector(v33)
	local v35 = useDesignTokens()
	local v36 = if not FFlagEnableDevSubsFastFollowFixes then if not FFlagRenameDeprecatedUIBloxTokens then v35.Global.Space_300 else v35.Size.Size_600 else if not FFlagRenameDeprecatedUIBloxTokens then v35.Global.Space_200 else v35.Size.Size_400

	return React.createElement(DefaultMetricsGridView, {
		renderItem = function(p7) -- line: 84
			-- upvalues: React (copy), SubscriptionTile (copy)
			return React.createElement(SubscriptionTile, p7)
		end,
		getItemHeight = function() -- line: 87
			-- upvalues: GetFFlagEnableDevSubsInRobux (copy)
			if GetFFlagEnableDevSubsInRobux() then
				return 136
			end

			return 224
		end,
		getItemMetrics = GridMetrics.getLargeMetrics,
		itemPadding = Vector2.new(v36, v36),
		items = v34,
		LayoutOrder = t2.layoutOrder
	})
end

return SubscriptionsGrid
