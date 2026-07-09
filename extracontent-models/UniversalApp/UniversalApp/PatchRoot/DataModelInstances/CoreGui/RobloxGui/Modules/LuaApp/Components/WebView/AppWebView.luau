local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Object = require(CorePackages.Packages.LuauPolyfill).Object
local useEarlyIsFocused = require(CorePackages.Workspace.Packages.Navigation).useEarlyIsFocused
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local mapTransitionAnimationToNativeString = require(Modules.LuaApp.mapTransitionAnimationToNativeString)
local WebView = require(script.Parent.WebView)
local GetFFlagWebViewServiceHasBackButtonVisibility = require(Modules.LuaApp.Flags.GetFFlagWebViewServiceHasBackButtonVisibility)

local function useTitle(s1: string?, s2: string?) -- line: 23
	-- upvalues: useLocalization (copy)
	local v16 = useLocalization({
		titleKey = s2
	})

	return s1 or v16.titleKey
end
local function useLatestCallbackOnUnmount(p1: ((...any) -> ...any)?) -- line: 30
	-- upvalues: React (copy)
	local v18 = React.useRef(p1)

	React.useEffect(function() -- line: 33
		-- upvalues: v18 (copy), p1 (copy)
		v18.current = p1
	end, { p1 })
	React.useEffect(function() -- line: 37
		-- upvalues: v18 (copy)
		return function() -- line: 38
			-- upvalues: v18 (copy)
			local current = v18.current

			if current ~= nil then
				current()
			end
		end
	end, {})
end
local function AppWebView(p2) -- line: 47
	-- upvalues: useEarlyIsFocused (copy), useNavigation (copy), useLocalization (copy), useLatestCallbackOnUnmount (copy), React (copy), WebView (copy), Object (copy), mapTransitionAnimationToNativeString (copy), GetFFlagWebViewServiceHasBackButtonVisibility (copy)
	local v20 = useEarlyIsFocused()
	local v21 = useNavigation()
	local title = p2.title
	local titleKey = p2.titleKey
	local v24 = useLocalization({
		titleKey = titleKey
	})
	local v25 = title or v24.titleKey

	useLatestCallbackOnUnmount(p2.windowCloseCallback)

	if v20 then
		return (React.createElement(WebView, Object.assign({}, p2, {
			title = v25,
			transitionAnimation = mapTransitionAnimationToNativeString(p2.transitionAnimation),
			windowCloseCallback = v21.goBack,
			hasBackButton = if not GetFFlagWebViewServiceHasBackButtonVisibility() then nil else p2.hasBackButton
		})))
	end

	return nil
end

return AppWebView
