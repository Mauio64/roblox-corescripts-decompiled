local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local AmpUpsell = require(parent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local MarketingConsentOptInMethod = require(AccountUpgrade.MarketingConsentOptInMethod)
local FStringAccountUpgradeAmpNameSpace = require(AccountUpgrade.Flags.FStringAccountUpgradeAmpNameSpace)

local FStringAccountUpgradeMarketingConsentAmpFeatureName = require(AccountUpgrade.Flags.FStringAccountUpgradeMarketingConsentAmpFeatureName)

local FStringAccountUpgradeMarketingConsentGateAmpFeatureName = require(AccountUpgrade.Flags.FStringAccountUpgradeMarketingConsentGateAmpFeatureName)

local FStringDebugAccountUpgradeMarketingConsentOverride = require(AccountUpgrade.Flags.FStringDebugAccountUpgradeMarketingConsentOverride)

local function getMarketingConsentOptInMethod()
	if FStringDebugAccountUpgradeMarketingConsentOverride == "AutoOptIn" then
		return MarketingConsentOptInMethod.AutoOptIn
	elseif FStringDebugAccountUpgradeMarketingConsentOverride == "Checkbox" then
		return MarketingConsentOptInMethod.Checkbox
	end

	local v = FStringAccountUpgradeMarketingConsentGateAmpFeatureName
	local v2 = FStringAccountUpgradeMarketingConsentAmpFeatureName

	if v == "" or v2 == "" then
		return MarketingConsentOptInMethod.None
	end

	local success, result = pcall(function()
		return AmpApiProvider.getFeatureAccess({ v, v2 }, FStringAccountUpgradeAmpNameSpace)
	end)

	if not success or type(result) ~= "table" or type(result.featureAccessList) ~= "table" then
		return MarketingConsentOptInMethod.None
	end

	local accessesByFeature = {}

	for _, featureAccess in result.featureAccessList do
		if not (type(featureAccess) == "table" and type(featureAccess.feature) == "string") then
			continue
		end

		accessesByFeature[featureAccess.feature] = featureAccess.access
	end

	if accessesByFeature[v] ~= AccessResponseEnum.Granted then
		return MarketingConsentOptInMethod.None
	end

	local v3 = accessesByFeature[v2]

	if v3 == AccessResponseEnum.Granted then
		return MarketingConsentOptInMethod.AutoOptIn
	end

	if v3 == AccessResponseEnum.Denied then
		return MarketingConsentOptInMethod.Checkbox
	end

	return MarketingConsentOptInMethod.None
end

return getMarketingConsentOptInMethod
