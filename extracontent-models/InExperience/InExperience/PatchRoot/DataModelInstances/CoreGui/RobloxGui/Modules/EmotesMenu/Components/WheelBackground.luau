local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local Colors = UIBlox.App.Style.Colors
local withStyle = UIBlox.Style.withStyle

local parent = script.Parent
local parent2 = parent.Parent

local Constants = require(parent2.Constants)
local SelectionGradient = require(parent.SelectionGradient)
local SelectionEffect = require(parent.SelectionEffect)
local WheelText = require(parent.WheelText)

local extended = Roact.PureComponent:extend("WheelBackground")

function extended:renderContent(p)
	local layout = Constants.Layouts[self.props.layout]

	local createElement = Roact.createElement
	local backgroundCircleOverlay

	if p then
		backgroundCircleOverlay = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Colors.Flint:Lerp(Color3.new(0, 0, 0), p),
			BackgroundTransparency = Constants.WheelBackgroundTransparency * p
		}, { Roact.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }) })
	else
		backgroundCircleOverlay = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			Image = layout.CircleBackground,
			ZIndex = 1
		})
	end

	return createElement("Folder", {}, {
		BackgroundCircleOverlay = backgroundCircleOverlay,
		BackgroundGradient = Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 2 },
			{
				SelectionGradient = Roact.createElement(SelectionGradient)
			}
		),
		BackgroundImage = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			Image = layout.SegmentedCircle,
			ZIndex = 3
		}),
		Selection = Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 4 },
			{
				SelectionEffect = Roact.createElement(SelectionEffect)
			}
		),
		BackgroundText = Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 5 },
			{ MiddleText = Roact.createElement(WheelText) }
		)
	})
end

function extended:render()
	return withStyle(function(p)
		return self:renderContent(p.Settings.PreferredTransparency)
	end)
end

local function mapStateToProps(p)
	return { layout = p.layout }
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
