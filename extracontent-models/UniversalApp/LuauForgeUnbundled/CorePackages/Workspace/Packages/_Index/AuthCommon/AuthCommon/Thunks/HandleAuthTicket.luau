local GuiService = game:GetService("GuiService")

local notificationType = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").NotificationType
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local experienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/ExperienceService").ExperienceService
local gameParams = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/ExperienceService").GameParams

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags")
local fFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch

local fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues

local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
local User = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/User")
local AccountSwitcherConstants = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/AccountSwitcherConstants")
local RedeemAuthenticationTicket = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/RedeemAuthenticationTicket")

local function castStringToInferredType(p2)
	local v5 = tonumber(p2)

	if v5 then
		return v5
	end

	if p2 == "true" then
		return true
	elseif p2 == "false" then
		return false
	end

	return p2
end

local function parsePlaceLauncherUrl(value)
	if not value or value == "" then
		return {}
	end

	local v5 = value:gsub("%%(%x%x)", function(p2)
		return (string.char((tonumber(p2, 16))))
	end)

	local result = {}
	local v6, v7 = string.find(v5, "?")

	if not v7 then
		return result
	end

	local v8 = string.sub(v5, v7 + 1)

	for k in string.gmatch(v8, "[^&]+") do
		local v9, v10 = string.match(k, "([^=]+)=?(.*)")

		if v9 then
			result[v9] = v10
		end
	end

	return result
end

return function(p2, p3, p4, callback, callback2)
	return (RedeemAuthenticationTicket(p2, p3):andThen(function(p5)
		local v5 = parsePlaceLauncherUrl(p4)

		local placeId = tonumber(v5.placeId)

		if placeId then
			local v6 = gameParams.fromPlaceId(placeId)

			for k, v7 in pairs(v5) do
				if k == "placeId" then
					continue
				end

				local v8 = tonumber(v7)

				if v8 then
					v7 = v8
				elseif v7 == "true" then
					v7 = true
				elseif v7 == "false" then
					v7 = false
				end

				v6[k] = v7
			end

			local accountBlob = AppStorageUtilities.getAccountBlob()
			local v7 = User.fromLocalStorage().userId ~= -1

			if not fFlagEnableLuaAccountSwitch or not v7 and accountBlob == "" then
				return Promise.resolve(callback()):andThen(function()
					experienceService:LaunchExperience(v6, "AuthTicket", nil)
				end)
			end

			Promise.resolve(callback2()):andThen(function()
				local v8 = if fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then AccountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus else AccountSwitcherConstants.AccountSwitcherSwitchedStatus
				AppStorageUtilities.setAccountSwitchStatus(v8)
				AppStorageUtilities.setAccountBlob(p5.responseBody.accountBlob)
				AppStorageUtilities.setAccountSwitchStartupQueryParams(v5)
				AppStorageUtilities.flush()

				GuiService:BroadcastNotification("", notificationType.DID_SWITCH_ACCOUNT)
			end, function(p6)
				print("error: ", p6)
			end)
		end

		return Promise.resolve()
	end, function(p5)
		return Promise.reject(p5)
	end))
end
