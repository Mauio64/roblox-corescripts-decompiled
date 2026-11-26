local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local extended = Roact.PureComponent:extend("DismissMenuBackground")

extended.validateProps = t.strictInterface({
	Visible = t.union(t.boolean, t.table),
	ZIndex = t.number,
	onDismiss = t.callback,
	screenSize = t.Vector2
})

extended.defaultProps = { ZIndex = 1 }

function extended.render(p2)
	return Roact.createElement("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		Visible = p2.props.Visible,
		ZIndex = p2.props.ZIndex,
		Size = UDim2.fromOffset(p2.props.screenSize.X, p2.props.screenSize.Y),
		Position = UDim2.fromOffset(0, -13),
		[Roact.Event.Activated] = p2.props.onDismiss
	})
end

local function mapStateToProps(p2, p3)
	return { screenSize = p2.ScreenSize }
end

return (RoactRodux.connect(mapStateToProps, nil)(extended))
