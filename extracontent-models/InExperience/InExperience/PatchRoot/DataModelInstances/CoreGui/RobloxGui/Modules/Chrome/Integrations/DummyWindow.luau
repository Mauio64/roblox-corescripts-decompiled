local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local WindowSizeSignal = require(Chrome.ChromeShared.Service.WindowSizeSignal)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagDebugEnableUnibarDummyIntegrations = SharedFlags.GetFFlagDebugEnableUnibarDummyIntegrations

local iconsnavigationcycleUp = Images["icons/navigation/cycleUp"]
local flag = false
local windowSize = WindowSizeSignal.new(Constants.DEFAULT_WIDTH, Constants.DEFAULT_HEIGHT)
local udim = UDim2.new(1, -95, 0, 165)
local initialAvailability

if GetFFlagDebugEnableUnibarDummyIntegrations() then
	initialAvailability = Service.AvailabilitySignal.Available
else
	initialAvailability = Service.AvailabilitySignal.Unavailable
end

return (Service:register({
	initialAvailability = initialAvailability,
	id = "dummy_window",
	label = "CoreScripts.TopBar.Menu",
	draggable = true,
	cachePosition = true,
	startingWindowPosition = udim,
	windowSize = windowSize,
	persistWindowState = true,
	components = {
		Icon = function(_)
			return CommonIcon("icons/menu/avatar_on")
		end,
		Window = function(_)
			return React.createElement("Frame", {
				BackgroundTransparency = 0,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Corner = React.createElement("UICorner", { CornerRadius = Constants.CORNER_RADIUS }),
				SizeIcon = React.createElement(IconButton, {
					icon = iconsnavigationcycleUp,
					iconSize = Constants.CLOSE_ICON_SIZE,
					anchorPoint = Vector2.new(0.5, 1),
					position = UDim2.new(0.5, 0, 1, 0),
					backgroundTransparency = 0.5,
					onActivated = function()
						if flag then
							windowSize:requestSize(Constants.DEFAULT_WIDTH, Constants.DEFAULT_HEIGHT)
							flag = false
						else
							windowSize:requestSize(Constants.DEFAULT_WIDTH_LARGE, Constants.DEFAULT_HEIGHT_LARGE)
							flag = true
						end
					end
				})
			})
		end
	}
}))
