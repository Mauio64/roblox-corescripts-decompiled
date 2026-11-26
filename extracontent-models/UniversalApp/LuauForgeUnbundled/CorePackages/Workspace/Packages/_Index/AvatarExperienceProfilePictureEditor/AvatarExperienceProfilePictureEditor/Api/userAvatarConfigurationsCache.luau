local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Promise")

local parseUserAvatarConfigurationsV4 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/parseUserAvatarConfigurationsV4").parseUserAvatarConfigurationsV4
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/parseCloseupCameraConfig")
local userAvatarConfigurationsApi = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Api/userAvatarConfigurationsApi")

local v5 = {}
local v6 = {}

local function normalizeSelectionTypes(value)
	if typeof(value) == "string" then
		return { value }
	end

	local clone = table.clone(value)
	table.sort(clone)
	return clone
end

local function clearCacheEntry(p2)
	v5[p2] = nil
	v6[p2] = nil
end

return {
	buildCacheKey = function(p2, value)
		local concat = table.concat
		local v8

		if typeof(value) == "string" then
			v8 = { value }
		else
			v8 = table.clone(value)
			table.sort(v8)
		end

		return `{p2}:{concat(v8, ",")}`
	end,
	fetchCached = function(p2, p3, p4)
		local v7 = p4 or userAvatarConfigurationsApi.DEFAULT_SELECTION_TYPES
		local concat = table.concat
		local v9

		if typeof(v7) == "string" then
			v9 = { v7 }
		else
			v9 = table.clone(v7)
			table.sort(v9)
		end

		local formatted = `{p3}:{concat(v9, ",")}`

		local v10 = v5[formatted]

		if v10 then
			return Promise.resolve(v10)
		end

		local v11 = v6[formatted]

		if v11 then
			return v11
		end

		local v12 = userAvatarConfigurationsApi.fetchUserAvatarConfigurations(p2, p3, v7):andThen(function(p5)
			local v13 = {
				response = p5,
				parsed = parseUserAvatarConfigurationsV4(p5.responseBody)
			}

			v5[formatted] = v13
			v6[formatted] = nil
			return v13
		end):catch(function(p5)
			v6[formatted] = nil
			return Promise.reject(p5)
		end)

		v6[formatted] = v12
		return v12
	end,
	invalidate = function(p2)
		local formatted = `{p2}:`

		for k in v5 do
			if string.sub(k, 1, #formatted) ~= formatted then
				continue
			end

			v5[k] = nil
			v6[k] = nil
		end
	end,
	clearCacheForTests = function()
		table.clear(v5)
		table.clear(v6)
	end
}
