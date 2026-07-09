local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local AXCatalogPerfReduxReductionIXP = require(Modules.AvatarExperience.Experiments.AXCatalogPerfReduxReductionIXP)

return {
	StartTracking = Rodux.makeActionCreator("StartTracking", function(p1) -- line: 17
		return {
			type = "StartTracking",
			searchUuid = p1,
			startTime = os.clock()
		}
	end),
	PercievedTrackingStarted = Rodux.makeActionCreator("PercievedTrackingStarted", function() -- line: 26
		return {
			type = "PercievedTrackingStarted",
			startPerceivedTime = os.clock()
		}
	end),
	EndTracking = Rodux.makeActionCreator("EndTracking", function(p2, p3) -- line: 33
		return {
			type = "EndTracking",
			searchUuid = p2,
			endTime = p3
		}
	end),
	AppendThumbnail = Rodux.makeActionCreator("AppendThumbnail", function(p4, p5) -- line: 41
		return {
			type = "AppendThumbnail",
			searchUuid = p4,
			thumbnailId = p5
		}
	end),
	SetLoadedThumbnail = Rodux.makeActionCreator("SetLoadedThumbnail", function(p6, p7) -- line: 51
		return {
			type = "SetLoadedThumbnail",
			searchUuid = p6,
			thumbnailId = p7
		}
	end),
	AppendThumbnails = Rodux.makeActionCreator("AppendThumbnails", function(p8) -- line: 60
		-- upvalues: AXCatalogPerfReduxReductionIXP (copy)
		if not AXCatalogPerfReduxReductionIXP.isEnabled() then
			return {}
		end

		return {
			type = "AppendThumbnails",
			thumbnailsMap = p8
		}
	end),
	SetLoadedThumbnails = Rodux.makeActionCreator("SetLoadedThumbnails", function(p9, p10) -- line: 73
		-- upvalues: AXCatalogPerfReduxReductionIXP (copy)
		if not AXCatalogPerfReduxReductionIXP.isEnabled() then
			return {}
		end

		return {
			type = "SetLoadedThumbnails",
			searchUuid = p9,
			thumbnailIds = p10
		}
	end)
}
