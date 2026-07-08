local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)
local FFlagEnablePartyVoiceChangersInLua = dependencies.SharedFlags.FFlagEnablePartyVoiceChangersInLua
local t = dependencies.t
local t1 = {}

function t1.new(p1) -- line: 10
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.format(p2) -- line: 22
	-- upvalues: t1 (copy), FFlagEnablePartyVoiceChangersInLua (copy)
	return (t1.new({
		userId = p2.userId,
		isLocalUser = p2.isLocalUser,
		username = p2.username,
		displayname = p2.displayname,
		isMuted = p2.isMuted,
		isMutedLocally = p2.isMutedLocally,
		isVoiceChangerActive = if not FFlagEnablePartyVoiceChangersInLua then nil else p2.isVoiceChangerActive,
		isVoiceChangerHearMyselfActive = if not FFlagEnablePartyVoiceChangersInLua then nil else p2.isVoiceChangerHearMyselfActive,
		selectedVoicePack = if not FFlagEnablePartyVoiceChangersInLua then nil else p2.selectedVoicePack
	}))
end

t1.isValid = if not FFlagEnablePartyVoiceChangersInLua then t.strictInterface({
	userId = t.number,
	isLocalUser = t.boolean,
	username = t.string,
	displayname = t.string,
	isMuted = t.boolean,
	isMutedLocally = t.boolean
}) else t.strictInterface({
	userId = t.number,
	isLocalUser = t.boolean,
	username = t.string,
	displayname = t.string,
	isMuted = t.boolean,
	isMutedLocally = t.boolean,
	isVoiceChangerActive = t.boolean,
	isVoiceChangerHearMyselfActive = t.boolean,
	selectedVoicePack = t.string
})

return t1
