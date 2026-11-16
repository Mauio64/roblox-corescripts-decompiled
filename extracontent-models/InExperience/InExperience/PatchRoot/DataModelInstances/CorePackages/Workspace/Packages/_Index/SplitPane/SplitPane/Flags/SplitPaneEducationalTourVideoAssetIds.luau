local function toVideoAssetId(value: string, p: string) -- 8 equivalent calls inferred from this helper
	return "rbxassetid://" .. (string.match(value, "^%s*(%d+)%s*$") or string.match(value, "^%s*rbxassetid://(%d+)%s*$") or p)
end

return {
	step1Video = toVideoAssetId( -- inferred equivalent call
		game:DefineFastString("SplitPaneTourStep1VideoAssetId", "106704716489493"),
		"106704716489493"
	),
	step1GamepadVideo = toVideoAssetId( -- inferred equivalent call
		game:DefineFastString("SplitPaneTourStep1GamepadVideoAssetId", "99301012574407"),
		"99301012574407"
	),
	step1CollapsedVideo = toVideoAssetId( -- inferred equivalent call
		game:DefineFastString("SplitPaneTourStep1CollapsedVideoAssetId", "123698805466599"),
		"123698805466599"
	),
	step1CollapsedGamepadVideo = toVideoAssetId( -- inferred equivalent call
		game:DefineFastString("SplitPaneTourStep1CollapsedGamepadVideoAssetId", "133523533509006"),
		"133523533509006"
	),
	step2Video = toVideoAssetId( -- inferred equivalent call
		game:DefineFastString("SplitPaneTourStep2VideoAssetId", "91347423607736"),
		"91347423607736"
	),
	step2GamepadVideo = toVideoAssetId( -- inferred equivalent call
		game:DefineFastString("SplitPaneTourStep2GamepadVideoAssetId", "77203588287751"),
		"77203588287751"
	),
	step3Video = toVideoAssetId( -- inferred equivalent call
		game:DefineFastString("SplitPaneTourStep3VideoAssetId", "74337454749050"),
		"74337454749050"
	),
	step3GamepadVideo = toVideoAssetId( -- inferred equivalent call
		game:DefineFastString("SplitPaneTourStep3GamepadVideoAssetId", "139222920221400"),
		"139222920221400"
	)
}
