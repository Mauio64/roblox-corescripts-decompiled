local HttpService = game:GetService("HttpService")

local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local Signals = require(parent.Signals)
local Promise = require(parent.Promise)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local InternalHttpStore = require(parent.InternalHttpStore)
local createHttpStore = InternalHttpStore.createHttpStore

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local Http = require(parent.Http)
local Url = Http.Url

local getTimeoutEndTime = require(AvatarExperienceCommon.Utils.getTimeoutEndTime)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXTimeoutAcknowledgementGating = AvatarExperienceFlags.FFlagAXTimeoutAcknowledgementGating

local function isAcknowledged(acknowledgedTime: string?): boolean -- 1 equivalent call inferred from this helper
	return acknowledgedTime ~= nil and acknowledgedTime ~= "" and string.sub(acknowledgedTime, 1, 5) ~= "0001-"
end

local function getRequiresAcknowledgement(p) -- 1 equivalent call inferred from this helper
	local requiresAcknowledgement

	if p == nil or p.acknowledgeable ~= true then
		requiresAcknowledgement = false
	else
		requiresAcknowledgement = not isAcknowledged(p.acknowledgedTime) -- inferred equivalent call
	end

	return requiresAcknowledgement
end

local function getEndDateTime(p)
	local endDate

	if p.details then
		endDate = p.details.endDate
	end

	local v

	if p.timeoutAction then
		v = p.timeoutAction.endTime
	end

	local timeoutEndTime = getTimeoutEndTime(endDate, v)

	if not timeoutEndTime then
		return nil
	end

	local success, result = pcall(function()
		return DateTime.fromIsoDate(timeoutEndTime)
	end)
	return if success then result else nil
end

local function createTimeoutStatusStore()
	local signal, v = createSignal({
		isTimedOut = false,
		featureName = nil,
		access = nil,
		timeoutAction = nil,
		details = nil,
		error = nil
	})

	local v2 = false
	local flag = false
	local httpStore = createHttpStore()
	local v3 = nil
	local v4 = nil

	local v5 = {}
	local count = 0

	local function extractTimeoutAction(result, p: string)
		if not result.features then
			return nil
		end

		for _, feature in result.features do
			if not (feature.featureName == p and feature.v2Recourses and #feature.v2Recourses > 0) then
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

	local effect = Signals.createEffect(function(p)
		local v6 = signal(p)
		local v7

		if v6.details and v6.details.endDate then
			v7 = v6.details.endDate
		elseif v6.timeoutAction and v6.timeoutAction.endTime then
			v7 = v6.timeoutAction.endTime
		else
			v7 = nil
		end

		if not v7 or v7 == "" then
			return
		end

		local success, result = pcall(function()
			return DateTime.fromIsoDate(v7)
		end)

		if not (success and result) then
			return
		end

		local now = DateTime.now()
		local v8 = result.UnixTimestamp - now.UnixTimestamp

		if FFlagAXTimeoutAcknowledgementGating and v6.requiresAcknowledgement then
			local v9 = result.UnixTimestampMillis - now.UnixTimestampMillis

			if v9 <= 0 then
				return
			end

			local thread = task.delay(v9 / 1000 + 1, function()
				fn2(v6.featureName)
			end)

			return function()
				task.cancel(thread)
			end
		elseif v8 <= 0 then
			fn()
		else
			local thread = task.delay(v8, function()
				fn()
			end)

			return function()
				if thread then
					task.cancel(thread)
				end
			end
		end
	end)

	local function fetchTimeoutDetails(featureVector: string, complete)
		if flag then
			complete()
			return
		end

		flag = true

		local url = string.format("%sv1/not-approved?abuseVector=%s", Url.USER_MODERATION_URL, featureVector)

		local fetched, _ = httpStore.fetch("TimeoutDetails_" .. featureVector, {
			Url = url,
			Method = "GET"
		})

		if v4 then
			v4()
		end

		local function complete2() -- 3 equivalent calls inferred from this helper
			flag = false
			complete()
		end

		v4 = Signals.createEffect(function(p)
			local v6 = fetched(p)

			if v6.status == "Success" then
				local body = v6.response.Body
				local success, result = pcall(function()
					return HttpService:JSONDecode(body)
				end)

				if success and result then
					local v7 = signal(p)

					local v8 = {
						isTimedOut = v7.isTimedOut,
						featureName = v7.featureName,
						access = v7.access,
						timeoutAction = v7.timeoutAction,
						details = result,
						error = nil,
						requiresAcknowledgement = 0
					}
					local requiresAcknowledgement

					if FFlagAXTimeoutAcknowledgementGating then
						requiresAcknowledgement = v7.requiresAcknowledgement
					end

					v8.requiresAcknowledgement = requiresAcknowledgement
					v(v8)
					complete2() -- inferred equivalent call
				else
					mutedError("Failed to decode timeout details JSON response")
					local v7 = signal(p)
					local v8 = {
						isTimedOut = v7.isTimedOut,
						featureName = v7.featureName,
						access = v7.access,
						timeoutAction = v7.timeoutAction,
						details = nil,
						error = "Failed to decode timeout details",
						requiresAcknowledgement = 0
					}
					local requiresAcknowledgement

					if FFlagAXTimeoutAcknowledgementGating then
						requiresAcknowledgement = v7.requiresAcknowledgement
					end

					v8.requiresAcknowledgement = requiresAcknowledgement
					v(v8)
					complete2() -- inferred equivalent call
				end
			elseif v6.status == "Failed" then
				mutedError("Failed to fetch timeout details")
				local v7 = signal(p)
				local v8 = {
					isTimedOut = v7.isTimedOut,
					featureName = v7.featureName,
					access = v7.access,
					timeoutAction = v7.timeoutAction,
					details = nil,
					error = "Failed to fetch timeout details",
					requiresAcknowledgement = 0
				}
				local requiresAcknowledgement

				if FFlagAXTimeoutAcknowledgementGating then
					requiresAcknowledgement = v7.requiresAcknowledgement
				end

				v8.requiresAcknowledgement = requiresAcknowledgement
				v(v8)
				complete2() -- inferred equivalent call
			end
		end)
	end

	local function resolvePendingFetches()
		local v6 = signal(false)

		for _, v7 in v5 do
			v7(v6)
		end

		v5 = {}
	end

	local function doFetchStatus(value: string?, value2: string?, flag2: boolean?, callback)
		if v2 and not (FFlagAXTimeoutAcknowledgementGating and flag2) then
			return
		end

		v2 = true

		local v6 = value or "AvatarChange"

		local url = string.format("%saccess-management/v1/feature-access?%s", Url.APIS_URL, Url:makeQueryString({
			featureNames = v6,
			nameSpace = value2 or "avatar_marketplace/AvatarMarketPlace"
		}))

		local v7 = "TimeoutStatus_" .. v6

		if FFlagAXTimeoutAcknowledgementGating and flag2 then
			count += 1
			v7 ..= "_" .. tostring(count)

			if v4 then
				v4()
				v4 = nil
			end

			flag = false
		end

		local fetched, _ = httpStore.fetch(v7, { Url = url, Method = "GET" })

		if v3 then
			v3()
		end

		local function complete() -- 5 equivalent calls inferred from this helper
			resolvePendingFetches()
		end

		local function settle(flag3: boolean) -- 3 equivalent calls inferred from this helper
			if callback then
				callback(flag3)
			end
		end

		local function keepStatusWithError(err: string)
			local v8 = signal(false)
			v({
				isTimedOut = v8.isTimedOut,
				featureName = v8.featureName or v6,
				access = v8.access,
				timeoutAction = v8.timeoutAction,
				details = v8.details,
				error = err,
				requiresAcknowledgement = v8.requiresAcknowledgement
			})
		end

		v3 = Signals.createEffect(function(p)
			local v8 = fetched(p)

			if v8.status == "Success" then
				local body = v8.response.Body
				local success, result = pcall(function()
					return HttpService:JSONDecode(body)
				end)

				if success and result then
					local timeoutAction = extractTimeoutAction(result, v6)
					local isTimedOut = timeoutAction ~= nil
					local access = nil

					if result.features then
						for _, feature in result.features do
							if feature.featureName == v6 then
								access = feature.access
								break
							end
						end
					end

					local v9 = {
						isTimedOut = isTimedOut,
						featureName = v6,
						access = access,
						timeoutAction = timeoutAction,
						details = nil,
						error = nil,
						requiresAcknowledgement = 0
					}
					local requiresAcknowledgement

					if FFlagAXTimeoutAcknowledgementGating then
						requiresAcknowledgement = getRequiresAcknowledgement(timeoutAction) -- inferred equivalent call
					end

					v9.requiresAcknowledgement = requiresAcknowledgement
					v(v9)

					v2 = false

					if FFlagAXTimeoutAcknowledgementGating then
						settle(true) -- inferred equivalent call
					end

					if isTimedOut and timeoutAction then
						local featureVector = timeoutAction.featureVector or "avatar_change"
						fetchTimeoutDetails(featureVector, complete)
					else
						complete() -- inferred equivalent call
					end
				else
					mutedError("Failed to decode timeout status JSON response")

					if FFlagAXTimeoutAcknowledgementGating then
						keepStatusWithError("Failed to decode timeout status")
						v2 = false
						complete() -- inferred equivalent call
						settle(false) -- inferred equivalent call
					else
						v({
							isTimedOut = false,
							featureName = v6,
							access = nil,
							timeoutAction = nil,
							details = nil,
							error = "Failed to decode timeout status"
						})

						v2 = false
						complete() -- inferred equivalent call
					end
				end
			elseif v8.status == "Failed" then
				mutedError("Failed to fetch timeout status")

				if FFlagAXTimeoutAcknowledgementGating then
					keepStatusWithError("Failed to fetch timeout status")
					v2 = false
					complete() -- inferred equivalent call
					settle(false) -- inferred equivalent call
				else
					v({
						isTimedOut = false,
						featureName = v6,
						access = nil,
						timeoutAction = nil,
						details = nil,
						error = "Failed to fetch timeout status"
					})

					v2 = false
					complete() -- inferred equivalent call
				end
			end
		end)
	end

	local function fetchStatusAsync(p: string?, p2: string?)
		return Promise.new(function(p3)
			table.insert(v5, p3)
			doFetchStatus(p, p2)
		end)
	end

	fn2 = function(featureName: string?, p: string?)
		local v6 = 3
		local function attempt()
			doFetchStatus(featureName, p, true, function(p2)
				if not p2 and v6 > 0 then
					v6 -= 1

					task.defer(attempt)
				end
			end)
		end

		doFetchStatus(featureName, p, true, function(p2)
			if not p2 and v6 > 0 then
				v6 -= 1

				task.defer(attempt)
			end
		end)
	end

	local getIsTimedOut = createComputed(function(p)
		return signal(p).isTimedOut
	end)

	local getTimeoutDetails = createComputed(function(p)
		return signal(p).details
	end)

	local function setStatusAction(p)
		v(p)
	end

	fn = function()
		if v4 then
			v4()
			v4 = nil
		end

		if v3 then
			v3()
			v3 = nil
		end

		flag = false
		v2 = false

		v({
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
		getIsTimedOut = getIsTimedOut,
		getTimeoutDetails = getTimeoutDetails,
		fetchStatus = function(p: string?, p2: string?)
			doFetchStatus(p, p2)
		end,
		fetchStatusAsync = fetchStatusAsync,
		refreshStatus = fn2,
		setStatus = setStatusAction,
		clearStatus = fn,
		clearStatusIfServed = function(): boolean
			local v6 = signal(false)
			local endDateTime = getEndDateTime(v6)

			if
				not v6.isTimedOut
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
