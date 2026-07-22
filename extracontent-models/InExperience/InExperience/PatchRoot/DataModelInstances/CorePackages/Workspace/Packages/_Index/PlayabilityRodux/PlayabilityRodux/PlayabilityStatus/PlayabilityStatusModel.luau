local Parent = script:FindFirstAncestor("PlayabilityRodux").Parent
local PlayabilityStatusEnum = require(Parent.DiscoveryTypes).PlayabilityStatusEnum
local FFlagLuaAppPlayableUxTreatment = require(Parent.SharedFlags).FFlagLuaAppPlayableUxTreatment
local FFlagLuaAppDemoModePlayButton = require(Parent.SharedFlags).FFlagLuaAppDemoModePlayButton
local Result = require(Parent.Result)
local t1 = {
	new = function() -- line: 48
		return {}
	end
}

function t1.mock() -- line: 54
	-- upvalues: t1 (copy), PlayabilityStatusEnum (copy)
	local v7 = t1.new()

	v7.universeId = "149757"
	v7.isPlayable = true
	v7.playabilityStatus = PlayabilityStatusEnum.Playable

	return v7
end
function t1.fromJsonData(p1) -- line: 63
	-- upvalues: Result (copy), t1 (copy), FFlagLuaAppDemoModePlayButton (copy), FFlagLuaAppPlayableUxTreatment (copy)
	if type(p1.universeId) ~= "number" and type(p1.universeId) ~= "string" then
		return Result.error("PlayabilityStatus.fromJsonData expects universeId to be a number or a string")
	end

	if type(p1.isPlayable) ~= "boolean" then
		return Result.error("PlayabilityStatus.fromJsonData expects isPlayable to be a boolean")
	end

	if type(p1.playabilityStatus) ~= "string" then
		return Result.error("PlayabilityStatus.fromJsonData expects playabilityStatus to be a string")
	end

	local v9 = t1.new()

	v9.universeId = tostring(p1.universeId)
	v9.isPlayable = p1.isPlayable
	v9.playabilityStatus = p1.playabilityStatus
	v9.unplayableDisplayText = p1.unplayableDisplayText

	if FFlagLuaAppDemoModePlayButton and type(p1.demoModeAvailable) == "boolean" then
		v9.demoModeAvailable = p1.demoModeAvailable
	end

	if FFlagLuaAppPlayableUxTreatment then
		local playableUxTreatment = p1.playableUxTreatment

		if playableUxTreatment and type(playableUxTreatment) == "table" and type(playableUxTreatment.treatment) == "string" then
			v9.playableUxTreatment = {
				treatment = playableUxTreatment.treatment,
				data = playableUxTreatment.data
			}
		end
	end

	return Result.success(v9)
end

return t1
