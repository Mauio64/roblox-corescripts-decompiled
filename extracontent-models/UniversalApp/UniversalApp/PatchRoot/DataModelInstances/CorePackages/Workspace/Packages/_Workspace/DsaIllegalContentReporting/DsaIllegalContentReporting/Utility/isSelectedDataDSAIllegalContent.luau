local DsaIllegalContentReporting = script:FindFirstAncestor("DsaIllegalContentReporting")
local Constants = require(DsaIllegalContentReporting.Utility.Constants)

local function isSelectedDataDSAIllegalContent(t1: {[any]: any}) -- line: 6
	-- upvalues: Constants (copy)
	if t1 == nil then
		return false
	end

	local v5 = t1[#t1]

	return v5 ~= nil and v5.tagValues[1] == Constants.DSA_TAG_VALUE
end

return isSelectedDataDSAIllegalContent
