local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local slice = { center = Rect.new(35, 35, 37, 37) }

local function TileHoverShadow(props)
	local v = useTokens()
	local hoverPadding = props.hoverPadding or v.Padding.Medium
	local containmentPadding = props.containmentPadding or v.Padding.Small
	local v2 = hoverPadding + 18
	local v3 = hoverPadding + 14
	local v4 = hoverPadding + containmentPadding + v.Gap.XSmall

	local v5, v6 = React.useBinding(0)

	React.useEffect(function()
		local current = props.contentRef.current

		if not current then
			return
		end

		local function update() -- 1 equivalent call inferred from this helper
			local y = current.AbsoluteSize.Y
			v6((math.max(0, y - v4)))
		end

		update() -- inferred equivalent call
		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)

		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { props.contentRef, v4 })

	return React.createElement(Image, {
		Position = v5:map(function(p: number)
			return UDim2.new(0.5, 0, 0.5, p / 2 + 2)
		end),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = v5:map(function(p: number)
			return UDim2.new(1, v2, 1, v3 + p)
		end),
		Image = "component_assets/dropshadow_56_8",
		imageStyle = {
			Color3 = v.Color.Common.Shadow.Color3,
			Transparency = math.min(1, v.Color.Common.Shadow.Transparency + 0.25)
		},
		slice = slice,
		ZIndex = -1
	})
end

return React.memo(TileHoverShadow)
