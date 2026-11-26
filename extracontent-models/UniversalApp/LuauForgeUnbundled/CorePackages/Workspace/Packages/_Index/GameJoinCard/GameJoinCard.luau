local module = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/MobileGameJoinCard/MobileGameJoinCard")
local fFlagSocialCarouselBuildPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagSocialCarouselBuildPresence

local v5 = {
	Analytics = {
		AnalyticsConstants = module,
		Constants = module,
		useGameJoinCardAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics"),
		useAgeCheckUpsellAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useAgeCheckUpsellAnalytics")
	},
	BuildJoinCardPopover = 0,
	BuildJoinCardSheet = 0,
	DesktopGameJoinCard = 0,
	DesktopGameJoinCardContainer = 0,
	GamepadJoinFocusBehavior = 0,
	getInExperienceGameJoinCard = 0,
	useGameJoinCardNavigation = 0,
	useJoinUserActions = 0,
	usePrefetchInGameFriendsMedia = 0,
	MobileGameJoinCard = 0,
	MobileGameJoinCardView = 0,
	Telemetry = 0
}

local v6 = if fFlagSocialCarouselBuildPresence then require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/BuildJoinCard/BuildJoinCardPopoverContainer") else nil
v5.BuildJoinCardPopover = v6

local v7 = if fFlagSocialCarouselBuildPresence then require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/BuildJoinCard/BuildJoinCardSheetContainer") else nil
v5.BuildJoinCardSheet = v7

v5.DesktopGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/DesktopGameJoinCard/DesktopGameJoinCard")
v5.DesktopGameJoinCardContainer = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/DesktopGameJoinCard/DesktopGameJoinCardContainer")
v5.GamepadJoinFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/DesktopGameJoinCard/GamepadJoinFocusBehavior")

function v5.getInExperienceGameJoinCard()
	return require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/InExperienceGameJoinCard/InExperienceGameJoinCard")
end

v5.useGameJoinCardNavigation = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/DesktopGameJoinCard/useGameJoinCardNavigation")
v5.useJoinUserActions = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Hooks/useJoinUserActions")
v5.usePrefetchInGameFriendsMedia = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Hooks/usePrefetchInGameFriendsMedia")
v5.MobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/MobileGameJoinCard")
v5.MobileGameJoinCardView = module2
v5.Telemetry = {
	GameJoinCardTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Telemetry/GameJoinCardTelemetry"),
	GameJoinCardTTI = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Telemetry/GameJoinCardTTI")
}
return v5
