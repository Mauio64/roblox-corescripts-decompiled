local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayabilityRodux/DiscoveryTypes").PlayabilityStatusEnum
local fFlagLuaAppPlayableUxTreatment = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayabilityRodux/SharedFlags").FFlagLuaAppPlayableUxTreatment
local fFlagLuaAppPlayButtonPrivatePT = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayabilityRodux/SharedFlags").FFlagLuaAppPlayButtonPrivatePT

local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayabilityRodux/Result")

local v5 = {}

function v5.new()
	return {}
end

function v5.mock()
	local v6 = v5.new()
	v6.universeId = "149757"
	v6.isPlayable = true
	v6.playabilityStatus = playabilityStatusEnum.Playable

	return v6
end

function v5.fromJsonData(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("PlayabilityStatus.fromJsonData expects universeId to be a number or a string")
	end

	if type(data.isPlayable) ~= "boolean" then
		return Result.error("PlayabilityStatus.fromJsonData expects isPlayable to be a boolean")
	end

	if type(data.playabilityStatus) ~= "string" then
		return Result.error("PlayabilityStatus.fromJsonData expects playabilityStatus to be a string")
	end

	local v6 = v5.new()
	v6.universeId = tostring(data.universeId)
	v6.isPlayable = data.isPlayable
	v6.playabilityStatus = data.playabilityStatus
	v6.unplayableDisplayText = data.unplayableDisplayText

	if type(data.demoModeAvailable) == "boolean" then
		v6.demoModeAvailable = data.demoModeAvailable
	end

	if fFlagLuaAppPlayButtonPrivatePT then
		local privatePlaytestInfo = data.privatePlaytestInfo

		if type(privatePlaytestInfo) == "table" and type(privatePlaytestInfo.isPlayable) == "boolean" then
			v6.privatePlaytestInfo = {
				isPlayable = privatePlaytestInfo.isPlayable,
				playabilityStatus = privatePlaytestInfo.playabilityStatus
			}
		end
	end

	if fFlagLuaAppPlayableUxTreatment then
		local playableUxTreatment = data.playableUxTreatment

		if
			playableUxTreatment
			and type(playableUxTreatment) == "table"
			and type(playableUxTreatment.treatment) == "string"
		then
			v6.playableUxTreatment = {
				treatment = playableUxTreatment.treatment,
				data = playableUxTreatment.data
			}
		end
	end

	return Result.success(v6)
end

return v5
