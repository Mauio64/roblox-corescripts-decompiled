local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local DesktopGameJoinCard = require(GameJoinCard.Components.DesktopGameJoinCard.DesktopGameJoinCard)
local BuildJoinCardMedia = require(script.Parent.BuildJoinCardMedia)
local useBuildJoinCardViewModel = require(script.Parent.useBuildJoinCardViewModel)

local function noop(_) end

local function BuildJoinCardPopoverContainer(props)
	local v = useBuildJoinCardViewModel({
		userId = props.userId,
		onClose = props.onClose,
		keepsOpenOnNavigation = false
	})

	local v2 = useLocalization({
		isMakingGameIn = "Feature.Profile.Label.IsMakingGameIn",
		build = "CommonUI.Features.NavBar.Build"
	})

	local content = {
		media = React.createElement(BuildJoinCardMedia, { userId = props.userId, slot = "Icon" }),
		activityText = v2.isMakingGameIn
	}

	return React.createElement(DesktopGameJoinCard, {
		layoutOrder = 1,
		playerName = props.playerName,
		experienceName = v2.build,
		gameIconUrl = "",
		isLoading = false,
		onJoin = noop,
		onViewExperienceDetails = noop,
		anchorRef = props.anchorRef,
		isOpen = props.isOpen,
		onClose = props.onClose,
		isConsole = false,
		consolePlatformLabel = "",
		actions = v.actions,
		content = content
	})
end

return BuildJoinCardPopoverContainer
