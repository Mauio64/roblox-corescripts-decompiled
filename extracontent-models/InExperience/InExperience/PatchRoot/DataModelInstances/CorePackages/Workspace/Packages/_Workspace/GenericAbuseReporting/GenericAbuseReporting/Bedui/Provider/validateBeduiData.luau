local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local t = require(GenericAbuseReportingParent.t)
local BeduiDataTypeInterface = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes).BeduiDataTypeInterface

local function validateInterface(p1, t1: {[any]: any}) -- line: 15
	-- upvalues: t (copy)
	return t.interface(t1)(p1)
end
local function validateStepId(p2) -- line: 24
	local v11 = false
	local t2 = {}

	for _, v14 in p2.nodes do
		if v14.stepId == p2.rootStepId then
			if v11 then
				return false, "Bedui data contains multiple steps with the same rootStepId"
			end

			v11 = true
		end

		if table.find(t2, v14.stepId) then
			return false, "Bedui data contains duplicate stepId: " .. tostring(v14.stepId)
		end

		table.insert(t2, v14.stepId)
	end

	if v11 then
		return true, nil
	end

	return false, "Bedui data does not contain a step with the rootStepId"
end
local function validateBeduiData(t3: {[any]: any}?) -- line: 51
	-- upvalues: BeduiDataTypeInterface (copy), t (copy), validateStepId (copy)
	if t3 == nil then
		return false, "Bedui data is nil"
	end

	local v16 = BeduiDataTypeInterface

	if not t.interface(v16)(t3) then
		return false, "Bedui data does not conform to the expected structure"
	end

	return validateStepId(t3)
end

return validateBeduiData
