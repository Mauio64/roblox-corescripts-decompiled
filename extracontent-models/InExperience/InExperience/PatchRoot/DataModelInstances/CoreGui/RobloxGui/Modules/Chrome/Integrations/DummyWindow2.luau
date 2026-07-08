local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local GetFFlagDebugEnableUnibarDummyIntegrations = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagDebugEnableUnibarDummyIntegrations

return Service:register({
	id = "dummy_window_2",
	label = "CoreScripts.TopBar.Menu",
	persistWindowState = true,
	initialAvailability = if not GetFFlagDebugEnableUnibarDummyIntegrations() then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available,
	startingWindowPosition = UDim2.new(1, -245, 0, 95),
	components = {
		Icon = function(_) -- line: 22
			-- upvalues: CommonIcon (copy)
			return CommonIcon("icons/menu/home_on")
		end,
		Window = function(_) -- line: 25
			-- upvalues: React (copy), Constants (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 0,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = Constants.CORNER_RADIUS
				})
			})
		end
	}
})
