local module = require("@luauforge/bundled/dVl")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function useGetCurrentCategoryNames()
	return useSelector(function(p2)
		return module.getCurrentCategoryNames(p2)
	end, getUseSelectorDeepEquals())
end

return useGetCurrentCategoryNames
