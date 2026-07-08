local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Analytics = require(ParentParent.Analytics)
local getMeshMinMax = require(ParentParent.util.getMeshMinMax)

local function formatError(p1, p2, n1: number) -- line: 12
	local function getContext(p3) -- line: 13
		return p3.fullName .. "." .. p3.fieldName
	end

	local v10 = p1.fullName .. "." .. p1.fieldName
	local v11 = p2.fullName .. "." .. p2.fieldName

	return string.format("%s is more than max difference %.2f in size compared to the other mesh %s. You need to edit the model to adjust its size", v10, n1, v11)
end
local function validateMeshComparison(p4, p5, n2: number, p6) -- line: 28
	-- upvalues: getMeshMinMax (copy), Analytics (copy), formatError (copy)
	local v16, v17, v18, v19 = getMeshMinMax(p4, p6)

	if not v16 then
		return v16, v17
	end

	local v20, v21, v22, v23 = getMeshMinMax(p5, p6)

	if not v20 then
		return v20, v21
	end

	if n2 < (v18 - v22).Magnitude or n2 < (v19 - v23).Magnitude then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshComparison, nil, p6)

		return false, { formatError(p4, p5, n2) }
	end

	return true
end

return validateMeshComparison
