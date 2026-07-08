local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent.Parent
local createShallowEqualAndTables = require(ParentParent.createShallowEqualAndTables)
local FFlagPlayerListReduceRerenders = require(ParentParent.Flags.FFlagPlayerListReduceRerenders)
local v8 = Roact.PureComponent:extend("CellExtender")

v8.validateProps = t.strictInterface({
	layoutOrder = t.integer,
	size = t.UDim2,
	backgroundStyle = t.strictInterface({
		Color = t.Color3,
		Transparency = t.number
	}),
	overlayStyle = t.strictInterface({
		Color = t.Color3,
		Transparency = t.number
	}),
	doubleOverlay = t.boolean
})

function v8.render(p1) -- line: 28
	-- upvalues: Roact (copy)
	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		LayoutOrder = p1.props.layoutOrder,
		Size = p1.props.size,
		BackgroundTransparency = p1.props.backgroundStyle.Transparency,
		BackgroundColor3 = p1.props.backgroundStyle.Color
	}, {
		DoubleOverLay = Roact.createElement("Frame", {
			ZIndex = 1,
			BorderSizePixel = 0,
			Visible = p1.props.doubleOverlay,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = p1.props.overlayStyle.Transparency,
			BackgroundColor3 = p1.props.overlayStyle.Color
		}),
		OverlayFrame = Roact.createElement("Frame", {
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = p1.props.overlayStyle.Transparency,
			BackgroundColor3 = p1.props.overlayStyle.Color
		})
	})
end

if FFlagPlayerListReduceRerenders then
	return React.memo(v8, createShallowEqualAndTables({ "backgroundStyle" }))
end

return v8
