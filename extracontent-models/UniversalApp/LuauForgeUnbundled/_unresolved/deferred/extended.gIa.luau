local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/deferred/gIb")

local module2 = require("@luauforge/bundled/fzK")

local extended = Roact.PureComponent:extend("NativeViewUserProfileWrapper")

function extended.render(p2)
	local isVisible = p2.props.isVisible
	local displayOrder = p2.props.DisplayOrder
	local userId = p2.props.userId
	local onClose = p2.props.onClose

	local profile = module2.user.profile({ userId = userId })

	return Roact.createElement(module, {
		isVisible = isVisible,
		DisplayOrder = displayOrder,
		url = profile,
		onClose = onClose
	})
end

return extended
