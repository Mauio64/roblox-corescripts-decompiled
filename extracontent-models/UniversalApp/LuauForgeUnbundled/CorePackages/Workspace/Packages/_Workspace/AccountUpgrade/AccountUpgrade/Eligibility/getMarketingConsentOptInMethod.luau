local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AmpUpsell")
local ampApiProvider = AmpUpsell.AmpApiProvider
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local MarketingConsentOptInMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MarketingConsentOptInMethod")
local FStringAccountUpgradeAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FStringAccountUpgradeAmpNameSpace")

local FStringAccountUpgradeMarketingConsentAmpFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FStringAccountUpgradeMarketingConsentAmpFeatureName")

local FStringAccountUpgradeMarketingConsentGateAmpFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FStringAccountUpgradeMarketingConsentGateAmpFeatureName")

local FStringDebugAccountUpgradeMarketingConsentOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FStringDebugAccountUpgradeMarketingConsentOverride")

local function getMarketingConsentOptInMethod()
	if FStringDebugAccountUpgradeMarketingConsentOverride == "AutoOptIn" then
		return MarketingConsentOptInMethod.AutoOptIn
	elseif FStringDebugAccountUpgradeMarketingConsentOverride == "Checkbox" then
		return MarketingConsentOptInMethod.Checkbox
	end

	local v5 = FStringAccountUpgradeMarketingConsentGateAmpFeatureName
	local v6 = FStringAccountUpgradeMarketingConsentAmpFeatureName

	if v5 == "" or v6 == "" then
		return MarketingConsentOptInMethod.None
	end

	local success, result = pcall(function()
		return ampApiProvider.getFeatureAccess({ v5, v6 }, FStringAccountUpgradeAmpNameSpace)
	end)

	if not success or type(result) ~= "table" or type(result.featureAccessList) ~= "table" then
		return MarketingConsentOptInMethod.None
	end

	local accessesByFeature = {}

	for k, featureAccess in result.featureAccessList do
		if not (type(featureAccess) == "table" and type(featureAccess.feature) == "string") then
			continue
		end

		accessesByFeature[featureAccess.feature] = featureAccess.access
	end

	if accessesByFeature[v5] ~= accessResponseEnum.Granted then
		return MarketingConsentOptInMethod.None
	end

	local v7 = accessesByFeature[v6]

	if v7 == accessResponseEnum.Granted then
		return MarketingConsentOptInMethod.AutoOptIn
	end

	if v7 == accessResponseEnum.Denied then
		return MarketingConsentOptInMethod.Checkbox
	end

	return MarketingConsentOptInMethod.None
end

return getMarketingConsentOptInMethod
