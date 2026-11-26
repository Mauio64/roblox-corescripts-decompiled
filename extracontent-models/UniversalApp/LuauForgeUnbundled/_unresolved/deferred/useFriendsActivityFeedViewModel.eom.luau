local module = require("@luauforge/deferred/enn")
local module2 = require("@luauforge/deferred/enD")
local useAppPolicy = require("@luauforge/deferred/eon").useAppPolicy
local module3 = require("@luauforge/deferred/enK")

local module4 = require("@luauforge/deferred/eoe")
local fFlagEnableRecentActivityInspectAndBuy = module4.FFlagEnableRecentActivityInspectAndBuy
local fFlagFriendsActivityFeedFetchItemNames = module4.FFlagFriendsActivityFeedFetchItemNames

local module5 = require("@luauforge/bundled/enl")
local module6 = require("@luauforge/deferred/eoo")
local module7 = require("@luauforge/deferred/eor")
local module8 = require("@luauforge/deferred/eoE")
local module9 = require("@luauforge/deferred/eoF")
local module10 = require("@luauforge/deferred/eoG")
local module11 = require("@luauforge/deferred/eoz")
local module12 = require("@luauforge/deferred/enr")
local module13 = require("@luauforge/deferred/eoI")
local networkImpl = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Networking/networkImpl")

local eventType = module5.EventType

local function prefetchItemNames(items)
	local set = {}
	local v5 = {}

	for k, item in items do
		local v6 = if item.eventType == eventType.AvatarChange then item.assetIds[1] else nil

		if v6 == nil or v6 == 0 or set[v6] then
			continue
		end

		set[v6] = true
		table.insert(v5, { id = v6, itemType = "Asset" })
	end

	if #v5 > 0 then
		module3.ItemDetailsStore.fetchAndCache(networkImpl, v5)
	end
end

local function useFriendsActivityFeedViewModel(data)
	local source = data.source

	local v5 = useAppPolicy(function(p2)
		return p2.getEnableContinuousLoad()
	end)

	local v6 = module.useMemo(function()
		return module6(source)
	end, { source })

	module.useEffect(function()
		v6.loadInitial()
		return function()
			v6.dispose()
		end
	end, { v6 })

	local v7 = module2.useSignalState(v6.getItems)
	local v8 = module2.useSignalState(v6.getStatus)
	local v9 = module2.useSignalState(v6.getHasMore)
	local v10 = module2.useSignalState(v6.getLoadMoreStatus)

	if fFlagFriendsActivityFeedFetchItemNames then
		module.useEffect(function()
			prefetchItemNames(v7)
		end, { v7 })
	end

	local v11 = module11()
	local v12 = module7(v11)
	local v13 = module8(v11)
	local v14 = module9(v11)
	local onAvatarActivated = data.onAvatarActivated

	local v15 = { v7, v12, v13, v14, (module10()) }
	local v16 = module.useMemo(function()
		local clones = {}

		for k, v17 in v7 do
			if module12[v17.eventType] == nil then
				continue
			end

			local fn = nil

			if v17.eventType == eventType.ExperienceJoin then
				local experienceId = v17.experienceId
				fn = function()
					v12(experienceId, k)
				end
			elseif v17.eventType == eventType.BadgeAwarded then
				local experienceId = v17.experienceId

				fn = experienceId ~= nil and experienceId ~= 0 and function()
					v13(experienceId, k)
				end or fn
			elseif v17.eventType == eventType.AvatarChange then
				local actor = v17.actors[1]
				local userId = if actor ~= nil then actor.userId else nil
				local assetIds = v17.assetIds
				fn = function()
					v14(userId, k)

					if fFlagEnableRecentActivityInspectAndBuy and onAvatarActivated ~= nil then
						onAvatarActivated(assetIds, userId)
					end
				end
			end

			local clone = table.clone(v17)
			clone.onActivated = fn
			table.insert(clones, clone)
		end

		return module13(clones, DateTime.now().UnixTimestampMillis)
	end, v15)

	local v17 = module.useCallback(function()
		v6.refresh()
	end, { v6 })

	local v18 = module.useCallback(function()
		v6.loadMore()
	end, { v6 })

	return {
		status = v8,
		rows = v16,
		onRetry = v17,
		emptyStateDescription = data.emptyStateDescription,
		isScrollEnabled = data.isScrollEnabled,
		hasMore = v9,
		loadMoreStatus = v10,
		enableContinuousLoad = v5,
		onLoadMore = v18,
		layoutOrder = data.layoutOrder
	}
end

return useFriendsActivityFeedViewModel
