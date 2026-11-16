local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent

local React = require(parent2.React)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

require(parent.Style.StyleTypes)

local v = { zIndex = 1 }

return function(p)
	local v2 = Object.assign({}, v, p)
	local createElement = React.createElement
	local v3 = { ZIndex = v2.zIndex, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

	local createElement2 = React.createElement
	local v4 = {
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 0.5),
		ClipsDescendants = true,
		BackgroundTransparency = 1
	}

	local createElement3 = React.createElement
	local v5 = {
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 2),
		BackgroundColor3 = v2.background.Color,
		BackgroundTransparency = v2.background.Transparency
	}
	local uiCorner

	if v2.topCornerRadius then
		uiCorner = React.createElement("UICorner", { CornerRadius = v2.topCornerRadius })
	end

	local children = {
		TopContainer = createElement2("Frame", v4, {
			Content = createElement3("Frame", v5, { UICorner = uiCorner })
		}),
		BottomContainer = 0
	}

	local createElement4 = React.createElement
	local v6 = {
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromScale(1, 0.5),
		ClipsDescendants = true,
		BackgroundTransparency = 1
	}

	local createElement5 = React.createElement
	local v7 = {
		Position = UDim2.fromScale(0, -1),
		Size = UDim2.fromScale(1, 2),
		BackgroundColor3 = v2.background.Color,
		BackgroundTransparency = v2.background.Transparency
	}
	local uiCorner2

	if v2.bottomCornerRadius then
		uiCorner2 = React.createElement("UICorner", { CornerRadius = v2.bottomCornerRadius })
	end

	children.BottomContainer = createElement4("Frame", v6, {
		Content = createElement5("Frame", v7, { UICorner = uiCorner2 })
	})
	return createElement("Frame", v3, children)
end
