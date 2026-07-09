local Parent = script:FindFirstAncestor("PeekView").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens
local ReactOtter = require(Parent.ReactOtter)
local v5 = game:DefineFastFlag("RemovePeekViewScrimBorder", false)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 16
	-- upvalues: useDesignTokens (copy), React (copy), ReactOtter (copy), v5 (copy)
	local v8 = useDesignTokens()
	local v9, v10 = React.useState(true)
	local u11 = v9
	local u12 = v10
	local v13, v14 = ReactOtter.useAnimatedBinding(1)
	local u15 = v14

	React.useEffect(function() -- line: 22
		-- upvalues: u15 (ref), ReactOtter (copy), u11 (ref)
		u15(ReactOtter.spring(not u11 and 1 or 0.35))
	end, { u11 })

	return React.createElement("TextButton", {
		ref = p1,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = v13,
		BackgroundColor3 = v8.Color.Common.Scrim.Color3,
		ClipsDescendants = false,
		Text = "",
		AutoButtonColor = false,
		[React.Event.Activated] = function() -- line: 34
			-- upvalues: t1 (copy), u12 (ref), u11 (ref)
			if t1.onActivated then
				t1.onActivated()
			end

			u12(not u11)
		end,
		[React.Change.AbsoluteSize] = t1.onSizeChanged,
		BorderSizePixel = if not v5 then nil else 0
	}, t1.children)
end))
