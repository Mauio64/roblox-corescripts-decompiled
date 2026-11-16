local AuthLocalStorageKeys = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/AuthLocalStorageKeys")
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local getFFlagEnableMultiPageSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableMultiPageSignup

require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/PreviousAccountEntry")
local gameParams = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/ExperienceService").GameParams

local v5 = { passkeySignupName = "PasskeySignupName" }

local v6 = {}

function v6.setRobloxLocaleId(p2)
	AppStorageService:SetItem(AuthLocalStorageKeys.RobloxLocaleId, p2)
end

function v6.setGameLocaleId(p2)
	AppStorageService:SetItem(AuthLocalStorageKeys.GameLocaleId, p2)
end

function v6.getAuthenticatedTheme()
	return AppStorageService:GetItem(AuthLocalStorageKeys.AuthenticatedTheme)
end

function v6.setAuthenticatedTheme(p2)
	AppStorageService:SetItem(AuthLocalStorageKeys.AuthenticatedTheme, p2)
end

function v6.getAccountBlob()
	if game:GetEngineFeature("AccountSwitchFeatureEnabled") then
		return AppStorageService:GetItem(AuthLocalStorageKeys.AccountBlob) or ""
	end

	return ""
end

function v6.setAccountBlob(value)
	if game:GetEngineFeature("AccountSwitchFeatureEnabled") then
		AppStorageService:SetItem(AuthLocalStorageKeys.AccountBlob, value or "")
	end
end

function v6.getDefaultUsername()
	return AppStorageService:GetItem(AuthLocalStorageKeys.CredentialValue)
end

function v6.getSignupActionRequired()
	return AppStorageService:GetItem(AuthLocalStorageKeys.SignupActionRequired)
end

function v6.setSignupActionRequired(p2)
	AppStorageService:SetItem(AuthLocalStorageKeys.SignupActionRequired, p2)
end

function v6.getAccountSwitcherMetadataMap()
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		return AppStorageService:GetItem(AuthLocalStorageKeys.AccountSwitcherMetadataMap) or ""
	end

	return ""
end

function v6.setAccountSwitcherMetadataMap(value)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		AppStorageService:SetItem(AuthLocalStorageKeys.AccountSwitcherMetadataMap, value or "")
	end
end

function v6.setAccountSwitchStartupQueryParams(accountSwitchStartupQueryParams)
	if typeof(accountSwitchStartupQueryParams) == "table" then
		accountSwitchStartupQueryParams = HttpService:JSONEncode(accountSwitchStartupQueryParams)
	end

	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local accountSwitcherMetadataMap = v6.getAccountSwitcherMetadataMap()
		local v7

		if accountSwitcherMetadataMap == nil or accountSwitcherMetadataMap == "" then
			v7 = { AccountSwitchStartupQueryParams = accountSwitchStartupQueryParams }
		else
			v7 = HttpService:JSONDecode(accountSwitcherMetadataMap)
			v7.AccountSwitchStartupQueryParams = accountSwitchStartupQueryParams
		end

		v6.setAccountSwitcherMetadataMap(HttpService:JSONEncode(v7))
	end
end

function v6.clearAccountSwitchStartupGameParams()
	v6.setAccountSwitchStartupQueryParams("")
end

function v6.getAccountSwitchStartupGameParams()
	if not game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		return nil
	end

	local accountSwitcherMetadataMap = v6.getAccountSwitcherMetadataMap()

	if accountSwitcherMetadataMap == nil or accountSwitcherMetadataMap == "" then
		return nil
	end

	local jsonDecode = HttpService:JSONDecode(accountSwitcherMetadataMap)

	if
		jsonDecode == nil
		or jsonDecode == ""
		or next(jsonDecode) == nil
		or next(jsonDecode) == ""
		or jsonDecode.AccountSwitchTargetUsername == nil
	then
		return nil
	end

	local accountSwitchStartupQueryParams = jsonDecode.AccountSwitchStartupQueryParams

	if accountSwitchStartupQueryParams == nil or accountSwitchStartupQueryParams == "" then
		return nil
	end

	local jsonDecode2 = HttpService:JSONDecode(accountSwitchStartupQueryParams)

	local result = gameParams.fromParams(jsonDecode2)

	for k, v7 in pairs(jsonDecode2) do
		local v8 = tonumber(v7)

		if v8 then
			v7 = v8
		elseif v7 == "true" then
			v7 = true
		elseif v7 == "false" then
			v7 = false
		end

		result[k] = v7
	end

	return result
end

function v6.getAccountSwitchTargetUsername()
	if not game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		return ""
	end

	local accountSwitcherMetadataMap = v6.getAccountSwitcherMetadataMap()

	if accountSwitcherMetadataMap == nil or accountSwitcherMetadataMap == "" then
		return ""
	end

	local jsonDecode = HttpService:JSONDecode(accountSwitcherMetadataMap)

	if
		jsonDecode == nil
		or jsonDecode == ""
		or next(jsonDecode) == nil
		or next(jsonDecode) == ""
		or jsonDecode.AccountSwitchTargetUsername == nil
	then
		return ""
	end

	return jsonDecode.AccountSwitchTargetUsername
end

function v6.setAccountSwitchTargetUsername(accountSwitchTargetUsername)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local accountSwitcherMetadataMap = v6.getAccountSwitcherMetadataMap()
		local v7

		if accountSwitcherMetadataMap == nil or accountSwitcherMetadataMap == "" then
			v7 = { AccountSwitchTargetUsername = accountSwitchTargetUsername }
		else
			v7 = HttpService:JSONDecode(accountSwitcherMetadataMap)
			v7.AccountSwitchTargetUsername = accountSwitchTargetUsername
		end

		v6.setAccountSwitcherMetadataMap(HttpService:JSONEncode(v7))
	end
end

function v6.getAccountSwitchStatus()
	if not game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		return ""
	end

	local accountSwitcherMetadataMap = v6.getAccountSwitcherMetadataMap()

	if accountSwitcherMetadataMap == nil or accountSwitcherMetadataMap == "" then
		return ""
	end

	local jsonDecode = HttpService:JSONDecode(accountSwitcherMetadataMap)

	if
		jsonDecode == nil
		or jsonDecode == ""
		or next(jsonDecode) == nil
		or next(jsonDecode) == ""
		or jsonDecode.AccountSwitchStatus == nil
	then
		return ""
	end

	return jsonDecode.AccountSwitchStatus
end

function v6.setAccountSwitchStatus(accountSwitchStatus)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local accountSwitcherMetadataMap = v6.getAccountSwitcherMetadataMap()
		local v7

		if accountSwitcherMetadataMap == nil or accountSwitcherMetadataMap == "" then
			v7 = { AccountSwitchStatus = accountSwitchStatus }
		else
			v7 = HttpService:JSONDecode(accountSwitcherMetadataMap)
			v7.AccountSwitchStatus = accountSwitchStatus
		end

		v6.setAccountSwitcherMetadataMap(HttpService:JSONEncode(v7))
	end
end

function v6.getMultipageSignupMetadataMap()
	return AppStorageService:GetItem(AuthLocalStorageKeys.MultipageSignupMetadataMap) or ""
end

function v6.setMultipageSignupMetadataMap(value)
	AppStorageService:SetItem(AuthLocalStorageKeys.MultipageSignupMetadataMap, value or "")
end

function v6.getIncompleteSignupUserId()
	local multipageSignupMetadataMap = v6.getMultipageSignupMetadataMap()

	if multipageSignupMetadataMap == nil or multipageSignupMetadataMap == "" then
		return ""
	end

	local jsonDecode = HttpService:JSONDecode(multipageSignupMetadataMap)

	if
		jsonDecode == nil
		or jsonDecode == ""
		or next(jsonDecode) == nil
		or next(jsonDecode) == ""
		or jsonDecode.IncompleteSignupUserId == nil
	then
		return ""
	end

	return jsonDecode.IncompleteSignupUserId
end

function v6.setIncompleteSignupUserId(incompleteSignupUserId)
	if getFFlagEnableMultiPageSignup() then
		local multipageSignupMetadataMap = v6.getMultipageSignupMetadataMap()
		local v7

		if multipageSignupMetadataMap == nil or multipageSignupMetadataMap == "" then
			v7 = { IncompleteSignupUserId = incompleteSignupUserId }
		else
			v7 = HttpService:JSONDecode(multipageSignupMetadataMap)
			v7.IncompleteSignupUserId = incompleteSignupUserId
		end

		v6.setMultipageSignupMetadataMap(HttpService:JSONEncode(v7))
	end
end

function v6.getIncompleteSignupUsername()
	local multipageSignupMetadataMap = v6.getMultipageSignupMetadataMap()

	if multipageSignupMetadataMap == nil or multipageSignupMetadataMap == "" then
		return ""
	end

	local jsonDecode = HttpService:JSONDecode(multipageSignupMetadataMap)

	if
		jsonDecode == nil
		or jsonDecode == ""
		or next(jsonDecode) == nil
		or next(jsonDecode) == ""
		or jsonDecode.IncompleteSignupUsername == nil
	then
		return ""
	end

	return jsonDecode.IncompleteSignupUsername
end

function v6.setIncompleteSignupUsername(incompleteSignupUsername)
	if getFFlagEnableMultiPageSignup() then
		local multipageSignupMetadataMap = v6.getMultipageSignupMetadataMap()
		local v7

		if multipageSignupMetadataMap == nil or multipageSignupMetadataMap == "" then
			v7 = { IncompleteSignupUsername = incompleteSignupUsername }
		else
			v7 = HttpService:JSONDecode(multipageSignupMetadataMap)
			v7.IncompleteSignupUsername = incompleteSignupUsername
		end

		v6.setMultipageSignupMetadataMap(HttpService:JSONEncode(v7))
	end
end

function LUAUFORGE_MODULE_GLOBALS_byr_getMultiPageSignupKey(p2)
	local multipageSignupMetadataMap = v6.getMultipageSignupMetadataMap()

	if multipageSignupMetadataMap == nil or multipageSignupMetadataMap == "" then
		return ""
	end

	local jsonDecode = HttpService:JSONDecode(multipageSignupMetadataMap)

	if
		jsonDecode == nil
		or jsonDecode == ""
		or next(jsonDecode) == nil
		or next(jsonDecode) == ""
		or jsonDecode[p2] == nil
	then
		return ""
	end

	return jsonDecode[p2]
end

function LUAUFORGE_MODULE_GLOBALS_byr_setMultiPageSignupKey(p2, p3)
	if game:GetEngineFeature("MultipageSignupMetadataMapKeyAvailable") then
		local multipageSignupMetadataMap = v6.getMultipageSignupMetadataMap()
		local v7

		if multipageSignupMetadataMap == nil or multipageSignupMetadataMap == "" then
			v7 = { [p2] = p3 }
		else
			v7 = HttpService:JSONDecode(multipageSignupMetadataMap)
			v7[p2] = p3
		end

		v6.setMultipageSignupMetadataMap(HttpService:JSONEncode(v7))
	end
end

function v6.getPasskeySignupUsername()
	return LUAUFORGE_MODULE_GLOBALS_byr_getMultiPageSignupKey("PasskeySignupName")
end

function v6.setPasskeySignupUsername(p2)
	LUAUFORGE_MODULE_GLOBALS_byr_setMultiPageSignupKey("PasskeySignupName", p2)
end

function v6.getPreviousAccountsList()
	if not game:GetEngineFeature("PreviousAccountsListAvailable") then
		return {}
	end

	local item = AppStorageService:GetItem(AuthLocalStorageKeys.PreviousAccountsList) or ""

	if item == "" then
		return {}
	end

	return (HttpService:JSONDecode(item))
end

function v6.setPreviousAccountsList(p2)
	if game:GetEngineFeature("PreviousAccountsListAvailable") then
		local jsonEncode = HttpService:JSONEncode(p2)
		AppStorageService:SetItem(AuthLocalStorageKeys.PreviousAccountsList, jsonEncode)

		AppStorageService:flush()
	end
end

function v6.getLastSuccessfulSignInMethod()
	if game:GetEngineFeature("LastSuccessfulSignInMethodKeyAvailable") then
		return AppStorageService:GetItem(AuthLocalStorageKeys.LastSuccessfulSignInMethod)
	end

	return ""
end

function v6.setLastSuccessfulSignInMethod(p2)
	if game:GetEngineFeature("LastSuccessfulSignInMethodKeyAvailable") then
		AppStorageService:SetItem(AuthLocalStorageKeys.LastSuccessfulSignInMethod, p2)
	end
end

function v6.setDiscoveryClientFallbackCache(p2)
	if game:GetEngineFeature("UniversalAppDiscoveryClientFallbackCacheStorageKey") then
		AppStorageService:SetItem(AuthLocalStorageKeys.DiscoveryClientFallbackCache, p2)
	end
end

function v6.flush()
	AppStorageService:flush()
end

return v6
