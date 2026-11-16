local Lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/Lumberyak")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/SharedFlags")
local fFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile
local PlatformProfileRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/GraphQLServer/PlatformProfileRequest")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/Signals")
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local defineFastString = game:DefineFastString(
	"UserProfileStoreMaxLoggingLevel",
	Lumberyak.Logger.Levels.Error
)
local defineFastInt = game:DefineFastInt("UserProfileStoreHttpTimeout", 1500)
local fIntUserProfileStoreBatchSize = SharedFlags.FIntUserProfileStoreBatchSize
local defineFastInt2 = game:DefineFastInt("UserProfileStoreQueueProcessDelay", 1)
local fFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local UserProfileModel = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Stores/UserProfileModel")
local FFlagUserProfileStoreSplitPlatformFields = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Flags/FFlagUserProfileStoreSplitPlatformFields")
local v5 = fFlagUserProfilePlatformProfile and FFlagUserProfileStoreSplitPlatformFields

local computed = createComputed(function(p2)
	local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UrlBuilder")
	local urlBuilder = UrlBuilder.UrlBuilder
	local urlBase = UrlBuilder.UrlBase

	local logger = Lumberyak.Logger.new(nil, "UserProfileStore")
	logger:setContext({ prefix = "[UserProfileStore] " })
	logger:addSink({
		maxLevel = defineFastString,
		log = function(p3, p4, p5) end
	})

	local HttpService = game:GetService("HttpService")
	local v6 = urlBuilder.new({
		base = urlBase.APIS,
		path = "user-profile-api/v1/user/profiles/get-profiles"
	})()
	local v7 = defineFastInt

	local v8 = {
		USERNAME = "names.username",
		DISPLAY_NAME = "names.displayName",
		COMBINED_NAME = "names.combinedName",
		IN_EXPERIENCE_COMBINED_NAME = "names.inExperienceCombinedName",
		PLATFORM_NAME = "names.platformName",
		CONTACT_NAME = "names.contactName",
		ALIAS = "names.alias",
		PLATFORM_PROFILE_ID = "platformProfileId",
		IS_VERIFIED = fFlagEnableVerifiedBadgeStore and "isVerified" or nil,
		HAS_ROBLOX_SUBSCRIPTION = fFlagEnableBlackbirdCheck and "hasRobloxSubscription" or nil
	}

	local v9 = {}
	local v10 = {}
	local v11 = {}
	local v12 = false

	local function getOrCreateByUserId(p3)
		local v13 = v9[p3]

		if v13 ~= nil then
			logger:trace("Found profile: {}", p3)
			return v13
		end

		logger:trace("Creating profile: {}", p3)
		local v14 = UserProfileModel.create(p3)
		v9[p3] = v14
		return v14
	end

	local v13 = { v8.PLATFORM_NAME, v8.PLATFORM_PROFILE_ID }
	local clone = table.clone(v13)
	table.sort(clone)
	local joined = table.concat(clone, ",")
	local function performBatchFetch(userIds, value, clone2, p3)
		if #userIds == 0 then
			logger:trace("No more ids to fetch. Setting result.")

			for i, item in ipairs(clone2) do
				local v14 = v10[value]
				local v15 = {}

				for k, userId in item.userIds do
					local v16 = v14[userId]

					if v16 then
						logger:trace("Found cached profile: {}", userId)
						table.insert(v15, v16)
					else
						logger:debug("Expected cached profile: {}", userId)
					end
				end

				local v16 = {
					status = p3 and "success" or "failed",
					data = v15
				}

				item.setResult(v16)
				local callback = item.callback

				if callback ~= nil then
					callback(v16)
				end
			end
		else
			local v14 = {}
			local v16

			if fIntUserProfileStoreBatchSize < #userIds then
				v16 = {}

				for i = 1, fIntUserProfileStoreBatchSize do
					table.insert(v16, userIds[i])
				end

				for i = fIntUserProfileStoreBatchSize + 1, #userIds do
					table.insert(v14, userIds[i])
				end
			else
				v16 = userIds
			end

			local v17 = string.split(value, ",")

			local jsonEncode = HttpService:JSONEncode({
				userIds = v16,
				fields = v17,
				includePlatformProfile = fFlagUserProfilePlatformProfile and PlatformProfileRequest.hasPlatformFields(v17) and true or nil
			})

			logger:debug("Fetching: {}", jsonEncode)

			HttpService:RequestInternal({
				Url = v6,
				Method = "POST",
				Body = jsonEncode,
				Timeout = v7,
				CachePolicy = Enum.HttpCachePolicy.None,
				Priority = 0,
				Headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				},
				RequestType = Enum.HttpRequestType.Default
			}):Start(function(p4, p5)
				if p4 == true then
					local body = p5.Body

					if body ~= nil then
						local success, result = pcall(function()
							return HttpService:JSONDecode(body)
						end)

						if result ~= nil then
							logger:trace("Fetched: {}\nresponse: {}", jsonEncode, body)
							local profileDetails = result.profileDetails

							if profileDetails ~= nil then
								if fFlagUserProfilePlatformProfile then
									profileDetails = PlatformProfileRequest.normalizeProfiles(profileDetails, v17)
								end

								local v19 = v10[value]

								for i, profileDetail in ipairs(profileDetails) do
									local userId = tostring(profileDetail.userId)
									local v20 = v9[userId]

									if v20 == nil then
										logger:trace("Creating profile: {}", userId)
										v20 = UserProfileModel.create(userId)
										v9[userId] = v20
									else
										logger:trace("Found profile: {}", userId)
									end

									if profileDetail then
										logger:trace("Updating profile: {}", userId)
										UserProfileModel.update(v20, profileDetail)
									end

									v19[userId] = v20
								end

								if v5 and value == joined then
									for k, v20 in v16 do
										if v19[v20] ~= nil then
											continue
										end

										local v21 = v9[v20]

										if v21 == nil then
											logger:trace("Creating profile: {}", v20)
											v21 = UserProfileModel.create(v20)
											v9[v20] = v21
										else
											logger:trace("Found profile: {}", v20)
										end

										UserProfileModel.update(v21, PlatformProfileRequest.normalizeProfiles({
											{ userId = v20 }
										}, v17)[1])

										v19[v20] = v21
									end
								end
							end
						end
					end
				else
					logger:error("Error fetching")
				end

				performBatchFetch(v14, value, clone2, p4 ~= false and p3)
			end)
		end
	end

	local function processQueuedRequests()
		for k, list in pairs(v11) do
			logger:trace("Processing requests ({}) for fields: {}", #list, k)

			local v14 = v10[k]
			local userIdsByUserId = {}
			local userIds = {}

			for i, item in ipairs(list) do
				for j, userId in ipairs(item.userIds) do
					if userIdsByUserId[userId] ~= nil then
						continue
					end

					userIdsByUserId[userId] = userId

					if v14[userId] == nil then
						table.insert(userIds, userId)
					end
				end
			end

			performBatchFetch(userIds, k, table.clone(list), true)
		end

		v11 = {}
	end

	local function fetchByUserIds(items, list, callback)
		table.sort(list)
		local joined2 = table.concat(list, ",")

		local v14 = v10[joined2]

		if v14 == nil then
			v14 = {}
			v10[joined2] = v14
		end

		local v15 = false
		local v16 = {}

		for k, item in items do
			local v17 = v14[item]
			v15 = v17 == nil and v15 == false or v15

			if not v17 then
				v17 = v9[item]

				if v17 == nil then
					logger:trace("Creating profile: {}", item)
					v17 = UserProfileModel.create(item)
					v9[item] = v17
				else
					logger:trace("Found profile: {}", item)
				end
			end

			table.insert(v16, v17)
		end

		if v15 == false then
			logger:trace("All requested profiles are cached. Calling back early")

			local v17 = { status = "success", data = v16 }

			local signal = createSignal(v17)

			if callback ~= nil then
				callback(v17)
			end

			return signal
		else
			local v17 = { status = "fetching", data = v16 }

			local signal, v18 = createSignal(v17)

			local v19 = v11[joined2]

			if v19 == nil then
				v19 = {}
				v11[joined2] = v19
			end

			table.insert(v19, {
				userIds = items,
				getResult = signal,
				setResult = v18,
				callback = callback
			})

			if not v12 then
				v12 = true

				if fFlagEnableBlackbirdCheck then
					task.defer(function()
						processQueuedRequests()
						v12 = false
					end)
				else
					task.delay(defineFastInt2, function()
						processQueuedRequests()
						v12 = false
					end)
				end
			end

			if callback ~= nil then
				callback(v17)
			end

			return signal
		end
	end

	local function getNameFields(p3)
		local nameFields = {
			v8.COMBINED_NAME,
			v8.DISPLAY_NAME,
			v8.USERNAME,
			v8.IN_EXPERIENCE_COMBINED_NAME,
			v8.CONTACT_NAME,
			v8.ALIAS
		}

		if not fFlagUserProfilePlatformProfile or p3 and not v5 then
			table.insert(nameFields, v8.PLATFORM_NAME)
			table.insert(nameFields, v8.PLATFORM_PROFILE_ID)
		end

		if fFlagEnableVerifiedBadgeStore then
			table.insert(nameFields, v8.IS_VERIFIED)
		end

		if fFlagEnableBlackbirdCheck then
			table.insert(nameFields, v8.HAS_ROBLOX_SUBSCRIPTION)
		end

		return nameFields
	end

	local function getPlatformFields()
		return table.clone(v13)
	end

	local function combineFetchResults(p3, p4)
		return {
			status = (p3.status == "fetching" or p4.status == "fetching") and "fetching" or (p3.status == "failed" or p4.status == "failed") and "failed" or "success",
			data = p3.data
		}
	end

	local function fetchNamesAndPlatformFieldsByUserIds(p3, callback)
		local v14 = nil
		local v15 = nil
		local status = nil
		local function report()
			if callback == nil or v14 == nil or v15 == nil then
				return
			end

			local v16 = v14
			local v17 = v15
			local v18 = {
				status = (v16.status == "fetching" or v17.status == "fetching") and "fetching" or (v16.status == "failed" or v17.status == "failed") and "failed" or "success",
				data = v16.data
			}

			if v18.status ~= status then
				status = v18.status
				callback(v18)
			end
		end

		local v16 = fetchByUserIds(p3, getNameFields(false), function(p4)
			v14 = p4

			if callback ~= nil and v14 ~= nil then
				if v15 == nil then
					return
				end

				local v17 = v14
				local v18 = v15
				local v19 = {
					status = (v17.status == "fetching" or v18.status == "fetching") and "fetching" or (v17.status == "failed" or v18.status == "failed") and "failed" or "success",
					data = v17.data
				}

				if v19.status ~= status then
					status = v19.status
					callback(v19)
				end
			end
		end)
		local v17 = fetchByUserIds(p3, table.clone(v13), function(p4)
			v15 = p4

			if callback ~= nil and v14 ~= nil then
				if v15 == nil then
					return
				end

				local v18 = v14
				local v19 = v15
				local v20 = {
					status = (v18.status == "fetching" or v19.status == "fetching") and "fetching" or (v18.status == "failed" or v19.status == "failed") and "failed" or "success",
					data = v18.data
				}

				if v20.status ~= status then
					status = v20.status
					callback(v20)
				end
			end
		end)

		return createComputed(function(p4)
			local v18 = v16(p4)
			local v19 = v17(p4)
			return {
				status = (v18.status == "fetching" or v19.status == "fetching") and "fetching" or (v18.status == "failed" or v19.status == "failed") and "failed" or "success",
				data = v18.data
			}
		end)
	end

	local function invalidateCachedProfiles(list, items)
		table.sort(list)
		local v14 = v10[table.concat(list, ",")]

		if not (v14 ~= nil and items ~= nil) then
			return
		end

		for k, item in items do
			v14[item] = nil
		end
	end

	return {
		fetchNamesByUserIds = function(p3, p4, p5)
			if v5 and p5 then
				return fetchNamesAndPlatformFieldsByUserIds(p3, p4)
			end

			return fetchByUserIds(p3, getNameFields(p5), p4)
		end,
		updateFromHydration = function(items)
			for userId, item in items do
				if item.userId ~= nil then
					userId = tostring(item.userId)
				end

				local v14 = v9[userId]

				if v14 == nil then
					logger:trace("Creating profile: {}", userId)
					v14 = UserProfileModel.create(userId)
					v9[userId] = v14
				else
					logger:trace("Found profile: {}", userId)
				end

				UserProfileModel.update(v14, {
					names = { username = item.username, displayName = item.displayName },
					isVerified = item.isVerified
				})
			end
		end,
		getProfileByUserId = function(p3)
			return v9[p3]
		end,
		invalidateCachedNamesForUserIds = function(p3)
			if v5 then
				invalidateCachedProfiles(getNameFields(false), p3)
				invalidateCachedProfiles(table.clone(v13), p3)
			elseif fFlagUserProfilePlatformProfile then
				invalidateCachedProfiles(getNameFields(false), p3)
				invalidateCachedProfiles(getNameFields(true), p3)
			else
				invalidateCachedProfiles(
					{
						v8.COMBINED_NAME,
						v8.DISPLAY_NAME,
						v8.USERNAME,
						v8.IN_EXPERIENCE_COMBINED_NAME,
						v8.CONTACT_NAME,
						v8.ALIAS,
						v8.PLATFORM_NAME,
						v8.PLATFORM_PROFILE_ID
					},
					p3
				)
			end
		end
	}
end)

return {
	get = function()
		return computed(false)
	end
}
