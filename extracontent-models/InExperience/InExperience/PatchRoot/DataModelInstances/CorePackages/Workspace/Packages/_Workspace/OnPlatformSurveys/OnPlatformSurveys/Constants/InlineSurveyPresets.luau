local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")

require(OnPlatformSurveys.Enums.InlineSurveyPreset)
local Surface = require(OnPlatformSurveys.Enums.Surface)

local v = {
	NoInviteInContent = {
		hasInvite = false,
		inviteSurface = nil,
		surveySurface = Surface.InContent
	},
	NoInviteModal = { hasInvite = false, inviteSurface = nil, surveySurface = Surface.Modal },
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
		return v[value or "NoInviteModal"] or v.NoInviteModal
	end,
	DEFAULT_PRESET = "NoInviteModal"
}
