local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens

require(Parent.SduiCompat)

local function SduiPlaceholder(t1: {[any]: any}) -- line: 25
	-- upvalues: useTokens (copy), React (copy)
	local v6 = useTokens()
	local v7 = t1.backgroundStyle or v6.Color.Surface.Surface_200
	local v8 = t1.cornerRadius or UDim.new(0, v6.Radius.Medium)
	local v9 = v8.Offset > 0 or v8.Scale > 0

	return React.createElement("Frame", {
		AnchorPoint = t1.anchorPoint,
		AutomaticSize = t1.automaticSize,
		BackgroundColor3 = v7.Color3,
		BackgroundTransparency = t1.transparencyBinding or 0,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		Size = t1.size or UDim2.fromScale(1, 0),
		ZIndex = t1.zIndex,
		[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`
	}, {
		UICorner = if not v9 then nil else React.createElement("UICorner", {
			CornerRadius = v8
		})
	})
end

return React.memo(SduiPlaceholder)
