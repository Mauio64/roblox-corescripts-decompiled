local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums")

local url = Http.Url
local appPage = RobloxAppEnums.AppPage

local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

local FFlagProfilePlatformEnableTradeItems = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableTradeItems")

return {
	[Enums.ProfileActions.TradeItems] = FFlagProfilePlatformEnableTradeItems and function(data)
		return {
			text = data.localized[Enums.ProfileActions.TradeItems],
			onActivated = {
				[profileTypes.User] = function()
					if data.buttonSurface == Enums.ButtonSurface.ContextualMenu then
						data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonTradeItems, {
							buttonSurface = data.buttonSurface
						})
					else
						data.analytics.fireAnalyticsEvent(EventNames.CTAButtonTradeItems, {
							buttonSurface = data.buttonSurface
						})
					end

					local v8 = {
						name = appPage.GenericWebPage,
						detail = `{url.BASE_URL}users/{data.profileId}/trade`,
						extraProps = { titleKey = TextKeys.TradeItems }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						data.dispatch(navigateDown(v8))
					end
				end
			}
		}
	end or nil
}
