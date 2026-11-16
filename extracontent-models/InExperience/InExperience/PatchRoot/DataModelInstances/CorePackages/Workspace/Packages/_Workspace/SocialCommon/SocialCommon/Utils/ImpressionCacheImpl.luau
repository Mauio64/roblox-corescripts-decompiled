local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("SocialCommon").Parent

local Cryo = require(parent.Cryo)

local function ImpressionCacheImpl(data)
	local isKeyAvailableInEngine = data.isKeyAvailableInEngine
	local dismissedValue = data.dismissedValue
	local appStorageKey = data.appStorageKey

	local playersService = data.PlayersService or Players
	local appStorageService = data.AppStorageService or AppStorageService

	local function getLocalUserId() -- 2 equivalent calls inferred from this helper
		local localPlayer = playersService.LocalPlayer

		if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
			return (tostring(localPlayer.UserId))
		end

		return nil
	end

	local function updateStoredValue(joined) -- 1 equivalent call inferred from this helper
		local success, result = pcall(function()
			return HttpService:JSONEncode(joined)
		end)

		if success then
			appStorageService:SetItem(appStorageKey, result)
			appStorageService:Flush()
		end
	end

	local function getStoredValue() -- 2 equivalent calls inferred from this helper
		local item = appStorageService:GetItem(appStorageKey) or ""

		local success, result = pcall(function()
			return HttpService:JSONDecode(item)
		end)

		if success and type(result) == "table" then
			return result
		end

		return nil
	end

	local function setImpressionCountPerUser(localUserId: string, p: number)
		local storedValue = getStoredValue() -- inferred equivalent call
		updateStoredValue(Cryo.Dictionary.join(storedValue or {}, { [localUserId] = p })) -- inferred equivalent call
	end

	local function getImpressionCountPerUser(localUserId: string) -- 1 equivalent call inferred from this helper
		local storedValue = getStoredValue() -- inferred equivalent call
		return storedValue and storedValue[localUserId] and tonumber(storedValue[localUserId]) or 0
	end

	local function setValue(p: number) -- 2 equivalent calls inferred from this helper
		local localUserId = getLocalUserId() -- inferred equivalent call

		if isKeyAvailableInEngine and localUserId then
			setImpressionCountPerUser(localUserId, p)
		end
	end

	local function getValue() -- 1 equivalent call inferred from this helper
		local localUserId = getLocalUserId() -- inferred equivalent call

		if not (isKeyAvailableInEngine and localUserId) then
			return dismissedValue
		end

		return getImpressionCountPerUser(localUserId) -- inferred equivalent call
	end

	return {
		getValue = getValue,
		incrementValue = function()
			setValue(getValue() + 1) -- inferred equivalent call
		end,
		dismissValue = function()
			setValue(dismissedValue) -- inferred equivalent call
		end
	}
end

return ImpressionCacheImpl
