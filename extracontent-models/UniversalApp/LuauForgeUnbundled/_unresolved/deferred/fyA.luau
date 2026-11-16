local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.Foundation)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local module = require("@luauforge/bundled/eeo")
require("@luauforge/deferred/fyz")

return function(data)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(nil)
	local ref = React.useRef(false)
	local v5 = ReactFocusNavigation.useFocusGuiObject()
	local v6 = module.useLastInputMode() == "Focus"
	local v7 = false

	for k, item in data.items do
		if not item.isDisabled then
			v7 = true
			break
		end
	end

	local v9 = module.useFocusRoot({
		surfaceIdentifier = module.FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		isFocusable = v7
	})

	local v10 = React.useCallback(function(p2)
		if p2 then
			p2.Selectable = false
			p2.SelectionGroup = true
		end

		v9(p2)
		setState(p2 ~= nil)
	end, { v9 })
	React.useEffect(function()
		if ref.current and not state and v6 and state2 then
			v5(state2)
		end

		ref.current = state
	end, { state, v6, state2, v5 })

	return {
		items = data.items,
		value = data.value,
		onItemChanged = data.onItemChanged,
		width = data.width,
		maxHeight = data.maxHeight,
		menuRef = v10,
		controlRef = setState2
	}
end
