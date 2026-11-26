require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SignalsUtils").createSessionScopedSignal

local getCurrentlyWearingSavedOutfitId = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Requests/getCurrentlyWearingSavedOutfitId")

local function createEquippedAvatarOutfitIdStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(nil)
	local count = 0

	local function commitOutfitId(value)
		if sessionScopedSignal(false) == nil then
			v5(value or "")
		end
	end

	local function commitOutfitIdIfCurrent(p2, value)
		if p2 == count and sessionScopedSignal(false) == nil then
			v5(value or "")
		end
	end

	local function fetchCurrentlyWearingSavedOutfitId()
		if sessionScopedSignal(false) ~= nil then
			return
		end

		count += 1
		local v6 = count
		getCurrentlyWearingSavedOutfitId():andThen(function(value)
			if v6 == count and sessionScopedSignal(false) == nil then
				v5(value or "")
			end
		end, function()
			if v6 == count and sessionScopedSignal(false) == nil then
				v5("")
			end
		end)
	end

	return {
		getLastEquippedAvatarOutfitId = sessionScopedSignal,
		setLastEquippedAvatarOutfitId = v5,
		fetchCurrentlyWearingSavedOutfitId = fetchCurrentlyWearingSavedOutfitId
	}
end

return createEquippedAvatarOutfitIdStore
