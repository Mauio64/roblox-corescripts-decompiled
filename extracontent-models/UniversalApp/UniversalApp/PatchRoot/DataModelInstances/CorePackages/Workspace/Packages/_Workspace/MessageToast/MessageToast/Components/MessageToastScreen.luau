local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Types = require(ParentParent.Common.Types)
local Dash = dependencies.Dash
local Toast = dependencies.UIBlox.App.Dialog.Toast
local React = dependencies.React
local useLocalization = dependencies.Hooks.useLocalization
local useNavigation = dependencies.Hooks.useNavigation
local useDidUpdate = dependencies.Hooks.useDidUpdate
local getTranslationKeys = require(script.Parent.getTranslationKeys)
local t1 = {
	duration = 2,
	messageType = Types.DefaultError
}

return function(t2: {[any]: any}) -- line: 28
	-- upvalues: Dash (copy), t1 (copy), useLocalization (copy), getTranslationKeys (copy), useNavigation (copy), useDidUpdate (copy), React (copy), Toast (copy)
	local v13 = Dash.join(t1, t2 or {})
	local v14 = useLocalization(getTranslationKeys(v13.messageType, v13.localizationOverrides))
	local v15 = useNavigation()
	local v16 = useDidUpdate()
	local v17 = React.useMemo(function() -- line: 35
		-- upvalues: v14 (copy), v16 (copy), v15 (copy)
		return {
			toastTitle = v14.toastTitle,
			toastSubtitle = v14.toastSubtitle,
			onDismissed = function() -- line: 39
				-- upvalues: v16 (copy), v15 (copy)
				if v16.current then
					return
				end

				v15.goBack()
			end
		}
	end, {
		v14.toastTitle,
		v14.toastSubtitle
	})

	return React.createElement(Toast, {
		toastContent = v17,
		duration = v13.duration
	})
end
