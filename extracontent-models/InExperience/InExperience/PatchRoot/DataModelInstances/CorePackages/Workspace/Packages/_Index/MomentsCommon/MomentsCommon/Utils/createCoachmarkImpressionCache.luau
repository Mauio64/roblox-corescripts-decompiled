local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local MomentsLocalStorage = require(MomentsCommon.Storage.MomentsLocalStorage)
local MomentsLocalStorageKeys = require(MomentsCommon.Storage.MomentsLocalStorageKeys)
local Players = game:GetService("Players")

local CoachmarkImpressions = MomentsLocalStorageKeys.CoachmarkImpressions

local function createCoachmarkImpressionCache(data)
	local dismissedValue = data.dismissedValue
	local coachmarkId = data.coachmarkId

	local playersService = data.PlayersService or Players
	local localStorage = data.localStorage or MomentsLocalStorage

	local function getLocalUserId() -- 2 equivalent calls inferred from this helper
		local localPlayer = playersService.LocalPlayer

		if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
			return (tostring(localPlayer.UserId))
		end

		return nil
	end

	local function getStoredObject() -- 2 equivalent calls inferred from this helper
		local field = localStorage.getField(CoachmarkImpressions)

		if type(field) == "table" then
			return field
		end

		return {}
	end

	local function setValue(p: number)
		local localUserId = getLocalUserId() -- inferred equivalent call

		if not localUserId then
			return
		end

		local storedObject = getStoredObject() -- inferred equivalent call
		local v = storedObject[localUserId]

		if type(v) ~= "table" then
			v = {}
			storedObject[localUserId] = v
		end

		v[coachmarkId] = p
		localStorage.setField(CoachmarkImpressions, storedObject)
	end

	local function getValue() -- 1 equivalent call inferred from this helper
		local localUserId = getLocalUserId() -- inferred equivalent call

		if not localUserId then
			return dismissedValue
		end

		local v = getStoredObject()[localUserId] -- inferred equivalent call

		if type(v) == "table" then
			return tonumber(v[coachmarkId]) or 0
		end

		return 0
	end

	return {
		getValue = getValue,
		incrementValue = function()
			setValue(getValue() + 1) -- inferred equivalent call
		end,
		dismissValue = function()
			setValue(dismissedValue)
		end
	}
end

return createCoachmarkImpressionCache
