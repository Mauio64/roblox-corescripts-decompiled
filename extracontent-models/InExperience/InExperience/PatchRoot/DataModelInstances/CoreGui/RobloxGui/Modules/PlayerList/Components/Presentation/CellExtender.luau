local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent.Parent
local createShallowEqualAndTables = require(parent.createShallowEqualAndTables)
local FFlagPlayerListReduceRerenders = require(parent.Flags.FFlagPlayerListReduceRerenders)

local extended = Roact.PureComponent:extend("CellExtender")

extended.validateProps = t.strictInterface({
	layoutOrder = t.integer,
	size = t.UDim2,
	backgroundStyle = t.strictInterface({ Color = t.Color3, Transparency = t.number }),
	overlayStyle = t.strictInterface({ Color = t.Color3, Transparency = t.number }),
	doubleOverlay = t.boolean
})

function extended.render(p)
	return Roact.createElement("Frame", {
		LayoutOrder = p.props.layoutOrder,
		Size = p.props.size,
		BackgroundTransparency = p.props.backgroundStyle.Transparency,
		BackgroundColor3 = p.props.backgroundStyle.Color,
		BorderSizePixel = 0
	}, {
		DoubleOverLay = Roact.createElement("Frame", {
			ZIndex = 1,
			Visible = p.props.doubleOverlay,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = p.props.overlayStyle.Transparency,
			BackgroundColor3 = p.props.overlayStyle.Color,
			BorderSizePixel = 0
		}),
		OverlayFrame = Roact.createElement("Frame", {
			ZIndex = 2,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = p.props.overlayStyle.Transparency,
			BackgroundColor3 = p.props.overlayStyle.Color,
			BorderSizePixel = 0
		})
	})
end

if FFlagPlayerListReduceRerenders then
	return React.memo(extended, createShallowEqualAndTables({ "backgroundStyle" }))
end

return extended
