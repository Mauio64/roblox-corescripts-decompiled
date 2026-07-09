local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local CharacterManagerUtils = require(Modules.AvatarExperience.Common.Util.CharacterManagerUtils)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local CreateOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.CreateOutfit)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService

local function v16(p1) -- line: 31
	-- upvalues: CharacterManagerUtils (copy)
	return CharacterManagerUtils.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(p1)
end

local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local function useOnAddOutfit(p2, p3, p4: ((...any) -> ...any), b1: boolean) -- line: 37
	-- upvalues: useDispatch (copy), useRoactService (copy), Analytics (copy), useAppPolicy (copy), useSelector (copy), v16 (copy), getUseSelectorDeepEquals (copy), React (copy), NavigationUtils (copy), CreateOutfit (copy), AvatarScreen (copy), NavigateWithLock (copy)
	local v24 = useDispatch()
	local v25 = useRoactService(Analytics)
	local v26 = useAppPolicy(function(p5) -- line: 46
		return p5.getCustomOutfitNames()
	end)
	local v27 = useSelector(v16, getUseSelectorDeepEquals())
	local v28 = React.useRef(false)

	React.useEffect(function() -- line: 54
		-- upvalues: v28 (copy)
		v28.current = true

		return function() -- line: 56
			-- upvalues: v28 (copy)
			v28.current = false
		end
	end, {})

	local v29 = React.useCallback(function() -- line: 61
		-- upvalues: NavigationUtils (copy), p2 (copy)
		NavigationUtils.closeOverlay(p2)
	end, { p2 })
	local v30 = React.useCallback(function() -- line: 65
		-- upvalues: v28 (copy)
		return v28.current
	end, { v28 })
	local v31 = React.useCallback(function(p6, p7) -- line: 69
		-- upvalues: v24 (copy), CreateOutfit (copy), v25 (copy), v30 (copy), v27 (copy)
		v24(CreateOutfit(p6, v25, v30, p7, v27))
	end, {
		v24,
		v25,
		v30,
		v27
	})
	local v32 = React.useMemo(function() -- line: 73
		-- upvalues: p3 (copy), v31 (copy), p4 (copy)
		return {
			outfitType = p3,
			onComplete = v31,
			onOverlayClosed = p4
		}
	end, {
		p3,
		v31,
		p4
	})
	local v33 = React.useCallback(function() -- line: 81
		-- upvalues: b1 (copy), NavigationUtils (copy), p2 (copy), AvatarScreen (copy), v32 (copy)
		if b1 then
			NavigationUtils.navigateToNextOverlay(p2, AvatarScreen.AddOutfitDialog, v32)

			return
		end

		p2.navigate(AvatarScreen.AddOutfitDialog, v32)
	end, {
		p2,
		v32,
		b1
	})

	return React.useCallback(function() -- line: 90
		-- upvalues: v26 (copy), v24 (copy), NavigateWithLock (copy), v33 (copy), v31 (copy)
		if v26 then
			v24(NavigateWithLock(v33))

			return
		end

		v31("", function() -- line: 94
			return nil
		end)
	end, {
		p2,
		v31,
		v26,
		v33,
		v24,
		v29
	})
end

return useOnAddOutfit
