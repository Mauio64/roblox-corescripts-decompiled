local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Colors = UIBlox.App.Style.Colors
local withStyle = UIBlox.Style.withStyle
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Constants = require(scriptParentParent.Constants)
local SelectionGradient = require(scriptParent.SelectionGradient)
local SelectionEffect = require(scriptParent.SelectionEffect)
local WheelText = require(scriptParent.WheelText)
local v13 = Roact.PureComponent:extend("WheelBackground")

function v13.renderContent(p1, p2) -- line: 20
	-- upvalues: Constants (copy), Roact (copy), Colors (copy), SelectionGradient (copy), SelectionEffect (copy), WheelText (copy)
	local v17 = Constants.Layouts[p1.props.layout]

	return Roact.createElement("Folder", {}, {
		BackgroundCircleOverlay = if not p2 then Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ZIndex = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = v17.CircleBackground
		}) else Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Colors.Flint:Lerp(Color3.new(0, 0, 0), p2),
			BackgroundTransparency = Constants.WheelBackgroundTransparency * p2
		}, { Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}) }),
		BackgroundGradient = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			SelectionGradient = Roact.createElement(SelectionGradient)
		}),
		BackgroundImage = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ZIndex = 3,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = v17.SegmentedCircle
		}),
		Selection = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 4,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			SelectionEffect = Roact.createElement(SelectionEffect)
		}),
		BackgroundText = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 5,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			MiddleText = Roact.createElement(WheelText)
		})
	})
end
function v13.render(p3) -- line: 78
	-- upvalues: withStyle (copy)
	return withStyle(function(p4) -- line: 79
		-- upvalues: p3 (copy)
		return p3:renderContent(p4.Settings.PreferredTransparency)
	end)
end

local function mapStateToProps(p5) -- line: 84
	return {
		layout = p5.layout
	}
end

return RoactRodux.connect(mapStateToProps, nil)(v13)
