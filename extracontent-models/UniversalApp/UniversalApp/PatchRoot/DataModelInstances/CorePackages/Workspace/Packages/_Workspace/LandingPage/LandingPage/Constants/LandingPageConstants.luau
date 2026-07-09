local Parent = script:FindFirstAncestor("LandingPage").Parent
local Colors = require(Parent.UIBlox).App.Style.Colors
local Otter = require(Parent.Otter)
local FFlagLuaEnableGenreLandingDeeplink = require(Parent.SharedFlags).FFlagLuaEnableGenreLandingDeeplink
local _ = {
	VERTICAL = 90,
	HORIZONTAL = 0
}
local u6 = nil

if FFlagLuaEnableGenreLandingDeeplink then
	local v7 = game:DefineFastString("LandingPageGenreBackgroundAssetIdMap", "rpg,90754439723067;simulation,82204668514040;sports,95472945314001;strategy,111044680425731;survival,133883166686292;fps,72055167390311")
	local t1 = {}

	for _, v10 in string.split(v7, ";") do
		local parts = string.split(v10, ",")
		local v12 = parts[1]
		local v13 = parts[2]

		if v12 and v12 ~= "" and v13 and v13 ~= "" then
			t1[v12] = v13
		end
	end

	u6 = t1
end

local function getGenreBackgroundAssetId(s1: string?) -- line: 35
	-- upvalues: FFlagLuaEnableGenreLandingDeeplink (copy), u6 (ref)
	if not FFlagLuaEnableGenreLandingDeeplink or (not u6 or not s1) then
		return nil
	end

	return u6[s1]
end

return {
	ContentProps = {
		ContentFocusedStyle = {
			LogoPositionYScale = 0.08,
			BodyPositionYScale = 0.3,
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 1)
		}
	},
	Common = {
		IMAGE_ASSET_URL_TEMPLATE = "http://www.roblox.com/asset/?id=%s",
		AccountCarouselAvatarScaleFactor = game:DefineFastInt("AccountCarouselAvatarScaleFactor", 125) / 100,
		RobloxLogo = {
			IMAGE = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_1x.png",
			ASPECT_RATIO = 5.78,
			MAX_WIDTH_SMALL = 150,
			MAX_WIDTH_LARGE = 460
		},
		DefaultBackground = {
			IMAGE = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg",
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
		GenreBackgroundAssetIdMap = u6,
		GetGenreBackgroundAssetId = getGenreBackgroundAssetId,
		GradientOrientation = {
			VERTICAL = 90,
			HORIZONTAL = 0
		}
	},
	CustomizedLandingPage = {
		GameIcon = {
			SIZE = 100,
			PADDING = 0,
			CORNER_RADIUS = 0.12,
			IMAGE_URI_TEMPLATE = "rbxthumb://type=GameIcon&id=%s&w=150&h=150"
		},
		BackgroundGradient = {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Colors.Black),
				ColorSequenceKeypoint.new(0.4, Colors.White),
				ColorSequenceKeypoint.new(0.75, Colors.Black),
				ColorSequenceKeypoint.new(1, Colors.Black)
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 0)
			})
		},
		BackgroundAnimation = {
			RIGHT_EDGE = 0,
			LEFT_EDGE = 1,
			TRANSPARENT = 1,
			OPAQUE = 0,
			OTTER_SCROLL_LEFT = Otter.ease(1, {
				duration = 16,
				easingStyle = Enum.EasingStyle.Linear
			}),
			OTTER_INSTANT_RIGHT = Otter.instant(0),
			OTTER_FADE_OUT = Otter.ease(1, {
				duration = 0.4,
				easingStyle = Enum.EasingStyle.Linear
			}),
			OTTER_INSTANT_IN = Otter.instant(0)
		}
	}
}
