local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")

local extended = Roact.PureComponent:extend("VngComplianceLoadingPopup")
local Foundation = require(CorePackages.Packages.Foundation)
local loading = Foundation.Loading

function extended.render(p2)
	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, p2.props.screenSize.Y),
			BackgroundTransparency = 0,
			BorderSizePixel = 0
		},
		{
			Layout = Roact.createElement(loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
		}
	)
end

return (useSheetNavigation.connect(function(p2)
	return { screenSize = p2.ScreenSize }
end, function(p2) end)(extended))
