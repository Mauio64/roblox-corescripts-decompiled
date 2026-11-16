local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fvh")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local React = require(CorePackages.Packages.React)

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local function fn(p2)
	return p2.AvatarExperience.AvatarEditor.OutfitInfos
end

local function fn2(p2)
	return p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
end

return function(p2, p3)
	local v5 = useSelector(fn)
	local v6 = useSelector(fn2)

	return React.useCallback(function(p4)
		return module.isDuplicateOutfitName(v6, v5, p4, p2, p3)
	end, { p2, v6, v5, p3 })
end
