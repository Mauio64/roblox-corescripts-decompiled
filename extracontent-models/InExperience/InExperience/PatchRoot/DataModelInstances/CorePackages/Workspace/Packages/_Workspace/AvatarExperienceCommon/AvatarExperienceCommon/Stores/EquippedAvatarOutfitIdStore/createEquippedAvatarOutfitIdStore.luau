local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local getCurrentlyWearingSavedOutfitId = require(AvatarExperienceCommon.Requests.getCurrentlyWearingSavedOutfitId)

local function createEquippedAvatarOutfitIdStore()
	local sessionScopedSignal, setLastEquippedAvatarOutfitId = createSessionScopedSignal(nil)
	local count = 0

	local function commitOutfitId(value: string?) -- 1 equivalent call inferred from this helper
		if sessionScopedSignal(false) == nil then
			setLastEquippedAvatarOutfitId(value or "")
		end
	end

	local function commitOutfitIdIfCurrent(p: number, value: string?) -- 2 equivalent calls inferred from this helper
		if p == count then
			commitOutfitId(value) -- inferred equivalent call
		end
	end

	local function fetchCurrentlyWearingSavedOutfitId()
		if sessionScopedSignal(false) ~= nil then
			return
		end

		count += 1
		local v = count
		getCurrentlyWearingSavedOutfitId():andThen(function(p: string?)
			commitOutfitIdIfCurrent(v, p) -- inferred equivalent call
		end, function()
			commitOutfitIdIfCurrent(v) -- inferred equivalent call
		end)
	end

	return {
		getLastEquippedAvatarOutfitId = sessionScopedSignal,
		setLastEquippedAvatarOutfitId = setLastEquippedAvatarOutfitId,
		fetchCurrentlyWearingSavedOutfitId = fetchCurrentlyWearingSavedOutfitId
	}
end

return createEquippedAvatarOutfitIdStore
