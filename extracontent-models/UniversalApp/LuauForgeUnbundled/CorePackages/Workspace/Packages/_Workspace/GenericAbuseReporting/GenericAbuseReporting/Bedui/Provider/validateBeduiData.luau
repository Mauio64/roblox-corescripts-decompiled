local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/t")

local beduiDataTypeInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes").BeduiDataTypeInterface

local function validateInterface(p2, p3)
	return t.interface(p3)(p2)
end

local function validateStepId(p2)
	local flag = false
	local stepIds = {}

	for k, node in p2.nodes do
		if node.stepId == p2.rootStepId then
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

local function validateBeduiData(p2)
	if p2 == nil then
		return false, "Bedui data is nil"
	end

	if t.interface(beduiDataTypeInterface)(p2) then
		return validateStepId(p2)
	end

	return false, "Bedui data does not conform to the expected structure"
end

return validateBeduiData
