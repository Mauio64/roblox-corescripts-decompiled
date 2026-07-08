local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local ParentParent = script.Parent.Parent
local FTUXSlideshow = require(ParentParent.Components.FTUXSlideshow)
local FTUXConstants = require(ParentParent.Resources.FTUXConstants)

require(ParentParent.Enums.PlatformEnum)

local v7 = game:DefineFastInt("FTUXPanelXOffset", 50)

local function FTUXPanel(t1: {[any]: any}) -- line: 20
	-- upvalues: useStyle (copy), FTUXConstants (copy), React (copy), v7 (copy), FTUXSlideshow (copy)
	local v10 = useStyle()
	local PanelConstants = FTUXConstants[t1.platform].PanelConstants
	local MAIN_SCREEN_SIZE_WIDTH = PanelConstants.MAIN_SCREEN_SIZE_WIDTH
	local MAIN_SCREEN_SIZE_HEIGHT = PanelConstants.MAIN_SCREEN_SIZE_HEIGHT
	local SLIDESHOW_FRAME_WIDTH = PanelConstants.SLIDESHOW_FRAME_WIDTH
	local SLIDESHOW_FRAME_HEIGHT = PanelConstants.SLIDESHOW_FRAME_HEIGHT
	local SLIDESHOW_FRAME_X = PanelConstants.SLIDESHOW_FRAME_X
	local SLIDESHOW_FRAME_Y = PanelConstants.SLIDESHOW_FRAME_Y
	local BackgroundDefaultColor = v10.Theme.BackgroundDefault.Color

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, v7, 0, 0)
	}, {
		Slideshow = React.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			BackgroundColor3 = BackgroundDefaultColor,
			Size = UDim2.new(SLIDESHOW_FRAME_WIDTH / MAIN_SCREEN_SIZE_WIDTH, 0, SLIDESHOW_FRAME_HEIGHT / MAIN_SCREEN_SIZE_HEIGHT, 0),
			Position = UDim2.new(SLIDESHOW_FRAME_X / MAIN_SCREEN_SIZE_WIDTH, 0, SLIDESHOW_FRAME_Y / MAIN_SCREEN_SIZE_HEIGHT, 0)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.02, 0)
			}),
			Slideshow = React.createElement(FTUXSlideshow, {
				platform = t1.platform
			}, {})
		})
	})
end

return FTUXPanel
