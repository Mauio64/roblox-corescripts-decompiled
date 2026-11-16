local colors = require("@luauforge/bundled/fHO").App.Style.Colors
local module = require("@luauforge/bundled/fHP")

local module2 = require("@luauforge/bundled/fHQ")
local getGenreBackgroundAssetId = module2.getGenreBackgroundAssetId
local genreBackgroundAssetIdMap = module2.genreBackgroundAssetIdMap

local v5 = { VERTICAL = 90, HORIZONTAL = 0 }

return {
	ContentProps = {
		ContentFocusedStyle = {
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			LogoPositionYScale = 0.08,
			BodyPositionYScale = 0.3
		}
	},
	Common = {
		RobloxLogo = {
			IMAGE = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_1x.png",
			ASPECT_RATIO = 5.78,
			MAX_WIDTH_SMALL = 150,
			MAX_WIDTH_LARGE = 460
		},
		DefaultBackground = {
			IMAGE = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground_05202026.jpg",
			ASPECT_RATIO = 1
		},
		GenreBackgrounds = {
			RPG = {
				IMAGE = "rbxasset://textures/ui/LuaApp/graphic/Auth/RPGBackground.png",
				ASPECT_RATIO = 1
			},
			Simulation = {
				IMAGE = "rbxasset://textures/ui/LuaApp/graphic/Auth/SimulationBackground.png",
				ASPECT_RATIO = 1
			},
			Shooter = {
				IMAGE = "rbxasset://textures/ui/LuaApp/graphic/Auth/FPSBackground.png",
				ASPECT_RATIO = 1
			},
			SportsAndRacing = {
				IMAGE = "rbxasset://textures/ui/LuaApp/graphic/Auth/SportsAndRacingBackground.png",
				ASPECT_RATIO = 1
			}
		},
		GenreBackgroundAssetIdMap = genreBackgroundAssetIdMap,
		GetGenreBackgroundAssetId = getGenreBackgroundAssetId,
		GradientOrientation = { VERTICAL = 90, HORIZONTAL = 0 },
		IMAGE_ASSET_URL_TEMPLATE = "http://www.roblox.com/asset/?id=%s"
	},
	Pioneer = { MAX_CONTENT_SIZE = Vector2.new(340, 1000000) },
	CustomizedLandingPage = {
		GameIcon = {
			SIZE = 100,
			PADDING = 0,
			CORNER_RADIUS = 0.12,
			IMAGE_URI_TEMPLATE = "rbxthumb://type=GameIcon&id=%s&w=150&h=150"
		},
		BackgroundGradient = {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, colors.Black),
				ColorSequenceKeypoint.new(0.4, colors.White),
				ColorSequenceKeypoint.new(0.75, colors.Black),
				ColorSequenceKeypoint.new(1, colors.Black)
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 0)
			}),
			Rotation = 90
		},
		BackgroundAnimation = {
			RIGHT_EDGE = 0,
			LEFT_EDGE = 1,
			TRANSPARENT = 1,
			OPAQUE = 0,
			OTTER_SCROLL_LEFT = module.ease(1, {
				duration = 16,
				easingStyle = Enum.EasingStyle.Linear
			}),
			OTTER_INSTANT_RIGHT = module.instant(0),
			OTTER_FADE_OUT = module.ease(1, {
				duration = 0.4,
				easingStyle = Enum.EasingStyle.Linear
			}),
			OTTER_INSTANT_IN = module.instant(0)
		}
	}
}
