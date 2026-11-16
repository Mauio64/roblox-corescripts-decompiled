local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent

local canViewBuild = require(parent.BuildExperiencePlaytestLaunch.canViewBuild)
local DataHydration = require(parent.DataHydration)
local Foundation = require(parent.Foundation)
local GameJoinCard = require(parent.GameJoinCard)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SharedFlags = require(parent.SharedFlags)
local FFlagMobileGameJoinCardGamepadSupport = SharedFlags.FFlagMobileGameJoinCardGamepadSupport

local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)

local isPresenceInBuild = DataHydration.Presence.isPresenceInBuild

local function useBuildCard(data)
	local v = useNavigation()
	local v2 = useSocialCarouselContext()
	local openBuildCardUserId = v2.openBuildCardUserId
	local setOpenBuildCardUserId = v2.setOpenBuildCardUserId
	local setOpenGameJoinCardUserId = v2.setOpenGameJoinCardUserId
	local v3 = v2.openGameJoinCardUserId ~= nil
	local userId = data.userId
	local isInBuild = useAppPolicy(canViewBuild) and isPresenceInBuild(data.presence)
	local v4 = useLocalization({ build = "CommonUI.Features.NavBar.Build" })

	local v5 = data.preferredInput == Responsive.Input.Touch
		or FFlagMobileGameJoinCardGamepadSupport and data.isPhoneOrTablet
	local canOpen = v5 or data.preferredInput ~= Responsive.Input.Directional

	local onClose = React.useCallback(function()
		setOpenBuildCardUserId(function(p: string?)
			return if p ~= userId then p else nil
		end)
	end, { userId, setOpenBuildCardUserId })
	local v6

	if openBuildCardUserId == userId then
		v6 = not isInBuild or v3
	else
		v6 = false
	end

	React.useEffect(function()
		if v6 then
			onClose()
		end
	end, { v6, onClose })
	local isOpen

	if isInBuild then
		if openBuildCardUserId == userId then
			isOpen = not v3
		else
			isOpen = false
		end
	else
		isOpen = isInBuild
	end

	local onActivated = React.useCallback(function()
		if v5 then
			v.navigate(AppPage.BuildJoinCard, { userId = userId })
			return
		end

		local v7

		if not isOpen then
			v7 = userId
		end

		setOpenBuildCardUserId(v7)

		if setOpenGameJoinCardUserId then
			setOpenGameJoinCardUserId(nil)
		end
	end, { v, userId, v5, isOpen, setOpenBuildCardUserId, setOpenGameJoinCardUserId })

	return React.useMemo(function()
		local v7 = {
			isInBuild = isInBuild,
			canOpen = canOpen,
			onActivated = onActivated,
			contextualInfo = isInBuild and {
				text = v4.build,
				icon = Foundation.Enums.IconName.Nebula
			} or nil,
			popover = 0
		}
		local popover

		if isInBuild then
			popover = React.createElement(GameJoinCard.BuildJoinCardPopover, {
				userId = userId,
				isOpen = isOpen,
				anchorRef = data.anchorRef,
				onClose = onClose,
				playerName = data.playerName
			})
		end

		v7.popover = popover
		return v7
	end, {
		isInBuild,
		canOpen,
		onActivated,
		v4.build,
		userId,
		isOpen,
		data.anchorRef,
		onClose,
		data.playerName
	})
end

return useBuildCard
