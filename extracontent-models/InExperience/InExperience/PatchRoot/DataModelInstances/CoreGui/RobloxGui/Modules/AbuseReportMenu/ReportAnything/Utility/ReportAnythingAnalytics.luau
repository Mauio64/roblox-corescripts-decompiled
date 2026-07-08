local EventIngestService = game:GetService("EventIngestService")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.TnSAvatarIdentification)

local EventIngest = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest
local t1 = {
	EventType = {
		AvatarsIdentified = "ReportAnythingAvatarsIdentified"
	},
	Context = {
		LegacyMenu = "ReportAbuseLegacyMenu"
	}
}
local t2 = {
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
local u7 = nil

return {
	incrementPreviewBack = function() -- line: 59
		-- upvalues: t2 (ref)
		local v8 = t2

		v8.previewBackCount = v8.previewBackCount + 1
	end,
	incrementPreviewAttach = function() -- line: 62
		-- upvalues: t2 (ref)
		local v9 = t2

		v9.previewAttachCount = v9.previewAttachCount + 1
	end,
	incrementRetake = function() -- line: 65
		-- upvalues: t2 (ref)
		local v10 = t2

		v10.retakeCount = v10.retakeCount + 1
	end,
	setRetakeAbandon = function() -- line: 68
		-- upvalues: t2 (ref)
		t2.retakeAbandon = true
	end,
	incrementHighlightScene = function() -- line: 71
		-- upvalues: t2 (ref)
		local v11 = t2

		v11.highlightSceneCount = v11.highlightSceneCount + 1
	end,
	incrementAnnotationBack = function() -- line: 74
		-- upvalues: t2 (ref)
		local v12 = t2

		v12.annotationBackCount = v12.annotationBackCount + 1
	end,
	incrementAnnotationPlace = function() -- line: 77
		-- upvalues: t2 (ref)
		local v13 = t2

		v13.annotationPlaceCount = v13.annotationPlaceCount + 1
	end,
	incrementAnnotationUndo = function() -- line: 80
		-- upvalues: t2 (ref)
		local v14 = t2

		v14.annotationUndoCount = v14.annotationUndoCount + 1
	end,
	incrementAnnotationRedo = function() -- line: 83
		-- upvalues: t2 (ref)
		local v15 = t2

		v15.annotationRedoCount = v15.annotationRedoCount + 1
	end,
	setAnnotationNext = function() -- line: 86
		-- upvalues: t2 (ref)
		t2.annotationNext = true
	end,
	getAccumulatedParameters = function() -- line: 90
		-- upvalues: t2 (ref)
		return t2
	end,
	emitAvatarsIdentifiedStats = function(p1) -- line: 93
		-- upvalues: Cryo (copy), u7 (ref), EventIngest (copy), EventIngestService (copy), t1 (copy)
		local v17 = Cryo.Dictionary.join(p1, {
			duration = p1.duration * 1000000
		})

		if not u7 then
			u7 = EventIngest.new(EventIngestService)
		end

		u7:sendEventDeferred(t1.Context.LegacyMenu, t1.EventType.AvatarsIdentified, v17)
	end,
	clear = function() -- line: 103
		-- upvalues: t2 (ref)
		t2 = {
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
}
