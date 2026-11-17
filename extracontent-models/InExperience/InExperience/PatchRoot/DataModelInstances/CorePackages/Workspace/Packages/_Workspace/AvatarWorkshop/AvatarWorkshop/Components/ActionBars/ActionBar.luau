local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local ButtonVariant = Foundation.Enums.ButtonVariant

local function ActionBar(p)
	local v = useTokens()

	local count = #p.actions

	local v2 = not (count > 0) and 0 or v.Gap.Small * (count - 1) / count

	local children = {}

	for k, action in p.actions do
		children[action.key] = React.createElement(Foundation.View, {
			tag = "row auto-y",
			Size = UDim2.new(1 / count, -v2, 0, 0),
			LayoutOrder = k
		}, {
			Button = React.createElement(Foundation.Button, {
				text = action.text,
				onActivated = action.onActivated,
				variant = action.variant,
				size = Foundation.Enums.ButtonSize.Medium,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				testId = action.testId
			})
		})
	end

	return React.createElement(Foundation.View, { tag = "row gap-small size-full-0 auto-y" }, children)
end

return ActionBar
