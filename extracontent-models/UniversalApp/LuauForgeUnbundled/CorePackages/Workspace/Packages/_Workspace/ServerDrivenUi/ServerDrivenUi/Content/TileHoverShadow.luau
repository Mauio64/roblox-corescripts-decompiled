local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local v5 = { center = Rect.new(35, 35, 37, 37) }

local function TileHoverShadow(props)
	local v6 = useTokens()
	local hoverPadding = props.hoverPadding or v6.Padding.Medium
	local containmentPadding = props.containmentPadding or v6.Padding.Small
	local v7 = hoverPadding + 18
	local v8 = hoverPadding + 14
	local v9 = hoverPadding + containmentPadding + v6.Gap.XSmall

	local v10, v11 = React.useBinding(0)

	React.useEffect(function()
		local current = props.contentRef.current

		if not current then
			return
		end

		local function update()
			local y = current.AbsoluteSize.Y
			v11((math.max(0, y - v9)))
		end

		local y = current.AbsoluteSize.Y
		v11((math.max(0, y - v9)))

		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)

		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { props.contentRef, v9 })

	return React.createElement(image, {
		Position = v10:map(function(p2)
			return UDim2.new(0.5, 0, 0.5, p2 / 2 + 2)
		end),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = v10:map(function(p2)
			return UDim2.new(1, v7, 1, v8 + p2)
		end),
		Image = "component_assets/dropshadow_56_8",
		imageStyle = {
			Color3 = v6.Color.Common.Shadow.Color3,
			Transparency = math.min(1, v6.Color.Common.Shadow.Transparency + 0.25)
		},
		slice = v5,
		ZIndex = -1
	})
end

return React.memo(TileHoverShadow)
