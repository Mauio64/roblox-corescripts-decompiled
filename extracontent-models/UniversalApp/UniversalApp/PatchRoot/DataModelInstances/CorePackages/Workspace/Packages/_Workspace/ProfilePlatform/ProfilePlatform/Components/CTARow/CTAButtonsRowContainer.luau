local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local HorizontalPageMargin = require(ProfilePlatformParent.UIBlox).App.Container.HorizontalPageMargin
local CTAButtonsRow = require(ProfilePlatform.Components.CTARow.CTAButtonsRow)
local useMapJsonToButtonList = require(ProfilePlatform.Components.CTARow.useMapJsonToButtonList)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useIsMeTab = require(ProfilePlatform.Hooks.useIsMeTab)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local SocialStopwatch = require(ProfilePlatformParent.SocialStopwatch)
local LoadingStagesExtension = require(ProfilePlatform.Analytics.LoadingStagesExtension)
local useEffectOnMount = require(ProfilePlatformParent.RoactUtils).Hooks.useEffectOnMount
local FFlagAddCTAButtonAnalytics = require(ProfilePlatform.Flags.FFlagAddCTAButtonAnalytics)
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab

local function CTAButtonRowContainer(t1: {[any]: any}) -- line: 26
	-- upvalues: useProfileWrapperContext (copy), useMapJsonToButtonList (copy), FFlagAXEnableProfileTab (copy), useIsMeTab (copy), FFlagAddCTAButtonAnalytics (copy), useProfileAnalyticsContext (copy), useEffectOnMount (copy), SocialStopwatch (copy), EventNames (copy), LoadingStagesExtension (copy), React (copy), CTAButtonsRow (copy), HorizontalPageMargin (copy)
	local profileId = useProfileWrapperContext().profileId
	local v19 = useMapJsonToButtonList(profileId)
	local v20 = if not FFlagAXEnableProfileTab then nil else useIsMeTab()

	if FFlagAddCTAButtonAnalytics then
		local v21 = useProfileAnalyticsContext()

		useEffectOnMount(function() -- line: 34
			-- upvalues: SocialStopwatch (copy), v21 (copy), EventNames (copy), LoadingStagesExtension (copy)
			local v22 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.ProfileOpened)

			v21.fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
				isProfilePlatform = true,
				statValue = if not v22 then nil else v22.timeElapsed,
				status = LoadingStagesExtension.CTALoaded
			})
		end)
	end

	if FFlagAXEnableProfileTab and v20 then
		return React.createElement(CTAButtonsRow, {
			buttonList = v19,
			layoutOrder = t1.layoutOrder
		})
	end

	return React.createElement(HorizontalPageMargin, {
		backgroundTransparency = 1,
		useAutomaticSizing = true,
		size = UDim2.new(1, 0, 0, 0),
		layoutOrder = t1.layoutOrder
	}, {
		Content = React.createElement(CTAButtonsRow, {
			layoutOrder = 1,
			buttonList = v19
		})
	})
end

return CTAButtonRowContainer
