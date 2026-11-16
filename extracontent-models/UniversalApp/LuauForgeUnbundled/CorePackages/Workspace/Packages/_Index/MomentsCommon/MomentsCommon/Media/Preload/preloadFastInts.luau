local preloadConstants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Preload/preloadConstants")

game:DefineFastInt("MomentsPreloadDownloadWindowForward", preloadConstants.downloadWindow.forward)
game:DefineFastInt("MomentsPreloadDownloadWindowBack", preloadConstants.downloadWindow.back)
game:DefineFastInt("MomentsPreloadDecodeWindowForward", preloadConstants.decodeWindow.forward)
game:DefineFastInt("MomentsPreloadDecodeWindowBack", preloadConstants.decodeWindow.back)
game:DefineFastInt("MomentsPreloadDecodeRetryDelayMs", 2000)
game:DefineFastInt("MomentsPreloadMaxDecodeRetries", 2)
game:DefineFastInt("MomentsScreenshotDurationSeconds", preloadConstants.screenshotDurationSeconds)

return {
	getDownloadWindow = function()
		return {
			forward = game:GetFastInt("MomentsPreloadDownloadWindowForward"),
			back = game:GetFastInt("MomentsPreloadDownloadWindowBack")
		}
	end,
	getDecodeWindow = function()
		return {
			forward = game:GetFastInt("MomentsPreloadDecodeWindowForward"),
			back = game:GetFastInt("MomentsPreloadDecodeWindowBack")
		}
	end,
	getDecodeRetryDelayMs = function()
		return game:GetFastInt("MomentsPreloadDecodeRetryDelayMs")
	end,
	getMaxDecodeRetries = function()
		return game:GetFastInt("MomentsPreloadMaxDecodeRetries")
	end,
	getScreenshotDurationSeconds = function()
		return game:GetFastInt("MomentsScreenshotDurationSeconds")
	end
}
