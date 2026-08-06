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
			onboardingTitle = "CoreScripts.FTUX.Heading.NewTiltOnboarding",
			onboardingText = "CoreScripts.FTUX.Label.NewTiltOnboarding",
			updatesTitle = "CoreScripts.FTUX.Heading.NewTiltUpdate",
			updatesText = "CoreScripts.FTUX.Label.NewTiltUpdate",
			align = PopoverAlign.Start
		}
	},
	whatsNew = {
		{
			id = "SideSheet",
			scopeId = "TiltMenu",
			anchorId = "sideSheet",
			title = "CoreScripts.FTUX.Heading.SideSheetUpdate",
			text = "CoreScripts.FTUX.Label.SideSheetUpdate",
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
			title = "CoreScripts.FTUX.Heading.LeaveRespawn",
			text = "CoreScripts.FTUX.Label.LeaveRespawn",
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
			title = "CoreScripts.FTUX.Heading.SocialOnboarding",
			text = "CoreScripts.FTUX.Label.SocialOnboarding",
			icon = "",
			enabled = true,
			publishedTime = "2026-05-01T00:00:00Z",
			align = PopoverAlign.Start
		},
		{
			id = "SideSheet",
			scopeId = "TiltMenu",
			anchorId = "sideSheet",
			title = "CoreScripts.FTUX.Heading.SideSheetUpdate",
			text = "CoreScripts.FTUX.Label.SideSheetOnboarding",
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
			title = "CoreScripts.FTUX.Heading.LeaveRespawn",
			text = "CoreScripts.FTUX.Label.LeaveRespawn",
			icon = "",
			enabled = true,
			publishedTime = "2026-05-01T00:00:00Z",
			side = PopoverSide.Right,
			align = PopoverAlign.End
		}
	}
}
