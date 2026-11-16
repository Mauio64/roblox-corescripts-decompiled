local EventIngestService = game:GetService("EventIngestService")

local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
require(CorePackages.Workspace.Packages.TnSAvatarIdentification)
local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local EventIngest = Analytics.AnalyticsReporters.EventIngest

local v = {
	EventType = { AvatarsIdentified = "ReportAnythingAvatarsIdentified" },
	Context = { LegacyMenu = "ReportAbuseLegacyMenu" }
}

local function fn() -- 2 equivalent calls inferred from this helper
	return {
		previewBackCount = 0,
		previewAttachCount = 0,
		retakeCount = 0,
		retakeAbandon = false,
		highlightSceneCount = 0,
		annotationBackCount = 0,
		annotationPlaceCount = 0,
		annotationUndoCount = 0,
		annotationRedoCount = 0,
		annotationNext = false
	}
end

local accumulatedParameters = fn() -- inferred equivalent call
local v2 = nil
local function fn2() -- 1 equivalent call inferred from this helper
	if not v2 then
		v2 = EventIngest.new(EventIngestService)
	end

	return v2
end

local ReportAnythingAnalytics = {}

function ReportAnythingAnalytics.incrementPreviewBack()
	accumulatedParameters.previewBackCount += 1
end
function ReportAnythingAnalytics.incrementPreviewAttach()
	accumulatedParameters.previewAttachCount += 1
end
function ReportAnythingAnalytics.incrementRetake()
	accumulatedParameters.retakeCount += 1
end
function ReportAnythingAnalytics.setRetakeAbandon()
	accumulatedParameters.retakeAbandon = true
end
function ReportAnythingAnalytics.incrementHighlightScene()
	accumulatedParameters.highlightSceneCount += 1
end
function ReportAnythingAnalytics.incrementAnnotationBack()
	accumulatedParameters.annotationBackCount += 1
end
function ReportAnythingAnalytics.incrementAnnotationPlace()
	accumulatedParameters.annotationPlaceCount += 1
end
function ReportAnythingAnalytics.incrementAnnotationUndo()
	accumulatedParameters.annotationUndoCount += 1
end
function ReportAnythingAnalytics.incrementAnnotationRedo()
	accumulatedParameters.annotationRedoCount += 1
end
function ReportAnythingAnalytics.setAnnotationNext()
	accumulatedParameters.annotationNext = true
end

function ReportAnythingAnalytics.getAccumulatedParameters()
	return accumulatedParameters
end

function ReportAnythingAnalytics.emitAvatarsIdentifiedStats(p)
	local joined = Cryo.Dictionary.join(p, {
		duration = p.duration * 1000000
	})

	fn2():sendEventDeferred(v.Context.LegacyMenu, v.EventType.AvatarsIdentified, joined) -- inferred equivalent call
end
function ReportAnythingAnalytics.clear()
	accumulatedParameters = fn() -- inferred equivalent call
end

return ReportAnythingAnalytics
