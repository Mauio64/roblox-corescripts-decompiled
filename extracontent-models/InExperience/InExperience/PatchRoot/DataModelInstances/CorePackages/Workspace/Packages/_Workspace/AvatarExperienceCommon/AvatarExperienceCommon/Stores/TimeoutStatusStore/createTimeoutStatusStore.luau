local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Signals = require(Parent.Signals)
local Promise = require(Parent.Promise)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local createHttpStore = require(Parent.InternalHttpStore).createHttpStore
local mutedError = require(Parent.Loggers).mutedError
local Url = require(Parent.Http).Url

local function createTimeoutStatusStore() -- line: 88
	-- upvalues: createSignal (copy), createHttpStore (copy), Signals (copy), Url (copy), HttpService (copy), mutedError (copy), Promise (copy), createComputed (copy)
	local v11, v12 = createSignal({
		isTimedOut = false,
		featureName = nil,
		access = nil,
		timeoutAction = nil,
		details = nil,
		error = nil
	})
	local u13 = false
	local u14 = false
	local v15 = createHttpStore()
	local u16 = nil
	local u17 = nil
	local t1 = {}

	local function extractTimeoutAction(t2: {[any]: any}, s1: string) -- line: 107
		if not t2.features then
			return nil
		end

		for _, v31 in t2.features do
			if s1 ~= v31.featureName or not v31.v2Recourses or not (#v31.v2Recourses > 0) then
				continue
			end

			local v32 = v31.v2Recourses[1]

			if v32 and #v32 > 0 then
				local v33 = v32[1]

				if not v33.timeoutActions or not (#v33.timeoutActions > 0) then
					continue
				end

				return v33.timeoutActions[1]
			end
		end

		return nil
	end

	local u20 = nil
	local v21 = Signals.createEffect(function(p1) -- line: 131
		-- upvalues: v11 (copy), u20 (ref)
		local v35 = v11(p1)
		local v36 = if not v35.details or not v35.details.endDate then if not v35.timeoutAction or not v35.timeoutAction.endTime then nil else v35.timeoutAction.endTime else v35.details.endDate

		if not v36 or v36 == "" then
			return
		end

		local ok, result = pcall(function() -- line: 145
			-- upvalues: v36 (copy)
			return DateTime.fromIsoDate(v36)
		end)

		if not ok or not result then
			return
		end

		local dateTime = DateTime.now()
		local v40 = result.UnixTimestamp - dateTime.UnixTimestamp

		if v40 <= 0 then
			u20()

			return
		end

		local thread = task.delay(v40, function() -- line: 163
			-- upvalues: u20 (ref)
			u20()
		end)

		return function() -- line: 168
			-- upvalues: thread (copy)
			if thread then
				task.cancel(thread)
			end
		end
	end)

	local function fetchTimeoutDetails(s2: string, p2: ((...any) -> ...any)) -- line: 176
		-- upvalues: u14 (ref), Url (copy), v15 (copy), u17 (ref), Signals (copy), HttpService (copy), v11 (copy), v12 (copy), mutedError (copy)
		if u14 then
			p2()

			return
		end

		u14 = true

		local v44 = string.format("%sv1/not-approved?abuseVector=%s", Url.USER_MODERATION_URL, s2)
		local v45, _ = v15.fetch("TimeoutDetails_" .. s2, {
			Method = "GET",
			Url = v44
		})

		if u17 then
			u17()
		end

		local function complete() -- line: 196
			-- upvalues: u14 (ref), p2 (copy)
			u14 = false
			p2()
		end

		u17 = Signals.createEffect(function(p3) -- line: 201
			-- upvalues: v45 (copy), HttpService (copy), v11 (copy), v12 (copy), u14 (ref), p2 (copy), mutedError (copy)
			local v68 = v45(p3)

			if v68.status == "Success" then
				local Body = v68.response.Body
				local ok, result = pcall(function() -- line: 205
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				if ok and result then
					local v72 = v11(p3)

					v12({
						error = nil,
						isTimedOut = v72.isTimedOut,
						featureName = v72.featureName,
						access = v72.access,
						timeoutAction = v72.timeoutAction,
						details = result
					})
					u14 = false
					p2()

					return
				end

				mutedError("Failed to decode timeout details JSON response")

				local v73 = v11(p3)

				v12({
					details = nil,
					error = "Failed to decode timeout details",
					isTimedOut = v73.isTimedOut,
					featureName = v73.featureName,
					access = v73.access,
					timeoutAction = v73.timeoutAction
				})
				u14 = false
				p2()

				return
			end

			if v68.status == "Failed" then
				mutedError("Failed to fetch timeout details")

				local v74 = v11(p3)

				v12({
					details = nil,
					error = "Failed to fetch timeout details",
					isTimedOut = v74.isTimedOut,
					featureName = v74.featureName,
					access = v74.access,
					timeoutAction = v74.timeoutAction
				})
				u14 = false
				p2()
			end
		end)
	end
	local function resolvePendingFetches() -- line: 251
		-- upvalues: v11 (copy), t1 (ref)
		local v48 = v11(false)

		for _, v50 in t1 do
			v50(v48)
		end

		t1 = {}
	end
	local function doFetchStatus(s3: string?, s4: string?) -- line: 259
		-- upvalues: u13 (ref), Url (copy), v15 (copy), u16 (ref), resolvePendingFetches (copy), Signals (copy), HttpService (copy), extractTimeoutAction (copy), v12 (copy), fetchTimeoutDetails (copy), mutedError (copy)
		if u13 then
			return
		end

		u13 = true

		local v53 = s3 or "AvatarChange"
		local v54 = s4 or "avatar_marketplace/AvatarMarketPlace"
		local t3 = {
			featureNames = v53,
			nameSpace = v54
		}
		local v56 = string.format("%saccess-management/v1/feature-access?%s", Url.APIS_URL, Url:makeQueryString(t3))
		local v57, _ = v15.fetch("TimeoutStatus_" .. v53, {
			Method = "GET",
			Url = v56
		})

		if u16 then
			u16()
		end

		local function complete() -- line: 288
			-- upvalues: resolvePendingFetches (copy)
			resolvePendingFetches()
		end

		u16 = Signals.createEffect(function(p4) -- line: 292
			-- upvalues: v57 (copy), HttpService (copy), extractTimeoutAction (copy), v53 (copy), v12 (copy), u13 (ref), fetchTimeoutDetails (copy), complete (copy), resolvePendingFetches (copy), mutedError (copy)
			local v76 = v57(p4)

			if v76.status == "Success" then
				local Body = v76.response.Body
				local ok, result = pcall(function() -- line: 296
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				if ok and result then
					local v80 = extractTimeoutAction(result, v53)
					local v81 = v80 ~= nil
					local access = nil

					if result.features then
						for _, v84 in result.features do
							if v84.featureName == v53 then
								access = v84.access

								break
							end
						end
					end

					v12({
						details = nil,
						error = nil,
						isTimedOut = v81,
						featureName = v53,
						access = access,
						timeoutAction = v80
					})
					u13 = false

					if v81 and v80 then
						local v85 = v80.featureVector or "avatar_change"

						fetchTimeoutDetails(v85, complete)

						return
					end

					resolvePendingFetches()

					return
				end

				mutedError("Failed to decode timeout status JSON response")
				v12({
					isTimedOut = false,
					access = nil,
					timeoutAction = nil,
					details = nil,
					error = "Failed to decode timeout status",
					featureName = v53
				})
				u13 = false
				resolvePendingFetches()

				return
			end

			if v76.status == "Failed" then
				mutedError("Failed to fetch timeout status")
				v12({
					isTimedOut = false,
					access = nil,
					timeoutAction = nil,
					details = nil,
					error = "Failed to fetch timeout status",
					featureName = v53
				})
				u13 = false
				resolvePendingFetches()
			end
		end)
	end

	local v25 = createComputed(function(p5) -- line: 373
		-- upvalues: v11 (copy)
		return v11(p5).isTimedOut
	end)
	local v26 = createComputed(function(p6) -- line: 377
		-- upvalues: v11 (copy)
		return v11(p6).details
	end)

	local function setStatusAction(t4: {[any]: any}) -- line: 382
		-- upvalues: v12 (copy)
		v12(t4)
	end

	function u20() -- line: 388
		-- upvalues: u17 (ref), u16 (ref), u14 (ref), u13 (ref), v12 (copy), resolvePendingFetches (copy)
		if u17 then
			u17()
			u17 = nil
		end

		if u16 then
			u16()
			u16 = nil
		end

		u14 = false
		u13 = false
		v12({
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
		getStatus = v11,
		getIsTimedOut = v25,
		getTimeoutDetails = v26,
		fetchStatus = function(s5: string?, s6: string?) -- line: 361
			-- upvalues: doFetchStatus (copy)
			doFetchStatus(s5, s6)
		end,
		fetchStatusAsync = function(s7: string?, s8: string?) -- line: 365
			-- upvalues: Promise (copy), t1 (ref), doFetchStatus (copy)
			return Promise.new(function(resolve) -- line: 366
				-- upvalues: t1 (ref), doFetchStatus (copy), s7 (copy), s8 (copy)
				table.insert(t1, resolve)
				doFetchStatus(s7, s8)
			end)
		end,
		setStatus = setStatusAction,
		clearStatus = u20,
		effectDispose = v21
	}
end

return createTimeoutStatusStore
