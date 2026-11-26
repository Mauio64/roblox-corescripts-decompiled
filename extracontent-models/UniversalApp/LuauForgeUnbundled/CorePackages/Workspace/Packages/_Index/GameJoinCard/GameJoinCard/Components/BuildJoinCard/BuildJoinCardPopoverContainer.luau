local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Localization").Hooks.useLocalization

local DesktopGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/DesktopGameJoinCard/DesktopGameJoinCard")
local BuildJoinCardMedia = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/BuildJoinCard/BuildJoinCardMedia")
local useBuildJoinCardViewModel = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/BuildJoinCard/useBuildJoinCardViewModel")

local function noop(p2) end

local function BuildJoinCardPopoverContainer(props)
	local v5 = useBuildJoinCardViewModel({
		userId = props.userId,
		onClose = props.onClose,
		keepsOpenOnNavigation = false
	})

	local v6 = useLocalization({
		isMakingGameIn = "Feature.Profile.Label.IsMakingGameIn",
		build = "CommonUI.Features.NavBar.Build"
	})

	local v7 = {
		media = React.createElement(BuildJoinCardMedia, { userId = props.userId, slot = "Icon" }),
		activityText = v6.isMakingGameIn
	}

	return React.createElement(DesktopGameJoinCard, {
		layoutOrder = 1,
		playerName = props.playerName,
		experienceName = v6.build,
		gameIconUrl = "",
		isLoading = false,
		onJoin = noop,
		onViewExperienceDetails = noop,
		anchorRef = props.anchorRef,
		isOpen = props.isOpen,
		onClose = props.onClose,
		isConsole = false,
		consolePlatformLabel = "",
		actions = v5.actions,
		content = v7
	})
end

return BuildJoinCardPopoverContainer
