local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")

require(OnPlatformSurveys.Enums.InlineSurveyPreset)

local Surface = require(OnPlatformSurveys.Enums.Surface)
local t1 = {
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
	DEFAULT_PRESET = "NoInviteModal",
	getPresentationConfig = function(p1) -- line: 29
		-- upvalues: t1 (copy)
		return t1[p1 or "NoInviteModal"] or t1.NoInviteModal
	end
}
