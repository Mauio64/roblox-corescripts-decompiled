local CorePackages = game:GetService("CorePackages")

local unableToJoinExperienceModal = require("@luauforge/bundled/cAK").UnableToJoinExperienceModal

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local module2 = require("@luauforge/bundled/dKt")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function()
	local v5 = useDispatch()

	local v6 = React.useCallback(function(p2, p3)
		v5(module2(p2, p3))
	end, {})

	return React.createElement(unableToJoinExperienceModal, {
		openGameDetailsPeekView = v6
	})
end
