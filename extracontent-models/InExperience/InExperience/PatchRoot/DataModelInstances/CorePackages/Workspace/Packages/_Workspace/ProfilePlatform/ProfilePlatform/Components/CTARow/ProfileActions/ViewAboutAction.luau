local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local SharedFlags = require(parent.SharedFlags)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet

return {
	[Enums.ProfileActions.ViewAbout] = FFlagProfilePlatformNewProfileHeader and function(data)
		return {
			text = data.localized[Enums.ProfileActions.ViewAbout],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					local v = { name = AppPage.AboutDetailsSheet, extraProps = 0 }
					local extraProps = { sections = data.aboutSections, profileName = 0 }
					local profileName

					if FFlagProfileAboutDetailsUseSheet then
						profileName = data.aboutProfileName
					end

					extraProps.profileName = profileName
					v.extraProps = extraProps

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v))
					else
						data.dispatch(NavigateDown(v))
					end
				end
			}
		}
	end or nil
}
