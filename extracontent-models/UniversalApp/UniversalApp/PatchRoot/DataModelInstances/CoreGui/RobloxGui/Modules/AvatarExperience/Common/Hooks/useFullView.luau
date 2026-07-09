local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useRouteName = require(CorePackages.Workspace.Packages.Navigation).useRouteName
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local _ = AvatarExperienceCommon.Enums.FullView
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local function useFullView() -- line: 27
	-- upvalues: useRouteName (copy), React (copy), selectIsFullView (copy), useSelector (copy), getUseSelectorDeepEquals (copy), useRoactService (copy), Analytics (copy), useDispatch (copy), SetFullView (copy)
	local v16 = useRouteName()
	local v17 = React.useCallback(function(p1) -- line: 29
		-- upvalues: selectIsFullView (copy), v16 (copy)
		return selectIsFullView(p1, v16)
	end, { v16 })
	local v18 = useSelector(v17, getUseSelectorDeepEquals())
	local v19 = useRoactService(Analytics)
	local v20 = useDispatch()

	return v18, (React.useCallback(function(p2) -- line: 38
		-- upvalues: v20 (copy), SetFullView (copy), v19 (copy), v16 (copy)
		v20(SetFullView(v19, v16, p2))
	end, {
		v19,
		v16,
		v20
	}))
end

return useFullView
