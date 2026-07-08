local Parent = script:FindFirstAncestor("UserProfiles").Parent
local Lumberyak = require(Parent.Lumberyak)
local SharedFlags = require(Parent.SharedFlags)
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local v7 = game:DefineFastString("UserProfileStoreMaxLoggingLevel", Lumberyak.Logger.Levels.Error)
local v8 = game:DefineFastInt("UserProfileStoreHttpTimeout", 1500)
local v9 = game:DefineFastInt("UserProfileStoreBatchSize", 50)
local v10 = game:DefineFastInt("UserProfileStoreQueueProcessDelay", 1)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local UserProfileModel = require(script.Parent.UserProfileModel)
local v15 = createComputed(function(_) -- line: 36
	-- upvalues: Parent (copy), Lumberyak (copy), v7 (copy), v8 (copy), FFlagEnableVerifiedBadgeStore (copy), FFlagEnableBlackbirdCheck (copy), UserProfileModel (copy), v9 (copy), createSignal (copy), v10 (copy), FFlagSduiExperienceDetailsSupport (copy)
	local UrlBuilder = require(Parent.UrlBuilder)
	local UrlBuilder2 = UrlBuilder.UrlBuilder
	local UrlBase = UrlBuilder.UrlBase
	local v20 = Lumberyak.Logger.new(nil, "UserProfileStore")

	v20:setContext({
		prefix = "[UserProfileStore] "
	})
	v20:addSink({
		maxLevel = v7,
		log = function(_, _, _) -- line: 54
		end
	})

	local HttpService = game:GetService("HttpService")
	local v22 = UrlBuilder2.new({
		path = "user-profile-api/v1/user/profiles/get-profiles",
		base = UrlBase.APIS
	})()
	local v23 = v8
	local t1 = {
		USERNAME = "names.username",
		DISPLAY_NAME = "names.displayName",
		COMBINED_NAME = "names.combinedName",
		IN_EXPERIENCE_COMBINED_NAME = "names.inExperienceCombinedName",
		PLATFORM_NAME = "names.platformName",
		CONTACT_NAME = "names.contactName",
		ALIAS = "names.alias",
		PLATFORM_PROFILE_ID = "platformProfileId",
		IS_VERIFIED = if not FFlagEnableVerifiedBadgeStore then nil else "isVerified",
		HAS_ROBLOX_SUBSCRIPTION = if not FFlagEnableBlackbirdCheck then nil else "hasRobloxSubscription"
	}
	local t2 = {}
	local t3 = {}
	local t4 = {}
	local u28 = false

	local function getOrCreateByUserId(s1: string) -- line: 85
		-- upvalues: t2 (copy), v20 (copy), UserProfileModel (copy)
		local v40 = t2[s1]

		if v40 ~= nil then
			v20:trace("Found profile: {}", s1)

			return v40
		end

		v20:trace("Creating profile: {}", s1)

		local v41 = UserProfileModel.create(s1)

		t2[s1] = v41

		return v41
	end
	local function performBatchFetch(t5: {[any]: any}, s2: string, t6: {[any]: any}, b1: boolean) -- line: 98
		-- upvalues: v20 (copy), t3 (copy), v9 (copy), HttpService (copy), v22 (copy), v23 (copy), t2 (copy), UserProfileModel (copy), performBatchFetch (copy)
		if #t5 == 0 then
			v20:trace("No more ids to fetch. Setting result.")

			for _, v in ipairs(t6) do
				local t7 = {}
				local v49 = t3[s2]

				for _, v51 in v.userIds do
					local v52 = v49[v51]

					if v52 then
						v20:trace("Found cached profile: {}", v51)
						table.insert(t7, v52)
					else
						v20:debug("Expected cached profile: {}", v51)
					end
				end

				local t8 = {
					status = not b1 and "failed" or "success",
					data = t7
				}

				v.setResult(t8)

				local callback = v.callback

				if callback ~= nil then
					callback(t8)
				end
			end

			return
		end

		local t9 = {}
		local t10

		if #t5 > v9 then
			t10 = {}

			for i = 1, v9 do
				table.insert(t10, t5[i])
			end

			for i = v9 + 1, #t5 do
				table.insert(t9, t5[i])
			end
		else
			t10 = t5
		end

		local parts = string.split(s2, ",")
		local json = HttpService:JSONEncode({
			userIds = t10,
			fields = parts
		})

		v20:debug("Fetching: {}", json)

		local v61 = v22

		HttpService:RequestInternal({
			Method = "POST",
			Priority = 0,
			Url = v61,
			Body = json,
			Timeout = v23,
			CachePolicy = Enum.HttpCachePolicy.None,
			Headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			},
			RequestType = Enum.HttpRequestType.Default
		}):Start(function(p5, p6) -- line: 168
			-- upvalues: HttpService (copy), v20 (copy), json (copy), t3 (copy), s2 (copy), t2 (copy), UserProfileModel (copy), performBatchFetch (copy), t9 (copy), t6 (copy), b1 (copy)
			if p5 == true then
				local Body = p6.Body

				if Body ~= nil then
					local _, result = pcall(function() -- line: 172
						-- upvalues: HttpService (copy), Body (copy)
						return HttpService:JSONDecode(Body)
					end)

					if result ~= nil then
						v20:trace("Fetched: {}\nresponse: {}", json, Body)

						local profileDetails = result.profileDetails

						if profileDetails ~= nil then
							local v109 = t3[s2]

							for _, v in ipairs(profileDetails) do
								local str = tostring(v.userId)
								local v113 = t2[str]

								if v113 ~= nil then
									v20:trace("Found profile: {}", str)
								else
									v20:trace("Creating profile: {}", str)
									v113 = UserProfileModel.create(str)
									t2[str] = v113
								end

								if v then
									v20:trace("Updating profile: {}", str)
									UserProfileModel.update(v113, v)
								end

								v109[str] = v113
							end
						end
					end
				end
			else
				v20:error("Error fetching")
			end

			performBatchFetch(t9, s2, t6, p5 ~= false and b1)
		end)
	end
	local function processQueuedRequests() -- line: 200
		-- upvalues: t4 (ref), v20 (copy), t3 (copy), performBatchFetch (copy)
		for k, v in pairs(t4) do
			v20:trace("Processing requests ({}) for fields: {}", #v, k)

			local t11 = {}
			local t12 = {}
			local v66 = t3[k]

			for _, v2 in ipairs(v) do
				for _, v3 in ipairs(v2.userIds) do
					if t11[v3] == nil then
						t11[v3] = v3

						if v66[v3] == nil then
							table.insert(t12, v3)
						end
					end
				end
			end

			performBatchFetch(t12, k, table.clone(v), true)
		end

		t4 = {}
	end
	local function fetchByUserIds(t13: {[any]: any}, t14: {[any]: any}, p7: ((...any) -> ...any)?) -- line: 222
		-- upvalues: t3 (copy), t2 (copy), v20 (copy), UserProfileModel (copy), createSignal (copy), t4 (ref), u28 (ref), FFlagEnableBlackbirdCheck (copy), processQueuedRequests (copy), v10 (copy)
		table.sort(t14)

		local v74 = table.concat(t14, ",")
		local v75 = t3[v74]

		if v75 == nil then
			v75 = {}
			t3[v74] = v75
		end

		local t15 = {}
		local v77 = false

		for _, v79 in t13 do
			local v80 = v75[v79]

			if v80 == nil and v77 == false then
				v77 = true
			end

			if not v80 then
				v80 = t2[v79]

				if v80 ~= nil then
					v20:trace("Found profile: {}", v79)
				else
					v20:trace("Creating profile: {}", v79)
					v80 = UserProfileModel.create(v79)
					t2[v79] = v80
				end
			end

			table.insert(t15, v80)
		end

		if v77 == false then
			v20:trace("All requested profiles are cached. Calling back early")

			local t16 = {
				status = "success",
				data = t15
			}
			local v82 = createSignal(t16)

			if p7 ~= nil then
				p7(t16)
			end

			return v82
		end

		local t17 = {
			status = "fetching",
			data = t15
		}
		local v84, v85 = createSignal(t17)
		local v86 = t4[v74]

		if v86 == nil then
			v86 = {}
			t4[v74] = v86
		end

		table.insert(v86, {
			userIds = t13,
			getResult = v84,
			setResult = v85,
			callback = p7
		})

		if not u28 then
			u28 = true

			if FFlagEnableBlackbirdCheck then
				task.defer(function() -- line: 285
					-- upvalues: processQueuedRequests (copy), u28 (ref)
					processQueuedRequests()
					u28 = false
				end)
			else
				task.delay(v10, function() -- line: 290
					-- upvalues: processQueuedRequests (copy), u28 (ref)
					processQueuedRequests()
					u28 = false
				end)
			end
		end

		if p7 ~= nil then
			p7(t17)
		end

		return v84
	end
	local function updateFromHydration(t18: {[any]: any}) -- line: 328
		-- upvalues: t2 (copy), v20 (copy), UserProfileModel (copy)
		for v91, v92 in t18 do
			local v93 = if v92.userId == nil then v91 else tostring(v92.userId)
			local v94 = t2[v93]

			if v94 ~= nil then
				v20:trace("Found profile: {}", v93)
			else
				v20:trace("Creating profile: {}", v93)
				v94 = UserProfileModel.create(v93)
				t2[v93] = v94
			end

			UserProfileModel.update(v94, {
				names = {
					username = v92.username,
					displayName = v92.displayName
				},
				isVerified = v92.isVerified
			})
		end
	end
	local function invalidateCachedProfiles(t19: {[any]: any}, t20: {[any]: any}?) -- line: 342
		-- upvalues: t3 (copy)
		table.sort(t19)

		local v97 = t3[table.concat(t19, ",")]

		if v97 == nil then
			return
		end

		if t20 ~= nil then
			for _, v99 in t20 do
				v97[v99] = nil
			end

			return
		end
	end
	local function getProfileByUserId(s3: string) -- line: 374
		-- upvalues: t2 (copy)
		return t2[s3]
	end

	return {
		fetchNamesByUserIds = function(t21: {[any]: any}, p8: ((...any) -> ...any)?) -- line: 302
			-- upvalues: t1 (copy), FFlagEnableVerifiedBadgeStore (copy), FFlagEnableBlackbirdCheck (copy), fetchByUserIds (copy)
			local t22 = {
				t1.COMBINED_NAME,
				t1.DISPLAY_NAME,
				t1.USERNAME,
				t1.IN_EXPERIENCE_COMBINED_NAME,
				t1.CONTACT_NAME,
				t1.ALIAS,
				t1.PLATFORM_NAME,
				t1.PLATFORM_PROFILE_ID
			}

			if FFlagEnableVerifiedBadgeStore then
				table.insert(t22, t1.IS_VERIFIED)
			end

			if FFlagEnableBlackbirdCheck then
				table.insert(t22, t1.HAS_ROBLOX_SUBSCRIPTION)
			end

			return (fetchByUserIds(t21, t22, p8))
		end,
		updateFromHydration = if not FFlagSduiExperienceDetailsSupport then nil else updateFromHydration,
		getProfileByUserId = if not FFlagSduiExperienceDetailsSupport then nil else getProfileByUserId,
		invalidateCachedNamesForUserIds = function(t23: {[any]: any}) -- line: 360
			-- upvalues: t1 (copy), invalidateCachedProfiles (copy)
			local t24 = {
				t1.COMBINED_NAME,
				t1.DISPLAY_NAME,
				t1.USERNAME,
				t1.IN_EXPERIENCE_COMBINED_NAME,
				t1.CONTACT_NAME,
				t1.ALIAS,
				t1.PLATFORM_NAME,
				t1.PLATFORM_PROFILE_ID
			}

			invalidateCachedProfiles(t24, t23)
		end
	}
end)

return {
	get = function() -- line: 387
		-- upvalues: v15 (copy)
		return v15(false)
	end
}
