local ParentParent = script.Parent.Parent
local ExperimentCacheManager = require(ParentParent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastInt("FlyoutTestVariantRollout12", -1)
local v4 = game:DefineFastFlag("EnableFlyoutIxp11", false)
local v5 = game:DefineFastString("FlyoutIxpLayer", "Universality.MorePage")
local v6 = game:DefineFastString("FlyoutIxpVariantKey", "flyout_side_panel_type")
local v7 = game:DefineFastInt("IxpFlyoutControl", 0)
local v8 = game:DefineFastInt("IxpFlyoutVariantAlternateEntry", 1)
local v9 = game:DefineFastInt("IxpFlyoutVariantHamburger", 2)
local v10 = game:DefineFastInt("IxpFlyoutVariantNoSubTabs", 3)
local v11 = game:DefineFastInt("IxpFlyoutVariantRemovalRobuxIcon", 4)
local v12 = game:DefineFastFlag("FlyoutShowFriendsSortForCurrentVariant", false)
local v13 = game:DefineFastFlag("EnableFlyoutExposure", false)
local v14 = game:DefineFastFlag("FlyoutHamburgerEnableProfileEntry", false)
local v15 = game:DefineFastFlag("FlyoutFacepileEnableProfileEntry", false)
local v16 = game:DefineFastFlag("FlyoutDisallowAlternativeEntryOnProfileEntryEnabled", false)
local FFlagSubTabRemoveFlyoutDependency = require(ParentParent.SharedFlags).FFlagSubTabRemoveFlyoutDependency
local FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency = require(ParentParent.SharedFlags).FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency
local v19 = game:DefineFastFlag("HiddenFriendsSortHeaderAddSubTabDependency", false)
local FFlagAppIaHomeSubTab = require(ParentParent.SharedFlags).FFlagAppIaHomeSubTab
local u21 = nil

local function getIXPVariant() -- line: 32
	-- upvalues: v3 (copy), v4 (copy), v7 (copy), u21 (ref), ExperimentCacheManager (copy), v5 (copy), v13 (copy), v6 (copy)
	if v3 ~= -1 then
		return v3
	end

	if not v4 then
		return v7
	end

	if u21 == nil then
		local v23 = ExperimentCacheManager.default:getLayerVariables(v5)

		if v13 and v23 ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v5)
		end

		u21 = v23 or {}
	end

	local v24 = u21[v6]

	if v24 == nil then
		return v7
	end

	return (tonumber(v24))
end

return {
	isFlyoutSidePanelEnabled = function() -- line: 53
		-- upvalues: getIXPVariant (copy), v7 (copy)
		return getIXPVariant() ~= v7
	end,
	isRobloxLogoEnabled = function() -- line: 59
		-- upvalues: getIXPVariant (copy), v7 (copy)
		return getIXPVariant() ~= v7
	end,
	isProfileEntryRemoved = function() -- line: 65
		-- upvalues: getIXPVariant (copy), v14 (copy), v9 (copy), v15 (copy), v8 (copy), v10 (copy), v7 (copy)
		local v25 = getIXPVariant()

		if v14 and v25 == v9 then
			return false
		end

		if v15 and (v25 == v8 or v25 == v10) then
			return false
		end

		return v25 ~= v7
	end,
	isFriendsSortHeaderHiddenInFlyoutIxp = function() -- line: 79
		-- upvalues: FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency (copy), v19 (copy), FFlagAppIaHomeSubTab (copy), v12 (copy), getIXPVariant (copy), v7 (copy)
		if FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency then
			if v19 then
				return FFlagAppIaHomeSubTab and not v12
			end

			return not v12
		end

		return getIXPVariant() ~= v7 and not v12
	end,
	isAlternateEntryPointEnabled = function() -- line: 90
		-- upvalues: getIXPVariant (copy), v16 (copy), v14 (copy), v9 (copy), v15 (copy), v8 (copy), v10 (copy), v7 (copy)
		local v26 = getIXPVariant()

		if v16 then
			local v27 = getIXPVariant()

			return (not v14 or v27 ~= v9) and ((not v15 or v27 ~= v8 and v27 ~= v10) and v27 ~= v7) and (v26 == v8 or v26 == v10)
		end

		return v26 == v8 or v26 == v10
	end,
	isRobuxIconRemoved = function() -- line: 101
		-- upvalues: getIXPVariant (copy), v11 (copy)
		return getIXPVariant() == v11
	end,
	isScrollAwayEnabled = function() -- line: 107
		-- upvalues: getIXPVariant (copy), v7 (copy)
		return getIXPVariant() ~= v7
	end,
	isHomeSubTabEnabled = function() -- line: 112
		-- upvalues: FFlagSubTabRemoveFlyoutDependency (copy), getIXPVariant (copy), v8 (copy), v9 (copy)
		if FFlagSubTabRemoveFlyoutDependency then
			return true
		end

		local v28 = getIXPVariant()

		return v28 == v8 or v28 == v9
	end
}
