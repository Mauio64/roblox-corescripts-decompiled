local Foundation = script:FindFirstAncestor("Foundation")

local DisplacedBehavior = require(Foundation.Providers.ScreenRegion.DisplacedBehavior)
local RegionOrder = require(Foundation.Providers.ScreenRegion.RegionOrder)
local ScreenRegion = require(Foundation.Providers.ScreenRegion.ScreenRegion)
local ScreenRegionKind = require(Foundation.Providers.ScreenRegion.ScreenRegionKind)

local Bottom = ScreenRegion.Bottom
local v = { capacity = 1, order = RegionOrder.Newest, displaced = 0, sequential = true }
local suspendsByFloatingBanner = { [ScreenRegionKind.FloatingBanner] = DisplacedBehavior.Suspend }
v.displaced = suspendsByFloatingBanner
return { [Bottom] = v }
