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
local FFlagEnableSubTabOverride = SharedFlags4.FFlagEnableSubTabOverride
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSubTabHideChartsForNonArgo = SharedFlags5.FFlagSubTabHideChartsForNonArgo
local SharedFlags6 = require(parent.SharedFlags)
local FFlagEnableChartsInFlyout = SharedFlags6.FFlagEnableChartsInFlyout

local defineFastInt7 = game:DefineFastInt("FlyoutAmpGatedVariant", 2)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

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

	if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
		variant = defineFastInt7
	else
		variant = getIXPVariant()
	end

	return variant
end

local function isFlyoutSidePanelEnabled(): boolean -- 2 equivalent calls inferred from this helper
	return getVariant() ~= defineFastInt2 -- inferred equivalent call
end

local function isRobloxLogoEnabled(): boolean
	return getVariant() ~= defineFastInt2 -- inferred equivalent call
end

local function isProfileEntryRemoved(): boolean -- 1 equivalent call inferred from this helper
	local variant2 = getVariant() -- inferred equivalent call

	if
		defineFastFlag4 and variant2 == defineFastInt4
		or defineFastFlag5 and (variant2 == defineFastInt3 or variant2 == defineFastInt5)
	then
		return false
	end

	return variant2 ~= defineFastInt2
end

local function isChartsInFlyoutEnabled() -- 3 equivalent calls inferred from this helper
	return FFlagEnableChartsInFlyout and isFlyoutSidePanelEnabled() -- inferred equivalent call
end

local function isAlternateEntryPointEnabled()
	local variant2 = getVariant() -- inferred equivalent call

	if not defineFastFlag6 then
		return variant2 == defineFastInt3 or variant2 == defineFastInt5
	end

	return isProfileEntryRemoved() and (variant2 == defineFastInt3 or variant2 == defineFastInt5) -- inferred equivalent call
end

local function isRobuxIconRemoved(): boolean
	return getVariant() == defineFastInt6 -- inferred equivalent call
end

local function isScrollAwayEnabled(): boolean
	return getVariant() ~= defineFastInt2 -- inferred equivalent call
end

local function isHomeSubTabEnabled(): boolean
	if FFlagEnableSubTabOverride then
		return true
	end

	if isChartsInFlyoutEnabled() then -- inferred equivalent call
		return false
	end

	if FFlagSubTabRemoveFlyoutDependency then
		return true
	end

	local variant2 = getVariant() -- inferred equivalent call

	return variant2 == defineFastInt3 or variant2 == defineFastInt4
end

local function isChartsInSubTab(): boolean
	local v2 = FFlagSubTabHideChartsForNonArgo

	if not v2 then
		v2 = isChartsInFlyoutEnabled() -- inferred equivalent call
	end

	return not v2
end

local function isFriendsSortHeaderHiddenInFlyoutIxp()
	if FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency then
		if FFlagEnableSubTabOverride then
			return not defineFastFlag2
		end

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

return {
	isFlyoutSidePanelEnabled = isFlyoutSidePanelEnabled,
	isRobloxLogoEnabled = isRobloxLogoEnabled,
	isProfileEntryRemoved = isProfileEntryRemoved,
	isFriendsSortHeaderHiddenInFlyoutIxp = isFriendsSortHeaderHiddenInFlyoutIxp,
	isAlternateEntryPointEnabled = isAlternateEntryPointEnabled,
	isRobuxIconRemoved = isRobuxIconRemoved,
	isScrollAwayEnabled = isScrollAwayEnabled,
	isHomeSubTabEnabled = isHomeSubTabEnabled,
	isChartsInSubTab = isChartsInSubTab,
	isChartsInFlyoutEnabled = isChartsInFlyoutEnabled
}
