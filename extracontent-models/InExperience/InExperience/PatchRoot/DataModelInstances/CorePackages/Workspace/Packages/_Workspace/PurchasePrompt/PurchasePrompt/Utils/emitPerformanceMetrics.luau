local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptLite = require(parent.PurchasePromptLite)
local PurchasePromptLite2 = require(parent.PurchasePromptLite)
local Enums = PurchasePromptLite2.Enums
require(PurchasePrompt.types)
local getTTIEventName = PurchasePromptLite.getTTIEventName
local IntervalPerformanceTracker = require(parent.IntervalPerformanceTracker)
local intervalPerformanceTracker = IntervalPerformanceTracker.IntervalPerformanceTracker
local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker

local Constants = require(PurchasePrompt.Misc.Constants)
local defineFastInt = game:DefineFastInt("ProductPurchaseContainerFPSDuration", 2)
local SharedFlags = require(parent.SharedFlags)
local FIntTTIUnifiedPurchaseSamplingRate = SharedFlags.FIntTTIUnifiedPurchaseSamplingRate
local FFlagEnableEdpPreviewPurchaseSurface = SharedFlags.FFlagEnableEdpPreviewPurchaseSurface
local FFlagEnableInExperiencePurchaseModalMetrics = require(PurchasePrompt.Flags.FFlagEnableInExperiencePurchaseModalMetrics)

local set = {
	[Enums.ProductPurchaseSurface.Catalog] = true,
	[Enums.ProductPurchaseSurface.EDP] = true
}

if FFlagEnableInExperiencePurchaseModalMetrics then
	set[Enums.ProductPurchaseSurface.InExperience] = true
end

if FFlagEnableEdpPreviewPurchaseSurface then
	set[Enums.ProductPurchaseSurface.EDPPreview] = true
end

function emitPerformanceMetrics(p: string, p2)
	if p2 ~= nil and set[p2] then
		emitFPSMetrics(p, p2)
		emitTTIMetrics(p2)
	end
end

function emitFPSMetrics(p: string, p2)
	intervalPerformanceTracker:startTracking(
		Constants.PerformanceMetrics.Prefix.UnifiedPurchaseModal .. "_" .. p .. "_" .. p2,
		defineFastInt,
		nil,
		true,
		true
	)

	intervalPerformanceTracker:startTracking(
		Constants.PerformanceMetrics.Prefix.PurchaseModal .. "_" .. p .. "_" .. p2,
		defineFastInt,
		nil,
		true,
		true
	)
end

function emitTTIMetrics(p)
	local ttiEventName = getTTIEventName(p)
	timeToInteractiveTracker.trackEnd(ttiEventName, {
		samplingRateOverride = FIntTTIUnifiedPurchaseSamplingRate
	})
end

return emitPerformanceMetrics
