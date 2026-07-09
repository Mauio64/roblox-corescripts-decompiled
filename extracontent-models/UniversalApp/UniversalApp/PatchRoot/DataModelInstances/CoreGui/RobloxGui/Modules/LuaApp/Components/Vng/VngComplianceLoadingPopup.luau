local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local v5 = Roact.PureComponent:extend("VngComplianceLoadingPopup")
local Loading = require(CorePackages.Packages.Foundation).Loading

function v5.render(p1) -- line: 10
	-- upvalues: Roact (copy), Loading (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, p1.props.screenSize.Y)
	}, {
		Layout = Roact.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
	})
end

return (RoactRodux.connect(function(p2) -- line: 23
	return {
		screenSize = p2.ScreenSize
	}
end, function(_) -- line: 27
end)(v5))
