local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.VoiceChat.createVoiceRestrictionController)
local Constants = require(script.Parent.Parent.Constants)

local function getRestrictionType(p): string
	if not p then
		return "Nudge"
	end

	if not p.bannedUntil then
		return "PermanentBan"
	end

	if p.banReason == Constants.BAN_REASON.NUDGE_V3 then
		return "NudgeBan"
	end

	return "TemporaryBan"
end

return getRestrictionType
