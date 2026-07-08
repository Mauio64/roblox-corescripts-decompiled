local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local PurchasePromptLite = require(PurchasePromptParent.PurchasePromptLite)
local Enums = require(PurchasePromptParent.PurchasePromptLite).Enums

require(PurchasePrompt.types)

local getTTIEventName = PurchasePromptLite.getTTIEventName
local IntervalPerformanceTracker = require(PurchasePromptParent.IntervalPerformanceTracker).IntervalPerformanceTracker
local TimeToInteractiveTracker = require(PurchasePromptParent.TimeToInteractiveTracker).TimeToInteractiveTracker
local Constants = require(PurchasePrompt.Misc.Constants)
local v9 = game:DefineFastInt("ProductPurchaseContainerFPSDuration", 2)
local FIntTTIUnifiedPurchaseSamplingRate = require(PurchasePromptParent.SharedFlags).FIntTTIUnifiedPurchaseSamplingRate
local t1 = {
	[Enums.ProductPurchaseSurface.Catalog] = true,
	[Enums.ProductPurchaseSurface.EDP] = true
}

function emitPerformanceMetrics(s1: string, p1) -- line: 22
	-- upvalues: t1 (copy)
	if p1 ~= nil and t1[p1] then
		emitFPSMetrics(s1, p1)
		emitTTIMetrics(p1)
	end
end
function emitFPSMetrics(s2: string, p2) -- line: 30
	-- upvalues: IntervalPerformanceTracker (copy), Constants (copy), v9 (copy)
	IntervalPerformanceTracker:startTracking(Constants.PerformanceMetrics.Prefix.UnifiedPurchaseModal .. "_" .. s2 .. "_" .. p2, v9, nil, true, true)
	IntervalPerformanceTracker:startTracking(Constants.PerformanceMetrics.Prefix.PurchaseModal .. "_" .. s2 .. "_" .. p2, v9, nil, true, true)
end
function emitTTIMetrics(p3) -- line: 51
	-- upvalues: getTTIEventName (copy), TimeToInteractiveTracker (copy), FIntTTIUnifiedPurchaseSamplingRate (copy)
	local v17 = getTTIEventName(p3)

	TimeToInteractiveTracker.trackEnd(v17, {
		samplingRateOverride = FIntTTIUnifiedPurchaseSamplingRate
	})
end

return emitPerformanceMetrics
