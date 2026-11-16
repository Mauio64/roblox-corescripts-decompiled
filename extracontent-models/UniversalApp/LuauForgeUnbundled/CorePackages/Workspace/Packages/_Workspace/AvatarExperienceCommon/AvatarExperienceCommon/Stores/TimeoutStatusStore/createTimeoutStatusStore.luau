local HttpService = game:GetService("HttpService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Promise")
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local createHttpStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/InternalHttpStore").createHttpStore

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Loggers").mutedError
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Http").Url

local getTimeoutEndTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getTimeoutEndTime")

local fFlagAXTimeoutAcknowledgementGating = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXTimeoutAcknowledgementGating

local function isAcknowledged(value): boolean
	return value ~= nil and value ~= "" and string.sub(value, 1, 5) ~= "0001-"
end

local function getRequiresAcknowledgement(p2)
	local requiresAcknowledgement

	if p2 == nil or p2.acknowledgeable ~= true then
		requiresAcknowledgement = false
	else
		local acknowledgedTime = p2.acknowledgedTime
		requiresAcknowledgement = acknowledgedTime == nil
			or acknowledgedTime == ""
			or string.sub(acknowledgedTime, 1, 5) == "0001-"
	end

	return requiresAcknowledgement
end

local function getEndDateTime(p2)
	local endDate = if p2.details then p2.details.endDate else nil
	local v6 = if p2.timeoutAction then p2.timeoutAction.endTime else nil
	local v7 = getTimeoutEndTime(endDate, v6)

	if not v7 then
		return nil
	end

	local success, result = pcall(function()
		return DateTime.fromIsoDate(v7)
	end)

	if success then
		return result
	end

	return nil
end

local function createTimeoutStatusStore()
	local signal, v5 = createSignal({
		isTimedOut = false,
		featureName = nil,
		access = nil,
		timeoutAction = nil,
		details = nil,
		error = nil
	})

	local v6 = false
	local flag = false
	local httpStore = createHttpStore()
	local v7 = nil
	local v8 = nil

	local v9 = {}
	local count = 0

	local function extractTimeoutAction(result, p2)
		if not result.features then
			return nil
		end

		for k, feature in result.features do
			if not (feature.featureName == p2 and feature.v2Recourses and #feature.v2Recourses > 0) then
				continue
			end

			local v2Recours = feature.v2Recourses[1]

			if not (v2Recours and #v2Recours > 0) then
				continue
			end

			local v2Recour = v2Recours[1]

			if v2Recour.timeoutActions and #v2Recour.timeoutActions > 0 then
				return v2Recour.timeoutActions[1]
			end
		end

		return nil
	end

	local fn
	local fn2

	local effect = Signals.createEffect(function(p2)
		local v10 = signal(p2)
		local v11

		if v10.details and v10.details.endDate then
			v11 = v10.details.endDate
		else
			v11 = if v10.timeoutAction and v10.timeoutAction.endTime then v10.timeoutAction.endTime else nil
		end

		if not v11 or v11 == "" then
			return
		end

		local success, result = pcall(function()
			return DateTime.fromIsoDate(v11)
		end)

		if not (success and result) then
			return
		end

		local now = DateTime.now()
		local v12 = result.UnixTimestamp - now.UnixTimestamp

		if fFlagAXTimeoutAcknowledgementGating and v10.requiresAcknowledgement then
			local v13 = result.UnixTimestampMillis - now.UnixTimestampMillis

			if v13 <= 0 then
				return
			end

			local thread = task.delay(v13 / 1000 + 1, function()
				fn2(v10.featureName)
			end)

			return function()
				task.cancel(thread)
			end
		elseif v12 <= 0 then
			fn()
		else
			local thread = task.delay(v12, function()
				fn()
			end)

			return function()
				if thread then
					task.cancel(thread)
				end
			end
		end
	end)

	local function fetchTimeoutDetails(featureVector, complete)
		if flag then
			complete()
			return
		end

		flag = true

		local v10 = string.format(
			"%sv1/not-approved?abuseVector=%s",
			url.USER_MODERATION_URL,
			featureVector
		)

		local fetched, v11 = httpStore.fetch("TimeoutDetails_" .. featureVector, {
			Url = v10,
			Method = "GET"
		})

		if v8 then
			v8()
		end

		local function complete2()
			flag = false
			complete()
		end

		v8 = Signals.createEffect(function(p2)
			local v12 = fetched(p2)

			if v12.status == "Success" then
				local body = v12.response.Body
				local success, result = pcall(function()
					return HttpService:JSONDecode(body)
				end)

				if success and result then
					local v13 = signal(p2)

					local v15 = {
						isTimedOut = v13.isTimedOut,
						featureName = v13.featureName,
						access = v13.access,
						timeoutAction = v13.timeoutAction,
						details = result,
						error = nil,
						requiresAcknowledgement = 0
					}

					local v16 = if fFlagAXTimeoutAcknowledgementGating then v13.requiresAcknowledgement else nil
					v15.requiresAcknowledgement = v16
					v5(v15)
					flag = false
					complete()
				else
					mutedError("Failed to decode timeout details JSON response")
					local v13 = signal(p2)
					local v15 = {
						isTimedOut = v13.isTimedOut,
						featureName = v13.featureName,
						access = v13.access,
						timeoutAction = v13.timeoutAction,
						details = nil,
						error = "Failed to decode timeout details",
						requiresAcknowledgement = 0
					}

					local v16 = if fFlagAXTimeoutAcknowledgementGating then v13.requiresAcknowledgement else nil
					v15.requiresAcknowledgement = v16
					v5(v15)
					flag = false
					complete()
				end
			elseif v12.status == "Failed" then
				mutedError("Failed to fetch timeout details")
				local v13 = signal(p2)
				local v15 = {
					isTimedOut = v13.isTimedOut,
					featureName = v13.featureName,
					access = v13.access,
					timeoutAction = v13.timeoutAction,
					details = nil,
					error = "Failed to fetch timeout details",
					requiresAcknowledgement = 0
				}

				local v16 = if fFlagAXTimeoutAcknowledgementGating then v13.requiresAcknowledgement else nil
				v15.requiresAcknowledgement = v16
				v5(v15)
				flag = false
				complete()
			end
		end)
	end

	local function resolvePendingFetches()
		local v10 = signal(false)

		for k, v11 in v9 do
			v11(v10)
		end

		v9 = {}
	end

	local function doFetchStatus(value, value2, p2, callback)
		if v6 and not (fFlagAXTimeoutAcknowledgementGating and p2) then
			return
		end

		v6 = true

		local v10 = value or "AvatarChange"

		local v11 = string.format(
			"%saccess-management/v1/feature-access?%s",
			url.APIS_URL,
			url:makeQueryString({
				featureNames = v10,
				nameSpace = value2 or "avatar_marketplace/AvatarMarketPlace"
			})
		)

		local v12 = "TimeoutStatus_" .. v10

		if fFlagAXTimeoutAcknowledgementGating and p2 then
			count += 1
			v12 ..= "_" .. tostring(count)

			if v8 then
				v8()
				v8 = nil
			end

			flag = false
		end

		local fetched, v13 = httpStore.fetch(v12, { Url = v11, Method = "GET" })

		if v7 then
			v7()
		end

		local function complete()
			resolvePendingFetches()
		end

		local function settle(p3)
			if callback then
				callback(p3)
			end
		end

		local function keepStatusWithError(p3)
			local v14 = signal(false)
			v5({
				isTimedOut = v14.isTimedOut,
				featureName = v14.featureName or v10,
				access = v14.access,
				timeoutAction = v14.timeoutAction,
				details = v14.details,
				error = p3,
				requiresAcknowledgement = v14.requiresAcknowledgement
			})
		end

		v7 = Signals.createEffect(function(p3)
			local v14 = fetched(p3)

			if v14.status == "Success" then
				local body = v14.response.Body
				local success, result = pcall(function()
					return HttpService:JSONDecode(body)
				end)

				if success and result then
					local v15 = extractTimeoutAction(result, v10)
					local v16 = v15 ~= nil
					local access = nil

					if result.features then
						for k, feature in result.features do
							if feature.featureName == v10 then
								access = feature.access
								break
							end
						end
					end

					local v18 = {
						isTimedOut = v16,
						featureName = v10,
						access = access,
						timeoutAction = v15,
						details = nil,
						error = nil,
						requiresAcknowledgement = 0
					}
					local v19

					if fFlagAXTimeoutAcknowledgementGating then
						if v15 == nil or v15.acknowledgeable ~= true then
							v19 = false
						else
							local acknowledgedTime = v15.acknowledgedTime
							v19 = acknowledgedTime == nil
								or acknowledgedTime == ""
								or string.sub(acknowledgedTime, 1, 5) == "0001-"
						end
					end

					v18.requiresAcknowledgement = v19
					v5(v18)

					v6 = false

					if fFlagAXTimeoutAcknowledgementGating and callback then
						callback(true)
					end

					if v16 and v15 then
						local featureVector = v15.featureVector or "avatar_change"
						fetchTimeoutDetails(featureVector, complete)
					else
						resolvePendingFetches()
					end
				else
					mutedError("Failed to decode timeout status JSON response")

					if fFlagAXTimeoutAcknowledgementGating then
						keepStatusWithError("Failed to decode timeout status")
						v6 = false
						resolvePendingFetches()

						if callback then
							callback(false)
						end
					else
						v5({
							isTimedOut = false,
							featureName = v10,
							access = nil,
							timeoutAction = nil,
							details = nil,
							error = "Failed to decode timeout status"
						})

						v6 = false
						resolvePendingFetches()
					end
				end
			elseif v14.status == "Failed" then
				mutedError("Failed to fetch timeout status")

				if fFlagAXTimeoutAcknowledgementGating then
					keepStatusWithError("Failed to fetch timeout status")
					v6 = false
					resolvePendingFetches()

					if callback then
						callback(false)
					end
				else
					v5({
						isTimedOut = false,
						featureName = v10,
						access = nil,
						timeoutAction = nil,
						details = nil,
						error = "Failed to fetch timeout status"
					})

					v6 = false
					resolvePendingFetches()
				end
			end
		end)
	end

	local function fetchStatusAsync(p2, p3)
		return Promise.new(function(p4)
			table.insert(v9, p4)
			doFetchStatus(p2, p3)
		end)
	end

	fn2 = function(featureName, p2)
		local v10 = 3
		local function attempt()
			doFetchStatus(featureName, p2, true, function(p3)
				if not p3 and v10 > 0 then
					v10 -= 1

					task.defer(attempt)
				end
			end)
		end

		doFetchStatus(featureName, p2, true, function(p3)
			if not p3 and v10 > 0 then
				v10 -= 1

				task.defer(attempt)
			end
		end)
	end

	local computed = createComputed(function(p2)
		return signal(p2).isTimedOut
	end)

	local computed2 = createComputed(function(p2)
		return signal(p2).details
	end)

	local function setStatusAction(p2)
		v5(p2)
	end

	fn = function()
		if v8 then
			v8()
			v8 = nil
		end

		if v7 then
			v7()
			v7 = nil
		end

		flag = false
		v6 = false

		v5({
			isTimedOut = false,
			featureName = nil,
			access = nil,
			timeoutAction = nil,
			details = nil,
			error = nil
		})

		resolvePendingFetches()
	end

	return {
		getStatus = signal,
		getIsTimedOut = computed,
		getTimeoutDetails = computed2,
		fetchStatus = function(p2, p3)
			doFetchStatus(p2, p3)
		end,
		fetchStatusAsync = fetchStatusAsync,
		refreshStatus = fn2,
		setStatus = setStatusAction,
		clearStatus = fn,
		clearStatusIfServed = function(): boolean
			local v10 = signal(false)
			local endDateTime = getEndDateTime(v10)

			if
				not v10.isTimedOut
				or not endDateTime
				or endDateTime.UnixTimestampMillis > DateTime.now().UnixTimestampMillis
			then
				return false
			end

			fn()
			return true
		end,
		effectDispose = effect
	}
end

return createTimeoutStatusStore
