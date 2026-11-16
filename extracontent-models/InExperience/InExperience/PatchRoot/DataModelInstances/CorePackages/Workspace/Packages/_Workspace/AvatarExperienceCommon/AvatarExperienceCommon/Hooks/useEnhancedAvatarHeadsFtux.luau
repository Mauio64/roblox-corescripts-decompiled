local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local SafeAppStorageService = require(AvatarExperienceCommon.Lib.SafeAppStorageService)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = Navigation.useNavigation
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Responsive = require(parent.Responsive)
local useIsSpatial = Responsive.useIsSpatial

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage = AvatarExperienceFlags.FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage
local FIntAXEnhancedAvatarHeadsFtuxDelay = AvatarExperienceFlags.FIntAXEnhancedAvatarHeadsFtuxDelay

local function fn(p)
	return p.ScreenSize
end

local function useEnhancedAvatarHeadsFtux()
	local v = useNavigation()
	local v2 = useAvatarRoute()
	local screenSize = useSelector(fn)

	local v3 = React.useMemo(function()
		return v2 and v2.opaque and v2.opaque.name
	end, { v2 })

	local v4 = React.useCallback(function()
		return SafeAppStorageService.getItem("AXEnhancedAvatarHeadsFtux", FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage)
	end, {})

	local v5 = React.useCallback(function()
		SafeAppStorageService.setItem("AXEnhancedAvatarHeadsFtux", "true", FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage)
		SafeAppStorageService.flush()
	end, {})

	local v6 = useIsSpatial()

	React.useEffect(function()
		if v6 or v4() == "true" or v3 ~= AvatarScreen.AvatarEditor then
			return
		end

		local thread = task.delay(FIntAXEnhancedAvatarHeadsFtuxDelay / 1000, function()
			v.navigate(AvatarScreen.EnhancedAvatarHeadsFtuxPrompt, {
				screenSize = screenSize,
				onConfirm = function()
					v5()
				end
			})
		end)

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { v4, v5, v3, screenSize, v, v6 })
end

return useEnhancedAvatarHeadsFtux
