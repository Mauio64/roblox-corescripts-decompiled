local AnalyticsConstants = require(script.Analytics.AnalyticsConstants)
local MobileGameJoinCard = require(script.Components.MobileGameJoinCard.MobileGameJoinCard)
local SharedFlags = require(script.Parent.SharedFlags)
local FFlagSocialCarouselBuildPresence = SharedFlags.FFlagSocialCarouselBuildPresence

local GameJoinCard = {}
GameJoinCard.Analytics = {
	AnalyticsConstants = AnalyticsConstants,
	Constants = AnalyticsConstants,
	useGameJoinCardAnalytics = require(script.Analytics.useGameJoinCardAnalytics)
}
local buildJoinCardPopover

if FFlagSocialCarouselBuildPresence then
	buildJoinCardPopover = require(script.Components.BuildJoinCard.BuildJoinCardPopoverContainer)
end

GameJoinCard.BuildJoinCardPopover = buildJoinCardPopover
local buildJoinCardSheet

if FFlagSocialCarouselBuildPresence then
	buildJoinCardSheet = require(script.Components.BuildJoinCard.BuildJoinCardSheetContainer)
end

GameJoinCard.BuildJoinCardSheet = buildJoinCardSheet

GameJoinCard.DesktopGameJoinCard = require(script.Components.DesktopGameJoinCard.DesktopGameJoinCard)
GameJoinCard.DesktopGameJoinCardContainer = require(script.Components.DesktopGameJoinCard.DesktopGameJoinCardContainer)
GameJoinCard.GamepadJoinFocusBehavior = require(script.Components.DesktopGameJoinCard.GamepadJoinFocusBehavior)

function GameJoinCard.getInExperienceGameJoinCard()
	return require(script.Components.InExperienceGameJoinCard.InExperienceGameJoinCard)
end

GameJoinCard.useGameJoinCardNavigation = require(script.Components.DesktopGameJoinCard.useGameJoinCardNavigation)
GameJoinCard.useJoinUserActions = require(script.Hooks.useJoinUserActions)
GameJoinCard.usePrefetchInGameFriendsMedia = require(script.Hooks.usePrefetchInGameFriendsMedia)
GameJoinCard.MobileGameJoinCard = require(script.Components.MobileGameJoinCard)
GameJoinCard.MobileGameJoinCardView = MobileGameJoinCard
GameJoinCard.Telemetry = {
	GameJoinCardTelemetry = require(script.Telemetry.GameJoinCardTelemetry),
	GameJoinCardTTI = require(script.Telemetry.GameJoinCardTTI)
}

GameJoinCard["jest.config"] = script["jest.config"]
return GameJoinCard
