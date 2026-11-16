local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)

local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableEditLook = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditLook)

return {
	[Enums.ProfileActions.EditAppearance] = FFlagProfilePlatformEnableEditAppearanceMenu and function(data)
		return {
			text = data.localized[Enums.ProfileActions.EditAppearance],
			variant = ButtonVariant.Emphasis,
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonEditAppearance, {
						buttonSurface = data.buttonSurface
					})
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.EditAvatar] = function(data)
		local v = {
			text = data.localized[Enums.ProfileActions.EditAvatar],
			icon = 0,
			onActivated = 0
		}
		local icon

		if FFlagProfilePlatformEnableEditAppearanceMenu then
			icon = IconName.Person
		end

		v.icon = icon
		v.onActivated = {
			[ProfileTypes.User] = function()
				local fireAnalyticsEvent = data.analytics.fireAnalyticsEvent
				local v2

				if FFlagProfilePlatformEnableEditAppearanceMenu then
					v2 = EventNames.EditAppearanceMenuEditAvatar
				else
					v2 = EventNames.CTAButtonEditAvatar
				end

				fireAnalyticsEvent(v2, { buttonSurface = data.buttonSurface })

				data.navigateTo.editAvatar()
			end
		}
		return v
	end,
	[Enums.ProfileActions.EditLook] = FFlagProfilePlatformEnableEditLook and function(data)
		return {
			text = data.localized[Enums.ProfileActions.EditLook],
			icon = IconName.Person,
			onActivated = {
				[ProfileTypes.User] = function()
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
			icon = IconName.SquareFaceWavingHand,
			onActivated = {
				[ProfileTypes.User] = function()
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
			icon = IconName.PersonStandingArrowReverse,
			onActivated = {
				[ProfileTypes.User] = function()
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
			icon = IconName.Image,
			onActivated = {
				[ProfileTypes.User] = function()
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
