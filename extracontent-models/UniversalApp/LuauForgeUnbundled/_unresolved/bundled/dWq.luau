local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dWr")

return {
	["StartTracking"] = Rodux.makeActionCreator("StartTracking", function(p2)
		return { type = "StartTracking", searchUuid = p2, startTime = os.clock() }
	end),
	PercievedTrackingStarted = Rodux.makeActionCreator("PercievedTrackingStarted", function()
		return { type = "PercievedTrackingStarted", startPerceivedTime = os.clock() }
	end),
	EndTracking = Rodux.makeActionCreator("EndTracking", function(p2, p3)
		return { type = "EndTracking", searchUuid = p2, endTime = p3 }
	end),
	AppendThumbnail = Rodux.makeActionCreator("AppendThumbnail", function(p2, p3)
		return { type = "AppendThumbnail", searchUuid = p2, thumbnailId = p3 }
	end),
	SetLoadedThumbnail = Rodux.makeActionCreator("SetLoadedThumbnail", function(p2, p3)
		return { type = "SetLoadedThumbnail", searchUuid = p2, thumbnailId = p3 }
	end),
	AppendThumbnails = Rodux.makeActionCreator("AppendThumbnails", function(p2)
		if module.isEnabled() then
			return { type = "AppendThumbnails", thumbnailsMap = p2 }
		end

		return {}
	end),
	SetLoadedThumbnails = Rodux.makeActionCreator("SetLoadedThumbnails", function(p2, p3)
		if module.isEnabled() then
			return { type = "SetLoadedThumbnails", searchUuid = p2, thumbnailIds = p3 }
		end

		return {}
	end)
}
