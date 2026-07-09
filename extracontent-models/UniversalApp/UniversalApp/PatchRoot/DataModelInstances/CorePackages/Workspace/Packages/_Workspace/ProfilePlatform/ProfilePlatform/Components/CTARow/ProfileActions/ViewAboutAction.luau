local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet

return {
	[Enums.ProfileActions.ViewAbout] = if not FFlagProfilePlatformNewProfileHeader then nil else function(p1) -- line: 25
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), AppPage (copy), FFlagProfileAboutDetailsUseSheet (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
		return {
			text = p1.localized[Enums.ProfileActions.ViewAbout],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 29
					-- upvalues: p1 (copy), EventNames (copy), AppPage (copy), FFlagProfileAboutDetailsUseSheet (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = p1.buttonSurface,
						btnContext = p1.profileWrapperContext.sourceInfo.source
					})

					local t1 = {
						name = AppPage.AboutDetailsSheet,
						extraProps = {
							sections = p1.aboutSections,
							profileName = if not FFlagProfileAboutDetailsUseSheet then nil else p1.aboutProfileName
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v7.down(v7.fromLegacyPage(t1))

						return
					end

					p1.dispatch(NavigateDown(t1))
				end
			}
		}
	end
}
