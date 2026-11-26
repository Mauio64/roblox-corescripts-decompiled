local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local useEffect = React.useEffect
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/LuauPolyfill")
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

local snackbar = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Foundation").Snackbar

local defineFastInt = game:DefineFastInt("GenericInterventionSnackbarAutoDismissDelaySeconds", 4)

local function GenericInterventionSnackbar(props)
	useEffect(function()
		local autoDismissDelaySeconds = props.autoDismissDelaySeconds or defineFastInt

		local v5 = setTimeout(function()
			props.onDismiss()
		end, autoDismissDelaySeconds * 1000)

		return function()
			if v5 then
				clearTimeout(v5)
			end
		end
	end, { props.onDismiss, props.autoDismissDelaySeconds })

	return (React.createElement(snackbar, {
		title = props.titleText,
		icon = props.iconName,
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0)
	}))
end

return React.memo(GenericInterventionSnackbar)
