local module = require("@luauforge/deferred/gzS")
local useEffect = module.useEffect
local useCallback = module.useCallback
local useRef = module.useRef

local getFFlagEnableUnifiedWebViews = require("@luauforge/deferred/gAd").GetFFlagEnableUnifiedWebViews
local useDispatch = require("@luauforge/deferred/gAC").Hooks.RoactRodux.useDispatch
local navigateDown = require("@luauforge/deferred/gAv").Thunks.NavigateDown
local appPage = require("@luauforge/deferred/gAu").AppPage

local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/gAd").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/gAx").NavigationCommands else nil

local WebViewService = game:GetService("WebViewService")

local function useWebView(p2, p3)
	local v5 = useDispatch()
	local v6 = useRef(nil)

	local v7 = useCallback(function()
		if v6.current then
			v6.current:Disconnect()
			v6.current = nil
		end
	end, { v6 })

	local v8 = useCallback(function()
		if getFFlagEnableUnifiedWebViews() then
			v7()

			v6.current = WebViewService.OnWindowClosed:Connect(function()
				WebViewService:CloseWindow()
				v7()
			end)

			WebViewService:OpenWindow(p2, p3, true)
		else
			local v9 = {
				name = appPage.GenericWebPage,
				detail = p2,
				extraProps = { title = p3 }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v9))
			else
				v5(navigateDown(v9))
			end
		end
	end, { p2, p3, v7 })

	useEffect(function()
		return function()
			v7()
		end
	end, { v7 })

	return v8
end

return useWebView
