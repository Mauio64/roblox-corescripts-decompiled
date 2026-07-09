local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local NotificationType = require(AuthCommonParent.RobloxAppEnums).NotificationType
local Url = require(AuthCommonParent.Http).Url
local Promise = require(AuthCommonParent.Promise)
local ExperienceService = require(AuthCommonParent.ExperienceService).ExperienceService
local GameParams = require(AuthCommonParent.ExperienceService).GameParams
local SharedFlags = require(AuthCommonParent.SharedFlags)
local FFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch
local FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local User = require(AuthCommon.Thunks.User)
local AccountSwitcherConstants = require(AuthCommon.Common.AccountSwitcherConstants)

local function castStringToInferredType(s1: string) -- line: 22
	local num = tonumber(s1)

	if num then
		return num
	end

	if s1 == "true" then
		return true
	end

	if s1 == "false" then
		return false
	end

	return s1
end
local function parsePlaceLauncherUrl(s2: string) -- line: 41
	if not s2 or s2 == "" then
		return {}
	end

	local v21 = s2:gsub("%%(%x%x)", function(p1) -- line: 47
		return (string.char((tonumber(p1, 16))))
	end)
	local t1 = {}
	local _, stop = string.find(v21, "?")

	if not stop then
		return t1
	end

	local v25 = string.sub(v21, stop + 1)

	for match in string.gmatch(v25, "[^&]+") do
		local v27, v28 = string.match(match, "([^=]+)=?(.*)")

		if v27 then
			t1[v27] = v28
		end
	end

	return t1
end

return function(p2, p3, p4, p5, p6) -- line: 72
	-- upvalues: Url (copy), HttpService (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy), parsePlaceLauncherUrl (copy), GameParams (copy), User (copy), Promise (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), GuiService (copy), NotificationType (copy), ExperienceService (copy)
	return p2(string.format("%sv1/authentication-ticket/redeem", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			retainCurrentSession = true,
			authenticationTicket = p3,
			accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
		})
	}):andThen(function(p7) -- line: 81
		-- upvalues: parsePlaceLauncherUrl (copy), p4 (copy), GameParams (copy), AppStorageUtilities (copy), User (copy), FFlagEnableLuaAccountSwitch (copy), Promise (copy), p6 (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), GuiService (copy), NotificationType (copy), p5 (copy), ExperienceService (copy)
		local v36 = parsePlaceLauncherUrl(p4)
		local num = tonumber(v36.placeId)

		if num then
			local v38 = GameParams.fromPlaceId(num)

			for k, v in pairs(v36) do
				if k ~= "placeId" then
					v38[k] = tonumber(v) or (v == "true" or v ~= "false" and v)
				end
			end

			local v41 = AppStorageUtilities.getAccountBlob()
			local v42 = User.fromLocalStorage().userId ~= -1

			if not FFlagEnableLuaAccountSwitch or not v42 and v41 == "" then
				return Promise.resolve(p5()):andThen(function() -- line: 112
					-- upvalues: ExperienceService (copy), v38 (copy)
					ExperienceService:LaunchExperience(v38, "AuthTicket", nil)
				end)
			end

			Promise.resolve(p6()):andThen(function() -- line: 98
				-- upvalues: FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), AppStorageUtilities (copy), p7 (copy), v36 (copy), GuiService (copy), NotificationType (copy)
				local v44 = if not FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then AccountSwitcherConstants.AccountSwitcherSwitchedStatus else AccountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus

				AppStorageUtilities.setAccountSwitchStatus(v44)
				AppStorageUtilities.setAccountBlob(p7.responseBody.accountBlob)
				AppStorageUtilities.setAccountSwitchStartupQueryParams(v36)
				AppStorageUtilities.flush()
				GuiService:BroadcastNotification("", NotificationType.DID_SWITCH_ACCOUNT)
			end, function(p8) -- line: 108
				print("error: ", p8)
			end)
		end

		return Promise.resolve()
	end, function(p9) -- line: 119
		-- upvalues: Promise (copy)
		return Promise.reject(p9)
	end)
end
