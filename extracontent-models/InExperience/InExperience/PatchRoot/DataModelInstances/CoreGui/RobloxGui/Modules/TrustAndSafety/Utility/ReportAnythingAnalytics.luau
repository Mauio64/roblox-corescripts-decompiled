local CorePackages = game:GetService("CorePackages")
local EventIngestService = game:GetService("EventIngestService")
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
	annotationOptionSeenCount = 0,
	annotationPageSeenCount = 0,
	annotationPlaceCount = 0,
	annotationUndoCount = 0,
	annotationRedoCount = 0,
	abandonedForRetake = false,
	isPortraitMode = false
}
local u7 = nil

return {
	incrementAnnotationOptionSeen = function() -- line: 52
		-- upvalues: t2 (ref)
		local v8 = t2

		v8.annotationOptionSeenCount = v8.annotationOptionSeenCount + 1
	end,
	incrementAnnotationPageSeen = function() -- line: 55
		-- upvalues: t2 (ref)
		local v9 = t2

		v9.annotationPageSeenCount = v9.annotationPageSeenCount + 1
	end,
	incrementAnnotationPlace = function() -- line: 58
		-- upvalues: t2 (ref)
		local v10 = t2

		v10.annotationPlaceCount = v10.annotationPlaceCount + 1
	end,
	incrementAnnotationUndo = function() -- line: 61
		-- upvalues: t2 (ref)
		local v11 = t2

		v11.annotationUndoCount = v11.annotationUndoCount + 1
	end,
	incrementAnnotationRedo = function() -- line: 64
		-- upvalues: t2 (ref)
		local v12 = t2

		v12.annotationRedoCount = v12.annotationRedoCount + 1
	end,
	setAbandonedForRetake = function() -- line: 67
		-- upvalues: t2 (ref)
		t2.abandonedForRetake = true
	end,
	setIsPortraitMode = function() -- line: 70
		-- upvalues: t2 (ref)
		t2.isPortraitMode = true
	end,
	getAccumulatedParameters = function() -- line: 74
		-- upvalues: t2 (ref)
		return t2
	end,
	emitAvatarsIdentifiedStats = function(p1) -- line: 77
		-- upvalues: Cryo (copy), u7 (ref), EventIngest (copy), EventIngestService (copy), t1 (copy)
		local v14 = Cryo.Dictionary.join(p1, {
			duration = p1.duration * 1000000
		})

		if not u7 then
			u7 = EventIngest.new(EventIngestService)
		end

		u7:sendEventDeferred(t1.Context.LegacyMenu, t1.EventType.AvatarsIdentified, v14)
	end,
	clear = function() -- line: 87
		-- upvalues: t2 (ref)
		t2 = {
			annotationOptionSeenCount = 0,
			annotationPageSeenCount = 0,
			annotationPlaceCount = 0,
			annotationUndoCount = 0,
			annotationRedoCount = 0,
			abandonedForRetake = false,
			isPortraitMode = false
		}
	end
}
