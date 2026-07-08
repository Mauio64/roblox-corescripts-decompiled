local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array
local invariant = require(ParentParent.utils.invariant)
local NavigationFocusEvents = require(ParentParent.views.NavigationFocusEvents)

return function(p1, p2, p3) -- line: 12
	-- upvalues: React (copy), invariant (copy), Array (copy), Object (copy), NavigationFocusEvents (copy)
	local v12 = React.Component:extend("Navigator")

	v12.router = p2
	v12.navigationOptions = p3.navigationOptions

	function v12.init(p4) -- line: 20
		local screenProps = p4.props.screenProps

		p4.state = {
			descriptors = {},
			transitioningDescriptors = {},
			screenProps = screenProps
		}
	end
	function v12.getDerivedStateFromProps(p5, p6) -- line: 32
		-- upvalues: invariant (copy), Array (copy), p2 (copy), Object (copy)
		local descriptors = p6.descriptors
		local transitioningDescriptors = p6.transitioningDescriptors
		local navigation = p5.navigation
		local screenProps = p5.screenProps

		invariant(navigation ~= nil, "The navigation prop is missing for this navigator. In react-navigation v3 and v4 you must set up your app container directly. More info: https://reactnavigation.org/docs/en/app-containers.html")

		local routes = navigation.state.routes

		invariant(type(routes) == "table", "No \"routes\" found in navigation state. Did you try to pass the navigation prop of a React component to a Navigator child? See https://reactnavigation.org/docs/en/custom-navigators.html#navigator-navigation-prop")

		local v22 = Array.reduce(routes, function(p7, p8) -- line: 55
			-- upvalues: descriptors (copy), screenProps (copy), p6 (copy), p2 (copy), navigation (copy)
			if descriptors and (descriptors[p8.key] and p8 == descriptors[p8.key].state and screenProps == p6.screenProps) then
				p7[p8.key] = descriptors[p8.key]

				return p7
			end

			local v31 = navigation.getChildNavigation(p8.key)
			local v32 = p2.getScreenOptions(v31, screenProps)

			p7[p8.key] = {
				key = p8.key,
				getComponent = function() -- line: 65
					-- upvalues: p2 (copy), p8 (copy)
					return p2.getComponentForRouteName(p8.routeName)
				end,
				options = v32,
				state = p8,
				navigation = v31
			}

			return p7
		end, {})
		local t1 = {}

		if navigation.state.isTransitioning then
			t1 = Object.assign({}, transitioningDescriptors, descriptors, Array.reduce(routes, function(p9, p10) -- line: 92
				-- upvalues: Object (copy)
				p9[p10.key] = Object.None

				return p9
			end, {}))
		end

		return {
			descriptors = v22,
			transitioningDescriptors = t1,
			screenProps = screenProps
		}
	end
	function v12.render(p11) -- line: 111
		-- upvalues: React (copy), NavigationFocusEvents (copy), p1 (copy), Object (copy), p3 (copy)
		local navigation = p11.props.navigation
		local screenProps = p11.state.screenProps
		local descriptors = p11.state.descriptors
		local transitioningDescriptors = p11.state.transitioningDescriptors

		return React.createElement(React.Fragment, {}, {
			Events = React.createElement(NavigationFocusEvents, {
				navigation = navigation,
				onEvent = function(p12, p13, p14) -- line: 121
					-- upvalues: descriptors (copy), transitioningDescriptors (copy)
					if descriptors[p12] then
						descriptors[p12].navigation.emit(p13, p14)

						return
					end

					if transitioningDescriptors[p12] then
						transitioningDescriptors[p12].navigation.emit(p13, p14)
					end
				end
			}),
			View = React.createElement(p1, Object.assign(table.clone(p11.props), {
				screenProps = screenProps,
				navigation = navigation,
				navigationConfig = p3,
				descriptors = descriptors
			}))
		})
	end

	return v12
end
