local Flags = require(script.Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script.Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08

local AttachedViewportOverlay = require(script.RobloxAdapter.AttachedViewportOverlay)
local CanvasItemPlacer = require(script.RobloxAdapter.CanvasItemPlacer)
local ViewRecycler = require(script.Parent.ViewRecycler)

local HostPlacement = require(script.RobloxAdapter.HostPlacement)
local HostPresentationPhase = require(script.RobloxAdapter.HostPresentationPhase)

local MeasurementBatcher = require(script.RobloxAdapter.MeasurementBatcher)
local Measurer = require(script.RobloxAdapter.Measurer)
local ReparentableHost = require(script.RobloxAdapter.ReparentableHost)

local ScrollHost = require(script.RobloxAdapter.ScrollHost)
local ScrollbarOverlay = require(script.RobloxAdapter.ScrollbarOverlay)
local SlotGeometry = require(script.RobloxAdapter.SlotGeometry)

local VacantHosts = require(script.RobloxAdapter.VacantHosts)
local ViewportCoordinator = require(script.RobloxAdapter.ViewportCoordinator)
local createRecyclingScope = require(script.RobloxAdapter.createRecyclingScope)
local createVirtualizer = require(script.RobloxAdapter.createVirtualizer)

if not FFlagViewRecyclerReact084 then
	VacantHosts = nil
end

if FFlagViewRecyclerReact084 then
	AttachedViewportOverlay = nil
elseif FFlagViewRecyclerReact08 then
	AttachedViewportOverlay = nil
end

if FFlagViewRecyclerReact084 then
	CanvasItemPlacer = nil
elseif FFlagViewRecyclerReact08 then
	CanvasItemPlacer = nil
end

if FFlagViewRecyclerReact084 then
	HostPlacement = nil
elseif FFlagViewRecyclerReact08 then
	HostPlacement = nil
end

if FFlagViewRecyclerReact084 then
	ScrollHost = nil
elseif FFlagViewRecyclerReact08 then
	ScrollHost = nil
end

local frozen = table.freeze({
	ScrollbarOverlay = ScrollbarOverlay,
	VacantHosts = VacantHosts,
	AttachedViewportOverlay = AttachedViewportOverlay,
	CanvasItemPlacer = CanvasItemPlacer,
	HostPlacement = HostPlacement,
	ScrollHost = ScrollHost
})

local v = {
	createRecyclingScope = createRecyclingScope.create,
	createVirtualizer = createVirtualizer,
	ChatPreset = ViewRecycler.ChatPreset,
	HostPresentationPhase = HostPresentationPhase,
	ReparentableHost = ReparentableHost,
	SlotGeometry = SlotGeometry,
	ViewportCoordinator = ViewportCoordinator,
	Internal = frozen,
	["jest.config"] = script["jest.config"]
}

if FFlagViewRecyclerReact084 then
	MeasurementBatcher = nil
elseif FFlagViewRecyclerReact08 then
	MeasurementBatcher = nil
end

v.MeasurementBatcher = MeasurementBatcher

if FFlagViewRecyclerReact084 then
	Measurer = nil
elseif FFlagViewRecyclerReact08 then
	Measurer = nil
end

v.Measurer = Measurer
return table.freeze(v)
