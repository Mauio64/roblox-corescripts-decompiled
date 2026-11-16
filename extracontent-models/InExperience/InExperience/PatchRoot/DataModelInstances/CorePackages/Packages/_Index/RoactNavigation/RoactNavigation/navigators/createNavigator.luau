local parent = script.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array
local invariant = require(parent.utils.invariant)
local NavigationFocusEvents = require(parent.views.NavigationFocusEvents)

return function(p, router, navigationConfig)
	local extended = React.Component:extend("Navigator")

	extended.router = router
	extended.navigationOptions = navigationConfig.navigationOptions

	function extended:init()
		self.state = {
			descriptors = {},
			transitioningDescriptors = {},
			screenProps = self.props.screenProps
		}
	end

	function extended.getDerivedStateFromProps(p2, data)
		local descriptors = data.descriptors

		local transitioningDescriptors = data.transitioningDescriptors
		local navigation = p2.navigation
		local screenProps = p2.screenProps

		invariant(
			navigation ~= nil,
			"The navigation prop is missing for this navigator. In react-navigation v3 and v4 you must set up your app container directly. More info: https://reactnavigation.org/docs/en/app-containers.html"
		)

		local routes = navigation.state.routes

		invariant(
			type(routes) == "table",
			"No \"routes\" found in navigation state. Did you try to pass the navigation prop of a React component to a Navigator child? See https://reactnavigation.org/docs/en/custom-navigators.html#navigator-navigation-prop"
		)

		return {
			descriptors = Array.reduce(routes, function(p3, state)
				if
					descriptors
					and descriptors[state.key]
					and state == descriptors[state.key].state
					and screenProps == data.screenProps
				then
					p3[state.key] = descriptors[state.key]
					return p3
				end

				local function fn()
					return router.getComponentForRouteName(state.routeName)
				end

				local childNavigation = navigation.getChildNavigation(state.key)
				local screenOptions = router.getScreenOptions(childNavigation, screenProps)

				p3[state.key] = {
					key = state.key,
					getComponent = fn,
					options = screenOptions,
					state = state,
					navigation = childNavigation
				}

				return p3
			end, {}),
			transitioningDescriptors = not navigation.state.isTransitioning and {} or Object.assign(
				{},
				transitioningDescriptors,
				descriptors,
				Array.reduce(routes, function(nones, p3)
					nones[p3.key] = Object.None
					return nones
				end, {})
			),
			screenProps = screenProps
		}
	end

	function extended.render(p2)
		local navigation = p2.props.navigation
		local screenProps = p2.state.screenProps
		local descriptors = p2.state.descriptors

		local transitioningDescriptors = p2.state.transitioningDescriptors

		return React.createElement(React.Fragment, {}, {
			Events = React.createElement(NavigationFocusEvents, {
				navigation = navigation,
				onEvent = function(p3, p4, p5)
					if descriptors[p3] then
						descriptors[p3].navigation.emit(p4, p5)
					elseif transitioningDescriptors[p3] then
						transitioningDescriptors[p3].navigation.emit(p4, p5)
					end
				end
			}),
			View = React.createElement(
				p,
				Object.assign(table.clone(p2.props), {
					screenProps = screenProps,
					navigation = navigation,
					navigationConfig = navigationConfig,
					descriptors = descriptors
				})
			)
		})
	end

	return extended
end
