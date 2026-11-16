local parent = script:FindFirstAncestor("PlayabilityRodux").Parent
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppPlayableUxTreatment = SharedFlags.FFlagLuaAppPlayableUxTreatment
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePT = SharedFlags2.FFlagLuaAppPlayButtonPrivatePT

local Result = require(parent.Result)

local PlayabilityStatusModel = {}

function PlayabilityStatusModel.new()
	return {}
end

function PlayabilityStatusModel.mock()
	local v = PlayabilityStatusModel.new()
	v.universeId = "149757"
	v.isPlayable = true
	v.playabilityStatus = PlayabilityStatusEnum.Playable

	return v
end

function PlayabilityStatusModel.fromJsonData(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("PlayabilityStatus.fromJsonData expects universeId to be a number or a string")
	end

	if type(data.isPlayable) ~= "boolean" then
		return Result.error("PlayabilityStatus.fromJsonData expects isPlayable to be a boolean")
	end

	if type(data.playabilityStatus) ~= "string" then
		return Result.error("PlayabilityStatus.fromJsonData expects playabilityStatus to be a string")
	end

	local v = PlayabilityStatusModel.new()
	v.universeId = tostring(data.universeId)
	v.isPlayable = data.isPlayable
	v.playabilityStatus = data.playabilityStatus
	v.unplayableDisplayText = data.unplayableDisplayText

	if type(data.demoModeAvailable) == "boolean" then
		v.demoModeAvailable = data.demoModeAvailable
	end

	if FFlagLuaAppPlayButtonPrivatePT then
		local privatePlaytestInfo = data.privatePlaytestInfo

		if type(privatePlaytestInfo) == "table" and type(privatePlaytestInfo.isPlayable) == "boolean" then
			v.privatePlaytestInfo = {
				isPlayable = privatePlaytestInfo.isPlayable,
				playabilityStatus = privatePlaytestInfo.playabilityStatus
			}
		end
	end

	if FFlagLuaAppPlayableUxTreatment then
		local playableUxTreatment = data.playableUxTreatment

		if
			playableUxTreatment
			and type(playableUxTreatment) == "table"
			and type(playableUxTreatment.treatment) == "string"
		then
			v.playableUxTreatment = {
				treatment = playableUxTreatment.treatment,
				data = playableUxTreatment.data
			}
		end
	end

	return Result.success(v)
end

return PlayabilityStatusModel
