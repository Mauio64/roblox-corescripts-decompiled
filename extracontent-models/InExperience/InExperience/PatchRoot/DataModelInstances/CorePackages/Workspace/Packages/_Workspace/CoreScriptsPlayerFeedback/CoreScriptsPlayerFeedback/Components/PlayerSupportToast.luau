local parent = script:FindFirstAncestor("CoreScriptsPlayerFeedback").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local BuilderIcons = require(parent.BuilderIcons)

return (React.memo(function(p)
	local v = useTokens()

	React.useEffect(function()
		local v2 = false
		task.delay(4, function()
			if not v2 then
				p.onDismiss()
			end
		end)
		return function()
			v2 = true
		end
	end, { p.onDismiss })

	return React.createElement(View, {
		Position = UDim2.new(0.5, 0, 1, -v.Padding.XLarge * 4),
		AnchorPoint = Vector2.new(0.5, 1),
		tag = "row align-y-center gap-medium auto-xy bg-system-contrast",
		padding = {
			left = UDim.new(0, v.Padding.Large),
			right = UDim.new(0, v.Padding.Large),
			top = UDim.new(0, v.Padding.Medium),
			bottom = UDim.new(0, v.Padding.Medium)
		},
		cornerRadius = UDim.new(0, v.Radius.Large)
	}, {
		CheckIcon = React.createElement(Icon, {
			name = BuilderIcons.Icon.CircleCheck,
			size = IconSize.Medium,
			style = v.Inverse.Content.Emphasis,
			LayoutOrder = 1
		}),
		Label = React.createElement(Text, {
			Text = p.text,
			tag = "auto-xy text-title-medium text-align-x-left",
			textStyle = v.Inverse.Content.Emphasis,
			LayoutOrder = 2
		})
	})
end))
