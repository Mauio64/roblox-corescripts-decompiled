local module = require("@luauforge/bundled/fJc")
local module2 = require("@luauforge/bundled/fJd")
local module3 = require("@luauforge/bundled/fJe")
local useNavigation = require("@luauforge/bundled/fJf").useNavigation
local darkTheme = module3.App.Style.Themes.DarkTheme
local useStyle = module3.Core.Style.useStyle
local memoize = require("@luauforge/bundled/fJg").memoize

local useIOSStatusBarStyler = require("@luauforge/bundled/fJh").Hooks.useIOSStatusBarStyler

require("@luauforge/bundled/fJi")

local module4 = require("@luauforge/bundled/fJq")
local module5 = require("@luauforge/bundled/fJY")

local v5 = memoize(function(p2)
	return module2.createAppContainer(p2)
end)

return function(p2)
	local v6 = useNavigation()
	local v7 = useStyle()
	local v8 = v5(module5)

	local ref = module.useRef(nil)

	local v9 = module.useCallback(function(current)
		ref.current = current
		return function()
			ref.current = nil
		end
	end, {})

	local v10 = module.useCallback(function()
		local current = ref.current

		if current then
			current(module2.StackActions.popToTop())
		end
	end, {})

	useIOSStatusBarStyler(v7.Theme == darkTheme)

	return module.createElement(
		module4,
		{
			parentNavigation = v6,
			monoDeps = p2.monoDeps,
			resetChildNavigationToFirstScreen = v10
		},
		{
			NavigationAppContainer = module.createElement(v8, {
				externalDispatchConnector = v9
			})
		}
	)
end
