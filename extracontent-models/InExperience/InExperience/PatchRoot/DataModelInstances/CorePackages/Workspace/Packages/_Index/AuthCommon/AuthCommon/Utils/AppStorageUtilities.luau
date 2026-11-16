local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local AuthLocalStorageKeys = require(AuthCommon.Enums.AuthLocalStorageKeys)
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableMultiPageSignup = SharedFlags.GetFFlagEnableMultiPageSignup

require(AuthCommon.Utils.PreviousAccountEntry)
local ExperienceService = require(parent.ExperienceService)
local GameParams = ExperienceService.GameParams

local _ = { passkeySignupName = "PasskeySignupName" }

local AppStorageUtilities = {}

function AppStorageUtilities.setRobloxLocaleId(p)
	AppStorageService:SetItem(AuthLocalStorageKeys.RobloxLocaleId, p)
end

function AppStorageUtilities.setGameLocaleId(p)
	AppStorageService:SetItem(AuthLocalStorageKeys.GameLocaleId, p)
end

function AppStorageUtilities.getAuthenticatedTheme()
	return AppStorageService:GetItem(AuthLocalStorageKeys.AuthenticatedTheme)
end

function AppStorageUtilities.setAuthenticatedTheme(p)
	AppStorageService:SetItem(AuthLocalStorageKeys.AuthenticatedTheme, p)
end

function AppStorageUtilities.getAccountBlob()
	if game:GetEngineFeature("AccountSwitchFeatureEnabled") then
		return AppStorageService:GetItem(AuthLocalStorageKeys.AccountBlob) or ""
	end

	return ""
end

function AppStorageUtilities.setAccountBlob(value)
	if game:GetEngineFeature("AccountSwitchFeatureEnabled") then
		AppStorageService:SetItem(AuthLocalStorageKeys.AccountBlob, value or "")
	end
end

function AppStorageUtilities.getDefaultUsername()
	return AppStorageService:GetItem(AuthLocalStorageKeys.CredentialValue)
end

function AppStorageUtilities.getSignupActionRequired()
	return AppStorageService:GetItem(AuthLocalStorageKeys.SignupActionRequired)
end

function AppStorageUtilities.setSignupActionRequired(p)
	AppStorageService:SetItem(AuthLocalStorageKeys.SignupActionRequired, p)
end

function AppStorageUtilities.getAccountSwitcherMetadataMap()
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		return AppStorageService:GetItem(AuthLocalStorageKeys.AccountSwitcherMetadataMap) or ""
	end

	return ""
end

function AppStorageUtilities.setAccountSwitcherMetadataMap(value)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		AppStorageService:SetItem(AuthLocalStorageKeys.AccountSwitcherMetadataMap, value or "")
	end
end

function AppStorageUtilities.setAccountSwitchStartupQueryParams(accountSwitchStartupQueryParams)
	if typeof(accountSwitchStartupQueryParams) == "table" then
		accountSwitchStartupQueryParams = HttpService:JSONEncode(accountSwitchStartupQueryParams)
	end

	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local accountSwitcherMetadataMap = AppStorageUtilities.getAccountSwitcherMetadataMap()
		local v

		if accountSwitcherMetadataMap == nil or accountSwitcherMetadataMap == "" then
			v = { AccountSwitchStartupQueryParams = accountSwitchStartupQueryParams }
		else
			v = HttpService:JSONDecode(accountSwitcherMetadataMap)
			v.AccountSwitchStartupQueryParams = accountSwitchStartupQueryParams
		end

		AppStorageUtilities.setAccountSwitcherMetadataMap(HttpService:JSONEncode(v))
	end
end

function AppStorageUtilities.clearAccountSwitchStartupGameParams()
	AppStorageUtilities.setAccountSwitchStartupQueryParams("")
end

function AppStorageUtilities.getAccountSwitchStartupGameParams()
	if not game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		return nil
	end

	local accountSwitcherMetadataMap = AppStorageUtilities.getAccountSwitcherMetadataMap()

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

	local result = GameParams.fromParams(jsonDecode2)

	local function fn(p) -- 1 equivalent call inferred from this helper
		return tonumber(p) or p == "true" or p ~= "false" and p
	end

	for k, v in pairs(jsonDecode2) do
		v = fn(v) -- inferred equivalent call
		result[k] = v
	end

	return result
end

function AppStorageUtilities.getAccountSwitchTargetUsername()
	if not game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		return ""
	end

	local accountSwitcherMetadataMap = AppStorageUtilities.getAccountSwitcherMetadataMap()

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

function AppStorageUtilities.setAccountSwitchTargetUsername(accountSwitchTargetUsername)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local accountSwitcherMetadataMap = AppStorageUtilities.getAccountSwitcherMetadataMap()
		local v

		if accountSwitcherMetadataMap == nil or accountSwitcherMetadataMap == "" then
			v = { AccountSwitchTargetUsername = accountSwitchTargetUsername }
		else
			v = HttpService:JSONDecode(accountSwitcherMetadataMap)
			v.AccountSwitchTargetUsername = accountSwitchTargetUsername
		end

		AppStorageUtilities.setAccountSwitcherMetadataMap(HttpService:JSONEncode(v))
	end
end

function AppStorageUtilities.getAccountSwitchStatus()
	if not game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		return ""
	end

	local accountSwitcherMetadataMap = AppStorageUtilities.getAccountSwitcherMetadataMap()

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

function AppStorageUtilities.setAccountSwitchStatus(accountSwitchStatus)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local accountSwitcherMetadataMap = AppStorageUtilities.getAccountSwitcherMetadataMap()
		local v

		if accountSwitcherMetadataMap == nil or accountSwitcherMetadataMap == "" then
			v = { AccountSwitchStatus = accountSwitchStatus }
		else
			v = HttpService:JSONDecode(accountSwitcherMetadataMap)
			v.AccountSwitchStatus = accountSwitchStatus
		end

		AppStorageUtilities.setAccountSwitcherMetadataMap(HttpService:JSONEncode(v))
	end
end

function AppStorageUtilities.getMultipageSignupMetadataMap()
	return AppStorageService:GetItem(AuthLocalStorageKeys.MultipageSignupMetadataMap) or ""
end

function AppStorageUtilities.setMultipageSignupMetadataMap(value)
	AppStorageService:SetItem(AuthLocalStorageKeys.MultipageSignupMetadataMap, value or "")
end

function AppStorageUtilities.getIncompleteSignupUserId()
	local multipageSignupMetadataMap = AppStorageUtilities.getMultipageSignupMetadataMap()

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

function AppStorageUtilities.setIncompleteSignupUserId(incompleteSignupUserId: string)
	if GetFFlagEnableMultiPageSignup() then
		local multipageSignupMetadataMap = AppStorageUtilities.getMultipageSignupMetadataMap()
		local v

		if multipageSignupMetadataMap == nil or multipageSignupMetadataMap == "" then
			v = { IncompleteSignupUserId = incompleteSignupUserId }
		else
			v = HttpService:JSONDecode(multipageSignupMetadataMap)
			v.IncompleteSignupUserId = incompleteSignupUserId
		end

		AppStorageUtilities.setMultipageSignupMetadataMap(HttpService:JSONEncode(v))
	end
end

function AppStorageUtilities.getIncompleteSignupUsername()
	local multipageSignupMetadataMap = AppStorageUtilities.getMultipageSignupMetadataMap()

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

function AppStorageUtilities.setIncompleteSignupUsername(incompleteSignupUsername: string)
	if GetFFlagEnableMultiPageSignup() then
		local multipageSignupMetadataMap = AppStorageUtilities.getMultipageSignupMetadataMap()
		local v

		if multipageSignupMetadataMap == nil or multipageSignupMetadataMap == "" then
			v = { IncompleteSignupUsername = incompleteSignupUsername }
		else
			v = HttpService:JSONDecode(multipageSignupMetadataMap)
			v.IncompleteSignupUsername = incompleteSignupUsername
		end

		AppStorageUtilities.setMultipageSignupMetadataMap(HttpService:JSONEncode(v))
	end
end

function getMultiPageSignupKey(p: string)
	local multipageSignupMetadataMap = AppStorageUtilities.getMultipageSignupMetadataMap()

	if multipageSignupMetadataMap == nil or multipageSignupMetadataMap == "" then
		return ""
	end

	local jsonDecode = HttpService:JSONDecode(multipageSignupMetadataMap)

	if
		jsonDecode == nil
		or jsonDecode == ""
		or next(jsonDecode) == nil
		or next(jsonDecode) == ""
		or jsonDecode[p] == nil
	then
		return ""
	end

	return jsonDecode[p]
end

function setMultiPageSignupKey(p: string, p2: string)
	if game:GetEngineFeature("MultipageSignupMetadataMapKeyAvailable") then
		local multipageSignupMetadataMap = AppStorageUtilities.getMultipageSignupMetadataMap()
		local v

		if multipageSignupMetadataMap == nil or multipageSignupMetadataMap == "" then
			v = { [p] = p2 }
		else
			v = HttpService:JSONDecode(multipageSignupMetadataMap)
			v[p] = p2
		end

		AppStorageUtilities.setMultipageSignupMetadataMap(HttpService:JSONEncode(v))
	end
end

function AppStorageUtilities.getPasskeySignupUsername()
	return getMultiPageSignupKey("PasskeySignupName")
end

function AppStorageUtilities.setPasskeySignupUsername(p: string)
	setMultiPageSignupKey("PasskeySignupName", p)
end

function AppStorageUtilities.getPreviousAccountsList()
	if not game:GetEngineFeature("PreviousAccountsListAvailable") then
		return {}
	end

	local item = AppStorageService:GetItem(AuthLocalStorageKeys.PreviousAccountsList) or ""

	if item == "" then
		return {}
	end

	return (HttpService:JSONDecode(item))
end

function AppStorageUtilities.setPreviousAccountsList(p)
	if game:GetEngineFeature("PreviousAccountsListAvailable") then
		local jsonEncode = HttpService:JSONEncode(p)
		AppStorageService:SetItem(AuthLocalStorageKeys.PreviousAccountsList, jsonEncode)

		AppStorageService:flush()
	end
end

function AppStorageUtilities.getLastSuccessfulSignInMethod()
	if game:GetEngineFeature("LastSuccessfulSignInMethodKeyAvailable") then
		return AppStorageService:GetItem(AuthLocalStorageKeys.LastSuccessfulSignInMethod)
	end

	return ""
end

function AppStorageUtilities.setLastSuccessfulSignInMethod(p: string)
	if game:GetEngineFeature("LastSuccessfulSignInMethodKeyAvailable") then
		AppStorageService:SetItem(AuthLocalStorageKeys.LastSuccessfulSignInMethod, p)
	end
end

function AppStorageUtilities.setDiscoveryClientFallbackCache(p: string)
	if game:GetEngineFeature("UniversalAppDiscoveryClientFallbackCacheStorageKey") then
		AppStorageService:SetItem(AuthLocalStorageKeys.DiscoveryClientFallbackCache, p)
	end
end

function AppStorageUtilities.flush()
	AppStorageService:flush()
end

return AppStorageUtilities
