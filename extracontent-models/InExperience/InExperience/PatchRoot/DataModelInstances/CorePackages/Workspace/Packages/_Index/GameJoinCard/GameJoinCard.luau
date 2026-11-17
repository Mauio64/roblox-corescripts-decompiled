local AnalyticsConstants = require(script.Analytics.AnalyticsConstants)
local MobileGameJoinCard = require(script.Components.MobileGameJoinCard.MobileGameJoinCard)
local SharedFlags = require(script.Parent.SharedFlags)
local FFlagSocialCarouselBuildPresence = SharedFlags.FFlagSocialCarouselBuildPresence

local analytics = {
	AnalyticsConstants = AnalyticsConstants,
	Constants = AnalyticsConstants,
	useGameJoinCardAnalytics = require(script.Analytics.useGameJoinCardAnalytics),
	useAgeCheckUpsellAnalytics = require(script.Analytics.useAgeCheckUpsellAnalytics)
}
local buildJoinCardPopover

if FFlagSocialCarouselBuildPresence then
	buildJoinCardPopover = require(script.Components.BuildJoinCard.BuildJoinCardPopoverContainer)
end

local buildJoinCardSheet

if FFlagSocialCarouselBuildPresence then
	buildJoinCardSheet = require(script.Components.BuildJoinCard.BuildJoinCardSheetContainer)
end

return {
	Analytics = analytics,
	BuildJoinCardPopover = buildJoinCardPopover,
	BuildJoinCardSheet = buildJoinCardSheet,
	DesktopGameJoinCard = require(script.Components.DesktopGameJoinCard.DesktopGameJoinCard),
	DesktopGameJoinCardContainer = require(script.Components.DesktopGameJoinCard.DesktopGameJoinCardContainer),
	GamepadJoinFocusBehavior = require(script.Components.DesktopGameJoinCard.GamepadJoinFocusBehavior),
	getInExperienceGameJoinCard = function()
		return require(script.Components.InExperienceGameJoinCard.InExperienceGameJoinCard)
	end,
	useGameJoinCardNavigation = require(script.Components.DesktopGameJoinCard.useGameJoinCardNavigation),
	useJoinUserActions = require(script.Hooks.useJoinUserActions),
	usePrefetchInGameFriendsMedia = require(script.Hooks.usePrefetchInGameFriendsMedia),
	MobileGameJoinCard = require(script.Components.MobileGameJoinCard),
	MobileGameJoinCardView = MobileGameJoinCard,
	Telemetry = {
		GameJoinCardTelemetry = require(script.Telemetry.GameJoinCardTelemetry),
		GameJoinCardTTI = require(script.Telemetry.GameJoinCardTTI)
	},
	["jest.config"] = script["jest.config"]
}
