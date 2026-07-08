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
local GetFFlagDebugEnableUnibarDummyIntegrations = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagDebugEnableUnibarDummyIntegrations
local v12 = Images["icons/navigation/cycleUp"]
local u13 = false
local v14 = WindowSizeSignal.new(Constants.DEFAULT_WIDTH, Constants.DEFAULT_HEIGHT)
local uDim2 = UDim2.new(1, -95, 0, 165)

return (Service:register({
	id = "dummy_window",
	label = "CoreScripts.TopBar.Menu",
	draggable = true,
	cachePosition = true,
	persistWindowState = true,
	initialAvailability = if not GetFFlagDebugEnableUnibarDummyIntegrations() then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available,
	startingWindowPosition = uDim2,
	windowSize = v14,
	components = {
		Icon = function(_) -- line: 35
			-- upvalues: CommonIcon (copy)
			return CommonIcon("icons/menu/avatar_on")
		end,
		Window = function(_) -- line: 38
			-- upvalues: React (copy), Constants (copy), IconButton (copy), v12 (copy), u13 (ref), v14 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 0,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = Constants.CORNER_RADIUS
				}),
				SizeIcon = React.createElement(IconButton, {
					backgroundTransparency = 0.5,
					icon = v12,
					iconSize = Constants.CLOSE_ICON_SIZE,
					anchorPoint = Vector2.new(0.5, 1),
					position = UDim2.new(0.5, 0, 1, 0),
					onActivated = function() -- line: 52
						-- upvalues: u13 (ref), v14 (copy), Constants (copy)
						if u13 then
							v14:requestSize(Constants.DEFAULT_WIDTH, Constants.DEFAULT_HEIGHT)
							u13 = false

							return
						end

						v14:requestSize(Constants.DEFAULT_WIDTH_LARGE, Constants.DEFAULT_HEIGHT_LARGE)
						u13 = true
					end
				})
			})
		end
	}
}))
