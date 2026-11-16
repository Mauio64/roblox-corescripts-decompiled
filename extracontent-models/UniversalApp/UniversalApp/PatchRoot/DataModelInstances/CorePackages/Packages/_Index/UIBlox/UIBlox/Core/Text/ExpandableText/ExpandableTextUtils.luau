local GetTextHeight = require(script.Parent.Parent.GetTextHeight)
local ExpandableTextUtils = {}

function ExpandableTextUtils.getExpandableTextHeights(p, p2, p3, p4)
	local v = p.BaseSize * p.Body.RelativeSize
	return GetTextHeight(p3, p.Body.Font, v, p2), p4 * v
end

function ExpandableTextUtils.getCanExpand(p, p2, p3, p4): boolean
	local v = p.BaseSize * p.Body.RelativeSize
	local textHeight = GetTextHeight(p3, p.Body.Font, v, p2)
	return p4 * v < textHeight
end

return ExpandableTextUtils
