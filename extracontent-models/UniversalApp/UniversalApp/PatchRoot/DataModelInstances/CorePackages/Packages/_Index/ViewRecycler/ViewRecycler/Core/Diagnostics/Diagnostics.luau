local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local frozen = table.freeze({
	RangeChanged = "rangeChanged",
	PoolChanged = "poolChanged",
	ItemViewsSynchronized = "itemViewsSynchronized",
	MeasurementsProcessingStarted = "measurementsProcessingStarted",
	MeasurementsProcessed = "measurementsProcessed",
	ScrollCorrection = "scrollCorrection"
})

local frozen2 = table.freeze({ Visible = "visible", Rendered = "rendered" })

local frozen3 = table.freeze({
	Create = "create",
	Acquire = "acquire",
	Release = "release",
	Evict = "evict"
})

local frozen4 = table.freeze({
	Data = "data",
	Measurement = "measurement",
	ProgrammaticScroll = "programmaticScroll",
	Policy = FFlagViewRecyclerReact084 and "policy" or nil
})

return table.freeze({
	EventKind = frozen,
	PoolAction = frozen3,
	RangeKind = frozen2,
	ScrollCorrectionSource = frozen4
})
