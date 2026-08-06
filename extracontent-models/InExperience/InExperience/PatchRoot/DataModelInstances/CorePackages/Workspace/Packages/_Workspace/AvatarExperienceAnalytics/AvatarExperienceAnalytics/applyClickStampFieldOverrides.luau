local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)

local function applyClickStampFieldOverrides(t1: {[any]: any}, t2: {[any]: any}) -- line: 3
	-- upvalues: UnifiedEventLogConstants (copy)
	if t2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "selectedItemIndex"] ~= nil then
		t1.selectedItemIndex = nil
	end

	if t2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "keyword"] ~= nil then
		t1.keyword = nil
	end

	return t1
end

return applyClickStampFieldOverrides
