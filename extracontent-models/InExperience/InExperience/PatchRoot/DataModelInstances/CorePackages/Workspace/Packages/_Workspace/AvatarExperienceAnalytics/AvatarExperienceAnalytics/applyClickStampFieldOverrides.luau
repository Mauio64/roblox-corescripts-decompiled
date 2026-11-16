local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)

local function applyClickStampFieldOverrides(p, p2)
	if p2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "selectedItemIndex"] ~= nil then
		p.selectedItemIndex = nil
	end

	if p2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "keyword"] ~= nil then
		p.keyword = nil
	end

	return p
end

return applyClickStampFieldOverrides
