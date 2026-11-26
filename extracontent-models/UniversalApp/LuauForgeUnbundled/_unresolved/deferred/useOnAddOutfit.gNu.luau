local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local module2 = require("@luauforge/bundled/dXh")

local module3 = require("@luauforge/bundled/gJz")

local module4 = require("@luauforge/deferred/gKR")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService

local function useOnAddOutfit(p2, p3, onOverlayClosed, p4)
	local v5 = useDispatch()
	local v6 = useRoactService(module3)

	local v7 = useAppPolicy(function(p5)
		return p5.getCustomOutfitNames()
	end)

	local ref = React.useRef(false)
	React.useEffect(function()
		ref.current = true
		return function()
			ref.current = false
		end
	end, {})

	local v8 = React.useCallback(function()
		module2.closeOverlay(p2)
	end, { p2 })

	local v9 = React.useCallback(function()
		return ref.current
	end, { ref })

	local v10 = React.useCallback(function(p5, p6)
		v5(module4(p5, v6, v9, p6, nil, p3))
	end, { v5, v6, v9, p3 })

	local v11 = React.useMemo(function()
		return { outfitType = p3, onComplete = v10, onOverlayClosed = onOverlayClosed }
	end, { p3, v10, onOverlayClosed })

	local v12 = React.useCallback(function()
		if p4 then
			module2.navigateToNextOverlay(p2, avatarScreen.AddOutfitDialog, v11)
		else
			p2.navigate(avatarScreen.AddOutfitDialog, v11)
		end
	end, { p2, v11, p4 })

	return React.useCallback(function()
		if v7 then
			v5(navigateWithLock(v12))
		else
			v10("", function(): nil
				return nil
			end)
		end
	end, { p2, v10, v7, v12, v5, v8 })
end

return useOnAddOutfit
