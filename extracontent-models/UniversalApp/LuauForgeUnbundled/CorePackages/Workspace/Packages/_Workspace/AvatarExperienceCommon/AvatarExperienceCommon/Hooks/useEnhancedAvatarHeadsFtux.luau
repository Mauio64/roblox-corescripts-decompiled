local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Navigation")
local SafeAppStorageService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Lib/SafeAppStorageService")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = Navigation.useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/RoactUtils").Hooks.RoactRodux.useSelector

local useIsSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Responsive").useIsSpatial

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagAXEnhancedAvatarHeadsFtuxUseMemStorage = AvatarExperienceFlags.FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage
local fIntAXEnhancedAvatarHeadsFtuxDelay = AvatarExperienceFlags.FIntAXEnhancedAvatarHeadsFtuxDelay

local function fn(p2)
	return p2.ScreenSize
end

local function useEnhancedAvatarHeadsFtux()
	local v5 = useNavigation()
	local v6 = useAvatarRoute()
	local v7 = useSelector(fn)

	local v8 = React.useMemo(function()
		return v6 and v6.opaque and v6.opaque.name
	end, { v6 })

	local v9 = React.useCallback(function()
		return SafeAppStorageService.getItem("AXEnhancedAvatarHeadsFtux", fFlagAXEnhancedAvatarHeadsFtuxUseMemStorage)
	end, {})

	local v10 = React.useCallback(function()
		SafeAppStorageService.setItem("AXEnhancedAvatarHeadsFtux", "true", fFlagAXEnhancedAvatarHeadsFtuxUseMemStorage)
		SafeAppStorageService.flush()
	end, {})

	local v11 = useIsSpatial()

	React.useEffect(function()
		if v11 or v9() == "true" or v8 ~= avatarScreen.AvatarEditor then
			return
		end

		local thread = task.delay(fIntAXEnhancedAvatarHeadsFtuxDelay / 1000, function()
			v5.navigate(avatarScreen.EnhancedAvatarHeadsFtuxPrompt, {
				screenSize = v7,
				onConfirm = function()
					v10()
				end
			})
		end)

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { v9, v10, v8, v7, v5, v11 })
end

return useEnhancedAvatarHeadsFtux
