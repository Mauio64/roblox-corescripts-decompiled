local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local t = require(parent.t)

local AbuseReportBeduiTypes = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local BeduiDataTypeInterface = AbuseReportBeduiTypes.BeduiDataTypeInterface

local function validateInterface(p, beduiDataTypeInterface) -- 1 equivalent call inferred from this helper
	return t.interface(beduiDataTypeInterface)(p)
end

local function validateStepId(p)
	local flag = false
	local stepIds = {}

	for _, node in p.nodes do
		if node.stepId == p.rootStepId then
			if flag then
				return false, "Bedui data contains multiple steps with the same rootStepId"
			end

			flag = true
		end

		if table.find(stepIds, node.stepId) then
			return false, "Bedui data contains duplicate stepId: " .. tostring(node.stepId)
		end

		table.insert(stepIds, node.stepId)
	end

	if flag then
		return true, nil
	end

	return false, "Bedui data does not contain a step with the rootStepId"
end

local function validateBeduiData(p)
	if p == nil then
		return false, "Bedui data is nil"
	end

	if validateInterface(p, BeduiDataTypeInterface) then -- inferred equivalent call
		return validateStepId(p)
	end

	return false, "Bedui data does not conform to the expected structure"
end

return validateBeduiData
