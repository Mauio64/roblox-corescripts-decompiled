local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local t = require(CorePackages.Packages.t)
local v5 = Roact.PureComponent:extend("BottomInsetBackground")

v5.validateProps = t.strictInterface({
	globalGuiInset = t.strictInterface({
		left = t.integer,
		top = t.integer,
		right = t.integer,
		bottom = t.integer
	})
})

function v5.renderWithStyle(p1, p2) -- line: 24
	-- upvalues: Roact (copy)
	local Theme = p2.Theme
	local globalGuiInset = p1.props.globalGuiInset

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		ZIndex = 3,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, globalGuiInset.bottom)
	})
end
function v5.render(p3) -- line: 39
	-- upvalues: withStyle (copy)
	return withStyle(function(p4) -- line: 40
		-- upvalues: p3 (copy)
		return p3:renderWithStyle(p4)
	end)
end

return v5
