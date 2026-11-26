local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/fvM")

local module2 = require("@luauforge/deferred/gRB")

local function useAvatarHardwareBackButton(data)
	local navigation = data.navigation
	local avatarRoute = data.avatarRoute
	local onBack = data.onBack
	local enabled = data.enabled ~= false

	local current = React.useRef(module()).current
	local v5 = enabled and module2({
		navigation = navigation,
		avatarRoute = avatarRoute
	})

	React.useEffect(function()
		if v5 then
			current.connect(onBack)
		end

		return function()
			current.disconnect()
		end
	end, { v5, onBack, current })
end

return useAvatarHardwareBackButton
