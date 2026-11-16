local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local initialAvailability

if SharedFlags.GetFFlagDebugEnableUnibarDummyIntegrations() then
	initialAvailability = Service.AvailabilitySignal.Available
else
	initialAvailability = Service.AvailabilitySignal.Unavailable
end

return Service:register({
	initialAvailability = initialAvailability,
	id = "dummy_window_2",
	label = "CoreScripts.TopBar.Menu",
	startingWindowPosition = UDim2.new(1, -245, 0, 95),
	persistWindowState = true,
	components = {
		Icon = function(_)
			return CommonIcon("icons/menu/home_on")
		end,
		Window = function(_)
			return React.createElement("Frame", {
				BackgroundTransparency = 0,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Corner = React.createElement("UICorner", { CornerRadius = Constants.CORNER_RADIUS })
			})
		end
	}
})
