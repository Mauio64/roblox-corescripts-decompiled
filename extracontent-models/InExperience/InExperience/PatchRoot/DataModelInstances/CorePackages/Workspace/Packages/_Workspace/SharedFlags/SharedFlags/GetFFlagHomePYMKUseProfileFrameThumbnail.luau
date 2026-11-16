local GetFFlagProfileFrameThumbnailEnabled = require(script.Parent.GetFFlagProfileFrameThumbnailEnabled)

game:DefineFastFlag("HomePYMKUseProfileFrameThumbnail", false)

return function()
	return game:GetFastFlag("HomePYMKUseProfileFrameThumbnail") and GetFFlagProfileFrameThumbnailEnabled()
end
