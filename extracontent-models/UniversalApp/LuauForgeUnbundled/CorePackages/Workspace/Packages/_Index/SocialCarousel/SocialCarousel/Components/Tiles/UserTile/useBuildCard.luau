local canViewBuild = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/BuildExperiencePlaytestLaunch/canViewBuild")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/DataHydration")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local GameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/GameJoinCard")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Responsive")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Navigation").useNavigation
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/UniversalAppPolicy").useAppPolicy
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums").AppPage
local fFlagMobileGameJoinCardGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagMobileGameJoinCardGamepadSupport

local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")

local isPresenceInBuild = DataHydration.Presence.isPresenceInBuild

local function useBuildCard(data)
	local v5 = useNavigation()
	local v6 = useSocialCarouselContext()
	local openBuildCardUserId = v6.openBuildCardUserId
	local setOpenBuildCardUserId = v6.setOpenBuildCardUserId
	local setOpenGameJoinCardUserId = v6.setOpenGameJoinCardUserId
	local v7 = v6.openGameJoinCardUserId ~= nil
	local userId = data.userId
	local v8 = useAppPolicy(canViewBuild) and isPresenceInBuild(data.presence)
	local v9 = useLocalization({ build = "CommonUI.Features.NavBar.Build" })

	local v10 = data.preferredInput == Responsive.Input.Touch
		or fFlagMobileGameJoinCardGamepadSupport and data.isPhoneOrTablet
	local v11 = v10 or data.preferredInput ~= Responsive.Input.Directional

	local v12 = React.useCallback(function()
		setOpenBuildCardUserId(function(p2)
			if p2 == userId then
				return nil
			end

			return p2
		end)
	end, { userId, setOpenBuildCardUserId })
	local v13 = openBuildCardUserId == userId and (not v8 or v7)
	React.useEffect(function()
		if v13 then
			v12()
		end
	end, { v13, v12 })

	local v14 = if v8 then openBuildCardUserId == userId and not v7 else v8
	local v15 = React.useCallback(function()
		if v10 then
			v5.navigate(appPage.BuildJoinCard, { userId = userId })
			return
		end

		setOpenBuildCardUserId(if not v14 then userId else nil)

		if setOpenGameJoinCardUserId then
			setOpenGameJoinCardUserId(nil)
		end
	end, { v5, userId, v10, v14, setOpenBuildCardUserId, setOpenGameJoinCardUserId })

	return React.useMemo(function()
		local v16 = {
			isInBuild = v8,
			canOpen = v11,
			onActivated = v15,
			contextualInfo = v8 and {
				text = v9.build,
				icon = Foundation.Enums.IconName.Nebula
			} or nil,
			popover = 0
		}

		local v17 = if v8 then React.createElement(GameJoinCard.BuildJoinCardPopover, {
			userId = userId,
			isOpen = v14,
			anchorRef = data.anchorRef,
			onClose = v12,
			playerName = data.playerName
		}) else nil
		v16.popover = v17
		return v16
	end, {
		v8,
		v11,
		v15,
		v9.build,
		userId,
		v14,
		data.anchorRef,
		v12,
		data.playerName
	})
end

return useBuildCard
