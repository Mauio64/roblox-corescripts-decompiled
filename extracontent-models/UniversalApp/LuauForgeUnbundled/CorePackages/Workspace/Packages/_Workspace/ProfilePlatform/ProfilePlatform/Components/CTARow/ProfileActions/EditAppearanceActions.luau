local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

local FFlagProfilePlatformEnableEditAppearanceMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableEditAppearanceMenu")

local FFlagProfilePlatformEditBackgroundMenuItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEditBackgroundMenuItem")
local FFlagProfilePlatformEnableEditLook = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableEditLook")

return {
	[Enums.ProfileActions.EditAppearance] = FFlagProfilePlatformEnableEditAppearanceMenu and function(data)
		return {
			text = data.localized[Enums.ProfileActions.EditAppearance],
			variant = buttonVariant.Emphasis,
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonEditAppearance, {
						buttonSurface = data.buttonSurface
					})
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.EditAvatar] = function(data)
		local v6 = {
			text = data.localized[Enums.ProfileActions.EditAvatar],
			icon = 0,
			onActivated = 0
		}
		local v7 = if FFlagProfilePlatformEnableEditAppearanceMenu then iconName.Person else nil
		v6.icon = v7
		v6.onActivated = {
			[profileTypes.User] = function()
				local fireAnalyticsEvent = data.analytics.fireAnalyticsEvent

				local v9 = if FFlagProfilePlatformEnableEditAppearanceMenu then EventNames.EditAppearanceMenuEditAvatar else EventNames.CTAButtonEditAvatar
				fireAnalyticsEvent(v9, { buttonSurface = data.buttonSurface })

				data.navigateTo.editAvatar()
			end
		}
		return v6
	end,
	[Enums.ProfileActions.EditLook] = FFlagProfilePlatformEnableEditLook and function(data)
		return {
			text = data.localized[Enums.ProfileActions.EditLook],
			icon = iconName.Person,
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonEditLook, {
						buttonSurface = data.buttonSurface
					})

					data.navigateTo.editAvatar()
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.EditEmotes] = FFlagProfilePlatformEnableEditAppearanceMenu and function(data)
		return {
			text = data.localized[Enums.ProfileActions.EditEmotes],
			icon = iconName.SquareFaceWavingHand,
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.EditAppearanceMenuEditEmote, {
						buttonSurface = data.buttonSurface
					})

					local editEmotes = data.navigateTo.editEmotes

					if editEmotes then
						editEmotes()
					end
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.SwitchAvatar] = FFlagProfilePlatformEnableEditAppearanceMenu and function(data)
		return {
			text = data.localized[Enums.ProfileActions.SwitchAvatar],
			icon = iconName.PersonStandingArrowReverse,
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.EditAppearanceMenuSwitchAvatar, {
						buttonSurface = data.buttonSurface
					})

					local switchAvatar = data.navigateTo.switchAvatar

					if switchAvatar then
						switchAvatar()
					end
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.EditBackground] = FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem and function(data)
		return {
			text = data.localized[Enums.ProfileActions.EditBackground],
			icon = iconName.Image,
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.EditAppearanceMenuEditBackground, {
						buttonSurface = data.buttonSurface
					})

					local editBackground = data.navigateTo.editBackground

					if editBackground then
						editBackground()
					end
				end
			}
		}
	end or nil
}
