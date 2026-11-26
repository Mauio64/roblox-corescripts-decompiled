local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ThemeBackground/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ThemeBackground/SignalsReact")

local GetThemeBackgroundStore = require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/Stores/GetThemeBackgroundStore")
local ThemeBackgroundImage = require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/ThemeBackgroundImage")
require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/ThemeBackgroundTypes")

local function ThemeBackgroundSlice(p2)
	local v5 = SignalsReact.useSignalBinding(GetThemeBackgroundStore(false).getGeometry)
	local v6, v7 = React.useBinding(Vector2.zero)
	local v8 = React.useCallback(function(p3)
		if p3 then
			v7(p3.AbsolutePosition)
		end
	end, {})

	local v9 = React.useMemo(function()
		return React.joinBindings({ v5, v6 }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			local v10 = item.position - item2
			return UDim2.fromOffset(v10.X, v10.Y)
		end)
	end, { v5 })

	local v10 = React.useMemo(function()
		return v5:map(function(p3)
			return UDim2.fromOffset(p3.size.X, p3.size.Y)
		end)
	end, { v5 })

	return React.createElement("Frame", {
		BackgroundColor3 = p2.baseColor,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 1),
		ZIndex = -1,
		ref = v8,
		[React.Change.AbsolutePosition] = v8
	}, {
		Image = React.createElement(ThemeBackgroundImage, {
			image = p2.image,
			Position = v9,
			Size = v10
		})
	})
end

return ThemeBackgroundSlice
