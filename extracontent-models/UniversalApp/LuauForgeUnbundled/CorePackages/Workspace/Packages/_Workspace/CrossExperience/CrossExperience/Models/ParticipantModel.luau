local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/dependencies")
local fFlagEnablePartyVoiceChangersInLua = dependencies.SharedFlags.FFlagEnablePartyVoiceChangersInLua

local t = dependencies.t

local class = {}

function class.new(p2)
	assert(class.isValid(p2))

	class.__index = class

	setmetatable(p2, class)

	return p2
end

function class.format(data)
	local new = class.new
	local v5 = {
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
	local v6 = if fFlagEnablePartyVoiceChangersInLua then data.isVoiceChangerActive else nil
	v5.isVoiceChangerActive = v6

	local v7 = if fFlagEnablePartyVoiceChangersInLua then data.isVoiceChangerHearMyselfActive else nil
	v5.isVoiceChangerHearMyselfActive = v7

	local v8 = if fFlagEnablePartyVoiceChangersInLua then data.selectedVoicePack else nil
	v5.selectedVoicePack = v8
	return (new(v5))
end

local v5 = if fFlagEnablePartyVoiceChangersInLua then t.strictInterface({
	userId = t.number,
	isLocalUser = t.boolean,
	username = t.string,
	displayname = t.string,
	isMuted = t.boolean,
	isMutedLocally = t.boolean,
	isVoiceChangerActive = t.boolean,
	isVoiceChangerHearMyselfActive = t.boolean,
	selectedVoicePack = t.string
}) else t.strictInterface({
	userId = t.number,
	isLocalUser = t.boolean,
	username = t.string,
	displayname = t.string,
	isMuted = t.boolean,
	isMutedLocally = t.boolean
})
class.isValid = v5

return class
