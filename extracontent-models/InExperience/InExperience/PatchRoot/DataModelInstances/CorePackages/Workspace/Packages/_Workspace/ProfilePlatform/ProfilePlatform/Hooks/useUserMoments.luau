local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local v = nil
pcall(function()
	local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	v = AppLifecycleObserverService
end)

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local MomentsGetMomentsUserStore = require(parent.DataHydration.MomentsGetMomentsUserStore)
require(parent.DataHydration.MomentsStoreTypes)

local GetDeletedMomentsStore = require(parent.Moments.GetDeletedMomentsStore)

local FFlagMomentsRemoveDeletedFromProfile = SharedFlags.FFlagMomentsRemoveDeletedFromProfile
local FFlagMomentsRefreshOwnMomentsAfterPublish = SharedFlags.FFlagMomentsRefreshOwnMomentsAfterPublish
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsRefreshProfileOnPostStatus = SharedFlags.FFlagMomentsRefreshProfileOnPostStatus

local function useUserMoments(current: string?, p)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(false)
	local ref = React.useRef(nil)
	local v2

	if FFlagMomentsRefreshProfileOnPostStatus or FFlagMomentsOptimisticProfilePending then
		v2 = useLocalUserId()
	end

	local v3

	if v2 == nil then
		v3 = false
	else
		v3 = tostring(v2) == current
	end

	local v4 = not (FFlagMomentsRefreshOwnMomentsAfterPublish or FFlagMomentsRefreshProfileOnPostStatus or FFlagMomentsOptimisticProfilePending)
		and 0
		or SignalsReact.useSignalState(MomentsGetMomentsUserStore(false).getUserMomentsVersion)

	local v5 = not FFlagMomentsOptimisticProfilePending and {}
		or SignalsReact.useSignalState(MomentsGetMomentsUserStore(false).getPendingUserMoments)

	React.useEffect(function()
		local v6

		if current ~= nil then
			v6 = tonumber(current)
		end

		if v6 == nil then
			return
		end

		local momentsGetMomentsUserStore = MomentsGetMomentsUserStore(false)

		if
			(FFlagMomentsRefreshProfileOnPostStatus or FFlagMomentsOptimisticProfilePending)
			and ref.current ~= current
		then
			ref.current = current

			if v3 then
				momentsGetMomentsUserStore.evictUserMoments(v6)
			end
		end

		local v7 = false

		momentsGetMomentsUserStore.getUserMoments(v6):andThen(function(p2)
			if not v7 then
				setState4(false)
				setState(p2.moments)
				setState2(p2.nextCursor)
				setState3(p2.nextCursor ~= nil)
			end
		end):catch(function()
			if not v7 then
				setState4(true)
			end
		end)
		return function()
			v7 = true
		end
	end, { current, v4, v3 })

	if FFlagMomentsRefreshProfileOnPostStatus or FFlagMomentsOptimisticProfilePending then
		React.useEffect(function()
			if not v3 then
				return
			end

			local v6 = p or v

			if v6 == nil then
				return
			end

			local onUnhideConnection = v6.OnUnhide:Connect(function()
				local v7

				if current ~= nil then
					v7 = tonumber(current)
				end

				if v7 ~= nil then
					MomentsGetMomentsUserStore(false).invalidateUser(v7)
				end
			end)
			return function()
				onUnhideConnection:Disconnect()
			end
		end, { current, p, v3 })
	end

	local loadMore = React.useCallback(function()
		local v6

		if current ~= nil then
			v6 = tonumber(current)
		end

		if v6 == nil or state2 == nil or not state3 or state5 then
			return
		end

		setState5(true)
		MomentsGetMomentsUserStore(false).getUserMoments(v6, state2):andThen(function(p2)
			setState(function(p3)
				return Cryo.List.join(p3, p2.moments)
			end)

			setState3(p2.nextCursor ~= nil and p2.nextCursor ~= state2)
			setState2(p2.nextCursor)
		end):catch(function() end):finally(function()
			setState5(false)
		end)
	end, { current, state2, state3, state5 })
	local v6, moments2

	if FFlagMomentsRemoveDeletedFromProfile or FFlagMomentsOptimisticProfilePending then
		v6 = SignalsReact.useSignalState(GetDeletedMomentsStore(false).getDeletedIds)

		moments2 = React.useMemo(function()
			if #v6 == 0 then
				return state
			end

			local result = {}

			for _, v7 in state do
				if not table.find(v6, v7.momentId) then
					table.insert(result, v7)
				end
			end

			return result
		end, { state, v6 })
	else
		moments2 = state
		v6 = nil
	end

	if FFlagMomentsOptimisticProfilePending then
		local v7

		if current == nil then
			v7 = nil
		else
			v7 = tonumber(current)
		end

		local state6, setState6 = React.useState({})
		local v8 = React.useMemo(function()
			local v8 = v7 == nil and {} or v5[v7] or {}

			local set = {}
			local momentIdSet = {}

			for _, v9 in state do
				set[v9.momentId] = true
				local feedItemId = v9.recommendationMetadata.feedItemId

				if feedItemId ~= nil and feedItemId ~= "" then
					set[feedItemId] = true
				end
			end

			for _, v9 in v8 do
				local publishedMoment = v9.publishedMoment

				if publishedMoment == nil then
					continue
				end

				local feedItemId = publishedMoment.recommendationMetadata.feedItemId

				if not (set[publishedMoment.momentId] or feedItemId ~= nil and set[feedItemId] or v6 ~= nil and table.find(v6, publishedMoment.momentId) ~= nil) then
					continue
				end

				momentIdSet[v9.moment.momentId] = true
			end

			return momentIdSet
		end, { v7, state, v5, v6 })
		React.useEffect(function()
			setState6(function(p2)
				local clone = table.clone(p2)
				local flag = false

				for k in v8 do
					if clone[k] then
						continue
					end

					clone[k] = true
					flag = true
				end

				return if flag then clone else p2
			end)
		end, { v8 })
		local v9

		if v7 ~= nil then
			v9 = v5[v7]
		end

		if v9 ~= nil and #v9 > 0 then
			local moments = {}

			for _, v10 in v9 do
				local moment = v10.moment

				if not (v8[moment.momentId] or state6[moment.momentId]) then
					table.insert(moments, moment)
				end
			end

			if #moments > 0 then
				moments2 = Cryo.List.join(moments, moments2)
			end
		end
	end

	return {
		moments = moments2,
		hasMore = state3,
		hasFailed = state4,
		isLoadingMore = state5,
		loadMore = loadMore
	}
end

return useUserMoments
