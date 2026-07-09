local Parent = script:FindFirstAncestor("NotApprovedPage").Parent
local React = require(Parent.React)
local useEffect = React.useEffect
local useCallback = React.useCallback
local useRef = React.useRef
local GetFFlagEnableUnifiedWebViews = require(Parent.SharedFlags).GetFFlagEnableUnifiedWebViews
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local AppPage = require(Parent.RobloxAppEnums).AppPage
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local WebViewService = game:GetService("WebViewService")

local function useWebView(s1: string, s2: string) -- line: 27
	-- upvalues: useDispatch (copy), useRef (copy), useCallback (copy), GetFFlagEnableUnifiedWebViews (copy), WebViewService (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateDown (copy), useEffect (copy)
	local v16 = useDispatch()
	local v17 = useRef(nil)
	local v18 = useCallback(function() -- line: 31
		-- upvalues: v17 (copy)
		if v17.current then
			v17.current:Disconnect()
			v17.current = nil
		end
	end, { v17 })
	local v19 = useCallback(function() -- line: 38
		-- upvalues: GetFFlagEnableUnifiedWebViews (copy), v18 (copy), v17 (copy), WebViewService (copy), s1 (copy), s2 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), v16 (copy), NavigateDown (copy)
		if GetFFlagEnableUnifiedWebViews() then
			v18()
			v17.current = WebViewService.OnWindowClosed:Connect(function() -- line: 44
				-- upvalues: WebViewService (copy), v18 (copy)
				WebViewService:CloseWindow()
				v18()
			end)
			WebViewService:OpenWindow(s1, s2, true)

			return
		end

		local t1 = {
			name = AppPage.GenericWebPage,
			detail = s1,
			extraProps = {
				title = s2
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v11.down(v11.fromLegacyPage(t1))

			return
		end

		v16(NavigateDown(t1))
	end, {
		s1,
		s2,
		v18
	})

	useEffect(function() -- line: 67
		-- upvalues: v18 (copy)
		return function() -- line: 68
			-- upvalues: v18 (copy)
			v18()
		end
	end, { v18 })

	return v19
end

return useWebView
