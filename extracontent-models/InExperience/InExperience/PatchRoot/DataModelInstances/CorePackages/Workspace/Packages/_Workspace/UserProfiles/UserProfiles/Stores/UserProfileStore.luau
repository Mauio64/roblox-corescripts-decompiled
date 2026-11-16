local UserProfiles = script:FindFirstAncestor("UserProfiles")
local parent = UserProfiles.Parent
local Lumberyak = require(parent.Lumberyak)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile
local PlatformProfileRequest = require(parent.GraphQLServer.PlatformProfileRequest)
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local defineFastString = game:DefineFastString("UserProfileStoreMaxLoggingLevel", Lumberyak.Logger.Levels.Error)
local defineFastInt = game:DefineFastInt("UserProfileStoreHttpTimeout", 1500)
local FIntUserProfileStoreBatchSize = SharedFlags.FIntUserProfileStoreBatchSize
local defineFastInt2 = game:DefineFastInt("UserProfileStoreQueueProcessDelay", 1)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local UserProfileModel = require(script.Parent.UserProfileModel)
local FFlagUserProfileStoreSplitPlatformFields = require(UserProfiles.Flags.FFlagUserProfileStoreSplitPlatformFields)
local v = FFlagUserProfilePlatformProfile and FFlagUserProfileStoreSplitPlatformFields

local computed = createComputed(function(_)
	local UrlBuilder = require(parent.UrlBuilder)
	local urlBuilder = UrlBuilder.UrlBuilder
	local urlBase = UrlBuilder.UrlBase

	local logger = Lumberyak.Logger.new(nil, "UserProfileStore")
	logger:setContext({ prefix = "[UserProfileStore] " })
	logger:addSink({
		maxLevel = defineFastString,
		log = function(_, _, _) end
	})

	local HttpService = game:GetService("HttpService")
	local url = urlBuilder.new({
		base = urlBase.APIS,
		path = "user-profile-api/v1/user/profiles/get-profiles"
	})()
	local timeout = defineFastInt

	local v2 = {
		USERNAME = "names.username",
		DISPLAY_NAME = "names.displayName",
		COMBINED_NAME = "names.combinedName",
		IN_EXPERIENCE_COMBINED_NAME = "names.inExperienceCombinedName",
		PLATFORM_NAME = "names.platformName",
		CONTACT_NAME = "names.contactName",
		ALIAS = "names.alias",
		PLATFORM_PROFILE_ID = "platformProfileId",
		IS_VERIFIED = FFlagEnableVerifiedBadgeStore and "isVerified" or nil,
		HAS_ROBLOX_SUBSCRIPTION = FFlagEnableBlackbirdCheck and "hasRobloxSubscription" or nil
	}

	local v3 = {}
	local v4 = {}
	local v5 = {}
	local v6 = false

	local function getOrCreateByUserId(p: string)
		local v7 = v3[p]

		if v7 ~= nil then
			logger:trace("Found profile: {}", p)
			return v7
		end

		logger:trace("Creating profile: {}", p)
		local v8 = UserProfileModel.create(p)
		v3[p] = v8
		return v8
	end

	local v7 = { v2.PLATFORM_NAME, v2.PLATFORM_PROFILE_ID }
	local clone = table.clone(v7)
	table.sort(clone)
	local joined = table.concat(clone, ",")
	local function performBatchFetch(userIds, value: string, clone2, flag: boolean)
		if #userIds == 0 then
			logger:trace("No more ids to fetch. Setting result.")

			for _, item in ipairs(clone2) do
				local v8 = v4[value]
				local v9 = {}

				for _, userId in item.userIds do
					local v10 = v8[userId]

					if v10 then
						logger:trace("Found cached profile: {}", userId)
						table.insert(v9, v10)
					else
						logger:debug("Expected cached profile: {}", userId)
					end
				end

				local v10 = {
					status = flag and "success" or "failed",
					data = v9
				}

				item.setResult(v10)
				local callback = item.callback

				if callback ~= nil then
					callback(v10)
				end
			end
		else
			local v8 = {}
			local userIds2

			if FIntUserProfileStoreBatchSize < #userIds then
				userIds2 = {}

				for i = 1, FIntUserProfileStoreBatchSize do
					table.insert(userIds2, userIds[i])
				end

				for i = FIntUserProfileStoreBatchSize + 1, #userIds do
					table.insert(v8, userIds[i])
				end
			else
				userIds2 = userIds
			end

			local fields = string.split(value, ",")

			local jsonEncode = HttpService:JSONEncode({
				userIds = userIds2,
				fields = fields,
				includePlatformProfile = FFlagUserProfilePlatformProfile and PlatformProfileRequest.hasPlatformFields(fields) and true or nil
			})

			logger:debug("Fetching: {}", jsonEncode)

			HttpService:RequestInternal({
				Url = url,
				Method = "POST",
				Body = jsonEncode,
				Timeout = timeout,
				CachePolicy = Enum.HttpCachePolicy.None,
				Priority = 0,
				Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
				RequestType = Enum.HttpRequestType.Default
			}):Start(function(p, p2)
				if p == true then
					local body = p2.Body

					if body ~= nil then
						local _, result = pcall(function()
							return HttpService:JSONDecode(body)
						end)

						if result ~= nil then
							logger:trace("Fetched: {}\nresponse: {}", jsonEncode, body)
							local profileDetails = result.profileDetails

							if profileDetails ~= nil then
								if FFlagUserProfilePlatformProfile then
									profileDetails = PlatformProfileRequest.normalizeProfiles(profileDetails, fields)
								end

								local v9 = v4[value]

								for _, profileDetail in ipairs(profileDetails) do
									local userId = tostring(profileDetail.userId)
									local v10 = v3[userId]

									if v10 == nil then
										logger:trace("Creating profile: {}", userId)
										v10 = UserProfileModel.create(userId)
										v3[userId] = v10
									else
										logger:trace("Found profile: {}", userId)
									end

									if profileDetail then
										logger:trace("Updating profile: {}", userId)
										UserProfileModel.update(v10, profileDetail)
									end

									v9[userId] = v10
								end

								if v and value == joined then
									for _, userId in userIds2 do
										if v9[userId] ~= nil then
											continue
										end

										local v10 = v3[userId]

										if v10 == nil then
											logger:trace("Creating profile: {}", userId)
											v10 = UserProfileModel.create(userId)
											v3[userId] = v10
										else
											logger:trace("Found profile: {}", userId)
										end

										UserProfileModel.update(v10, PlatformProfileRequest.normalizeProfiles({
											{ userId = userId }
										}, fields)[1])

										v9[userId] = v10
									end
								end
							end
						end
					end
				else
					logger:error("Error fetching")
				end

				performBatchFetch(v8, value, clone2, p ~= false and flag)
			end)
		end
	end

	local function processQueuedRequests()
		for k, list in pairs(v5) do
			logger:trace("Processing requests ({}) for fields: {}", #list, k)

			local v8 = v4[k]
			local userIdsByUserId = {}
			local userIds = {}

			for _, item in ipairs(list) do
				for _, userId in ipairs(item.userIds) do
					if userIdsByUserId[userId] ~= nil then
						continue
					end

					userIdsByUserId[userId] = userId

					if v8[userId] == nil then
						table.insert(userIds, userId)
					end
				end
			end

			performBatchFetch(userIds, k, table.clone(list), true)
		end

		v5 = {}
	end

	local function fetchByUserIds(userIds, list, callback)
		table.sort(list)
		local joined2 = table.concat(list, ",")

		local v8 = v4[joined2]

		if v8 == nil then
			v8 = {}
			v4[joined2] = v8
		end

		local v9 = false
		local v10 = {}

		for _, item in userIds do
			local v11 = v8[item]
			v9 = v11 == nil and v9 == false or v9

			if not v11 then
				v11 = v3[item]

				if v11 == nil then
					logger:trace("Creating profile: {}", item)
					v11 = UserProfileModel.create(item)
					v3[item] = v11
				else
					logger:trace("Found profile: {}", item)
				end
			end

			table.insert(v10, v11)
		end

		if v9 == false then
			logger:trace("All requested profiles are cached. Calling back early")

			local v11 = { status = "success", data = v10 }

			local signal = createSignal(v11)

			if callback ~= nil then
				callback(v11)
			end

			return signal
		else
			local v11 = { status = "fetching", data = v10 }

			local signal, setResult = createSignal(v11)

			local v12 = v5[joined2]

			if v12 == nil then
				v12 = {}
				v5[joined2] = v12
			end

			table.insert(v12, {
				userIds = userIds,
				getResult = signal,
				setResult = setResult,
				callback = callback
			})

			if not v6 then
				v6 = true

				if FFlagEnableBlackbirdCheck then
					task.defer(function()
						processQueuedRequests()
						v6 = false
					end)
				else
					task.delay(defineFastInt2, function()
						processQueuedRequests()
						v6 = false
					end)
				end
			end

			if callback ~= nil then
				callback(v11)
			end

			return signal
		end
	end

	local function getNameFields(flag: boolean?)
		local nameFields = {
			v2.COMBINED_NAME,
			v2.DISPLAY_NAME,
			v2.USERNAME,
			v2.IN_EXPERIENCE_COMBINED_NAME,
			v2.CONTACT_NAME,
			v2.ALIAS
		}

		if not FFlagUserProfilePlatformProfile or flag and not v then
			table.insert(nameFields, v2.PLATFORM_NAME)
			table.insert(nameFields, v2.PLATFORM_PROFILE_ID)
		end

		if FFlagEnableVerifiedBadgeStore then
			table.insert(nameFields, v2.IS_VERIFIED)
		end

		if FFlagEnableBlackbirdCheck then
			table.insert(nameFields, v2.HAS_ROBLOX_SUBSCRIPTION)
		end

		return nameFields
	end

	local function getPlatformFields() -- 2 equivalent calls inferred from this helper
		return table.clone(v7)
	end

	local function combineFetchResults(p, p2) -- 4 equivalent calls inferred from this helper
		return {
			status = (p.status == "fetching" or p2.status == "fetching") and "fetching" or (p.status == "failed" or p2.status == "failed") and "failed" or "success",
			data = p.data
		}
	end

	local function fetchNamesAndPlatformFieldsByUserIds(userIds, callback)
		local v8 = nil
		local v9 = nil
		local status = nil
		local function report()
			if callback == nil or v8 == nil or v9 == nil then
				return
			end

			local v10 = combineFetchResults(v8, v9) -- inferred equivalent call

			if v10.status ~= status then
				status = v10.status
				callback(v10)
			end
		end

		local v10 = fetchByUserIds(userIds, getNameFields(false), function(p)
			v8 = p

			if callback ~= nil and v8 ~= nil then
				if v9 == nil then
					return
				end

				local v10 = combineFetchResults(v8, v9) -- inferred equivalent call

				if v10.status ~= status then
					status = v10.status
					callback(v10)
				end
			end
		end)
		local v11 = fetchByUserIds(userIds, getPlatformFields(), function(p) -- inferred equivalent call
			v9 = p

			if callback ~= nil and v8 ~= nil then
				if v9 == nil then
					return
				end

				local v11 = combineFetchResults(v8, v9) -- inferred equivalent call

				if v11.status ~= status then
					status = v11.status
					callback(v11)
				end
			end
		end)

		return createComputed(function(p)
			return combineFetchResults(v10(p), v11(p)) -- inferred equivalent call
		end)
	end

	local function invalidateCachedProfiles(list, items)
		table.sort(list)
		local v8 = v4[table.concat(list, ",")]

		if not (v8 ~= nil and items ~= nil) then
			return
		end

		for _, item in items do
			v8[item] = nil
		end
	end

	return {
		fetchNamesByUserIds = function(userIds, callback, flag: boolean?)
			if v and flag then
				return fetchNamesAndPlatformFieldsByUserIds(userIds, callback)
			end

			return fetchByUserIds(userIds, getNameFields(flag), callback)
		end,
		updateFromHydration = function(items)
			for userId, item in items do
				if item.userId ~= nil then
					userId = tostring(item.userId)
				end

				local v8 = v3[userId]

				if v8 == nil then
					logger:trace("Creating profile: {}", userId)
					v8 = UserProfileModel.create(userId)
					v3[userId] = v8
				else
					logger:trace("Found profile: {}", userId)
				end

				UserProfileModel.update(v8, {
					names = { username = item.username, displayName = item.displayName },
					isVerified = item.isVerified
				})
			end
		end,
		getProfileByUserId = function(p: string)
			return v3[p]
		end,
		invalidateCachedNamesForUserIds = function(p)
			if v then
				invalidateCachedProfiles(getNameFields(false), p)
				invalidateCachedProfiles(getPlatformFields(), p) -- inferred equivalent call
			else
				if not FFlagUserProfilePlatformProfile then
					invalidateCachedProfiles(
						{
							v2.COMBINED_NAME,
							v2.DISPLAY_NAME,
							v2.USERNAME,
							v2.IN_EXPERIENCE_COMBINED_NAME,
							v2.CONTACT_NAME,
							v2.ALIAS,
							v2.PLATFORM_NAME,
							v2.PLATFORM_PROFILE_ID
						},
						p
					)
					return
				end

				invalidateCachedProfiles(getNameFields(false), p)
				invalidateCachedProfiles(getNameFields(true), p)
			end
		end
	}
end)

return {
	get = function()
		return computed(false)
	end
}
