local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)
local fFlagEnablePartyVoiceChangersInLua = dependencies.SharedFlags.FFlagEnablePartyVoiceChangersInLua

local t = dependencies.t

local ParticipantModel = {}

function ParticipantModel.new(p)
	assert(ParticipantModel.isValid(p))

	ParticipantModel.__index = ParticipantModel

	setmetatable(p, ParticipantModel)

	return p
end

function ParticipantModel.format(data)
	local new = ParticipantModel.new
	local v = {
		userId = data.userId,
		isLocalUser = data.isLocalUser,
		username = data.username,
		displayname = data.displayname,
		isMuted = data.isMuted,
		isMutedLocally = data.isMutedLocally,
		isVoiceChangerActive = 0,
		isVoiceChangerHearMyselfActive = 0,
		selectedVoicePack = 0
	}
	local isVoiceChangerActive

	if fFlagEnablePartyVoiceChangersInLua then
		isVoiceChangerActive = data.isVoiceChangerActive
	end

	v.isVoiceChangerActive = isVoiceChangerActive
	local isVoiceChangerHearMyselfActive

	if fFlagEnablePartyVoiceChangersInLua then
		isVoiceChangerHearMyselfActive = data.isVoiceChangerHearMyselfActive
	end

	v.isVoiceChangerHearMyselfActive = isVoiceChangerHearMyselfActive
	local selectedVoicePack

	if fFlagEnablePartyVoiceChangersInLua then
		selectedVoicePack = data.selectedVoicePack
	end

	v.selectedVoicePack = selectedVoicePack
	return (new(v))
end

local isValid

if fFlagEnablePartyVoiceChangersInLua then
	isValid = t.strictInterface({
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
else
	isValid = t.strictInterface({
		userId = t.number,
		isLocalUser = t.boolean,
		username = t.string,
		displayname = t.string,
		isMuted = t.boolean,
		isMutedLocally = t.boolean
	})
end

ParticipantModel.isValid = isValid

return ParticipantModel
