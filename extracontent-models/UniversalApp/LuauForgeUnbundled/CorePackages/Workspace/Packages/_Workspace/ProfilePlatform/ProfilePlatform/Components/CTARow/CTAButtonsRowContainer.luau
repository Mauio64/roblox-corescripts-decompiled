local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local horizontalPageMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.Container.HorizontalPageMargin

local CTAButtonsRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/CTAButtonsRow")
local useMapJsonToButtonList = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/useMapJsonToButtonList")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useIsMeTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useIsMeTab")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local SocialStopwatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialStopwatch")
local LoadingStagesExtension = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/LoadingStagesExtension")
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.useEffectOnMount
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab

local function CTAButtonRowContainer(p2)
	local v5 = useMapJsonToButtonList(useProfileWrapperContext().profileId)
	local v6 = if fFlagAXEnableProfileTab then useIsMeTab() else nil
	local v7 = useProfileAnalyticsContext()
	useEffectOnMount(function()
		local v8 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.ProfileOpened)

		local fireAnalyticsEvent = v7.fireAnalyticsEvent
		local profileLoadingStage = EventNames.ProfileLoadingStage
		local v10 = if v8 then v8.timeElapsed else nil
		fireAnalyticsEvent(profileLoadingStage, {
			statValue = v10,
			status = LoadingStagesExtension.CTALoaded,
			isProfilePlatform = true
		})
	end)

	if fFlagAXEnableProfileTab and v6 then
		return React.createElement(CTAButtonsRow, {
			buttonList = v5,
			layoutOrder = p2.layoutOrder
		})
	end

	return React.createElement(
		horizontalPageMargin,
		{
			size = UDim2.new(1, 0, 0, 0),
			backgroundTransparency = 1,
			layoutOrder = p2.layoutOrder,
			useAutomaticSizing = true
		},
		{
			Content = React.createElement(CTAButtonsRow, { buttonList = v5, layoutOrder = 1 })
		}
	)
end

return CTAButtonRowContainer
