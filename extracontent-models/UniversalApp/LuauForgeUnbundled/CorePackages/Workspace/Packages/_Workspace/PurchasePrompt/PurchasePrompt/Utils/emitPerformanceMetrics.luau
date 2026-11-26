local PurchasePromptLite = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite")
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite").Enums
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local getTTIEventName = PurchasePromptLite.getTTIEventName
local intervalPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IntervalPerformanceTracker").IntervalPerformanceTracker
local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/TimeToInteractiveTracker").TimeToInteractiveTracker

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
local defineFastInt = game:DefineFastInt("ProductPurchaseContainerFPSDuration", 2)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")
local fIntTTIUnifiedPurchaseSamplingRate = SharedFlags.FIntTTIUnifiedPurchaseSamplingRate
local fFlagEnableEdpPreviewPurchaseSurface = SharedFlags.FFlagEnableEdpPreviewPurchaseSurface
local FFlagEnableInExperiencePurchaseModalMetrics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnableInExperiencePurchaseModalMetrics")

local set = {
	[enums.ProductPurchaseSurface.Catalog] = true,
	[enums.ProductPurchaseSurface.EDP] = true
}

if FFlagEnableInExperiencePurchaseModalMetrics then
	set[enums.ProductPurchaseSurface.InExperience] = true
end

if fFlagEnableEdpPreviewPurchaseSurface then
	set[enums.ProductPurchaseSurface.EDPPreview] = true
end

function LUAUFORGE_MODULE_GLOBALS_bji_emitPerformanceMetrics(p2, p3)
	if p3 ~= nil and set[p3] then
		LUAUFORGE_MODULE_GLOBALS_bji_emitFPSMetrics(p2, p3)
		LUAUFORGE_MODULE_GLOBALS_bji_emitTTIMetrics(p3)
	end
end

function LUAUFORGE_MODULE_GLOBALS_bji_emitFPSMetrics(p2, p3)
	intervalPerformanceTracker:startTracking(
		Constants.PerformanceMetrics.Prefix.UnifiedPurchaseModal .. "_" .. p2 .. "_" .. p3,
		defineFastInt,
		nil,
		true,
		true
	)

	intervalPerformanceTracker:startTracking(
		Constants.PerformanceMetrics.Prefix.PurchaseModal .. "_" .. p2 .. "_" .. p3,
		defineFastInt,
		nil,
		true,
		true
	)
end

function LUAUFORGE_MODULE_GLOBALS_bji_emitTTIMetrics(p2)
	local ttiEventName = getTTIEventName(p2)
	timeToInteractiveTracker.trackEnd(ttiEventName, {
		samplingRateOverride = fIntTTIUnifiedPurchaseSamplingRate
	})
end

return LUAUFORGE_MODULE_GLOBALS_bji_emitPerformanceMetrics
