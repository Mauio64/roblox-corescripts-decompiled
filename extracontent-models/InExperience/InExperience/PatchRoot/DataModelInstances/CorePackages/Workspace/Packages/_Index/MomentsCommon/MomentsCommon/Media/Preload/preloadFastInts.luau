local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local preloadConstants = require(MomentsCommon.Media.Preload.preloadConstants)

game:DefineFastInt("MomentsPreloadDownloadWindowForward", preloadConstants.downloadWindow.forward)
game:DefineFastInt("MomentsPreloadDownloadWindowBack", preloadConstants.downloadWindow.back)
game:DefineFastInt("MomentsPreloadDecodeWindowForward", preloadConstants.decodeWindow.forward)
game:DefineFastInt("MomentsPreloadDecodeWindowBack", preloadConstants.decodeWindow.back)
game:DefineFastInt("MomentsPreloadDecodeRetryDelayMs", 2000)
game:DefineFastInt("MomentsPreloadMaxDecodeRetries", 2)
game:DefineFastInt("MomentsScreenshotDurationSeconds", preloadConstants.screenshotDurationSeconds)
local PreloadFastInts = {}

function PreloadFastInts.getDownloadWindow()
	return {
		forward = game:GetFastInt("MomentsPreloadDownloadWindowForward"),
		back = game:GetFastInt("MomentsPreloadDownloadWindowBack")
	}
end

function PreloadFastInts.getDecodeWindow()
	return {
		forward = game:GetFastInt("MomentsPreloadDecodeWindowForward"),
		back = game:GetFastInt("MomentsPreloadDecodeWindowBack")
	}
end

function PreloadFastInts.getDecodeRetryDelayMs()
	return game:GetFastInt("MomentsPreloadDecodeRetryDelayMs")
end

function PreloadFastInts.getMaxDecodeRetries()
	return game:GetFastInt("MomentsPreloadMaxDecodeRetries")
end

function PreloadFastInts.getScreenshotDurationSeconds()
	return game:GetFastInt("MomentsScreenshotDurationSeconds")
end

return PreloadFastInts
