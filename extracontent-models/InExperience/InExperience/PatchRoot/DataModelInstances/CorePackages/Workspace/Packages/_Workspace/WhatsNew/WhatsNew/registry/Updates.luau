local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Constants = require(WhatsNew.Constants)

require(WhatsNew.Types)

local Foundation = require(WhatsNew.Parent.Foundation)
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

return {
	constants = Constants.DEFAULT,
	scopeTours = {
		InGame = {
			id = "InGame",
			parentScopeId = nil
		},
		TiltMenu = {
			id = "TiltMenu",
			parentScopeId = "InGame",
			anchorId = "nine_dot",
			openActionKey = "OpenTiltMenu",
			closeActionKey = "CloseTiltMenu",
			onboardingTitle = "The menu lives here",
			onboardingText = "The game menu contains in-game actions along with your game settings.",
			updatesTitle = "New singular menu",
			updatesText = "The old hamburger menu items have been moved here with the main menu. Access all your in-game actions in one click.",
			align = PopoverAlign.Start
		}
	},
	whatsNew = {
		{
			id = "SideSheet",
			scopeId = "TiltMenu",
			anchorId = "sideSheet",
			title = "All your actions in one place",
			text = "The menu still contains your favorite features from the old menu, in addition to options previously only available in the hamburger menu.",
			icon = "",
			enabled = true,
			publishedTime = "2026-05-01T00:00:00Z",
			side = PopoverSide.Right,
			align = PopoverAlign.Center
		},
		{
			id = "LeaveRespawn",
			scopeId = "TiltMenu",
			anchorId = "LeaveRespawn",
			title = "Leave and Respawn",
			text = "Leaving the game or respawning your avatar is easily accessible from the bottom of the menu.",
			icon = "",
			enabled = true,
			publishedTime = "2026-05-01T00:00:00Z",
			side = PopoverSide.Right,
			align = PopoverAlign.End
		}
	},
	onboarding = {
		{
			id = "TopBar",
			scopeId = "InGame",
			anchorId = "chat",
			title = "Social",
			text = "Easily access your social features from the top bar, including Chat.",
			icon = "",
			enabled = true,
			publishedTime = "2026-05-01T00:00:00Z",
			align = PopoverAlign.Start
		},
		{
			id = "SideSheet",
			scopeId = "TiltMenu",
			anchorId = "sideSheet",
			title = "Game details",
			text = "View game-specific information while keeping your focus on the game. Invite friends, try out Emotes, control Music, and more.",
			icon = "",
			enabled = true,
			publishedTime = "2026-05-01T00:00:00Z",
			side = PopoverSide.Right,
			align = PopoverAlign.Center
		},
		{
			id = "LeaveRespawn",
			scopeId = "TiltMenu",
			anchorId = "LeaveRespawn",
			title = "Leave and Respawn",
			text = "Leaving the game or respawning your avatar is easily accessible from the bottom of the menu.",
			icon = "",
			enabled = true,
			publishedTime = "2026-05-01T00:00:00Z",
			side = PopoverSide.Right,
			align = PopoverAlign.End
		}
	}
}
