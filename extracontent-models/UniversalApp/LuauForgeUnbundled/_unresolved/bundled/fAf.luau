local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/fup")
local module2 = require("@luauforge/bundled/fzW")

local v5 = {
	[module.Halloween2026] = "rbxasset://textures/ui/LuaApp/graphic/home_background_halloween2026.jpg"
}

local function HomeThemeBackgroundImage(props)
	return React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = props.image,
		Position = props.Position,
		ScaleType = Enum.ScaleType.Crop,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = 0
	})
end

return {
	useHomeThemeBackgroundImage = function()
		local v6 = module2()

		if v6 then
			return v5[v6]
		end

		return nil
	end,
	HomeThemeBackgroundImage = HomeThemeBackgroundImage,
	HomeThemeBackgroundFill = function(props)
		return React.createElement("Frame", {
			BackgroundColor3 = props.baseColor,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 0,
			ref = props.onPageChanged,
			[React.Change.AbsolutePosition] = props.onPageChanged,
			[React.Change.AbsoluteSize] = props.onPageChanged
		}, {
			Image = React.createElement(HomeThemeBackgroundImage, {
				image = props.image
			})
		})
	end,
	HomeThemeBackgroundSlice = function(props)
		local v6, v7 = React.useBinding(Vector2.zero)
		local v8 = React.useCallback(function(p2)
			if p2 then
				v7(p2.AbsolutePosition)
			end
		end, {})

		local v9 = React.useMemo(function()
			return React.joinBindings({ props.pageGeometry, v6 }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				local v10 = item.position - item2
				return UDim2.fromOffset(v10.X, v10.Y)
			end)
		end, { props.pageGeometry })

		local v10 = React.useMemo(function()
			return props.pageGeometry:map(function(p2)
				return UDim2.fromOffset(p2.size.X, p2.size.Y)
			end)
		end, { props.pageGeometry })

		return React.createElement("Frame", {
			BackgroundColor3 = props.baseColor,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = UDim2.fromScale(1, 1),
			ZIndex = -1,
			ref = v8,
			[React.Change.AbsolutePosition] = v8
		}, {
			Image = React.createElement(HomeThemeBackgroundImage, {
				image = props.image,
				Position = v9,
				Size = v10
			})
		})
	end
}
