local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")
local parent = InExperienceOffers.Parent

require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local getAllUserOffers = require(InExperienceOffers.Api.getAllUserOffers)
local OffersDebugLogger = require(InExperienceOffers.Internal.OffersDebugLogger)
require(InExperienceOffers.Types)
local MockGetAllUserOffers = require(InExperienceOffers.Mocks.MockGetAllUserOffers)
local getSecondsUntilNextExpiration = require(InExperienceOffers.Utils.getSecondsUntilNextExpiration)
local getSecondsUntilAnyKeyEmpties = require(InExperienceOffers.Utils.getSecondsUntilAnyKeyEmpties)
local isNotificationEligible = require(InExperienceOffers.Utils.isNotificationEligible)
local FeatureKey = require(InExperienceOffers.Enums.FeatureKey)
local NotificationLocation = require(InExperienceOffers.Enums.NotificationLocation)
local FFlagHideOfferNotificationsWhenShopEmpty = SharedFlags.FFlagHideOfferNotificationsWhenShopEmpty
local FFlagOffersRespectExpiration = require(InExperienceOffers.Flags.FFlagOffersRespectExpiration)
local FFlagOffersMergeStoreResults = require(InExperienceOffers.Flags.FFlagOffersMergeStoreResults)
local FFlagUseMockUserOffers = require(InExperienceOffers.Flags.FFlagUseMockUserOffers)
local FIntOfferExpirationRefetchBufferSeconds = require(InExperienceOffers.Flags.FIntOfferExpirationRefetchBufferSeconds)
local FIntOfferExpirationRefetchJitterSeconds = require(InExperienceOffers.Flags.FIntOfferExpirationRefetchJitterSeconds)
local FIntOfferExpirationRefetchMaxCount = require(InExperienceOffers.Flags.FIntOfferExpirationRefetchMaxCount)
local FFlagOffersPerKeyExpiryRefetch = require(InExperienceOffers.Flags.FFlagOffersPerKeyExpiryRefetch)
local FFlagOffersShopScopedNotification = require(InExperienceOffers.Flags.FFlagOffersShopScopedNotification)

local function normalizePresentationData(presentationData)
	if presentationData == nil then
		return nil
	end

	local result = {}

	for _, item in presentationData do
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

local function normalizeOffer(offer) -- 2 equivalent calls inferred from this helper
	return {
		offerId = offer.offerId,
		offerStatus = offer.offerStatus,
		featureKeys = offer.featureKeys,
		expirationTimeInUTC = offer.expirationTimeInUTC,
		presentationData = normalizePresentationData(offer.presentationData)
	}
end

local function bucketResponse(p)
	local result = {}

	for _, offer in p.offers do
		local offer2 = normalizeOffer(offer) -- inferred equivalent call

		for _, featureKey in offer2.featureKeys do
			local offers = result[featureKey]

			if offers == nil then
				offers = {}
				result[featureKey] = offers
			end

			table.insert(offers, offer2)
		end
	end

	return result
end

local function mergeRequestedKeys(p, p2, items)
	local result = p == nil and {} or table.clone(p)

	for _, item in items do
		result[item] = p2[item]
	end

	return result
end

local function keysOf(items) -- 1 equivalent call inferred from this helper
	local result = {}

	for k in items do
		table.insert(result, k)
	end

	return result
end

local function createOffersStore()
	local sessionScopedSignal, v = createSessionScopedSignal(nil)

	local sessionScopedSignal2, v2 = createSessionScopedSignal(nil)

	local sessionScopedSignal3, v3 = createSessionScopedSignal(false)

	local signal, setInExperienceShopGlobalIconAvailable = Signals.createSignal(false)

	local signal2, setIsShopAvailable = Signals.createSignal(true)

	local signal3, setShopHasItems = Signals.createSignal(true)

	local getOfferNotificationShown = Signals.createComputed(function(p): boolean
		local v4 = sessionScopedSignal(p)
		local v5 = sessionScopedSignal2(p)

		if v4 == nil or v5 == nil or not signal2(p) or FFlagHideOfferNotificationsWhenShopEmpty and not signal3(p) then
			return false
		end

		if FFlagOffersShopScopedNotification then
			local v6 = v4[FeatureKey.RobloxShop]

			if v6 ~= nil then
				for _, v7 in v6 do
					if isNotificationEligible(v7, v5) then
						return true
					end
				end
			end

			return false
		end

		for _, v6 in v4 do
			for _, v7 in v6 do
				if isNotificationEligible(v7, v5) then
					return true
				end
			end
		end

		return false
	end)

	local getOfferNotificationShownWithEnum = Signals.createComputed(function(p)
		if sessionScopedSignal3(p) then
			return NotificationLocation.None
		end

		local v4 = sessionScopedSignal(p)
		local v5 = sessionScopedSignal2(p)

		if v4 == nil or v5 == nil or FFlagHideOfferNotificationsWhenShopEmpty and not signal3(p) then
			return NotificationLocation.None
		end

		local v6 = signal(p)

		if not (v6 or signal2(p)) then
			return NotificationLocation.None
		end

		local v7

		if v6 then
			v7 = NotificationLocation.GlobalIcon
		else
			v7 = NotificationLocation.Hamburger
		end

		if FFlagOffersShopScopedNotification then
			local v8 = v4[FeatureKey.RobloxShop]

			if v8 ~= nil then
				for _, v9 in v8 do
					if isNotificationEligible(v9, v5) then
						return v7
					end
				end
			end

			return NotificationLocation.None
		end

		for _, v8 in v4 do
			for _, v9 in v8 do
				if isNotificationEligible(v9, v5) then
					return v7
				end
			end
		end

		return NotificationLocation.None
	end)

	local function hydrateOfferExposureSnapshot(p)
		if sessionScopedSignal2(false) == nil then
			v2(p)
		end
	end

	local function markInExperienceShopOpened()
		v3(true)
	end

	local v4

	if FFlagUseMockUserOffers then
		v4 = MockGetAllUserOffers
	else
		v4 = getAllUserOffers
	end

	local v5 = nil
	local thread = nil

	local count = 0

	local count2 = 0

	local scheduleExpirationRefetch

	local function cancelExpirationRefetch() -- 3 equivalent calls inferred from this helper
		if thread ~= nil then
			pcall(task.cancel, thread)
			thread = nil
		end
	end

	local function commitOffers(p)
		local v6 = {}

		for _, offer in p.offers do
			local offer2 = normalizeOffer(offer) -- inferred equivalent call

			for _, featureKey in offer2.featureKeys do
				local offers = v6[featureKey]

				if offers == nil then
					offers = {}
					v6[featureKey] = offers
				end

				table.insert(offers, offer2)
			end
		end

		v(v6)

		if FFlagOffersRespectExpiration then
			scheduleExpirationRefetch(v6)
		end
	end

	local function commitMergedOffers(p, p2) -- 2 equivalent calls inferred from this helper
		local v6 = bucketResponse(p2)
		local v7 = mergeRequestedKeys(sessionScopedSignal(false), v6, p)
		v(v7)

		if FFlagOffersRespectExpiration then
			scheduleExpirationRefetch(v7)
		end
	end

	local function expireShopOffers()
		local v6 = sessionScopedSignal(false)

		if v6 == nil or v6[FeatureKey.RobloxShop] == nil then
			return
		end

		local v7 = {}

		for k, v8 in v6 do
			if k ~= FeatureKey.RobloxShop then
				v7[k] = v8
			end
		end

		v(v7)
	end

	local function commitOffersIfCurrent(p: number, p2) -- 3 equivalent calls inferred from this helper
		if p ~= count2 then
			return
		end

		commitOffers(p2)
	end

	local function commitMergedOffersIfCurrent(p: number, p2, p3) -- 3 equivalent calls inferred from this helper
		if p ~= count2 then
			return
		end

		commitMergedOffers(p2, p3) -- inferred equivalent call
	end

	local function fetchOffers(p)
		if not FFlagOffersRespectExpiration then
			v4(p):andThen(function(p2)
				if FFlagOffersMergeStoreResults then
					commitMergedOffers(p, p2) -- inferred equivalent call
				else
					commitOffers(p2)
				end
			end):catch(function(p2)
				OffersDebugLogger.log("fetchOffers failed: " .. tostring(p2))
			end)
			return
		end

		v5 = p
		cancelExpirationRefetch() -- inferred equivalent call
		count2 += 1
		local v6 = count2
		v4(p):andThen(function(p2)
			if FFlagOffersMergeStoreResults then
				commitMergedOffersIfCurrent(v6, p, p2) -- inferred equivalent call
			else
				commitOffersIfCurrent(v6, p2) -- inferred equivalent call
			end
		end):catch(function(p2)
			OffersDebugLogger.log("fetchOffers failed: " .. tostring(p2))

			if v6 == count2 then
				local v7 = sessionScopedSignal(false)

				if v7 ~= nil then
					scheduleExpirationRefetch(v7)
				end
			end
		end)
	end

	local function armExpirationRefetch(p, secondsUntilAnyKeyEmpties: number)
		if FIntOfferExpirationRefetchMaxCount <= count then
			return
		end

		local v6 = secondsUntilAnyKeyEmpties + FIntOfferExpirationRefetchBufferSeconds

		if FIntOfferExpirationRefetchJitterSeconds > 0 then
			v6 += math.random() * FIntOfferExpirationRefetchJitterSeconds
		end

		thread = task.delay(v6, function()
			thread = nil
			count += 1
			local v7 = count2
			v4(p):andThen(function(p2)
				if FFlagOffersMergeStoreResults then
					commitMergedOffersIfCurrent(v7, p, p2) -- inferred equivalent call
				else
					commitOffersIfCurrent(v7, p2) -- inferred equivalent call
				end
			end):catch(function(p2)
				if v7 ~= count2 then
					return
				end

				OffersDebugLogger.log("expiration refetch failed: " .. tostring(p2))

				local v8 = sessionScopedSignal(false)

				if v8 ~= nil then
					scheduleExpirationRefetch(v8)
				end
			end)
		end)
	end

	local function scheduleExpirationRefetchPerKey(items) -- 1 equivalent call inferred from this helper
		cancelExpirationRefetch() -- inferred equivalent call
		local secondsUntilAnyKeyEmpties = getSecondsUntilAnyKeyEmpties(items)

		if secondsUntilAnyKeyEmpties == nil then
			return
		end

		armExpirationRefetch(keysOf(items), secondsUntilAnyKeyEmpties) -- inferred equivalent call
	end

	scheduleExpirationRefetch = function(p)
		if FFlagOffersPerKeyExpiryRefetch then
			scheduleExpirationRefetchPerKey(p) -- inferred equivalent call
		else
			cancelExpirationRefetch() -- inferred equivalent call
			local v6 = v5
			local secondsUntilNextExpiration = getSecondsUntilNextExpiration(p)

			if v6 == nil or secondsUntilNextExpiration == nil or FIntOfferExpirationRefetchMaxCount <= count then
				return
			end

			local v7 = secondsUntilNextExpiration + FIntOfferExpirationRefetchBufferSeconds

			if FIntOfferExpirationRefetchJitterSeconds > 0 then
				v7 += math.random() * FIntOfferExpirationRefetchJitterSeconds
			end

			thread = task.delay(v7, function()
				thread = nil
				count += 1
				local v8 = count2

				v4(v6):andThen(function(p2)
					if FFlagOffersMergeStoreResults then
						commitMergedOffersIfCurrent(v8, v6, p2) -- inferred equivalent call
					else
						commitOffersIfCurrent(v8, p2) -- inferred equivalent call
					end
				end):catch(function(p2)
					if v8 ~= count2 then
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
		getOfferNotificationShown = getOfferNotificationShown,
		getOfferNotificationShownWithEnum = getOfferNotificationShownWithEnum,
		getOfferExposureSnapshot = sessionScopedSignal2,
		getHasInExperienceShopOpened = sessionScopedSignal3,
		getIsInExperienceShopGlobalIconAvailable = signal,
		getIsShopAvailable = signal2,
		getShopHasItems = signal3,
		fetchOffers = fetchOffers,
		hydrateOfferExposureSnapshot = hydrateOfferExposureSnapshot,
		markInExperienceShopOpened = markInExperienceShopOpened,
		setInExperienceShopGlobalIconAvailable = setInExperienceShopGlobalIconAvailable,
		setIsShopAvailable = setIsShopAvailable,
		setShopHasItems = setShopHasItems
	}
end

return createOffersStore
