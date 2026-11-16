local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local parent = script.Parent.Parent
local FTUXSlideshow = require(parent.Components.FTUXSlideshow)
local FTUXConstants = require(parent.Resources.FTUXConstants)

require(parent.Enums.PlatformEnum)

local defineFastInt = game:DefineFastInt("FTUXPanelXOffset", 50)

local function FTUXPanel(p)
	local v = useStyle()
	local panelConstants = FTUXConstants[p.platform].PanelConstants

	local MAIN_SCREEN_SIZE_WIDTH = panelConstants.MAIN_SCREEN_SIZE_WIDTH
	local MAIN_SCREEN_SIZE_HEIGHT = panelConstants.MAIN_SCREEN_SIZE_HEIGHT
	local SLIDESHOW_FRAME_WIDTH = panelConstants.SLIDESHOW_FRAME_WIDTH
	local SLIDESHOW_FRAME_HEIGHT = panelConstants.SLIDESHOW_FRAME_HEIGHT
	local SLIDESHOW_FRAME_X = panelConstants.SLIDESHOW_FRAME_X
	local SLIDESHOW_FRAME_Y = panelConstants.SLIDESHOW_FRAME_Y

	local color = v.Theme.BackgroundDefault.Color

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, defineFastInt, 0, 0)
		},
		{
			Slideshow = React.createElement("Frame", {
				BackgroundColor3 = color,
				BackgroundTransparency = 0,
				Size = UDim2.new(
					SLIDESHOW_FRAME_WIDTH / MAIN_SCREEN_SIZE_WIDTH,
					0,
					SLIDESHOW_FRAME_HEIGHT / MAIN_SCREEN_SIZE_HEIGHT,
					0
				),
				Position = UDim2.new(
					SLIDESHOW_FRAME_X / MAIN_SCREEN_SIZE_WIDTH,
					0,
					SLIDESHOW_FRAME_Y / MAIN_SCREEN_SIZE_HEIGHT,
					0
				),
				BorderSizePixel = 0,
				ClipsDescendants = true
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.02, 0) }),
				Slideshow = React.createElement(FTUXSlideshow, { platform = p.platform }, {})
			})
		}
	)
end

return FTUXPanel
