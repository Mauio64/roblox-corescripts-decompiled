local Parent = script:FindFirstAncestor("PlayabilityRodux").Parent
local PlayabilityStatusEnum = require(Parent.DiscoveryTypes).PlayabilityStatusEnum
local FFlagLuaAppPlayableUxTreatment = require(Parent.SharedFlags).FFlagLuaAppPlayableUxTreatment
local Result = require(Parent.Result)
local t1 = {
	new = function() -- line: 45
		return {}
	end
}

function t1.mock() -- line: 51
	-- upvalues: t1 (copy), PlayabilityStatusEnum (copy)
	local v6 = t1.new()

	v6.universeId = "149757"
	v6.isPlayable = true
	v6.playabilityStatus = PlayabilityStatusEnum.Playable

	return v6
end
function t1.fromJsonData(p1) -- line: 60
	-- upvalues: Result (copy), t1 (copy), FFlagLuaAppPlayableUxTreatment (copy)
	if type(p1.universeId) ~= "number" and type(p1.universeId) ~= "string" then
		return Result.error("PlayabilityStatus.fromJsonData expects universeId to be a number or a string")
	end

	if type(p1.isPlayable) ~= "boolean" then
		return Result.error("PlayabilityStatus.fromJsonData expects isPlayable to be a boolean")
	end

	if type(p1.playabilityStatus) ~= "string" then
		return Result.error("PlayabilityStatus.fromJsonData expects playabilityStatus to be a string")
	end

	local v8 = t1.new()

	v8.universeId = tostring(p1.universeId)
	v8.isPlayable = p1.isPlayable
	v8.playabilityStatus = p1.playabilityStatus
	v8.unplayableDisplayText = p1.unplayableDisplayText

	if FFlagLuaAppPlayableUxTreatment then
		local playableUxTreatment = p1.playableUxTreatment

		if playableUxTreatment and type(playableUxTreatment) == "table" and type(playableUxTreatment.treatment) == "string" then
			v8.playableUxTreatment = {
				treatment = playableUxTreatment.treatment,
				data = playableUxTreatment.data
			}
		end
	end

	return Result.success(v8)
end

return t1
