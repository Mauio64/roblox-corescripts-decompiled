local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin

local CTAButtonsRow = require(ProfilePlatform.Components.CTARow.CTAButtonsRow)
local useMapJsonToButtonList = require(ProfilePlatform.Components.CTARow.useMapJsonToButtonList)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useIsMeTab = require(ProfilePlatform.Hooks.useIsMeTab)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local SocialStopwatch = require(parent.SocialStopwatch)
local LoadingStagesExtension = require(ProfilePlatform.Analytics.LoadingStagesExtension)
local RoactUtils = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab

local function CTAButtonRowContainer(p)
	local buttonList = useMapJsonToButtonList(useProfileWrapperContext().profileId)
	local v

	if FFlagAXEnableProfileTab then
		v = useIsMeTab()
	end

	local v2 = useProfileAnalyticsContext()
	useEffectOnMount(function()
		local v3 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.ProfileOpened)

		local fireAnalyticsEvent = v2.fireAnalyticsEvent
		local profileLoadingStage = EventNames.ProfileLoadingStage
		local statValue

		if v3 then
			statValue = v3.timeElapsed
		end

		fireAnalyticsEvent(profileLoadingStage, {
			statValue = statValue,
			status = LoadingStagesExtension.CTALoaded,
			isProfilePlatform = true
		})
	end)

	if FFlagAXEnableProfileTab and v then
		return React.createElement(CTAButtonsRow, {
			buttonList = buttonList,
			layoutOrder = p.layoutOrder
		})
	end

	return React.createElement(
		HorizontalPageMargin,
		{
			size = UDim2.new(1, 0, 0, 0),
			backgroundTransparency = 1,
			layoutOrder = p.layoutOrder,
			useAutomaticSizing = true
		},
		{
			Content = React.createElement(CTAButtonsRow, {
				buttonList = buttonList,
				layoutOrder = 1
			})
		}
	)
end

return CTAButtonRowContainer
