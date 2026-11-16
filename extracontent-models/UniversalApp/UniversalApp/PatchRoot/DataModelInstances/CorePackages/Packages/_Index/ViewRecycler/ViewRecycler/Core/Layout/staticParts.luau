local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Layout.LayoutRuntime)
require(ViewRecycler.Core.Types)
local StaticParts = {}

function StaticParts.expandItemRange(p, p2: number, p3: number, p4: number)
	return {
		firstIndex = math.max(1, p.firstIndex - p2),
		lastIndex = math.min(p4, p.lastIndex + p3)
	}
end

function StaticParts.updateItemMeasurementNoop(_)
	return { accepted = false, geometryChanged = false }
end

function StaticParts.requiresItemMeasurementFalse(): boolean
	return false
end

function StaticParts.geometryUnchanged(): boolean
	return false
end

function StaticParts.noop() end

return StaticParts
