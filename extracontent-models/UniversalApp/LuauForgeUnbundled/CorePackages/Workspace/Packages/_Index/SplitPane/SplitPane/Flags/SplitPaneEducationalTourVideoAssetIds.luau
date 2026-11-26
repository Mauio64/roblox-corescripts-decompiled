local function toVideoAssetId(value, p2)
	return "rbxassetid://" .. (string.match(value, "^%s*(%d+)%s*$") or string.match(value, "^%s*rbxassetid://(%d+)%s*$") or p2)
end

local defineFastString = game:DefineFastString("SplitPaneTourStep1VideoAssetId", "106704716489493")
local v5 = {
	step1Video = "rbxassetid://" .. (string.match(defineFastString, "^%s*(%d+)%s*$") or string.match(defineFastString, "^%s*rbxassetid://(%d+)%s*$") or "106704716489493"),
	step1GamepadVideo = 0,
	step1CollapsedVideo = 0,
	step1CollapsedGamepadVideo = 0,
	step2Video = 0,
	step2GamepadVideo = 0,
	step3Video = 0,
	step3GamepadVideo = 0
}

local defineFastString2 = game:DefineFastString("SplitPaneTourStep1GamepadVideoAssetId", "99301012574407")
v5.step1GamepadVideo = "rbxassetid://" .. (string.match(defineFastString2, "^%s*(%d+)%s*$") or string.match(
	defineFastString2,
	"^%s*rbxassetid://(%d+)%s*$"
) or "99301012574407")

local defineFastString3 = game:DefineFastString(
	"SplitPaneTourStep1CollapsedVideoAssetId",
	"123698805466599"
)
v5.step1CollapsedVideo = "rbxassetid://" .. (string.match(defineFastString3, "^%s*(%d+)%s*$") or string.match(
	defineFastString3,
	"^%s*rbxassetid://(%d+)%s*$"
) or "123698805466599")

local defineFastString4 = game:DefineFastString(
	"SplitPaneTourStep1CollapsedGamepadVideoAssetId",
	"133523533509006"
)
v5.step1CollapsedGamepadVideo = "rbxassetid://" .. (string.match(defineFastString4, "^%s*(%d+)%s*$") or string.match(
	defineFastString4,
	"^%s*rbxassetid://(%d+)%s*$"
) or "133523533509006")

local defineFastString5 = game:DefineFastString("SplitPaneTourStep2VideoAssetId", "91347423607736")
v5.step2Video = "rbxassetid://" .. (string.match(defineFastString5, "^%s*(%d+)%s*$") or string.match(
	defineFastString5,
	"^%s*rbxassetid://(%d+)%s*$"
) or "91347423607736")

local defineFastString6 = game:DefineFastString("SplitPaneTourStep2GamepadVideoAssetId", "77203588287751")
v5.step2GamepadVideo = "rbxassetid://" .. (string.match(defineFastString6, "^%s*(%d+)%s*$") or string.match(
	defineFastString6,
	"^%s*rbxassetid://(%d+)%s*$"
) or "77203588287751")

local defineFastString7 = game:DefineFastString("SplitPaneTourStep3VideoAssetId", "74337454749050")
v5.step3Video = "rbxassetid://" .. (string.match(defineFastString7, "^%s*(%d+)%s*$") or string.match(
	defineFastString7,
	"^%s*rbxassetid://(%d+)%s*$"
) or "74337454749050")

local defineFastString8 = game:DefineFastString("SplitPaneTourStep3GamepadVideoAssetId", "139222920221400")
v5.step3GamepadVideo = "rbxassetid://" .. (string.match(defineFastString8, "^%s*(%d+)%s*$") or string.match(
	defineFastString8,
	"^%s*rbxassetid://(%d+)%s*$"
) or "139222920221400")
return v5
