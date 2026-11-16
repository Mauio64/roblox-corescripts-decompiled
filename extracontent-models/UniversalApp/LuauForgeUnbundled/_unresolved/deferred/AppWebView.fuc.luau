local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local object = LuauPolyfill.Object

local useEarlyIsFocused = require("@game/CorePackages/Workspace/Packages/Navigation").useEarlyIsFocused
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/deferred/fud")

local module2 = require("@luauforge/deferred/fuf")
local module3 = require("@luauforge/deferred/fuk")

local module4 = require("@luauforge/bundled/fui")
local module5 = require("@luauforge/deferred/fur")

local function useTitle(p2, p3)
	local v5 = useLocalization({ titleKey = p3 })

	return p2 or v5.titleKey
end

local function useLatestCallbackOnUnmount(windowCloseCallback)
	local ref = React.useRef(windowCloseCallback)

	React.useEffect(function()
		ref.current = windowCloseCallback
	end, { windowCloseCallback })

	React.useEffect(function()
		return function()
			local current = ref.current

			if current ~= nil then
				current()
			end
		end
	end, {})
end

local function AppWebView(props)
	local v5 = useEarlyIsFocused()

	local v6 = useNavigation()

	local title = props.title
	local v7 = useLocalization({ titleKey = props.titleKey })
	local v8 = title or v7.titleKey

	local v9 = if module5 then module3(props.url) else props.url

	useLatestCallbackOnUnmount(props.windowCloseCallback)

	if not v5 then
		return nil
	end

	local createElement = React.createElement

	local assign = object.assign
	local v12 = {
		url = v9,
		title = v8,
		transitionAnimation = module(props.transitionAnimation),
		windowCloseCallback = v6.goBack,
		hasBackButton = 0
	}
	local v13 = if module4() then props.hasBackButton else nil
	v12.hasBackButton = v13
	return (createElement(module2, assign({}, props, v12)))
end

return AppWebView
