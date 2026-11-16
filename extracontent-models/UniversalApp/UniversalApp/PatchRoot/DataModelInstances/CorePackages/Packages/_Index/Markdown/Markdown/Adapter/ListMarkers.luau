local parent = script:FindFirstAncestor("Markdown").Parent
require(parent.CommonMark)
local ListMarkers = {}

function ListMarkers.startNumber(p)
	if p.kind == "OrderedList" then
		return p.markerStartNumber or 1
	end

	return nil
end

function ListMarkers.bulletPrefix(p): string
	local v

	if p.kind == "BulletList" then
		v = p.marker
	end

	return if v == "*" then "* " else "- "
end

function ListMarkers.orderedPrefix(p: number)
	return (tostring(p))
end

return ListMarkers
