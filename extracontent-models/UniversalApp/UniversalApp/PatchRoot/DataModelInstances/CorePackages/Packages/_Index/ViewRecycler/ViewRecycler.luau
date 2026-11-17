local Flags = require(script.Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local AutoScrollPolicy = require(script.Core.Enums.AutoScrollPolicy)
local Axis = require(script.Core.Enums.Axis)
local ChatPreset = require(script.Core.ViewportBehavior.ChatPreset)
local DataPrefetch = require(script.Core.DataPrefetch)
local DataSource = require(script.Core.DataSource)
local DataSourceChangeType = require(script.Core.Enums.DataSourceChangeType)
local Diagnostics = require(script.Core.Diagnostics)
local IdentityKind = require(script.Core.Enums.IdentityKind)
local Layout = require(script.Core.Layout)
require(script.Core.PinnedItems)
local PinnedPosition = require(script.Core.Enums.PinnedPosition)
local ReachedThreshold = require(script.Core.ViewportBehavior.ReachedThreshold)
local Recycling = require(script.Core.Recycling)
local ScrollAlignment = require(script.Core.Enums.ScrollAlignment)

local ScrollMotion = require(script.Core.Virtualizer.ScrollMotion)
local ScrollObservationKind = require(script.Core.Enums.ScrollObservationKind)
local ShallowTable = require(script.Internal.ShallowTable)
require(script.Core.Types)
local createScope = Recycling.createScope
local SlotBinder = require(script.Core.Recycling.SlotBinder)
local Virtualizer = require(script.Core.Virtualizer.Virtualizer)

if not FFlagViewRecyclerReact084 then
	ReachedThreshold = nil
end

if not FFlagViewRecyclerReact084 then
	ScrollMotion = nil
end

local frozen = table.freeze({
	createRecyclingScope = createScope,
	createVirtualizer = Virtualizer,
	createSlotBinder = SlotBinder,
	_Private = table.freeze({
		ReachedThreshold = ReachedThreshold,
		ShallowTable = ShallowTable,
		ScrollMotion = ScrollMotion
	})
})

return table.freeze({
	DataSource = DataSource,
	Diagnostics = Diagnostics,
	Layout = Layout,
	ChatPreset = ChatPreset,
	Axis = Axis,
	AutoScrollPolicy = AutoScrollPolicy,
	ScrollAlignment = ScrollAlignment,
	ScrollObservationKind = ScrollObservationKind,
	PinnedPosition = PinnedPosition,
	IdentityKind = IdentityKind,
	DataPrefetchEdge = DataPrefetch.Edge,
	DataSourceChangeType = DataSourceChangeType,
	Adapter = frozen,
	["jest.config"] = script["jest.config"]
})
