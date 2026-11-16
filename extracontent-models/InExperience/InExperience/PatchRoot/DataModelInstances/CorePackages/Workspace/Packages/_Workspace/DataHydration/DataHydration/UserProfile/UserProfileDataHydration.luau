local Players = game:GetService("Players")

local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local createDataCache = require(DataHydration.createDataCache)
local DataHydrationTypes = require(DataHydration.DataHydrationTypes)
local Signals = require(parent.Signals)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId
local DataHydrationUtils2 = require(DataHydration.DataHydrationUtils)
local observeLocalPlayerUserId = DataHydrationUtils2.observeLocalPlayerUserId

local defineFastInt = game:DefineFastInt("UserProfileNamesRetryCount", 3)

local dataCache = createDataCache()

local v = {}

local v2 = getLocalPlayerUserId()
Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
	local localPlayerUserId = getLocalPlayerUserId()

	if localPlayerUserId ~= v2 then
		v2 = localPlayerUserId
		table.clear(v)
	end
end)

local namesStatusCache = nil
local v3 = {}
local v4 = {}

local count = 0

local function getNamesStatusCache()
	if namesStatusCache == nil then
		local dataCache2 = createDataCache(nil, nil, { observeLocalUser = false })
		namesStatusCache = dataCache2
		observeLocalPlayerUserId(function()
			count += 1
			table.clear(v3)
			table.clear(v4)
			dataCache2.clear()
		end)
	end

	return namesStatusCache
end

local userProfileStore = nil
local function getUserProfileStore() -- 4 equivalent calls inferred from this helper
	if not userProfileStore then
		local Stores = require(parent.UserProfiles.Stores)
		userProfileStore = Stores.UserProfileStore
	end

	return userProfileStore
end

local function getProfileModel(p: string) -- 3 equivalent calls inferred from this helper
	return (getUserProfileStore().get().getProfileByUserId(p)) -- inferred equivalent call
end

local function getStatusAndFetch(p: string)
	local item, v5 = dataCache.getItem(p)

	if v5 then
		getUserProfileStore().get().fetchNamesByUserIds({ p }, function(p2) -- inferred equivalent call
			if p2.status == "success" then
				dataCache.replaceItem(p, true)
			elseif p2.status == "failed" then
				dataCache.markItemsAsFailed({ p })
			end
		end)
	end

	return item, v5
end

local function resolveUserProfileField(profileModel, p: string, p2)
	if p == "userId" then
		return (tonumber(profileModel.userId))
	elseif p == "username" then
		return profileModel.names.getUsername(p2)
	elseif p == "displayName" then
		return profileModel.names.getDisplayName(p2)
	end

	if not (p == "isVerified" and profileModel.getIsVerified ~= nil) then
		return nil
	end

	return (profileModel.getIsVerified(p2))
end

local function fetchNamesWithRetries(p: string, p2: number, count2: number)
	if count2 ~= count then
		return
	end

	v4[p] = true
	getUserProfileStore().get().fetchNamesByUserIds({ p }, function(p3) -- inferred equivalent call
		if count2 ~= count then
			return
		end

		if p3.status == "success" then
			v4[p] = nil
			getNamesStatusCache().replaceItem(p, true)
		elseif p3.status == "failed" then
			if p2 < defineFastInt then
				task.delay(2 ^ p2 + math.random(), fetchNamesWithRetries, p, p2 + 1, count2)
				return
			end

			v4[p] = nil
			getNamesStatusCache().markItemsAsFailed({ p })
		end
	end)
end

local function getAndFetchUserNames(item)
	local v5 = tostring(item)
	local v6 = v3[v5]

	if v6 ~= nil then
		return v6
	end

	local status = Signals.createComputed(function(p)
		local item2, v7 = getNamesStatusCache().getItem(v5)

		if v7 and not v4[v5] then
			fetchNamesWithRetries(v5, 0, count)
		end

		return item2.status(p)
	end)

	local v7 = {
		names = Signals.createComputed(function(p)
			if status(p) ~= DataHydrationTypes.DataStatus.Ready then
				return nil
			end

			local profileModel = getProfileModel(v5) -- inferred equivalent call

			if profileModel == nil then
				return nil
			end

			return {
				combinedName = profileModel.names.getCombinedName(p),
				username = profileModel.names.getUsername(p)
			}
		end),
		status = status
	}
	v3[v5] = v7
	return v7
end

local function nonEmpty(p: string?) -- 2 equivalent calls inferred from this helper
	return if p ~= "" then p else nil
end

local UserProfileDataHydration = {}

function UserProfileDataHydration.resolveField(_: string, list, p: string, p2, _: boolean?)
	if #list < 2 then
		return nil, nil
	end

	local v5 = tostring(p)
	local status = getStatusAndFetch(v5).status(p2)

	if status ~= DataHydrationTypes.DataStatus.Ready then
		return nil, status
	end

	local profileModel = getProfileModel(v5) -- inferred equivalent call

	if profileModel then
		return resolveUserProfileField(profileModel, list[2], p2), status
	end

	return nil, status
end

function UserProfileDataHydration.updateFromHydration(items)
	getUserProfileStore().get().updateFromHydration(items) -- inferred equivalent call

	local userIdSet = {}

	for userId, item in items do
		if item.userId ~= nil then
			userId = tostring(item.userId)
		end

		userIdSet[userId] = true
	end

	dataCache.replaceItems(userIdSet)
end

function UserProfileDataHydration.getAndFetchUserInfo(p)
	local v5 = tostring(p)
	local v6 = v[v5]

	if v6 ~= nil then
		return v6
	end

	local status = Signals.createComputed(function(p2)
		return getStatusAndFetch(v5).status(p2)
	end)

	local v7 = {
		info = Signals.createComputed(function(p2)
			if status(p2) ~= DataHydrationTypes.DataStatus.Ready then
				return nil
			end

			local profileModel = getProfileModel(v5) -- inferred equivalent call

			if profileModel == nil then
				return nil
			end

			return {
				userId = tonumber(v5),
				displayName = profileModel.names.getDisplayName(p2),
				username = profileModel.names.getUsername(p2),
				hasVerifiedBadge = profileModel.getIsVerified ~= nil and profileModel.getIsVerified(p2)
			}
		end),
		status = status
	}
	v[v5] = v7
	return v7
end

UserProfileDataHydration.getAndFetchUserNames = getAndFetchUserNames

function UserProfileDataHydration.getAndFetchUserNamesByUserIds(items)
	local v5 = {}

	for _, item in items do
		if tonumber(item) ~= nil then
			v5[item] = getAndFetchUserNames(item)
		end
	end

	return Signals.createComputed(function(p)
		local status2 = DataHydrationTypes.DataStatus.Ready
		local namesByUserId = {}

		for k, v6 in v5 do
			local status = v6.status(p)

			if status == DataHydrationTypes.DataStatus.NotReady then
				status2 = DataHydrationTypes.DataStatus.NotReady
			elseif
				status == DataHydrationTypes.DataStatus.Failed
				and status2 == DataHydrationTypes.DataStatus.Ready
			then
				status2 = DataHydrationTypes.DataStatus.Failed
			end

			local names = v6.names(p)

			if names then
				namesByUserId[k] = {
					combinedName = nonEmpty(names.combinedName), -- inferred equivalent call
					username = nonEmpty(names.username) -- inferred equivalent call
				}
			end
		end

		return { status = status2, namesByUserId = namesByUserId }
	end)
end

return UserProfileDataHydration
