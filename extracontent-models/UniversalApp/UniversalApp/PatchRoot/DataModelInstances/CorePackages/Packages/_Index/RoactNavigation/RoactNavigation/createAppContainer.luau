local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local LuauPolyfill = require(scriptParentParent.LuauPolyfill)
local console = LuauPolyfill.console
local Object = LuauPolyfill.Object
local NavigationActions = require(scriptParent.NavigationActions)
local Events = require(scriptParent.Events)
local NavigationContext = require(scriptParent.views.NavigationContext)
local getNavigation = require(scriptParent.getNavigation)
local _assert = assert
local urlToPathAndParams = require(scriptParent.routers.pathUtils).urlToPathAndParams

local function isStateful(p1) -- line: 20
	return not p1.navigation
end
local function validateProps(p2) -- line: 24
	-- upvalues: Object (copy), _assert (copy)
	if p2.persistenceKey then
		warn("You passed persistenceKey prop to a navigator. The persistenceKey prop was replaced by a more flexible persistence mechanism, please see the navigation state persistence docs for more information. Passing the persistenceKey prop is a no-op.")
	end

	if not p2.navigation then
		return
	end

	local v18 = Object.assign(table.clone(p2), {
		navigation = Object.None,
		screenProps = Object.None,
		persistNavigationState = Object.None,
		loadNavigationState = Object.None,
		externalDispatchConnector = Object.None
	})

	if next(v18) ~= nil then
		error("This navigator has both navigation and container props, so it is " .. ("unclear if it should own its own state. Remove props: %q "):format(table.concat(Object.keys(v18), ", ")) .. "if the navigator should get its state from the navigation prop. If the " .. "navigator should maintain its own state, do not pass a navigation prop.")
	end

	local persistNavigationState = p2.persistNavigationState
	local loadNavigationState = p2.loadNavigationState

	_assert(persistNavigationState == nil and loadNavigationState == nil or type(persistNavigationState) == "function" and type(loadNavigationState) == "function", "both persistNavigationState and loadNavigationState must either be undefined, or be functions")
end

local n1 = 0

return {
	createAppContainer = function(p3, p4) -- line: 117
		-- upvalues: _assert (copy), React (copy), validateProps (copy), NavigationActions (copy), urlToPathAndParams (copy), console (copy), n1 (ref), Events (copy), getNavigation (copy), NavigationContext (copy), Object (copy)
		_assert(type(p3) == "table" and p3.router ~= nil, "AppComponent must be a navigator or a stateful Roact component with a 'router' field")

		local v23 = string.format("NavigationContainer(%s)", (tostring(p3)))
		local v24 = React.Component:extend(v23)

		v24.router = p3.router

		function v24.getDerivedStateFromProps(p5) -- line: 128
			-- upvalues: validateProps (copy)
			validateProps(p5)

			return nil
		end
		function v24.init(p6) -- line: 133
			-- upvalues: validateProps (copy), NavigationActions (copy), p3 (copy)
			validateProps(p6.props)
			p6._actionEventSubscribers = {}
			p6._initialAction = NavigationActions.init()

			local v27 = nil

			if p6:_isStateful() and not p6.props.loadNavigationState then
				v27 = p3.router.getStateForAction(p6._initialAction)
			end

			p6.state = {
				nav = v27
			}
		end
		function v24._updateExternalDispatchConnector(p7) -- line: 155
			if p7._disconnectExternalDispatch then
				p7._disconnectExternalDispatch()
				p7._disconnectExternalDispatch = nil
			end

			local externalDispatchConnector = p7.props.externalDispatchConnector

			if externalDispatchConnector ~= nil then
				p7._disconnectExternalDispatch = externalDispatchConnector(function(...) -- line: 163
					-- upvalues: p7 (copy)
					if p7._isMounted then
						return p7:dispatch(...)
					end

					return false
				end)
			end
		end
		function v24._renderLoading(p8) -- line: 174
			return p8.props.renderLoading and p8.props.renderLoading()
		end
		function v24._isStateful(p9) -- line: 178
			return not p9.props.navigation
		end
		function v24._handleOpenURL(p10, p11) -- line: 182
			-- upvalues: urlToPathAndParams (copy), p3 (copy)
			local url = p11.url
			local enableURLHandling = p10.props.enableURLHandling
			local uriPrefix = p10.props.uriPrefix

			if enableURLHandling == false then
				return
			end

			local v37 = urlToPathAndParams(url, uriPrefix)

			if v37 then
				local path = v37.path
				local params = v37.params
				local v40 = p3.router.getActionForPathAndParams(path, params)

				if v40 then
					p10:dispatch(v40)
				end
			end
		end
		function v24._onNavigationStateChange(p12, p13, p14, p15) -- line: 201
			-- upvalues: console (copy)
			local onNavigationStateChange = p12.props.onNavigationStateChange

			if onNavigationStateChange == nil and (p12:_isStateful() and _G.REACT_NAV_LOGGING) then
				console.group("Navigation Dispatch: ")
				console.log("Action: ", p15)
				console.log("New State: ", p14)
				console.log("Last State: ", p13)
				console.groupEnd()

				return
			end

			if type(onNavigationStateChange) == "function" then
				onNavigationStateChange(p13, p14, p15)
			end
		end
		function v24.didUpdate(p16, p17) -- line: 218
			if p16._navState == p16.state.nav then
				p16._navState = nil
			end

			if p16.props.externalDispatchConnector ~= p17.externalDispatchConnector then
				p16:_updateExternalDispatchConnector()
			end
		end
		function v24.didMount(p18) -- line: 231
			-- upvalues: n1 (ref), console (copy), p4 (copy), p3 (copy), Events (copy)
			p18._isMounted = true
			p18:_updateExternalDispatchConnector()

			if not p18:_isStateful() then
				return
			end

			if _G.__DEV__ and not p18.props.detached and n1 > 0 then
				console.warn("You should only render one navigator explicitly in your app, and other navigators should be rendered by including them in that navigator. Full details at: https://reactnavigation.org/docs/4.x/common-mistakes#explicitly-rendering-more-than-one-navigator")
			end

			n1 += 1

			if p4 then
				p4:listenForLuaURLs(function(p19) -- line: 256
					-- upvalues: p18 (copy)
					p18:_handleOpenURL({
						url = p19
					})
				end, false)
			end

			local parsedUrl = nil
			local userProvidedStartupState = nil

			if p18.props.enableURLHandling ~= false then
				local v51 = p18:getStartupParams()

				parsedUrl = v51.parsedUrl
				userProvidedStartupState = v51.userProvidedStartupState
			end

			local _initialAction = p18._initialAction
			local v53 = p18.state.nav or p3.router.getStateForAction(_initialAction)

			if userProvidedStartupState then
				v53 = userProvidedStartupState
			end

			if parsedUrl then
				local path = parsedUrl.path
				local params = parsedUrl.params
				local v56 = p3.router.getActionForPathAndParams(path, params)

				if v56 then
					_initialAction = v56
					v53 = p3.router.getStateForAction(v56, v53)
				end
			end

			local function dispatchAction() -- line: 300
				-- upvalues: p18 (copy), Events (copy), _initialAction (ref)
				for v84 in p18._actionEventSubscribers do
					v84({
						lastState = nil,
						type = Events.Action,
						action = _initialAction,
						state = p18.state.nav
					})
				end
			end

			if v53 == p18.state.nav then
				spawn(dispatchAction)

				return
			end

			p18:setState({
				nav = v53
			}, dispatchAction)
		end
		function v24.getStartupParams(p20) -- line: 326
			-- upvalues: p4 (copy), urlToPathAndParams (copy)
			local props = p20.props
			local uriPrefix = props.uriPrefix
			local loadNavigationState = props.loadNavigationState
			local u62 = nil
			local u63 = nil

			if p4 then
				pcall(function() -- line: 334
					-- upvalues: u62 (ref), p4 (copy)
					u62 = p4:getLastLuaURL()
				end)
			end

			if loadNavigationState then
				pcall(function() -- line: 340
					-- upvalues: u63 (ref), loadNavigationState (copy)
					u63 = loadNavigationState()
				end)
			end

			return {
				parsedUrl = u62 and urlToPathAndParams(u62, uriPrefix),
				userProvidedStartupState = u63
			}
		end
		function v24._persistNavigationState(p21, p22) -- line: 353
			local persistNavigationState = p21.props.persistNavigationState

			if persistNavigationState then
				local ok, result = pcall(persistNavigationState, p22)

				if not ok then
					warn("Uncaught error while calling persistNavigationState()! " .. "You should handle exceptions thrown from persistNavigationState(), " .. "ignoring them may result in undefined behavior.\n" .. result)
				end
			end
		end
		function v24.willUnmount(p23) -- line: 369
			-- upvalues: p4 (copy), n1 (ref)
			p23._isMounted = false

			if p4 then
				p4:stopListeningForLuaURLs()
			end

			if p23._disconnectExternalDispatch then
				p23._disconnectExternalDispatch()
				p23._disconnectExternalDispatch = nil
			end

			if p23:_isStateful() then
				n1 -= 1
			end
		end
		function v24.dispatch(p24, p25) -- line: 395
			-- upvalues: _assert (copy), p3 (copy), Events (copy)
			if p24.props.navigation then
				return p24.props.navigation.dispatch(p25)
			end

			p24._navState = p24._navState or p24.state.nav

			local _navState = p24._navState

			_assert(_navState ~= nil, "should be set in constructor if stateful")

			local v73 = p3.router.getStateForAction(p25, _navState)
			local u74 = v73

			if v73 == nil then
				u74 = _navState
			end

			local function dispatchActionEvents() -- line: 411
				-- upvalues: p24 (copy), Events (copy), p25 (copy), u74 (ref), _navState (copy)
				for v85 in p24._actionEventSubscribers do
					v85({
						type = Events.Action,
						action = p25,
						state = u74,
						lastState = _navState
					})
				end
			end

			if v73 == nil then
				dispatchActionEvents()

				return true
			end

			if _navState ~= u74 then
				p24._navState = u74
				p24:setState({
					nav = u74
				}, function() -- line: 436
					-- upvalues: p24 (copy), _navState (copy), u74 (ref), p25 (copy), dispatchActionEvents (copy)
					p24:_onNavigationStateChange(_navState, u74, p25)
					task.defer(dispatchActionEvents)
					p24:_persistNavigationState(u74)
				end)

				return true
			end

			dispatchActionEvents()

			return false
		end
		function v24._getScreenProps(p26, p27, p28) -- line: 450
			if p27 == nil then
				return p26.props.screenProps
			end

			local screenProps = p26.props.screenProps

			if screenProps == nil or screenProps[p27] == nil then
				return p28
			end

			return screenProps[p27]
		end
		function v24.render(p29) -- line: 465
			-- upvalues: getNavigation (copy), p3 (copy), _assert (copy), React (copy), NavigationContext (copy), Object (copy)
			local navigation = p29.props.navigation

			if p29:_isStateful() then
				local nav = p29.state.nav

				if not nav then
					return p29:_renderLoading()
				end

				if not p29._navigation or nav ~= p29._navigation.state then
					p29._navigation = getNavigation(p3.router, nav, function(...) -- line: 478
						-- upvalues: p29 (copy)
						return p29:dispatch(...)
					end, p29._actionEventSubscribers, function(...) -- line: 482
						-- upvalues: p29 (copy)
						return p29:_getScreenProps(...)
					end, function() -- line: 485
						-- upvalues: p29 (copy)
						return p29._navigation
					end)
				end

				navigation = p29._navigation
			end

			_assert(navigation ~= nil, "failed to get navigation")

			return React.createElement(NavigationContext.Provider, {
				value = navigation
			}, {
				AppComponent = React.createElement(p3, Object.assign(table.clone(p29.props), {
					navigation = navigation
				}))
			})
		end

		return v24
	end,
	_TESTING_ONLY_reset_container_count = function() -- line: 72
		-- upvalues: n1 (ref)
		n1 = 0
	end
}
