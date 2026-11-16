local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local GuiService = game:GetService("GuiService")

local RobloxAppEnums = require(parent.RobloxAppEnums)
local NotificationType = RobloxAppEnums.NotificationType
local Promise = require(parent.Promise)
local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService
local ExperienceService2 = require(parent.ExperienceService)
local GameParams = ExperienceService2.GameParams

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch

local FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues

local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local User = require(AuthCommon.Thunks.User)
local AccountSwitcherConstants = require(AuthCommon.Common.AccountSwitcherConstants)
local RedeemAuthenticationTicket = require(AuthCommon.Http.Requests.RedeemAuthenticationTicket)

local function castStringToInferredType(p: string) -- 1 equivalent call inferred from this helper
	return tonumber(p) or p == "true" or p ~= "false" and p
end

local function parsePlaceLauncherUrl(value: string?)
	if not value or value == "" then
		return {}
	end

	local v = value:gsub("%%(%x%x)", function(p)
		return (string.char((tonumber(p, 16))))
	end)

	local result = {}
	local _, v2 = string.find(v, "?")

	if not v2 then
		return result
	end

	local v3 = string.sub(v, v2 + 1)

	for k in string.gmatch(v3, "[^&]+") do
		local v4, v5 = string.match(k, "([^=]+)=?(.*)")

		if v4 then
			result[v4] = v5
		end
	end

	return result
end

return function(p, p2, p3, callback, callback2)
	return (RedeemAuthenticationTicket(p, p2):andThen(function(p4)
		local v = parsePlaceLauncherUrl(p3)

		local placeId = tonumber(v.placeId)

		if placeId then
			local v2 = GameParams.fromPlaceId(placeId)

			for k, v3 in pairs(v) do
				if k == "placeId" then
					continue
				end

				v3 = castStringToInferredType(v3) -- inferred equivalent call
				v2[k] = v3
			end

			local accountBlob = AppStorageUtilities.getAccountBlob()
			local v3 = User.fromLocalStorage().userId ~= -1

			if not FFlagEnableLuaAccountSwitch or not v3 and accountBlob == "" then
				return Promise.resolve(callback()):andThen(function()
					experienceService:LaunchExperience(v2, "AuthTicket", nil)
				end)
			end

			Promise.resolve(callback2()):andThen(function()
				local v4

				if FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then
					v4 = AccountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus
				else
					v4 = AccountSwitcherConstants.AccountSwitcherSwitchedStatus
				end

				AppStorageUtilities.setAccountSwitchStatus(v4)
				AppStorageUtilities.setAccountBlob(p4.responseBody.accountBlob)
				AppStorageUtilities.setAccountSwitchStartupQueryParams(v)
				AppStorageUtilities.flush()

				GuiService:BroadcastNotification("", NotificationType.DID_SWITCH_ACCOUNT)
			end, function(p5)
				print("error: ", p5)
			end)
		end

		return Promise.resolve()
	end, function(p4)
		return Promise.reject(p4)
	end))
end
