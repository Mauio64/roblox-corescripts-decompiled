local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Cryo")

local function ImpressionCacheImpl(data)
	local isKeyAvailableInEngine = data.isKeyAvailableInEngine
	local dismissedValue = data.dismissedValue
	local appStorageKey = data.appStorageKey

	local playersService = data.PlayersService or Players
	local appStorageService = data.AppStorageService or AppStorageService

	local function getLocalUserId()
		local localPlayer = playersService.LocalPlayer

		if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
			return (tostring(localPlayer.UserId))
		end

		return nil
	end

	local function updateStoredValue(p2)
		local success, result = pcall(function()
			return HttpService:JSONEncode(p2)
		end)

		if success then
			appStorageService:SetItem(appStorageKey, result)
			appStorageService:Flush()
		end
	end

	local function getStoredValue()
		local item = appStorageService:GetItem(appStorageKey) or ""

		local success, result = pcall(function()
			return HttpService:JSONDecode(item)
		end)

		if success and type(result) == "table" then
			return result
		end

		return nil
	end

	local function setImpressionCountPerUser(userId, p2)
		local item = appStorageService:GetItem(appStorageKey) or ""

		local success, result = pcall(function()
			return HttpService:JSONDecode(item)
		end)

		if not success or type(result) ~= "table" then
			result = nil
		end

		local joined = Cryo.Dictionary.join(result or {}, { [userId] = p2 })
		local success2, result2 = pcall(function()
			return HttpService:JSONEncode(joined)
		end)

		if success2 then
			appStorageService:SetItem(appStorageKey, result2)
			appStorageService:Flush()
		end
	end

	local function getImpressionCountPerUser(p2)
		local item = appStorageService:GetItem(appStorageKey) or ""

		local success, result = pcall(function()
			return HttpService:JSONDecode(item)
		end)

		if not success or type(result) ~= "table" then
			result = nil
		end

		return result and result[p2] and tonumber(result[p2]) or 0
	end

	local function setValue(p2)
		local localPlayer = playersService.LocalPlayer
		local userId

		if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
			userId = tostring(localPlayer.UserId)
		end

		if isKeyAvailableInEngine and userId then
			setImpressionCountPerUser(userId, p2)
		end
	end

	return {
		getValue = function()
			local localPlayer = playersService.LocalPlayer
			local userId

			if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
				userId = tostring(localPlayer.UserId)
			end

			if not (isKeyAvailableInEngine and userId) then
				return dismissedValue
			end

			local item = appStorageService:GetItem(appStorageKey) or ""

			local success, result = pcall(function()
				return HttpService:JSONDecode(item)
			end)

			if not success or type(result) ~= "table" then
				result = nil
			end

			return result and result[userId] and tonumber(result[userId]) or 0
		end,
		incrementValue = function()
			local localPlayer = playersService.LocalPlayer
			local userId

			if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
				userId = tostring(localPlayer.UserId)
			end

			local v5

			if isKeyAvailableInEngine and userId then
				local item = appStorageService:GetItem(appStorageKey) or ""

				local success, result = pcall(function()
					return HttpService:JSONDecode(item)
				end)

				if not success or type(result) ~= "table" then
					result = nil
				end

				v5 = result and result[userId] and tonumber(result[userId]) or 0
			else
				v5 = dismissedValue
			end

			local v6 = v5 + 1
			local localPlayer2 = playersService.LocalPlayer
			local userId2

			if localPlayer2 and localPlayer2.UserId and localPlayer2.UserId > 0 then
				userId2 = tostring(localPlayer2.UserId)
			end

			if isKeyAvailableInEngine and userId2 then
				setImpressionCountPerUser(userId2, v6)
			end
		end,
		dismissValue = function()
			local v5 = dismissedValue
			local localPlayer = playersService.LocalPlayer
			local userId

			if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
				userId = tostring(localPlayer.UserId)
			end

			if isKeyAvailableInEngine and userId then
				setImpressionCountPerUser(userId, v5)
			end
		end
	}
end

return ImpressionCacheImpl
