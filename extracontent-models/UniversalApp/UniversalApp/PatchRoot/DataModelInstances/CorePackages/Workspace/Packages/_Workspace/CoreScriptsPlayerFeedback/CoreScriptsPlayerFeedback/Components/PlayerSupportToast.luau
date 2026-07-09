local Parent = script:FindFirstAncestor("CoreScriptsPlayerFeedback").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local BuilderIcons = require(Parent.BuilderIcons)

return (React.memo(function(t1: {[any]: any}) -- line: 29
	-- upvalues: useTokens (copy), React (copy), View (copy), Icon (copy), BuilderIcons (copy), IconSize (copy), FoundationText (copy)
	local v11 = useTokens()

	React.useEffect(function() -- line: 32
		-- upvalues: t1 (copy)
		local u12 = false

		task.delay(4, function() -- line: 34
			-- upvalues: u12 (ref), t1 (copy)
			if not u12 then
				t1.onDismiss()
			end
		end)

		return function() -- line: 39
			-- upvalues: u12 (ref)
			u12 = true
		end
	end, { t1.onDismiss })

	return React.createElement(View, {
		tag = "row align-y-center gap-medium auto-xy bg-system-contrast",
		Position = UDim2.new(0.5, 0, 1, -v11.Padding.XLarge * 4),
		AnchorPoint = Vector2.new(0.5, 1),
		padding = {
			left = UDim.new(0, v11.Padding.Large),
			right = UDim.new(0, v11.Padding.Large),
			top = UDim.new(0, v11.Padding.Medium),
			bottom = UDim.new(0, v11.Padding.Medium)
		},
		cornerRadius = UDim.new(0, v11.Radius.Large)
	}, {
		CheckIcon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = BuilderIcons.Icon.CircleCheck,
			size = IconSize.Medium,
			style = v11.Inverse.Content.Emphasis
		}),
		Label = React.createElement(FoundationText, {
			tag = "auto-xy text-title-medium text-align-x-left",
			LayoutOrder = 2,
			Text = t1.text,
			textStyle = v11.Inverse.Content.Emphasis
		})
	})
end))
