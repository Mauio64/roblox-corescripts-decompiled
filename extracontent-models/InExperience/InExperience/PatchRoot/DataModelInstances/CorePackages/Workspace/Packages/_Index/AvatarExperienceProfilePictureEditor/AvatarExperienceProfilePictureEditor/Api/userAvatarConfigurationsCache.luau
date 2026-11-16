local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local Promise = require(parent.Promise)

local parseUserAvatarConfigurationsV4 = require(AvatarExperienceProfilePictureEditor.Shared.parseUserAvatarConfigurationsV4)
local parseUserAvatarConfigurationsV4_2 = parseUserAvatarConfigurationsV4.parseUserAvatarConfigurationsV4
require(AvatarExperienceProfilePictureEditor.Shared.parseCloseupCameraConfig)
local userAvatarConfigurationsApi = require(script.Parent.userAvatarConfigurationsApi)

local v = {}
local v2 = {}

local function normalizeSelectionTypes(value) -- 1 equivalent call inferred from this helper
	if typeof(value) == "string" then
		return { value }
	end

	local clone = table.clone(value)
	table.sort(clone)
	return clone
end

local function buildCacheKey(p: string, value) -- 1 equivalent call inferred from this helper
	return `{p}:{table.concat(normalizeSelectionTypes(value), ",")}` -- inferred equivalent call
end

local function clearCacheEntry(k: string) -- 1 equivalent call inferred from this helper
	v[k] = nil
	v2[k] = nil
end

local UserAvatarConfigurationsCache = {}
UserAvatarConfigurationsCache.buildCacheKey = buildCacheKey

function UserAvatarConfigurationsCache.fetchCached(p, p2: string, p3)
	local v3 = p3 or userAvatarConfigurationsApi.DEFAULT_SELECTION_TYPES
	local cacheKey = buildCacheKey(p2, v3) -- inferred equivalent call
	local v4 = v[cacheKey]

	if v4 then
		return Promise.resolve(v4)
	end

	local v5 = v2[cacheKey]

	if v5 then
		return v5
	end

	local v6 = userAvatarConfigurationsApi.fetchUserAvatarConfigurations(p, p2, v3):andThen(function(response)
		local v6 = {
			response = response,
			parsed = parseUserAvatarConfigurationsV4_2(response.responseBody)
		}

		v[cacheKey] = v6
		v2[cacheKey] = nil
		return v6
	end):catch(function(p4)
		v2[cacheKey] = nil
		return Promise.reject(p4)
	end)

	v2[cacheKey] = v6
	return v6
end

function UserAvatarConfigurationsCache.invalidate(p: string)
	local formatted = `{p}:`

	for k in v do
		if string.sub(k, 1, #formatted) == formatted then
			clearCacheEntry(k) -- inferred equivalent call
		end
	end
end

function UserAvatarConfigurationsCache.clearCacheForTests()
	table.clear(v)
	table.clear(v2)
end

return UserAvatarConfigurationsCache
