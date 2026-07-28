game:DefineFastFlag("MomentsStickerButton", false)

return function() -- line: 3
	return game:GetFastFlag("MomentsStickerButton") and game:GetEngineFeature("MomentsStickerOverlay")
end
