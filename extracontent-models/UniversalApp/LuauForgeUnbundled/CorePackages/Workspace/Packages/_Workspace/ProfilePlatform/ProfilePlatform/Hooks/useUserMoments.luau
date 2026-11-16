local v5 = nil
pcall(function()
	local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	v5 = AppLifecycleObserverService
end)

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId

local MomentsGetMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsGetMomentsUserStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsStoreTypes")

local GetDeletedMomentsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Moments/GetDeletedMomentsStore")

local fFlagMomentsRemoveDeletedFromProfile = SharedFlags.FFlagMomentsRemoveDeletedFromProfile
local fFlagMomentsRefreshOwnMomentsAfterPublish = SharedFlags.FFlagMomentsRefreshOwnMomentsAfterPublish
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagMomentsRefreshProfileOnPostStatus = SharedFlags.FFlagMomentsRefreshProfileOnPostStatus

local function useUserMoments(current, p2)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(false)
	local ref = React.useRef(nil)
	local v6

	if fFlagMomentsRefreshProfileOnPostStatus or fFlagMomentsOptimisticProfilePending then
		v6 = useLocalUserId()
	end

	local v7 = not (v6 == nil) and tostring(v6) == current

	local v8 = not (fFlagMomentsRefreshOwnMomentsAfterPublish or fFlagMomentsRefreshProfileOnPostStatus or fFlagMomentsOptimisticProfilePending)
		and 0
		or SignalsReact.useSignalState(MomentsGetMomentsUserStore(false).getUserMomentsVersion)

	local v9 = not fFlagMomentsOptimisticProfilePending and {}
		or SignalsReact.useSignalState(MomentsGetMomentsUserStore(false).getPendingUserMoments)

	React.useEffect(function()
		local v10 = if current ~= nil then tonumber(current) else nil

		if v10 == nil then
			return
		end

		local v11 = MomentsGetMomentsUserStore(false)

		if
			(fFlagMomentsRefreshProfileOnPostStatus or fFlagMomentsOptimisticProfilePending)
			and ref.current ~= current
		then
			ref.current = current

			if v7 then
				v11.evictUserMoments(v10)
			end
		end

		local v12 = false

		v11.getUserMoments(v10):andThen(function(p3)
			if not v12 then
				setState4(false)
				setState(p3.moments)
				setState2(p3.nextCursor)
				setState3(p3.nextCursor ~= nil)
			end
		end):catch(function()
			if not v12 then
				setState4(true)
			end
		end)
		return function()
			v12 = true
		end
	end, { current, v8, v7 })

	if fFlagMomentsRefreshProfileOnPostStatus or fFlagMomentsOptimisticProfilePending then
		React.useEffect(function()
			if not v7 then
				return
			end

			local v10 = p2 or v5

			if v10 == nil then
				return
			end

			local onUnhideConnection = v10.OnUnhide:Connect(function()
				local v11 = if current ~= nil then tonumber(current) else nil

				if v11 ~= nil then
					MomentsGetMomentsUserStore(false).invalidateUser(v11)
				end
			end)
			return function()
				onUnhideConnection:Disconnect()
			end
		end, { current, p2, v7 })
	end

	local v10 = React.useCallback(function()
		local v11 = if current ~= nil then tonumber(current) else nil

		if v11 == nil or state2 == nil or not state3 or state5 then
			return
		end

		setState5(true)
		MomentsGetMomentsUserStore(false).getUserMoments(v11, state2):andThen(function(p3)
			setState(function(p4)
				return Cryo.List.join(p4, p3.moments)
			end)

			setState3(p3.nextCursor ~= nil and p3.nextCursor ~= state2)
			setState2(p3.nextCursor)
		end):catch(function() end):finally(function()
			setState5(false)
		end)
	end, { current, state2, state3, state5 })
	local v11, v12

	if fFlagMomentsRemoveDeletedFromProfile or fFlagMomentsOptimisticProfilePending then
		v11 = SignalsReact.useSignalState(GetDeletedMomentsStore(false).getDeletedIds)
		local v13 = v11
		v12 = React.useMemo(function()
			if #v13 == 0 then
				return state
			end

			local result = {}

			for k, v14 in state do
				if not table.find(v13, v14.momentId) then
					table.insert(result, v14)
				end
			end

			return result
		end, { state, v13 })
	else
		v12 = state
		v11 = nil
	end

	if fFlagMomentsOptimisticProfilePending then
		local v13 = if current ~= nil then tonumber(current) else nil
		local state6, setState6 = React.useState({})
		local v14 = React.useMemo(function()
			local v15 = v13 == nil and {} or v9[v13] or {}

			local set = {}
			local momentIdSet = {}

			for k, v16 in state do
				set[v16.momentId] = true
				local feedItemId = v16.recommendationMetadata.feedItemId

				if feedItemId ~= nil and feedItemId ~= "" then
					set[feedItemId] = true
				end
			end

			for k, v16 in v15 do
				local publishedMoment = v16.publishedMoment

				if publishedMoment == nil then
					continue
				end

				local feedItemId = publishedMoment.recommendationMetadata.feedItemId

				if not (set[publishedMoment.momentId] or feedItemId ~= nil and set[feedItemId] or v11 ~= nil and table.find(v11, publishedMoment.momentId) ~= nil) then
					continue
				end

				momentIdSet[v16.moment.momentId] = true
			end

			return momentIdSet
		end, { v13, state, v9, v11 })
		React.useEffect(function()
			setState6(function(p3)
				local clone = table.clone(p3)
				local flag = false

				for k in v14 do
					if clone[k] then
						continue
					end

					clone[k] = true
					flag = true
				end

				if flag then
					return clone
				end

				return p3
			end)
		end, { v14 })
		local v15 = if v13 ~= nil then v9[v13] else nil

		if v15 ~= nil and #v15 > 0 then
			local moments = {}

			for k, v16 in v15 do
				local moment = v16.moment

				if not (v14[moment.momentId] or state6[moment.momentId]) then
					table.insert(moments, moment)
				end
			end

			if #moments > 0 then
				v12 = Cryo.List.join(moments, v12)
			end
		end
	end

	return {
		moments = v12,
		hasMore = state3,
		hasFailed = state4,
		isLoadingMore = state5,
		loadMore = v10
	}
end

return useUserMoments
