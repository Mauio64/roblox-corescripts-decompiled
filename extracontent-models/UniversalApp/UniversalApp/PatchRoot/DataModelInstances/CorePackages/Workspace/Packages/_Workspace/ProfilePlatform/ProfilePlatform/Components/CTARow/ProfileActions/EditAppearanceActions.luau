local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Foundation = require(ProfilePlatformParent.Foundation)
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
	[Enums.ProfileActions.EditAppearance] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else function(p1) -- line: 22
		-- upvalues: Enums (copy), ButtonVariant (copy), ProfileTypes (copy), EventNames (copy)
		return {
			text = p1.localized[Enums.ProfileActions.EditAppearance],
			variant = ButtonVariant.Emphasis,
			onActivated = {
				[ProfileTypes.User] = function() -- line: 27
					-- upvalues: p1 (copy), EventNames (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.CTAButtonEditAppearance, {
						buttonSurface = p1.buttonSurface
					})
				end
			}
		}
	end,
	[Enums.ProfileActions.EditAvatar] = function(p2) -- line: 37
		-- upvalues: Enums (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), IconName (copy), ProfileTypes (copy), EventNames (copy)
		return {
			text = p2.localized[Enums.ProfileActions.EditAvatar],
			icon = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else IconName.Person,
			onActivated = {
				[ProfileTypes.User] = function() -- line: 42
					-- upvalues: p2 (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), EventNames (copy)
					p2.analytics.fireAnalyticsEvent(if not FFlagProfilePlatformEnableEditAppearanceMenu then EventNames.CTAButtonEditAvatar else EventNames.EditAppearanceMenuEditAvatar, {
						buttonSurface = p2.buttonSurface
					})
					p2.navigateTo.editAvatar()
				end
			}
		}
	end,
	[Enums.ProfileActions.EditLook] = if not FFlagProfilePlatformEnableEditLook then nil else function(p3) -- line: 58
		-- upvalues: Enums (copy), IconName (copy), ProfileTypes (copy), EventNames (copy)
		return {
			text = p3.localized[Enums.ProfileActions.EditLook],
			icon = IconName.Person,
			onActivated = {
				[ProfileTypes.User] = function() -- line: 63
					-- upvalues: p3 (copy), EventNames (copy)
					p3.analytics.fireAnalyticsEvent(EventNames.CTAButtonEditLook, {
						buttonSurface = p3.buttonSurface
					})
					p3.navigateTo.editAvatar()
				end
			}
		}
	end,
	[Enums.ProfileActions.EditEmotes] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else function(p4) -- line: 75
		-- upvalues: Enums (copy), IconName (copy), ProfileTypes (copy), EventNames (copy)
		return {
			text = p4.localized[Enums.ProfileActions.EditEmotes],
			icon = IconName.SquareFaceWavingHand,
			onActivated = {
				[ProfileTypes.User] = function() -- line: 80
					-- upvalues: p4 (copy), EventNames (copy)
					p4.analytics.fireAnalyticsEvent(EventNames.EditAppearanceMenuEditEmote, {
						buttonSurface = p4.buttonSurface
					})

					local editEmotes = p4.navigateTo.editEmotes

					if editEmotes then
						editEmotes()
					end
				end
			}
		}
	end,
	[Enums.ProfileActions.SwitchAvatar] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else function(p5) -- line: 95
		-- upvalues: Enums (copy), IconName (copy), ProfileTypes (copy), EventNames (copy)
		return {
			text = p5.localized[Enums.ProfileActions.SwitchAvatar],
			icon = IconName.PersonStandingArrowReverse,
			onActivated = {
				[ProfileTypes.User] = function() -- line: 100
					-- upvalues: p5 (copy), EventNames (copy)
					p5.analytics.fireAnalyticsEvent(EventNames.EditAppearanceMenuSwitchAvatar, {
						buttonSurface = p5.buttonSurface
					})

					local switchAvatar = p5.navigateTo.switchAvatar

					if switchAvatar then
						switchAvatar()
					end
				end
			}
		}
	end,
	[Enums.ProfileActions.EditBackground] = if not FFlagProfilePlatformEnableEditAppearanceMenu or not FFlagProfilePlatformEditBackgroundMenuItem then nil else function(p6) -- line: 116
		-- upvalues: Enums (copy), IconName (copy), ProfileTypes (copy), EventNames (copy)
		return {
			text = p6.localized[Enums.ProfileActions.EditBackground],
			icon = IconName.Image,
			onActivated = {
				[ProfileTypes.User] = function() -- line: 121
					-- upvalues: p6 (copy), EventNames (copy)
					p6.analytics.fireAnalyticsEvent(EventNames.EditAppearanceMenuEditBackground, {
						buttonSurface = p6.buttonSurface
					})

					local editBackground = p6.navigateTo.editBackground

					if editBackground then
						editBackground()
					end
				end
			}
		}
	end
}
