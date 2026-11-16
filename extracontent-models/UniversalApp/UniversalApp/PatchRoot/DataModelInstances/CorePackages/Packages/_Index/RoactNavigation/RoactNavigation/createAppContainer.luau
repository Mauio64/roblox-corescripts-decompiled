local parent = script.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local LuauPolyfill = require(parent2.LuauPolyfill)
local console = LuauPolyfill.console
local Object = LuauPolyfill.Object
local NavigationActions = require(parent.NavigationActions)
local Events = require(parent.Events)
local NavigationContext = require(parent.views.NavigationContext)
local getNavigation = require(parent.getNavigation)

local assert = assert

local pathUtils = require(parent.routers.pathUtils)

local urlToPathAndParams = pathUtils.urlToPathAndParams

local function isStateful(p): boolean -- 2 equivalent calls inferred from this helper
	return not p.navigation
end

local function validateProps(data)
	if data.persistenceKey then
		warn("You passed persistenceKey prop to a navigator. The persistenceKey prop was replaced by a more flexible persistence mechanism, please see the navigation state persistence docs for more information. Passing the persistenceKey prop is a no-op.")
	end

	if isStateful(data) then -- inferred equivalent call
		return
	end

	local v = Object.assign(table.clone(data), {
		navigation = Object.None,
		screenProps = Object.None,
		persistNavigationState = Object.None,
		loadNavigationState = Object.None,
		externalDispatchConnector = Object.None
	})

	if next(v) ~= nil then
		error("This navigator has both navigation and container props, so it is " .. ("unclear if it should own its own state. Remove props: %q "):format(table.concat(Object.keys(v), ", ")) .. "if the navigator should get its state from the navigation prop. If the navigator should maintain its own state, do not pass a navigation prop.")
	end

	local persistNavigationState = data.persistNavigationState
	local loadNavigationState = data.loadNavigationState
	local v2

	if persistNavigationState == nil and loadNavigationState == nil then
		v2 = true
	elseif type(persistNavigationState) == "function" then
		v2 = type(loadNavigationState) == "function"
	else
		v2 = false
	end

	assert(v2, "both persistNavigationState and loadNavigationState must either be undefined, or be functions")
end

local v = 0
local CreateAppContainer = {}

function CreateAppContainer.createAppContainer(p, object)
	assert(
		type(p) == "table" and p.router ~= nil,
		"AppComponent must be a navigator or a stateful Roact component with a 'router' field"
	)

	local v2 = string.format("NavigationContainer(%s)", (tostring(p)))
	local appContainer = React.Component:extend(v2)

	appContainer.router = p.router

	function appContainer.getDerivedStateFromProps(p2): nil
		validateProps(p2)
		return nil
	end

	function appContainer:init()
		validateProps(self.props)

		self._actionEventSubscribers = {}
		self._initialAction = NavigationActions.init()
		local nav

		if self:_isStateful() and not self.props.loadNavigationState then
			nav = p.router.getStateForAction(self._initialAction)
		end

		self.state = { nav = nav }
	end

	function appContainer:_updateExternalDispatchConnector()
		if self._disconnectExternalDispatch then
			self._disconnectExternalDispatch()
			self._disconnectExternalDispatch = nil
		end

		local externalDispatchConnector = self.props.externalDispatchConnector

		if externalDispatchConnector ~= nil then
			self._disconnectExternalDispatch = externalDispatchConnector(function(...)
				if self._isMounted then
					return self:dispatch(...)
				end

				return false
			end)
		end
	end

	function appContainer:_renderLoading()
		return self.props.renderLoading and self.props.renderLoading()
	end

	function appContainer:_isStateful()
		return isStateful(self.props) -- inferred equivalent call
	end

	function appContainer:_handleOpenURL(p2)
		local url = p2.url
		local enableURLHandling = self.props.enableURLHandling
		local uriPrefix = self.props.uriPrefix

		if enableURLHandling == false then
			return
		end

		local v3 = urlToPathAndParams(url, uriPrefix)

		if v3 then
			local path = v3.path
			local params = v3.params
			local actionForPathAndParams = p.router.getActionForPathAndParams(path, params)

			if actionForPathAndParams then
				self:dispatch(actionForPathAndParams)
			end
		end
	end

	function appContainer:_onNavigationStateChange(p2, p3, p4)
		local onNavigationStateChange = self.props.onNavigationStateChange

		if onNavigationStateChange == nil and self:_isStateful() and _G.REACT_NAV_LOGGING then
			console.group("Navigation Dispatch: ")
			console.log("Action: ", p4)
			console.log("New State: ", p3)
			console.log("Last State: ", p2)
			console.groupEnd()
		elseif type(onNavigationStateChange) == "function" then
			onNavigationStateChange(p2, p3, p4)
		end
	end

	function appContainer:didUpdate(p2)
		if self._navState == self.state.nav then
			self._navState = nil
		end

		if self.props.externalDispatchConnector ~= p2.externalDispatchConnector then
			self:_updateExternalDispatchConnector()
		end
	end

	function appContainer:didMount()
		self._isMounted = true

		self:_updateExternalDispatchConnector()

		if not self:_isStateful() then
			return
		end

		if _G.__DEV__ and not self.props.detached and v > 0 then
			console.warn("You should only render one navigator explicitly in your app, and other navigators should be rendered by including them in that navigator. Full details at: https://reactnavigation.org/docs/4.x/common-mistakes#explicitly-rendering-more-than-one-navigator")
		end

		v += 1

		if object then
			object:listenForLuaURLs(function(url)
				self:_handleOpenURL({ url = url })
			end, false)
		end

		local userProvidedStartupState, parsedUrl

		if self.props.enableURLHandling ~= false then
			local startupParams = self:getStartupParams()
			parsedUrl = startupParams.parsedUrl
			userProvidedStartupState = startupParams.userProvidedStartupState
		end

		local action = self._initialAction
		local nav = self.state.nav or p.router.getStateForAction(action)
		local nav2 = userProvidedStartupState or nav

		if parsedUrl then
			local path = parsedUrl.path
			local params = parsedUrl.params
			local actionForPathAndParams = p.router.getActionForPathAndParams(path, params)

			if actionForPathAndParams then
				nav2 = p.router.getStateForAction(actionForPathAndParams, nav2)
				action = actionForPathAndParams
			end
		end

		local function dispatchAction()
			for k in self._actionEventSubscribers do
				k({ type = Events.Action, action = action, state = self.state.nav, lastState = nil })
			end
		end

		if nav2 == self.state.nav then
			spawn(dispatchAction)
		else
			self:setState({ nav = nav2 }, dispatchAction)
		end
	end

	function appContainer:getStartupParams()
		local props = self.props
		local uriPrefix = props.uriPrefix
		local loadNavigationState = props.loadNavigationState
		local v3 = nil
		local userProvidedStartupState = nil

		if object then
			pcall(function()
				v3 = object:getLastLuaURL()
			end)
		end

		if loadNavigationState then
			pcall(function()
				userProvidedStartupState = loadNavigationState()
			end)
		end

		return {
			parsedUrl = v3 and urlToPathAndParams(v3, uriPrefix),
			userProvidedStartupState = userProvidedStartupState
		}
	end

	function appContainer:_persistNavigationState(p2)
		local persistNavigationState = self.props.persistNavigationState

		if persistNavigationState then
			local success, result = pcall(persistNavigationState, p2)

			if not success then
				warn("Uncaught error while calling persistNavigationState()! " .. "You should handle exceptions thrown from persistNavigationState(), " .. "ignoring them may result in undefined behavior.\n" .. result)
			end
		end
	end

	function appContainer:willUnmount()
		self._isMounted = false

		if object then
			object:stopListeningForLuaURLs()
		end

		if self._disconnectExternalDispatch then
			self._disconnectExternalDispatch()
			self._disconnectExternalDispatch = nil
		end

		if self:_isStateful() then
			v -= 1
		end
	end

	function appContainer:dispatch(action)
		if self.props.navigation then
			return self.props.navigation.dispatch(action)
		end

		self._navState = self._navState or self.state.nav
		local navState = self._navState
		assert(navState ~= nil, "should be set in constructor if stateful")

		local stateForAction = p.router.getStateForAction(action, navState)
		local v3

		if stateForAction == nil then
			v3 = navState
		else
			v3 = stateForAction
		end

		local function dispatchActionEvents()
			for k in self._actionEventSubscribers do
				k({ type = Events.Action, action = action, state = v3, lastState = navState })
			end
		end

		if stateForAction == nil then
			dispatchActionEvents()
			return true
		end

		if v3 == navState then
			dispatchActionEvents()
			return false
		end

		self._navState = v3

		self:setState({ nav = v3 }, function()
			self:_onNavigationStateChange(navState, v3, action)
			task.defer(dispatchActionEvents)
			self:_persistNavigationState(v3)
		end)

		return true
	end

	function appContainer:_getScreenProps(p2, p3)
		if p2 == nil then
			return self.props.screenProps
		end

		local screenProps = self.props.screenProps

		if screenProps == nil or screenProps[p2] == nil then
			return p3
		end

		return screenProps[p2]
	end

	function appContainer:render()
		local navigation = self.props.navigation

		if self:_isStateful() then
			local nav = self.state.nav

			if not nav then
				return self:_renderLoading()
			end

			if not self._navigation or self._navigation.state ~= nav then
				self._navigation = getNavigation(p.router, nav, function(...)
					return self:dispatch(...)
				end, self._actionEventSubscribers, function(...)
					return self:_getScreenProps(...)
				end, function()
					return self._navigation
				end)
			end

			navigation = self._navigation
		end

		assert(navigation ~= nil, "failed to get navigation")

		return React.createElement(NavigationContext.Provider, { value = navigation }, {
			AppComponent = React.createElement(p, Object.assign(table.clone(self.props), {
				navigation = navigation
			}))
		})
	end

	return appContainer
end

function CreateAppContainer._TESTING_ONLY_reset_container_count()
	v = 0
end

return CreateAppContainer
