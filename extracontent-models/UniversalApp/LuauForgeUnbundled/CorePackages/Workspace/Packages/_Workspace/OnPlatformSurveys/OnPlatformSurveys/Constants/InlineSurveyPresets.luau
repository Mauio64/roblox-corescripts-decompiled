require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/InlineSurveyPreset")
local Surface = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/Surface")

local v5 = {
	NoInviteInContent = {
		hasInvite = false,
		inviteSurface = nil,
		surveySurface = Surface.InContent
	},
	NoInviteModal = {
		hasInvite = false,
		inviteSurface = nil,
		surveySurface = Surface.Modal
	},
	ModalInviteToModalSurvey = {
		hasInvite = true,
		inviteSurface = Surface.Modal,
		surveySurface = Surface.Modal
	},
	InContentInviteToModalSurvey = {
		hasInvite = true,
		inviteSurface = Surface.InContent,
		surveySurface = Surface.Modal
	}
}

return {
	getPresentationConfig = function(value)
		return v5[value or "NoInviteModal"] or v5.NoInviteModal
	end,
	DEFAULT_PRESET = "NoInviteModal"
}
