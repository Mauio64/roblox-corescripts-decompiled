local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local t = require(CorePackages.Packages.t)

local extended = Roact.PureComponent:extend("BottomInsetBackground")

extended.validateProps = t.strictInterface({
	globalGuiInset = t.strictInterface({
		left = t.integer,
		top = t.integer,
		right = t.integer,
		bottom = t.integer
	})
})

function extended:renderWithStyle(p3)
	local theme = p3.Theme

	local globalGuiInset = self.props.globalGuiInset

	return Roact.createElement("Frame", {
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, globalGuiInset.bottom),
		ZIndex = 3
	})
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithStyle(p2)
	end)
end

return extended
