local DsaIllegalContentReporting = script:FindFirstAncestor("DsaIllegalContentReporting")
local Constants = require(DsaIllegalContentReporting.Utility.Constants)

local function isSelectedDataDSAIllegalContent(list): boolean
	if list == nil then
		return false
	end

	local item = list[#list]
	return item ~= nil and item.tagValues[1] == Constants.DSA_TAG_VALUE
end

return isSelectedDataDSAIllegalContent
