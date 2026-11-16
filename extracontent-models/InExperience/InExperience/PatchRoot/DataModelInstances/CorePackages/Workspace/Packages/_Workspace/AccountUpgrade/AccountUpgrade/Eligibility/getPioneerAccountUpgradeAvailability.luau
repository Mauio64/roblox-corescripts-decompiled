local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local AmpUpsell = require(parent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local FFlagAccountUpgradeInExpGate = require(AccountUpgrade.Flags.FFlagAccountUpgradeInExpGate)
local FStringAccountUpgradeAmpFeatureName = require(AccountUpgrade.Flags.FStringAccountUpgradeAmpFeatureName)
local FStringAccountUpgradeAmpNameSpace = require(AccountUpgrade.Flags.FStringAccountUpgradeAmpNameSpace)

local function malformedAvailability(result) -- 3 equivalent calls inferred from this helper
	return {
		granted = false,
		access = (type(result) ~= "table" or type(result.access) ~= "string") and "Malformed" or result.access
	}
end

local function getPioneerAccountUpgradeAvailability()
	if not FFlagAccountUpgradeInExpGate then
		return { granted = false, access = "Disabled" }
	end

	local v = FStringAccountUpgradeAmpFeatureName
	local v2 = FStringAccountUpgradeAmpNameSpace

	if v == "" or v2 == "" then
		return { granted = false, access = "Misconfigured" }
	end

	local success, result = pcall(function()
		return AmpApiProvider.getFeatureAccess({ v }, v2)
	end)

	if not success then
		return { granted = false, access = AccessResponseEnum.Error }
	end

	if type(result) ~= "table" then
		return malformedAvailability(result) -- inferred equivalent call
	end

	local featureAccessList = result.featureAccessList

	if type(featureAccessList) ~= "table" or type(featureAccessList[1]) ~= "table" then
		return malformedAvailability(result) -- inferred equivalent call
	end

	local access = featureAccessList[1].access

	if type(access) == "string" then
		return {
			granted = access == AccessResponseEnum.Granted,
			access = access
		}
	end

	return malformedAvailability(result) -- inferred equivalent call
end

return getPioneerAccountUpgradeAvailability
