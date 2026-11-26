local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local icon = Foundation.Icon
local view = Foundation.View
local iconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local function QuickSignInAvatar(p2)
	local v5 = useTokens()

	return React.createElement(
		view,
		{
			Size = UDim2.fromOffset(p2.size, p2.size),
			LayoutOrder = p2.LayoutOrder,
			tag = "row align-x-center align-y-center radius-circle bg-surface-300"
		},
		{
			IdentityIcon = React.createElement(icon, {
				name = iconName.Person,
				size = 90,
				style = v5.Color.Content.Emphasis
			})
		}
	)
end

return QuickSignInAvatar
