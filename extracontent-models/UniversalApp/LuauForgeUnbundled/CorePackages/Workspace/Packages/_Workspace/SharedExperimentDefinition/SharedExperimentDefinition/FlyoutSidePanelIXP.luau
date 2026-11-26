local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/ExperimentCacheManager").ExperimentCacheManager

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
local fFlagSubTabRemoveFlyoutDependency = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/SharedFlags").FFlagSubTabRemoveFlyoutDependency

local fFlagHiddenFriendsSortHeaderRemoveFlyoutDependency = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/SharedFlags").FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency

local defineFastFlag7 = game:DefineFastFlag("HiddenFriendsSortHeaderAddSubTabDependency", false)
local fFlagAppIaHomeSubTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/SharedFlags").FFlagAppIaHomeSubTab
local fFlagEnableSubTabOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/SharedFlags").FFlagEnableSubTabOverride
local fFlagSubTabHideChartsForNonArgo = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/SharedFlags").FFlagSubTabHideChartsForNonArgo
local fFlagEnableChartsInFlyout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/SharedFlags").FFlagEnableChartsInFlyout

local defineFastInt7 = game:DefineFastInt("FlyoutAmpGatedVariant", 2)
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/UniversalAppPolicy")

local v5 = nil
local variant = nil

local function getIXPVariant()
	if defineFastInt ~= -1 then
		return defineFastInt
	end

	if not defineFastFlag then
		return defineFastInt2
	end

	if v5 == nil then
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if defineFastFlag3 and layerVariables ~= nil then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end

		v5 = layerVariables or {}
	end

	local v6 = v5[defineFastString2]

	if v6 == nil then
		return defineFastInt2
	end

	return (tonumber(v6))
end

local function getVariant()
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

return {
	isFlyoutSidePanelEnabled = function(): boolean
		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		return variant ~= defineFastInt2
	end,
	isRobloxLogoEnabled = function(): boolean
		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		return variant ~= defineFastInt2
	end,
	isProfileEntryRemoved = function(): boolean
		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		local v6 = variant

		if
			defineFastFlag4 and v6 == defineFastInt4
			or defineFastFlag5 and (v6 == defineFastInt3 or v6 == defineFastInt5)
		then
			return false
		end

		return v6 ~= defineFastInt2
	end,
	isFriendsSortHeaderHiddenInFlyoutIxp = function()
		if fFlagHiddenFriendsSortHeaderRemoveFlyoutDependency then
			if fFlagEnableSubTabOverride then
				return not defineFastFlag2
			end

			local v6 = fFlagEnableChartsInFlyout

			if v6 then
				if variant == nil then
					if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
						variant = defineFastInt7
					else
						variant = getIXPVariant()
					end
				end

				v6 = variant ~= defineFastInt2
			end

			if v6 then
				return false
			end

			if defineFastFlag7 then
				return fFlagAppIaHomeSubTab and not defineFastFlag2
			end

			return not defineFastFlag2
		end

		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		return variant ~= defineFastInt2 and not defineFastFlag2
	end,
	isAlternateEntryPointEnabled = function(): boolean
		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		local v6 = variant

		if not defineFastFlag6 then
			return v6 == defineFastInt3 or v6 == defineFastInt5
		end

		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		local v7 = variant

		return (not defineFastFlag4 or v7 ~= defineFastInt4)
			and (not defineFastFlag5 or v7 ~= defineFastInt3 and v7 ~= defineFastInt5)
			and v7 ~= defineFastInt2
			and (v6 == defineFastInt3 or v6 == defineFastInt5)
	end,
	isRobuxIconRemoved = function(): boolean
		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		return variant == defineFastInt6
	end,
	isScrollAwayEnabled = function(): boolean
		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		return variant ~= defineFastInt2
	end,
	isHomeSubTabEnabled = function(): boolean
		if fFlagEnableSubTabOverride then
			return true
		end

		local v6 = fFlagEnableChartsInFlyout

		if v6 then
			if variant == nil then
				if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
					variant = defineFastInt7
				else
					variant = getIXPVariant()
				end
			end

			v6 = variant ~= defineFastInt2
		end

		if v6 then
			return false
		end

		if fFlagSubTabRemoveFlyoutDependency then
			return true
		end

		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		local v7 = variant

		return v7 == defineFastInt3 or v7 == defineFastInt4
	end,
	isChartsInSubTab = function(): boolean
		local v6 = fFlagSubTabHideChartsForNonArgo

		if v6 then
			return not v6
		end

		v6 = fFlagEnableChartsInFlyout

		if not v6 then
			return not v6
		end

		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		v6 = variant ~= defineFastInt2
		return not v6
	end,
	isChartsInFlyoutEnabled = function()
		local v6 = fFlagEnableChartsInFlyout

		if not v6 then
			return v6
		end

		if variant == nil then
			if UniversalAppPolicy.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
				variant = defineFastInt7
			else
				variant = getIXPVariant()
			end
		end

		v6 = variant ~= defineFastInt2
		return v6
	end
}
