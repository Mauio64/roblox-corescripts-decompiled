local Players = game:GetService("Players")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local DataHydrationTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId
local observeLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").observeLocalPlayerUserId

local defineFastInt = game:DefineFastInt("UserProfileNamesRetryCount", 3)

local v5 = createDataCache()

local v6 = {}

local v7 = getLocalPlayerUserId()
Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
	local localPlayerUserId = getLocalPlayerUserId()

	if localPlayerUserId ~= v7 then
		v7 = localPlayerUserId
		table.clear(v6)
	end
end)

local namesStatusCache = nil
local v8 = {}
local v9 = {}

local count = 0

local function getNamesStatusCache()
	if namesStatusCache == nil then
		local v10 = createDataCache(nil, nil, { observeLocalUser = false })
		namesStatusCache = v10
		observeLocalPlayerUserId(function()
			count += 1
			table.clear(v8)
			table.clear(v9)
			v10.clear()
		end)
	end

	return namesStatusCache
end

local userProfileStore = nil
local function getUserProfileStore()
	if not userProfileStore then
		userProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UserProfiles/Stores").UserProfileStore
	end

	return userProfileStore
end

local function getProfileModel(p2)
	if not userProfileStore then
		userProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UserProfiles/Stores").UserProfileStore
	end

	return userProfileStore.get().getProfileByUserId(p2)
end

local function getStatusAndFetch(p2)
	local item, v10 = v5.getItem(p2)

	if v10 then
		if not userProfileStore then
			userProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UserProfiles/Stores").UserProfileStore
		end

		userProfileStore.get().fetchNamesByUserIds({ p2 }, function(p3)
			if p3.status == "success" then
				v5.replaceItem(p2, true)
			elseif p3.status == "failed" then
				v5.markItemsAsFailed({ p2 })
			end
		end)
	end

	return item, v10
end

local function resolveUserProfileField(profileByUserId, item, p2)
	if item == "userId" then
		return (tonumber(profileByUserId.userId))
	elseif item == "username" then
		return profileByUserId.names.getUsername(p2)
	elseif item == "displayName" then
		return profileByUserId.names.getDisplayName(p2)
	end

	if not (item == "isVerified" and profileByUserId.getIsVerified ~= nil) then
		return nil
	end

	return (profileByUserId.getIsVerified(p2))
end

local function fetchNamesWithRetries(p2, p3, count2)
	if count2 ~= count then
		return
	end

	v9[p2] = true

	if not userProfileStore then
		userProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UserProfiles/Stores").UserProfileStore
	end

	userProfileStore.get().fetchNamesByUserIds({ p2 }, function(p4)
		if count2 ~= count then
			return
		end

		if p4.status == "success" then
			v9[p2] = nil
			getNamesStatusCache().replaceItem(p2, true)
		elseif p4.status == "failed" then
			if p3 < defineFastInt then
				task.delay(2 ^ p3 + math.random(), fetchNamesWithRetries, p2, p3 + 1, count2)
			else
				v9[p2] = nil
				getNamesStatusCache().markItemsAsFailed({ p2 })
			end
		end
	end)
end

local function getAndFetchUserNames(item)
	local v10 = tostring(item)
	local v11 = v8[v10]

	if v11 ~= nil then
		return v11
	end

	local computed = Signals.createComputed(function(p2)
		local item2, v12 = getNamesStatusCache().getItem(v10)

		if v12 and not v9[v10] then
			fetchNamesWithRetries(v10, 0, count)
		end

		return item2.status(p2)
	end)

	local v12 = {
		names = Signals.createComputed(function(p2)
			if computed(p2) ~= DataHydrationTypes.DataStatus.Ready then
				return nil
			end

			if not userProfileStore then
				userProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UserProfiles/Stores").UserProfileStore
			end

			local profileByUserId = userProfileStore.get().getProfileByUserId(v10)

			if profileByUserId == nil then
				return nil
			end

			return {
				combinedName = profileByUserId.names.getCombinedName(p2),
				username = profileByUserId.names.getUsername(p2)
			}
		end),
		status = computed
	}
	v8[v10] = v12
	return v12
end

local function nonEmpty(p2)
	if p2 == "" then
		return nil
	end

	return p2
end

return {
	resolveField = function(p2, list, p3, p4, p5)
		if #list < 2 then
			return nil, nil
		end

		local v10 = tostring(p3)
		local status = getStatusAndFetch(v10).status(p4)

		if status ~= DataHydrationTypes.DataStatus.Ready then
			return nil, status
		end

		if not userProfileStore then
			userProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UserProfiles/Stores").UserProfileStore
		end

		local profileByUserId = userProfileStore.get().getProfileByUserId(v10)

		if not profileByUserId then
			return nil, status
		end

		return resolveUserProfileField(profileByUserId, list[2], p4), status
	end,
	updateFromHydration = function(items)
		if not userProfileStore then
			userProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UserProfiles/Stores").UserProfileStore
		end

		userProfileStore.get().updateFromHydration(items)

		local userIdSet = {}

		for userId, item in items do
			if item.userId ~= nil then
				userId = tostring(item.userId)
			end

			userIdSet[userId] = true
		end

		v5.replaceItems(userIdSet)
	end,
	getAndFetchUserInfo = function(p2)
		local v10 = tostring(p2)
		local v11 = v6[v10]

		if v11 ~= nil then
			return v11
		end

		local computed = Signals.createComputed(function(p3)
			return getStatusAndFetch(v10).status(p3)
		end)

		local v12 = {
			info = Signals.createComputed(function(p3)
				if computed(p3) ~= DataHydrationTypes.DataStatus.Ready then
					return nil
				end

				if not userProfileStore then
					userProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UserProfiles/Stores").UserProfileStore
				end

				local profileByUserId = userProfileStore.get().getProfileByUserId(v10)

				if profileByUserId == nil then
					return nil
				end

				return {
					userId = tonumber(v10),
					displayName = profileByUserId.names.getDisplayName(p3),
					username = profileByUserId.names.getUsername(p3),
					hasVerifiedBadge = profileByUserId.getIsVerified ~= nil and profileByUserId.getIsVerified(p3)
				}
			end),
			status = computed
		}
		v6[v10] = v12
		return v12
	end,
	getAndFetchUserNames = getAndFetchUserNames,
	getAndFetchUserNamesByUserIds = function(items)
		local v10 = {}

		for k, item in items do
			if tonumber(item) ~= nil then
				v10[item] = getAndFetchUserNames(item)
			end
		end

		return Signals.createComputed(function(p2)
			local v11 = DataHydrationTypes.DataStatus.Ready
			local v12 = {}

			for k, v13 in v10 do
				local status = v13.status(p2)

				if status == DataHydrationTypes.DataStatus.NotReady then
					v11 = DataHydrationTypes.DataStatus.NotReady
				elseif status == DataHydrationTypes.DataStatus.Failed and v11 == DataHydrationTypes.DataStatus.Ready then
					v11 = DataHydrationTypes.DataStatus.Failed
				end

				local names = v13.names(p2)

				if not names then
					continue
				end

				local combinedName = names.combinedName

				if combinedName == "" then
					combinedName = nil
				end

				local username = names.username

				if username == "" then
					username = nil
				end

				v12[k] = { combinedName = combinedName, username = username }
			end

			return { status = v11, namesByUserId = v12 }
		end)
	end
}
