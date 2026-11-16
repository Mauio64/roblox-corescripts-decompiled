local parent = script.Parent.Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastInt = game:DefineFastInt("FlyoutTestVariantRollout12", -1)
local defineFastFlag = game:DefineFastFlag("EnableFlyoutIxp11", false)

local defineFastString = game:DefineFastString("FlyoutIxpLayer", "Universality.MorePage")
local defineFastString2 = game:DefineFastString("FlyoutIxpVariantKey", "flyout_side_panel_type")

local defineFastInt2 = game:DefineFastInt("IxpFlyoutControl", 0)
local defineFastInt3 = game:DefineFastInt("IxpFlyoutVariantAlternateEntry", 1)
local defineFastInt4 = game:DefineFastInt("IxpFlyoutVariantHamburger", 2)
local defineFastInt5 = game:DefineFastInt("IxpFlyoutVariantNoSubTabs", 3)
local defineFastInt6 = game:DefineFastInt("IxpFlyoutVariantRemovalRobuxIcon", 4)
local defineFastFlag2 = game:DefineFastFlag("FlyoutShowFriendsSortForCurrentVariant", false)
local defineFastFlag3 = game:DefineFastFlag("EnableFlyoutExposure", false)
local defineFastFlag4 = game:DefineFastFlag("FlyoutHamburgerEnableProfileEntry", false)
local defineFastFlag5 = game:DefineFastFlag("FlyoutFacepileEnableProfileEntry", false)

local defineFastFlag6 = game:DefineFastFlag("FlyoutDisallowAlternativeEntryOnProfileEntryEnabled", false)
local SharedFlags = require(parent.SharedFlags)
local FFlagSubTabRemoveFlyoutDependency = SharedFlags.FFlagSubTabRemoveFlyoutDependency

local SharedFlags2 = require(parent.SharedFlags)
local FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency = SharedFlags2.FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency

local defineFastFlag7 = game:DefineFastFlag("HiddenFriendsSortHeaderAddSubTabDependency", false)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags3.FFlagAppIaHomeSubTab
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableChartsInFlyout = SharedFlags4.FFlagEnableChartsInFlyout

local defineFastInt7 = game:DefineFastInt("FlyoutAmpGatedVariant", 2)
local SharedFlags5 = require(parent.SharedFlags)
local FFlagFlyoutSidePanelUseAppPolicy = SharedFlags5.FFlagFlyoutSidePanelUseAppPolicy
local UniversalAppPolicy

if FFlagFlyoutSidePanelUseAppPolicy then
	UniversalAppPolicy = require(parent.UniversalAppPolicy)
else
	UniversalAppPolicy = nil
end

local v = nil
local variant = nil

local function getIXPVariant()
	if defineFastInt ~= -1 then
		return defineFastInt
	end

	if not defineFastFlag then
		return defineFastInt2
	end

	if v == nil then
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if defineFastFlag3 and layerVariables ~= nil then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end

		v = layerVariables or {}
	end

	local v2 = v[defineFastString2]

	if v2 == nil then
		return defineFastInt2
	end

	return (tonumber(v2))
end

local function getVariant() -- 7 equivalent calls inferred from this helper
	if variant ~= nil then
		return variant
	end

	if FFlagFlyoutSidePanelUseAppPolicy and UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
		variant = defineFastInt7
	else
		variant = getIXPVariant()
	end

	return variant
end

local function isFlyoutSidePanelEnabled(): boolean -- 2 equivalent calls inferred from this helper
	local v2

	if FFlagFlyoutSidePanelUseAppPolicy then
		v2 = getVariant() -- inferred equivalent call
	else
		v2 = getIXPVariant()
	end

	return v2 ~= defineFastInt2
end

local function isRobloxLogoEnabled(): boolean
	local v2

	if FFlagFlyoutSidePanelUseAppPolicy then
		v2 = getVariant() -- inferred equivalent call
	else
		v2 = getIXPVariant()
	end

	return v2 ~= defineFastInt2
end

local function isProfileEntryRemoved(): boolean -- 1 equivalent call inferred from this helper
	local v2

	if FFlagFlyoutSidePanelUseAppPolicy then
		v2 = getVariant() -- inferred equivalent call
	else
		v2 = getIXPVariant()
	end

	if defineFastFlag4 and v2 == defineFastInt4 then
		return false
	end

	return (not defineFastFlag5 or v2 ~= defineFastInt3 and v2 ~= defineFastInt5) and v2 ~= defineFastInt2
end

local function isChartsInFlyoutEnabled() -- 2 equivalent calls inferred from this helper
	return FFlagEnableChartsInFlyout and isFlyoutSidePanelEnabled() -- inferred equivalent call
end

local function isFriendsSortHeaderHiddenInFlyoutIxp()
	if FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency then
		if isChartsInFlyoutEnabled() then -- inferred equivalent call
			return false
		end

		if defineFastFlag7 then
			return FFlagAppIaHomeSubTab and not defineFastFlag2
		end

		return not defineFastFlag2
	end

	return isFlyoutSidePanelEnabled() and not defineFastFlag2 -- inferred equivalent call
end

local function isAlternateEntryPointEnabled()
	local v2

	if FFlagFlyoutSidePanelUseAppPolicy then
		v2 = getVariant() -- inferred equivalent call
	else
		v2 = getIXPVariant()
	end

	if not defineFastFlag6 then
		return v2 == defineFastInt3 or v2 == defineFastInt5
	end

	return isProfileEntryRemoved() and (v2 == defineFastInt3 or v2 == defineFastInt5) -- inferred equivalent call
end

local function isRobuxIconRemoved(): boolean
	local v2

	if FFlagFlyoutSidePanelUseAppPolicy then
		v2 = getVariant() -- inferred equivalent call
	else
		v2 = getIXPVariant()
	end

	return v2 == defineFastInt6
end

local function isScrollAwayEnabled(): boolean
	local v2

	if FFlagFlyoutSidePanelUseAppPolicy then
		v2 = getVariant() -- inferred equivalent call
	else
		v2 = getIXPVariant()
	end

	return v2 ~= defineFastInt2
end

local function isHomeSubTabEnabled(): boolean
	if isChartsInFlyoutEnabled() then -- inferred equivalent call
		return false
	end

	if FFlagSubTabRemoveFlyoutDependency then
		return true
	end

	local v2

	if FFlagFlyoutSidePanelUseAppPolicy then
		v2 = getVariant() -- inferred equivalent call
	else
		v2 = getIXPVariant()
	end

	return v2 == defineFastInt3 or v2 == defineFastInt4
end

return {
	isFlyoutSidePanelEnabled = isFlyoutSidePanelEnabled,
	isRobloxLogoEnabled = isRobloxLogoEnabled,
	isProfileEntryRemoved = isProfileEntryRemoved,
	isFriendsSortHeaderHiddenInFlyoutIxp = isFriendsSortHeaderHiddenInFlyoutIxp,
	isAlternateEntryPointEnabled = isAlternateEntryPointEnabled,
	isRobuxIconRemoved = isRobuxIconRemoved,
	isScrollAwayEnabled = isScrollAwayEnabled,
	isHomeSubTabEnabled = isHomeSubTabEnabled,
	isChartsInFlyoutEnabled = isChartsInFlyoutEnabled
}
