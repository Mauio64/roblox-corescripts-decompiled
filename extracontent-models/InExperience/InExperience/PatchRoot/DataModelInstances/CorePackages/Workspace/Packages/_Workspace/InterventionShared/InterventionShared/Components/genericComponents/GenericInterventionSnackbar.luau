local parent = script:FindFirstAncestor("InterventionShared").Parent

local React = require(parent.React)
local useEffect = React.useEffect
local LuauPolyfill = require(parent.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

local Foundation = require(parent.Foundation)
local Snackbar = Foundation.Snackbar

local defineFastInt = game:DefineFastInt("GenericInterventionSnackbarAutoDismissDelaySeconds", 4)

local function GenericInterventionSnackbar(props)
	useEffect(function()
		local autoDismissDelaySeconds = props.autoDismissDelaySeconds or defineFastInt

		local v = setTimeout(function()
			props.onDismiss()
		end, autoDismissDelaySeconds * 1000)

		return function()
			if v then
				clearTimeout(v)
			end
		end
	end, { props.onDismiss, props.autoDismissDelaySeconds })

	return (React.createElement(Snackbar, {
		title = props.titleText,
		icon = props.iconName,
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0)
	}))
end

return React.memo(GenericInterventionSnackbar)
