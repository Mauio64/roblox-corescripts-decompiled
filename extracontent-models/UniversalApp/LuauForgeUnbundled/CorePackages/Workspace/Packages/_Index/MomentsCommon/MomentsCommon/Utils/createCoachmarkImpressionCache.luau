local MomentsLocalStorage = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Storage/MomentsLocalStorage")
local MomentsLocalStorageKeys = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Storage/MomentsLocalStorageKeys")
local Players = game:GetService("Players")

local coachmarkImpressions = MomentsLocalStorageKeys.CoachmarkImpressions

local function createCoachmarkImpressionCache(data)
	local dismissedValue = data.dismissedValue
	local coachmarkId = data.coachmarkId

	local playersService = data.PlayersService or Players
	local localStorage = data.localStorage or MomentsLocalStorage

	local function getLocalUserId()
		local localPlayer = playersService.LocalPlayer

		if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
			return (tostring(localPlayer.UserId))
		end

		return nil
	end

	local function getStoredObject()
		local field = localStorage.getField(coachmarkImpressions)

		if type(field) == "table" then
			return field
		end

		return {}
	end

	local function setValue(dismissedValue2)
		local localPlayer = playersService.LocalPlayer
		local userId

		if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
			userId = tostring(localPlayer.UserId)
		end

		if not userId then
			return
		end

		local field = localStorage.getField(coachmarkImpressions)
		local v5 = type(field) ~= "table" and {} or field

		local v6 = v5[userId]

		if type(v6) ~= "table" then
			v6 = {}
			v5[userId] = v6
		end

		v6[coachmarkId] = dismissedValue2
		localStorage.setField(coachmarkImpressions, v5)
	end

	return {
		getValue = function()
			local localPlayer = playersService.LocalPlayer
			local userId

			if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
				userId = tostring(localPlayer.UserId)
			end

			if not userId then
				return dismissedValue
			end

			local field = localStorage.getField(coachmarkImpressions)
			local v5 = (type(field) ~= "table" and {} or field)[userId]

			if type(v5) == "table" then
				return tonumber(v5[coachmarkId]) or 0
			end

			return 0
		end,
		incrementValue = function()
			local localPlayer = playersService.LocalPlayer
			local userId

			if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
				userId = tostring(localPlayer.UserId)
			end

			local v6

			if userId then
				local field = localStorage.getField(coachmarkImpressions)
				local v7 = (type(field) ~= "table" and {} or field)[userId]

				v6 = type(v7) == "table" and tonumber(v7[coachmarkId]) or 0
			else
				v6 = dismissedValue
			end

			setValue(v6 + 1)
		end,
		dismissValue = function()
			setValue(dismissedValue)
		end
	}
end

return createCoachmarkImpressionCache
