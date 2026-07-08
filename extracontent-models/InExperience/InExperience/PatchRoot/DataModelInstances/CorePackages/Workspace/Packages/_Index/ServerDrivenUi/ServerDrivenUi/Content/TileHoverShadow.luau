local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationImage = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	center = Rect.new(35, 35, 37, 37)
}

local function TileHoverShadow(t2: {[any]: any}) -- line: 23
	-- upvalues: useTokens (copy), React (copy), FoundationImage (copy), t1 (copy)
	local v9 = useTokens()
	local v10 = t2.hoverPadding or v9.Padding.Medium
	local v11 = t2.containmentPadding or v9.Padding.Small
	local v12 = v10 + 18
	local v13 = v10 + 14
	local v14 = v10 + v11 + v9.Gap.XSmall
	local v15, v16 = React.useBinding(0)

	React.useEffect(function() -- line: 33
		-- upvalues: t2 (copy), v16 (copy), v14 (copy)
		local current = t2.contentRef.current

		if not current then
			return
		end

		local function update() -- line: 39
			-- upvalues: current (copy), v16 (copy), v14 (copy)
			local AbsoluteSizeY = current.AbsoluteSize.Y

			v16((math.max(0, AbsoluteSizeY - v14)))
		end

		local AbsoluteSizeY = current.AbsoluteSize.Y

		v16((math.max(0, AbsoluteSizeY - v14)))

		local connection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)

		return function() -- line: 47
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		t2.contentRef,
		v14
	})

	return React.createElement(FoundationImage, {
		Image = "component_assets/dropshadow_56_8",
		ZIndex = -1,
		Position = v15:map(function(n1: number) -- line: 53
			return UDim2.new(0.5, 0, 0.5, n1 / 2 + 2)
		end),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = v15:map(function(n2: number) -- line: 57
			-- upvalues: v12 (copy), v13 (copy)
			return UDim2.new(1, v12, 1, v13 + n2)
		end),
		imageStyle = {
			Color3 = v9.Color.Common.Shadow.Color3,
			Transparency = math.min(1, v9.Color.Common.Shadow.Transparency + 0.25)
		},
		slice = t1
	})
end

return React.memo(TileHoverShadow)
