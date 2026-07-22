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
local u19 = nil

local function getIXPVariant() -- line: 29
	-- upvalues: v3 (copy), v4 (copy), v7 (copy), u19 (ref), ExperimentCacheManager (copy), v5 (copy), v13 (copy), v6 (copy)
	if v3 ~= -1 then
		return v3
	end

	if not v4 then
		return v7
	end

	if u19 == nil then
		local v21 = ExperimentCacheManager.default:getLayerVariables(v5)

		if v13 and v21 ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v5)
		end

		u19 = v21 or {}
	end

	local v22 = u19[v6]

	if v22 == nil then
		return v7
	end

	return (tonumber(v22))
end

return {
	isFlyoutSidePanelEnabled = function() -- line: 50
		-- upvalues: getIXPVariant (copy), v7 (copy)
		return getIXPVariant() ~= v7
	end,
	isRobloxLogoEnabled = function() -- line: 56
		-- upvalues: getIXPVariant (copy), v7 (copy)
		return getIXPVariant() ~= v7
	end,
	isProfileEntryRemoved = function() -- line: 62
		-- upvalues: getIXPVariant (copy), v14 (copy), v9 (copy), v15 (copy), v8 (copy), v10 (copy), v7 (copy)
		local v23 = getIXPVariant()

		if v14 and v23 == v9 then
			return false
		end

		if v15 and (v23 == v8 or v23 == v10) then
			return false
		end

		return v23 ~= v7
	end,
	isFriendsSortHeaderHiddenInFlyoutIxp = function() -- line: 76
		-- upvalues: FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency (copy), v12 (copy), getIXPVariant (copy), v7 (copy)
		if FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency then
			return not v12
		end

		return getIXPVariant() ~= v7 and not v12
	end,
	isAlternateEntryPointEnabled = function() -- line: 84
		-- upvalues: getIXPVariant (copy), v16 (copy), v14 (copy), v9 (copy), v15 (copy), v8 (copy), v10 (copy), v7 (copy)
		local v24 = getIXPVariant()

		if v16 then
			local v25 = getIXPVariant()

			return (not v14 or v25 ~= v9) and ((not v15 or v25 ~= v8 and v25 ~= v10) and v25 ~= v7) and (v24 == v8 or v24 == v10)
		end

		return v24 == v8 or v24 == v10
	end,
	isRobuxIconRemoved = function() -- line: 95
		-- upvalues: getIXPVariant (copy), v11 (copy)
		return getIXPVariant() == v11
	end,
	isScrollAwayEnabled = function() -- line: 101
		-- upvalues: getIXPVariant (copy), v7 (copy)
		return getIXPVariant() ~= v7
	end,
	isHomeSubTabEnabled = function() -- line: 106
		-- upvalues: FFlagSubTabRemoveFlyoutDependency (copy), getIXPVariant (copy), v8 (copy), v9 (copy)
		if FFlagSubTabRemoveFlyoutDependency then
			return true
		end

		local v26 = getIXPVariant()

		return v26 == v8 or v26 == v9
	end
}
