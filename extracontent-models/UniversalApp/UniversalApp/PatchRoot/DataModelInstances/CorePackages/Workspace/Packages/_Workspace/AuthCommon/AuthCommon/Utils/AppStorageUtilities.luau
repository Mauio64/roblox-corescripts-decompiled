local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local AuthLocalStorageKeys = require(AuthCommon.Enums.AuthLocalStorageKeys)
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local GetFFlagEnableMultiPageSignup = require(AuthCommonParent.SharedFlags).GetFFlagEnableMultiPageSignup
local GetFStringAccountSwitcherTruthyVariantId = require(AuthCommonParent.SharedFlags).GetFStringAccountSwitcherTruthyVariantId
local GetFStringAccountSwitcherFalsyVariantId = require(AuthCommonParent.SharedFlags).GetFStringAccountSwitcherFalsyVariantId

require(AuthCommon.Utils.PreviousAccountEntry)

local GameParams = require(AuthCommonParent.ExperienceService).GameParams
local _ = {
	passkeySignupName = "PasskeySignupName"
}
local t1 = {
	setRobloxLocaleId = function(p1) -- line: 21
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		AppStorageService:SetItem(AuthLocalStorageKeys.RobloxLocaleId, p1)
	end,
	setGameLocaleId = function(p2) -- line: 26
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		AppStorageService:SetItem(AuthLocalStorageKeys.GameLocaleId, p2)
	end,
	getAuthenticatedTheme = function() -- line: 30
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		return AppStorageService:GetItem(AuthLocalStorageKeys.AuthenticatedTheme)
	end,
	setAuthenticatedTheme = function(p3) -- line: 34
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		AppStorageService:SetItem(AuthLocalStorageKeys.AuthenticatedTheme, p3)
	end,
	getAccountBlob = function() -- line: 38
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		if game:GetEngineFeature("AccountSwitchFeatureEnabled") then
			return AppStorageService:GetItem(AuthLocalStorageKeys.AccountBlob) or ""
		end

		return ""
	end,
	setAccountBlob = function(p4) -- line: 45
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		if game:GetEngineFeature("AccountSwitchFeatureEnabled") then
			AppStorageService:SetItem(AuthLocalStorageKeys.AccountBlob, p4 or "")
		end
	end,
	getDefaultUsername = function() -- line: 51
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		return AppStorageService:GetItem(AuthLocalStorageKeys.CredentialValue)
	end,
	getSignupActionRequired = function() -- line: 55
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		return AppStorageService:GetItem(AuthLocalStorageKeys.SignupActionRequired)
	end,
	setSignupActionRequired = function(p5) -- line: 59
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		AppStorageService:SetItem(AuthLocalStorageKeys.SignupActionRequired, p5)
	end,
	getAccountSwitcherMetadataMap = function() -- line: 63
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
			return AppStorageService:GetItem(AuthLocalStorageKeys.AccountSwitcherMetadataMap) or ""
		end

		return ""
	end,
	setAccountSwitcherMetadataMap = function(p6) -- line: 70
		-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
		if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
			AppStorageService:SetItem(AuthLocalStorageKeys.AccountSwitcherMetadataMap, p6 or "")
		end
	end
}

function t1.setAccountSwitchStartupQueryParams(p7) -- line: 76
	-- upvalues: HttpService (copy), t1 (copy)
	if typeof(p7) == "table" then
		p7 = HttpService:JSONEncode(p7)
	end

	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local v19 = t1.getAccountSwitcherMetadataMap()
		local t2

		if v19 == nil or v19 == "" then
			t2 = {
				AccountSwitchStartupQueryParams = p7
			}
		else
			t2 = HttpService:JSONDecode(v19)
			t2.AccountSwitchStartupQueryParams = p7
		end

		t1.setAccountSwitcherMetadataMap(HttpService:JSONEncode(t2))
	end
end
function t1.clearAccountSwitchStartupGameParams() -- line: 97
	-- upvalues: t1 (copy)
	t1.setAccountSwitchStartupQueryParams("")
end
function t1.getAccountSwitchStartupGameParams() -- line: 101
	-- upvalues: t1 (copy), HttpService (copy), GameParams (copy)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local v21 = t1.getAccountSwitcherMetadataMap()

		if v21 == nil or v21 == "" then
			return nil
		end

		local data = HttpService:JSONDecode(v21)

		if data == nil or data == "" or next(data) == nil or next(data) == "" or data.AccountSwitchTargetUsername == nil then
			return nil
		end

		local AccountSwitchStartupQueryParams = data.AccountSwitchStartupQueryParams

		if AccountSwitchStartupQueryParams == nil or AccountSwitchStartupQueryParams == "" then
			return nil
		end

		local data2 = HttpService:JSONDecode(AccountSwitchStartupQueryParams)
		local v25 = GameParams.fromParams(data2)

		for k, v in pairs(data2) do
			v25[k] = tonumber(v) or (v == "true" or v ~= "false" and v)
		end

		return v25
	end

	return nil
end
function t1.setAccountSwitcherExperimentVariantId(p8) -- line: 153
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
	if game:GetEngineFeature("AccountSwitcherExperimentVariantIdKeyAvailable") then
		AppStorageService:SetItem(AuthLocalStorageKeys.AccountSwitcherExperimentVariantId, p8)
	end
end
function t1.getAccountSwitcherAvailableByVariantId() -- line: 159
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy), GetFStringAccountSwitcherFalsyVariantId (copy), GetFStringAccountSwitcherTruthyVariantId (copy)
	if game:GetEngineFeature("AccountSwitcherExperimentVariantIdKeyAvailable") then
		local Item = AppStorageService:GetItem(AuthLocalStorageKeys.AccountSwitcherExperimentVariantId)

		if Item == GetFStringAccountSwitcherFalsyVariantId() then
			return false
		end

		if Item == GetFStringAccountSwitcherTruthyVariantId() then
			return true
		end

		return nil
	end

	return false
end
function t1.getAccountSwitchTargetUsername() -- line: 178
	-- upvalues: t1 (copy), HttpService (copy)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local v30 = t1.getAccountSwitcherMetadataMap()

		if v30 == nil or v30 == "" then
			return ""
		end

		local data = HttpService:JSONDecode(v30)

		if data == nil or data == "" or next(data) == nil or next(data) == "" or data.AccountSwitchTargetUsername == nil then
			return ""
		end

		return data.AccountSwitchTargetUsername
	end

	return ""
end
function t1.setAccountSwitchTargetUsername(p9) -- line: 199
	-- upvalues: t1 (copy), HttpService (copy)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local v33 = t1.getAccountSwitcherMetadataMap()
		local t3

		if v33 == nil or v33 == "" then
			t3 = {
				AccountSwitchTargetUsername = p9
			}
		else
			t3 = HttpService:JSONDecode(v33)
			t3.AccountSwitchTargetUsername = p9
		end

		t1.setAccountSwitcherMetadataMap(HttpService:JSONEncode(t3))
	end
end
function t1.getAccountSwitchStatus() -- line: 215
	-- upvalues: t1 (copy), HttpService (copy)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local v35 = t1.getAccountSwitcherMetadataMap()

		if v35 == nil or v35 == "" then
			return ""
		end

		local data = HttpService:JSONDecode(v35)

		if data == nil or data == "" or next(data) == nil or next(data) == "" or data.AccountSwitchStatus == nil then
			return ""
		end

		return data.AccountSwitchStatus
	end

	return ""
end
function t1.setAccountSwitchStatus(p10) -- line: 237
	-- upvalues: t1 (copy), HttpService (copy)
	if game:GetEngineFeature("AccountSwitcherMetadataMapKeyAvailable") then
		local v38 = t1.getAccountSwitcherMetadataMap()
		local t4

		if v38 == nil or v38 == "" then
			t4 = {
				AccountSwitchStatus = p10
			}
		else
			t4 = HttpService:JSONDecode(v38)
			t4.AccountSwitchStatus = p10
		end

		t1.setAccountSwitcherMetadataMap(HttpService:JSONEncode(t4))
	end
end
function t1.getMultipageSignupMetadataMap() -- line: 253
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
	return AppStorageService:GetItem(AuthLocalStorageKeys.MultipageSignupMetadataMap) or ""
end
function t1.setMultipageSignupMetadataMap(p11) -- line: 257
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
	AppStorageService:SetItem(AuthLocalStorageKeys.MultipageSignupMetadataMap, p11 or "")
end
function t1.getIncompleteSignupUserId() -- line: 261
	-- upvalues: t1 (copy), HttpService (copy)
	local v41 = t1.getMultipageSignupMetadataMap()

	if v41 == nil or v41 == "" then
		return ""
	end

	local data = HttpService:JSONDecode(v41)

	if data == nil or data == "" or next(data) == nil or next(data) == "" or data.IncompleteSignupUserId == nil then
		return ""
	end

	return data.IncompleteSignupUserId
end
function t1.setIncompleteSignupUserId(s1: string) -- line: 279
	-- upvalues: GetFFlagEnableMultiPageSignup (copy), t1 (copy), HttpService (copy)
	if GetFFlagEnableMultiPageSignup() then
		local v44 = t1.getMultipageSignupMetadataMap()
		local t5

		if v44 == nil or v44 == "" then
			t5 = {
				IncompleteSignupUserId = s1
			}
		else
			t5 = HttpService:JSONDecode(v44)
			t5.IncompleteSignupUserId = s1
		end

		t1.setMultipageSignupMetadataMap(HttpService:JSONEncode(t5))
	end
end
function t1.getIncompleteSignupUsername() -- line: 295
	-- upvalues: t1 (copy), HttpService (copy)
	local v46 = t1.getMultipageSignupMetadataMap()

	if v46 == nil or v46 == "" then
		return ""
	end

	local data = HttpService:JSONDecode(v46)

	if data == nil or data == "" or next(data) == nil or next(data) == "" or data.IncompleteSignupUsername == nil then
		return ""
	end

	return data.IncompleteSignupUsername
end
function t1.setIncompleteSignupUsername(s2: string) -- line: 313
	-- upvalues: GetFFlagEnableMultiPageSignup (copy), t1 (copy), HttpService (copy)
	if GetFFlagEnableMultiPageSignup() then
		local v49 = t1.getMultipageSignupMetadataMap()
		local t6

		if v49 == nil or v49 == "" then
			t6 = {
				IncompleteSignupUsername = s2
			}
		else
			t6 = HttpService:JSONDecode(v49)
			t6.IncompleteSignupUsername = s2
		end

		t1.setMultipageSignupMetadataMap(HttpService:JSONEncode(t6))
	end
end
function getMultiPageSignupKey(s3: string) -- line: 329
	-- upvalues: t1 (copy), HttpService (copy)
	local v52 = t1.getMultipageSignupMetadataMap()

	if v52 == nil or v52 == "" then
		return ""
	end

	local data = HttpService:JSONDecode(v52)

	if data == nil or data == "" or next(data) == nil or next(data) == "" or data[s3] == nil then
		return ""
	end

	return data[s3]
end
function setMultiPageSignupKey(s4: string, s5: string) -- line: 341
	-- upvalues: t1 (copy), HttpService (copy)
	if game:GetEngineFeature("MultipageSignupMetadataMapKeyAvailable") then
		local v56 = t1.getMultipageSignupMetadataMap()
		local t7

		if v56 == nil or v56 == "" then
			t7 = {
				[s4] = s5
			}
		else
			t7 = HttpService:JSONDecode(v56)
			t7[s4] = s5
		end

		t1.setMultipageSignupMetadataMap(HttpService:JSONEncode(t7))
	end
end
function t1.getPasskeySignupUsername() -- line: 357
	return getMultiPageSignupKey("PasskeySignupName")
end
function t1.setPasskeySignupUsername(s6: string) -- line: 361
	setMultiPageSignupKey("PasskeySignupName", s6)
end
function t1.getPreviousAccountsList() -- line: 365
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy), HttpService (copy)
	if game:GetEngineFeature("PreviousAccountsListAvailable") then
		local v59 = AppStorageService:GetItem(AuthLocalStorageKeys.PreviousAccountsList) or ""

		if v59 == "" then
			return {}
		end

		return (HttpService:JSONDecode(v59))
	end

	return {}
end
function t1.setPreviousAccountsList(t8: {[any]: any}) -- line: 379
	-- upvalues: HttpService (copy), AppStorageService (copy), AuthLocalStorageKeys (copy)
	if game:GetEngineFeature("PreviousAccountsListAvailable") then
		local json = HttpService:JSONEncode(t8)

		AppStorageService:SetItem(AuthLocalStorageKeys.PreviousAccountsList, json)
		AppStorageService:flush()
	end
end
function t1.getLastSuccessfulSignInMethod() -- line: 390
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
	if game:GetEngineFeature("LastSuccessfulSignInMethodKeyAvailable") then
		return AppStorageService:GetItem(AuthLocalStorageKeys.LastSuccessfulSignInMethod)
	end

	return ""
end
function t1.setLastSuccessfulSignInMethod(s7: string) -- line: 397
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
	if game:GetEngineFeature("LastSuccessfulSignInMethodKeyAvailable") then
		AppStorageService:SetItem(AuthLocalStorageKeys.LastSuccessfulSignInMethod, s7)
	end
end
function t1.setDiscoveryClientFallbackCache(s8: string) -- line: 403
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
	if game:GetEngineFeature("UniversalAppDiscoveryClientFallbackCacheStorageKey") then
		AppStorageService:SetItem(AuthLocalStorageKeys.DiscoveryClientFallbackCache, s8)
	end
end
function t1.flush() -- line: 409
	-- upvalues: AppStorageService (copy)
	AppStorageService:flush()
end

return t1
