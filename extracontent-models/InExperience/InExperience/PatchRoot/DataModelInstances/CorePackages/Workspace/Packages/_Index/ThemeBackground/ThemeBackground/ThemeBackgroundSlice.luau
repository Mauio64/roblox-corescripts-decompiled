local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local SignalsReact = require(parent2.SignalsReact)

local GetThemeBackgroundStore = require(parent.Stores.GetThemeBackgroundStore)
local ThemeBackgroundImage = require(parent.ThemeBackgroundImage)
require(parent.ThemeBackgroundTypes)

local function ThemeBackgroundSlice(p)
	local v = SignalsReact.useSignalBinding(GetThemeBackgroundStore(false).getGeometry)
	local v2, v3 = React.useBinding(Vector2.zero)
	local ref = React.useCallback(function(p2)
		if p2 then
			v3(p2.AbsolutePosition)
		end
	end, {})

	local position = React.useMemo(function()
		return React.joinBindings({ v, v2 }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			local v4 = item.position - item2
			return UDim2.fromOffset(v4.X, v4.Y)
		end)
	end, { v })

	local size = React.useMemo(function()
		return v:map(function(p2)
			return UDim2.fromOffset(p2.size.X, p2.size.Y)
		end)
	end, { v })

	return React.createElement("Frame", {
		BackgroundColor3 = p.baseColor,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 1),
		ZIndex = -1,
		ref = ref,
		[React.Change.AbsolutePosition] = ref
	}, {
		Image = React.createElement(ThemeBackgroundImage, {
			image = p.image,
			Position = position,
			Size = size
		})
	})
end

return ThemeBackgroundSlice
