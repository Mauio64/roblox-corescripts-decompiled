local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AmpUpsell")
local ampApiProvider = AmpUpsell.AmpApiProvider
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local FFlagAccountUpgradeInExpGate = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeInExpGate")
local FStringAccountUpgradeAmpFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FStringAccountUpgradeAmpFeatureName")
local FStringAccountUpgradeAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FStringAccountUpgradeAmpNameSpace")

local function malformedAvailability(p2)
	return {
		granted = false,
		access = (type(p2) ~= "table" or type(p2.access) ~= "string") and "Malformed" or p2.access
	}
end

local function getPioneerAccountUpgradeAvailability()
	if not FFlagAccountUpgradeInExpGate then
		return { granted = false, access = "Disabled" }
	end

	local v5 = FStringAccountUpgradeAmpFeatureName
	local v6 = FStringAccountUpgradeAmpNameSpace

	if v5 == "" or v6 == "" then
		return { granted = false, access = "Misconfigured" }
	end

	local success, result = pcall(function()
		return ampApiProvider.getFeatureAccess({ v5 }, v6)
	end)

	if not success then
		return { granted = false, access = accessResponseEnum.Error }
	end

	if type(result) ~= "table" then
		return {
			granted = false,
			access = (type(result) ~= "table" or type(result.access) ~= "string") and "Malformed" or result.access
		}
	end

	local featureAccessList = result.featureAccessList

	if type(featureAccessList) ~= "table" or type(featureAccessList[1]) ~= "table" then
		return {
			granted = false,
			access = (type(result) ~= "table" or type(result.access) ~= "string") and "Malformed" or result.access
		}
	end

	local access = featureAccessList[1].access

	if type(access) == "string" then
		return {
			granted = access == accessResponseEnum.Granted,
			access = access
		}
	end

	return {
		granted = false,
		access = (type(result) ~= "table" or type(result.access) ~= "string") and "Malformed" or result.access
	}
end

return getPioneerAccountUpgradeAvailability
