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
local fFlagEnableChartsInFlyout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/SharedFlags").FFlagEnableChartsInFlyout

local defineFastInt7 = game:DefineFastInt("FlyoutAmpGatedVariant", 2)
local fFlagFlyoutSidePanelUseAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/SharedFlags").FFlagFlyoutSidePanelUseAppPolicy

local v5 = if fFlagFlyoutSidePanelUseAppPolicy then require("@game/CorePackages/Workspace/Packages/_Workspace/SharedExperimentDefinition/UniversalAppPolicy") else nil

local v6 = nil
local variant = nil

local function getIXPVariant()
	if defineFastInt ~= -1 then
		return defineFastInt
	end

	if not defineFastFlag then
		return defineFastInt2
	end

	if v6 == nil then
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if defineFastFlag3 and layerVariables ~= nil then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end

		v6 = layerVariables or {}
	end

	local v7 = v6[defineFastString2]

	if v7 == nil then
		return defineFastInt2
	end

	return (tonumber(v7))
end

local function getVariant()
	if variant ~= nil then
		return variant
	end

	if fFlagFlyoutSidePanelUseAppPolicy and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled() then
		variant = defineFastInt7
	else
		variant = getIXPVariant()
	end

	return variant
end

return {
	isFlyoutSidePanelEnabled = function(): boolean
		local v7

		if fFlagFlyoutSidePanelUseAppPolicy then
			if variant == nil then
				if
					fFlagFlyoutSidePanelUseAppPolicy
					and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
				then
					variant = defineFastInt7
				else
					variant = getIXPVariant()
				end
			end

			v7 = variant
		else
			v7 = getIXPVariant()
		end

		return v7 ~= defineFastInt2
	end,
	isRobloxLogoEnabled = function(): boolean
		local v7

		if fFlagFlyoutSidePanelUseAppPolicy then
			if variant == nil then
				if
					fFlagFlyoutSidePanelUseAppPolicy
					and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
				then
					variant = defineFastInt7
				else
					variant = getIXPVariant()
				end
			end

			v7 = variant
		else
			v7 = getIXPVariant()
		end

		return v7 ~= defineFastInt2
	end,
	isProfileEntryRemoved = function(): boolean
		local v7

		if fFlagFlyoutSidePanelUseAppPolicy then
			if variant == nil then
				if
					fFlagFlyoutSidePanelUseAppPolicy
					and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
				then
					variant = defineFastInt7
				else
					variant = getIXPVariant()
				end
			end

			v7 = variant
		else
			v7 = getIXPVariant()
		end

		if
			defineFastFlag4 and v7 == defineFastInt4
			or defineFastFlag5 and (v7 == defineFastInt3 or v7 == defineFastInt5)
		then
			return false
		end

		return v7 ~= defineFastInt2
	end,
	isFriendsSortHeaderHiddenInFlyoutIxp = function()
		if fFlagHiddenFriendsSortHeaderRemoveFlyoutDependency then
			local v7 = fFlagEnableChartsInFlyout

			if v7 then
				local v8

				if fFlagFlyoutSidePanelUseAppPolicy then
					if variant == nil then
						if
							fFlagFlyoutSidePanelUseAppPolicy
							and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
						then
							variant = defineFastInt7
						else
							variant = getIXPVariant()
						end
					end

					v8 = variant
				else
					v8 = getIXPVariant()
				end

				v7 = v8 ~= defineFastInt2
			end

			if v7 then
				return false
			end

			if defineFastFlag7 then
				return fFlagAppIaHomeSubTab and not defineFastFlag2
			end

			return not defineFastFlag2
		else
			local v7

			if fFlagFlyoutSidePanelUseAppPolicy then
				if variant == nil then
					if
						fFlagFlyoutSidePanelUseAppPolicy
						and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
					then
						variant = defineFastInt7
					else
						variant = getIXPVariant()
					end
				end

				v7 = variant
			else
				v7 = getIXPVariant()
			end

			return v7 ~= defineFastInt2 and not defineFastFlag2
		end
	end,
	isAlternateEntryPointEnabled = function(): boolean
		local v7

		if fFlagFlyoutSidePanelUseAppPolicy then
			if variant == nil then
				if
					fFlagFlyoutSidePanelUseAppPolicy
					and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
				then
					variant = defineFastInt7
				else
					variant = getIXPVariant()
				end
			end

			v7 = variant
		else
			v7 = getIXPVariant()
		end

		if not defineFastFlag6 then
			return v7 == defineFastInt3 or v7 == defineFastInt5
		end

		local v8

		if fFlagFlyoutSidePanelUseAppPolicy then
			if variant == nil then
				if
					fFlagFlyoutSidePanelUseAppPolicy
					and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
				then
					variant = defineFastInt7
				else
					variant = getIXPVariant()
				end
			end

			v8 = variant
		else
			v8 = getIXPVariant()
		end

		return (not defineFastFlag4 or v8 ~= defineFastInt4)
			and (not defineFastFlag5 or v8 ~= defineFastInt3 and v8 ~= defineFastInt5)
			and v8 ~= defineFastInt2
			and (v7 == defineFastInt3 or v7 == defineFastInt5)
	end,
	isRobuxIconRemoved = function(): boolean
		local v7

		if fFlagFlyoutSidePanelUseAppPolicy then
			if variant == nil then
				if
					fFlagFlyoutSidePanelUseAppPolicy
					and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
				then
					variant = defineFastInt7
				else
					variant = getIXPVariant()
				end
			end

			v7 = variant
		else
			v7 = getIXPVariant()
		end

		return v7 == defineFastInt6
	end,
	isScrollAwayEnabled = function(): boolean
		local v7

		if fFlagFlyoutSidePanelUseAppPolicy then
			if variant == nil then
				if
					fFlagFlyoutSidePanelUseAppPolicy
					and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
				then
					variant = defineFastInt7
				else
					variant = getIXPVariant()
				end
			end

			v7 = variant
		else
			v7 = getIXPVariant()
		end

		return v7 ~= defineFastInt2
	end,
	isHomeSubTabEnabled = function(): boolean
		local v7 = fFlagEnableChartsInFlyout

		if v7 then
			local v8

			if fFlagFlyoutSidePanelUseAppPolicy then
				if variant == nil then
					if
						fFlagFlyoutSidePanelUseAppPolicy
						and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
					then
						variant = defineFastInt7
					else
						variant = getIXPVariant()
					end
				end

				v8 = variant
			else
				v8 = getIXPVariant()
			end

			v7 = v8 ~= defineFastInt2
		end

		if v7 then
			return false
		end

		if fFlagSubTabRemoveFlyoutDependency then
			return true
		end

		local v8

		if fFlagFlyoutSidePanelUseAppPolicy then
			if variant == nil then
				if
					fFlagFlyoutSidePanelUseAppPolicy
					and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
				then
					variant = defineFastInt7
				else
					variant = getIXPVariant()
				end
			end

			v8 = variant
		else
			v8 = getIXPVariant()
		end

		return v8 == defineFastInt3 or v8 == defineFastInt4
	end,
	isChartsInFlyoutEnabled = function()
		local v7 = fFlagEnableChartsInFlyout

		if not v7 then
			return v7
		end

		local v8

		if fFlagFlyoutSidePanelUseAppPolicy then
			if variant == nil then
				if
					fFlagFlyoutSidePanelUseAppPolicy
					and v5.getAppFeaturePolicies().getFlyoutSidePanelEnabled()
				then
					variant = defineFastInt7
				else
					variant = getIXPVariant()
				end
			end

			v8 = variant
		else
			v8 = getIXPVariant()
		end

		v7 = v8 ~= defineFastInt2
		return v7
	end
}
