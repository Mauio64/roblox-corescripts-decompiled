local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(Foundation.Enums.ColorMode)

local React = require(FoundationParent.React)
local useTokens = require(Foundation.Providers.Style.useTokens)
local v5 = React.forwardRef(function(t1: {[any]: any}, p1) -- line: 19
	-- upvalues: useTokens (copy), React (copy)
	local v8 = useTokens()
	local colorMode = t1.colorMode

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(-t1.offset, -t1.offset),
		Size = UDim2.new(1, t1.offset * 2, 1, t1.offset * 2),
		ref = p1
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = t1.cornerRadius
		}),
		UIStroke = React.createElement("UIStroke", {
			Color = v8[colorMode].Selection.Start.Color3,
			Transparency = v8[colorMode].Selection.Start.Transparency,
			Thickness = t1.borderWidth
		}, {})
	})
end)

return React.memo(v5)
