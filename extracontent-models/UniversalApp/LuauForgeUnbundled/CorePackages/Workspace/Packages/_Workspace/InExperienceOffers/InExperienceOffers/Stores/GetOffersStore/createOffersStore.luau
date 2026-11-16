require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/Promise")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/SignalsUtils").createSessionScopedSignal

local getAllUserOffers = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Api/getAllUserOffers")
local OffersDebugLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Internal/OffersDebugLogger")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")
local MockGetAllUserOffers = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Mocks/MockGetAllUserOffers")
local getSecondsUntilNextExpiration = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/getSecondsUntilNextExpiration")
local getSecondsUntilAnyKeyEmpties = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/getSecondsUntilAnyKeyEmpties")
local isNotificationEligible = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/isNotificationEligible")
local FeatureKey = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Enums/FeatureKey")
local NotificationLocation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Enums/NotificationLocation")
local fFlagHideOfferNotificationsWhenShopEmpty = SharedFlags.FFlagHideOfferNotificationsWhenShopEmpty
local FFlagOffersRespectExpiration = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FFlagOffersRespectExpiration")
local FFlagOffersMergeStoreResults = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FFlagOffersMergeStoreResults")
local FFlagUseMockUserOffers = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FFlagUseMockUserOffers")
local FIntOfferExpirationRefetchBufferSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FIntOfferExpirationRefetchBufferSeconds")
local FIntOfferExpirationRefetchJitterSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FIntOfferExpirationRefetchJitterSeconds")
local FIntOfferExpirationRefetchMaxCount = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FIntOfferExpirationRefetchMaxCount")
local FFlagOffersPerKeyExpiryRefetch = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FFlagOffersPerKeyExpiryRefetch")
local FFlagOffersShopScopedNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FFlagOffersShopScopedNotification")

local function normalizePresentationData(presentationData)
	if presentationData == nil then
		return nil
	end

	local result = {}

	for k, item in presentationData do
		if item.banner ~= nil then
			result.banner = item.banner
		end

		if item.menuBadge ~= nil then
			result.menuBadge = item.menuBadge
		end

		if item.tooltip ~= nil then
			result.tooltip = item.tooltip
		end
	end

	return result
end

local function normalizeOffer(data)
	return {
		offerId = data.offerId,
		offerStatus = data.offerStatus,
		featureKeys = data.featureKeys,
		expirationTimeInUTC = data.expirationTimeInUTC,
		presentationData = normalizePresentationData(data.presentationData)
	}
end

local function bucketResponse(p2)
	local result = {}

	for k, offer in p2.offers do
		local v5 = {
			offerId = offer.offerId,
			offerStatus = offer.offerStatus,
			featureKeys = offer.featureKeys,
			expirationTimeInUTC = offer.expirationTimeInUTC,
			presentationData = normalizePresentationData(offer.presentationData)
		}

		for k2, featureKey in v5.featureKeys do
			local v6 = result[featureKey]

			if v6 == nil then
				v6 = {}
				result[featureKey] = v6
			end

			table.insert(v6, v5)
		end
	end

	return result
end

local function mergeRequestedKeys(p2, p3, items)
	local result = p2 == nil and {} or table.clone(p2)

	for k, item in items do
		result[item] = p3[item]
	end

	return result
end

local function keysOf(items)
	local result = {}

	for k in items do
		table.insert(result, k)
	end

	return result
end

local function createOffersStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(nil)

	local sessionScopedSignal2, v6 = createSessionScopedSignal(nil)

	local sessionScopedSignal3, v7 = createSessionScopedSignal(false)

	local signal, v8 = Signals.createSignal(false)

	local signal2, v9 = Signals.createSignal(true)

	local signal3, v10 = Signals.createSignal(true)

	local computed = Signals.createComputed(function(p2): boolean
		local v11 = sessionScopedSignal(p2)
		local v12 = sessionScopedSignal2(p2)

		if
			v11 == nil
			or v12 == nil
			or not signal2(p2)
			or fFlagHideOfferNotificationsWhenShopEmpty and not signal3(p2)
		then
			return false
		end

		if FFlagOffersShopScopedNotification then
			local v13 = v11[FeatureKey.RobloxShop]

			if v13 ~= nil then
				for k, v14 in v13 do
					if isNotificationEligible(v14, v12) then
						return true
					end
				end
			end

			return false
		end

		for k, v13 in v11 do
			for k2, v14 in v13 do
				if isNotificationEligible(v14, v12) then
					return true
				end
			end
		end

		return false
	end)

	local computed2 = Signals.createComputed(function(p2)
		if sessionScopedSignal3(p2) then
			return NotificationLocation.None
		end

		local v11 = sessionScopedSignal(p2)
		local v12 = sessionScopedSignal2(p2)

		if v11 == nil or v12 == nil or fFlagHideOfferNotificationsWhenShopEmpty and not signal3(p2) then
			return NotificationLocation.None
		end

		local v13 = signal(p2)

		if not (v13 or signal2(p2)) then
			return NotificationLocation.None
		end

		local v14 = if v13 then NotificationLocation.GlobalIcon else NotificationLocation.Hamburger

		if FFlagOffersShopScopedNotification then
			local v15 = v11[FeatureKey.RobloxShop]

			if v15 ~= nil then
				for k, v16 in v15 do
					if isNotificationEligible(v16, v12) then
						return v14
					end
				end
			end

			return NotificationLocation.None
		end

		for k, v15 in v11 do
			for k2, v16 in v15 do
				if isNotificationEligible(v16, v12) then
					return v14
				end
			end
		end

		return NotificationLocation.None
	end)

	local function hydrateOfferExposureSnapshot(p2)
		if sessionScopedSignal2(false) == nil then
			v6(p2)
		end
	end

	local function markInExperienceShopOpened()
		v7(true)
	end

	local v11 = if FFlagUseMockUserOffers then MockGetAllUserOffers else getAllUserOffers
	local v12 = nil
	local thread = nil

	local count = 0

	local count2 = 0

	local scheduleExpirationRefetch

	local function cancelExpirationRefetch()
		if thread ~= nil then
			pcall(task.cancel, thread)
			thread = nil
		end
	end

	local function commitOffers(p2)
		local v13 = {}

		for k, offer in p2.offers do
			local v14 = {
				offerId = offer.offerId,
				offerStatus = offer.offerStatus,
				featureKeys = offer.featureKeys,
				expirationTimeInUTC = offer.expirationTimeInUTC,
				presentationData = normalizePresentationData(offer.presentationData)
			}

			for k2, featureKey in v14.featureKeys do
				local v15 = v13[featureKey]

				if v15 == nil then
					v15 = {}
					v13[featureKey] = v15
				end

				table.insert(v15, v14)
			end
		end

		v5(v13)

		if FFlagOffersRespectExpiration then
			scheduleExpirationRefetch(v13)
		end
	end

	local function commitMergedOffers(p2, p3)
		local v13 = bucketResponse(p3)
		local v14 = mergeRequestedKeys(sessionScopedSignal(false), v13, p2)
		v5(v14)

		if FFlagOffersRespectExpiration then
			scheduleExpirationRefetch(v14)
		end
	end

	local function expireShopOffers()
		local v13 = sessionScopedSignal(false)

		if v13 == nil or v13[FeatureKey.RobloxShop] == nil then
			return
		end

		local v14 = {}

		for k, v15 in v13 do
			if k ~= FeatureKey.RobloxShop then
				v14[k] = v15
			end
		end

		v5(v14)
	end

	local function commitOffersIfCurrent(p2, p3)
		if p2 ~= count2 then
			return
		end

		commitOffers(p3)
	end

	local function commitMergedOffersIfCurrent(p2, p3, p4)
		if p2 ~= count2 then
			return
		end

		local v13 = bucketResponse(p4)
		local v14 = mergeRequestedKeys(sessionScopedSignal(false), v13, p3)
		v5(v14)

		if FFlagOffersRespectExpiration then
			scheduleExpirationRefetch(v14)
		end
	end

	local function fetchOffers(p2)
		if not FFlagOffersRespectExpiration then
			v11(p2):andThen(function(p3)
				if FFlagOffersMergeStoreResults then
					local v14 = bucketResponse(p3)
					local v15 = mergeRequestedKeys(sessionScopedSignal(false), v14, p2)
					v5(v15)

					if FFlagOffersRespectExpiration then
						scheduleExpirationRefetch(v15)
					end
				else
					commitOffers(p3)
				end
			end):catch(function(p3)
				OffersDebugLogger.log("fetchOffers failed: " .. tostring(p3))
			end)
			return
		end

		v12 = p2

		if thread ~= nil then
			pcall(task.cancel, thread)
			thread = nil
		end

		count2 += 1
		local v13 = count2
		v11(p2):andThen(function(p3)
			if FFlagOffersMergeStoreResults then
				if v13 ~= count2 then
					return
				end

				local v15 = bucketResponse(p3)
				local v16 = mergeRequestedKeys(sessionScopedSignal(false), v15, p2)
				v5(v16)

				if FFlagOffersRespectExpiration then
					scheduleExpirationRefetch(v16)
				end
			elseif v13 == count2 then
				commitOffers(p3)
			end
		end):catch(function(p3)
			OffersDebugLogger.log("fetchOffers failed: " .. tostring(p3))

			if v13 == count2 then
				local v14 = sessionScopedSignal(false)

				if v14 ~= nil then
					scheduleExpirationRefetch(v14)
				end
			end
		end)
	end

	local function armExpirationRefetch(p2, p3)
		if FIntOfferExpirationRefetchMaxCount <= count then
			return
		end

		local v13 = p3 + FIntOfferExpirationRefetchBufferSeconds

		if FIntOfferExpirationRefetchJitterSeconds > 0 then
			v13 += math.random() * FIntOfferExpirationRefetchJitterSeconds
		end

		thread = task.delay(v13, function()
			thread = nil
			count += 1
			local v14 = count2
			v11(p2):andThen(function(p4)
				if FFlagOffersMergeStoreResults then
					if v14 ~= count2 then
						return
					end

					local v16 = bucketResponse(p4)
					local v17 = mergeRequestedKeys(sessionScopedSignal(false), v16, p2)
					v5(v17)

					if FFlagOffersRespectExpiration then
						scheduleExpirationRefetch(v17)
					end
				elseif v14 == count2 then
					commitOffers(p4)
				end
			end):catch(function(p4)
				if v14 ~= count2 then
					return
				end

				OffersDebugLogger.log("expiration refetch failed: " .. tostring(p4))

				local v15 = sessionScopedSignal(false)

				if v15 ~= nil then
					scheduleExpirationRefetch(v15)
				end
			end)
		end)
	end

	local function scheduleExpirationRefetchPerKey(items)
		if thread ~= nil then
			pcall(task.cancel, thread)
			thread = nil
		end

		local v13 = getSecondsUntilAnyKeyEmpties(items)

		if v13 == nil then
			return
		end

		local v15 = {}

		for k in items do
			table.insert(v15, k)
		end

		armExpirationRefetch(v15, v13)
	end

	scheduleExpirationRefetch = function(items)
		if FFlagOffersPerKeyExpiryRefetch then
			if thread ~= nil then
				pcall(task.cancel, thread)
				thread = nil
			end

			local v13 = getSecondsUntilAnyKeyEmpties(items)

			if v13 == nil then
				return
			end

			local v15 = {}

			for k in items do
				table.insert(v15, k)
			end

			armExpirationRefetch(v15, v13)
		else
			if thread ~= nil then
				pcall(task.cancel, thread)
				thread = nil
			end

			local v13 = v12
			local v14 = getSecondsUntilNextExpiration(items)

			if v13 == nil or v14 == nil or FIntOfferExpirationRefetchMaxCount <= count then
				return
			end

			local v15 = v14 + FIntOfferExpirationRefetchBufferSeconds

			if FIntOfferExpirationRefetchJitterSeconds > 0 then
				v15 += math.random() * FIntOfferExpirationRefetchJitterSeconds
			end

			thread = task.delay(v15, function()
				thread = nil
				count += 1
				local v16 = count2

				v11(v13):andThen(function(p2)
					if FFlagOffersMergeStoreResults then
						if v16 ~= count2 then
							return
						end

						local v18 = bucketResponse(p2)
						local v19 = mergeRequestedKeys(sessionScopedSignal(false), v18, v13)
						v5(v19)

						if FFlagOffersRespectExpiration then
							scheduleExpirationRefetch(v19)
						end
					elseif v16 == count2 then
						commitOffers(p2)
					end
				end):catch(function(p2)
					if v16 ~= count2 then
						return
					end

					OffersDebugLogger.log("expiration refetch failed, expiring shop offers: " .. tostring(p2))

					expireShopOffers()
				end)
			end)
		end
	end

	return {
		getOffers = sessionScopedSignal,
		getOfferNotificationShown = computed,
		getOfferNotificationShownWithEnum = computed2,
		getOfferExposureSnapshot = sessionScopedSignal2,
		getHasInExperienceShopOpened = sessionScopedSignal3,
		getIsInExperienceShopGlobalIconAvailable = signal,
		getIsShopAvailable = signal2,
		getShopHasItems = signal3,
		fetchOffers = fetchOffers,
		hydrateOfferExposureSnapshot = hydrateOfferExposureSnapshot,
		markInExperienceShopOpened = markInExperienceShopOpened,
		setInExperienceShopGlobalIconAvailable = v8,
		setIsShopAvailable = v9,
		setShopHasItems = v10
	}
end

return createOffersStore
