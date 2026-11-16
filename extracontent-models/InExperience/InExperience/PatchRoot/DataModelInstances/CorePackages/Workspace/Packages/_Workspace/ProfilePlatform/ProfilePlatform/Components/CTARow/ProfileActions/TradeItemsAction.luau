local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Http = require(parent.Http)
local SharedFlags = require(parent.SharedFlags)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local Url = Http.Url
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

local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

local FFlagProfilePlatformEnableTradeItems = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTradeItems)

return {
	[Enums.ProfileActions.TradeItems] = FFlagProfilePlatformEnableTradeItems and function(data)
		return {
			text = data.localized[Enums.ProfileActions.TradeItems],
			onActivated = {
				[ProfileTypes.User] = function()
					if data.buttonSurface == Enums.ButtonSurface.ContextualMenu then
						data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonTradeItems, {
							buttonSurface = data.buttonSurface
						})
					else
						data.analytics.fireAnalyticsEvent(EventNames.CTAButtonTradeItems, {
							buttonSurface = data.buttonSurface
						})
					end

					local v = {
						name = AppPage.GenericWebPage,
						detail = `{Url.BASE_URL}users/{data.profileId}/trade`,
						extraProps = { titleKey = TextKeys.TradeItems }
					}

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
