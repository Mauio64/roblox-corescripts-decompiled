local module = require("@luauforge/deferred/gGr")

local module2 = require("@luauforge/deferred/gGD")
local dash = module.Dash
local toast = module.UIBlox.App.Dialog.Toast
local react = module.React
local useLocalization = module.Hooks.useLocalization
local useNavigation = module.Hooks.useNavigation
local useDidUpdate = module.Hooks.useDidUpdate
local module3 = require("@luauforge/deferred/gGE")

local v5 = { messageType = module2.DefaultError, duration = 2 }

return function(options)
	local joined = dash.join(v5, options or {})
	local v6 = useLocalization(module3(joined.messageType, joined.localizationOverrides))

	local v7 = useNavigation()
	local v8 = useDidUpdate()

	local v9 = react.useMemo(function()
		return {
			toastTitle = v6.toastTitle,
			toastSubtitle = v6.toastSubtitle,
			onDismissed = function()
				if v8.current then
					return
				end

				v7.goBack()
			end
		}
	end, { v6.toastTitle, v6.toastSubtitle })

	return react.createElement(toast, { toastContent = v9, duration = joined.duration })
end
