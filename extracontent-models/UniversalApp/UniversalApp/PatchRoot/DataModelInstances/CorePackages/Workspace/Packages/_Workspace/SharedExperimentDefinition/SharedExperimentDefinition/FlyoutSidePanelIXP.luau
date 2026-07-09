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
local u17 = nil

local function getIXPVariant() -- line: 26
	-- upvalues: v3 (copy), v4 (copy), v7 (copy), u17 (ref), ExperimentCacheManager (copy), v5 (copy), v13 (copy), v6 (copy)
	if v3 ~= -1 then
		return v3
	end

	if not v4 then
		return v7
	end

	if u17 == nil then
		local v19 = ExperimentCacheManager.default:getLayerVariables(v5)

		if v13 and v19 ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v5)
		end

		u17 = v19 or {}
	end

	local v20 = u17[v6]

	if v20 == nil then
		return v7
	end

	return (tonumber(v20))
end

return {
	isFlyoutSidePanelEnabled = function() -- line: 47
		-- upvalues: getIXPVariant (copy), v7 (copy)
		return getIXPVariant() ~= v7
	end,
	isRobloxLogoEnabled = function() -- line: 53
		-- upvalues: getIXPVariant (copy), v7 (copy)
		return getIXPVariant() ~= v7
	end,
	isProfileEntryRemoved = function() -- line: 59
		-- upvalues: getIXPVariant (copy), v14 (copy), v9 (copy), v15 (copy), v8 (copy), v10 (copy), v7 (copy)
		local v21 = getIXPVariant()

		if v14 and v21 == v9 then
			return false
		end

		if v15 and (v21 == v8 or v21 == v10) then
			return false
		end

		return v21 ~= v7
	end,
	isFriendsSortHeaderHiddenInFlyoutIxp = function() -- line: 73
		-- upvalues: getIXPVariant (copy), v7 (copy), v12 (copy)
		return getIXPVariant() ~= v7 and not v12
	end,
	isAlternateEntryPointEnabled = function() -- line: 78
		-- upvalues: getIXPVariant (copy), v16 (copy), v14 (copy), v9 (copy), v15 (copy), v8 (copy), v10 (copy), v7 (copy)
		local v22 = getIXPVariant()

		if v16 then
			local v23 = getIXPVariant()

			return (not v14 or v23 ~= v9) and ((not v15 or v23 ~= v8 and v23 ~= v10) and v23 ~= v7) and (v22 == v8 or v22 == v10)
		end

		return v22 == v8 or v22 == v10
	end,
	isRobuxIconRemoved = function() -- line: 89
		-- upvalues: getIXPVariant (copy), v11 (copy)
		return getIXPVariant() == v11
	end,
	isScrollAwayEnabled = function() -- line: 95
		-- upvalues: getIXPVariant (copy), v7 (copy)
		return getIXPVariant() ~= v7
	end,
	isHomeSubTabEnabled = function() -- line: 100
		-- upvalues: getIXPVariant (copy), v8 (copy), v9 (copy)
		local v24 = getIXPVariant()

		return v24 == v8 or v24 == v9
	end
}
