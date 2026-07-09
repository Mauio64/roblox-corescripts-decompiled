local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local v5 = Roact.PureComponent:extend("DismissMenuBackground")

v5.validateProps = t.strictInterface({
	Visible = t.union(t.boolean, t.table),
	ZIndex = t.number,
	onDismiss = t.callback,
	screenSize = t.Vector2
})
v5.defaultProps = {
	ZIndex = 1
}

function v5.render(p1) -- line: 29
	-- upvalues: Roact (copy)
	return Roact.createElement("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		Visible = p1.props.Visible,
		ZIndex = p1.props.ZIndex,
		Size = UDim2.fromOffset(p1.props.screenSize.X, p1.props.screenSize.Y),
		Position = UDim2.fromOffset(0, -13),
		[Roact.Event.Activated] = p1.props.onDismiss
	})
end

local function mapStateToProps(p2, _) -- line: 41
	return {
		screenSize = p2.ScreenSize
	}
end

return (RoactRodux.connect(mapStateToProps, nil)(v5))
