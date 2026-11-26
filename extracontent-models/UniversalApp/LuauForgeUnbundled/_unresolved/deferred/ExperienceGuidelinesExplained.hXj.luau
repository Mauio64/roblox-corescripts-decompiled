local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/deferred/hXk")

local function ExperienceGuidelinesExplained(props)
	local v5 = useDispatch()
	return React.createElement(module, {
		universeId = props.universeId,
		hideCloseButton = props.hideCloseButton,
		closeModal = props.closeCentralOverlayThunk and function()
			v5(props.closeCentralOverlayThunk())
		end or nil
	})
end

return ExperienceGuidelinesExplained
