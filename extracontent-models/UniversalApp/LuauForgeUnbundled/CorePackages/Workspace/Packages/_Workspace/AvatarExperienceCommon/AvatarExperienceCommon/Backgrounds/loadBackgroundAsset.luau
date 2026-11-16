local assetSource = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/assetSource")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/types")

local default = assetSource.default

local v5 = {}

local function loadBackgroundAsset(p2)
	local v6 = v5[p2]

	if v6 then
		return v6
	end

	local v7 = default(p2):catch(function(message)
		v5[p2] = nil
		error(message)
	end)
	v5[p2] = v7
	return v7
end

local function clearCache()
	v5 = {}
end

return { load = loadBackgroundAsset, clearCache = clearCache }
