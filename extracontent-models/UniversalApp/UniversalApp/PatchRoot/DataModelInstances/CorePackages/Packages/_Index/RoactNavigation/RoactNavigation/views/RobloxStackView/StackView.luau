local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Object = require(ParentParentParent.LuauPolyfill).Object
local React = require(ParentParentParent.React)
local StackActions = require(ParentParent.routers.StackActions)
local StackViewLayout = require(scriptParent.StackViewLayout)
local Transitioner = require(scriptParent.Transitioner)
local StackViewTransitionConfigs = require(scriptParent.StackViewTransitionConfigs)
local t1 = {
	mode = require(scriptParent.StackPresentationStyle).Default
}
local v11 = React.Component:extend("StackView")

function v11.init(p1) -- line: 20
	function p1._doRender(...) -- line: 21
		-- upvalues: p1 (copy)
		return p1:_render(...)
	end
	function p1._doConfigureTransition(...) -- line: 25
		-- upvalues: p1 (copy)
		return p1:_configureTransition(...)
	end
	function p1._doOnTransitionStart(...) -- line: 29
		-- upvalues: p1 (copy)
		return p1:_onTransitionStart(...)
	end
	function p1._doOnTransitionEnd(...) -- line: 33
		-- upvalues: p1 (copy)
		return p1:_onTransitionEnd(...)
	end
	function p1._doOnTransitionStep(...) -- line: 37
		-- upvalues: p1 (copy)
		return p1:_onTransitionStep(...)
	end
end
function v11.render(p2) -- line: 42
	-- upvalues: React (copy), Transitioner (copy)
	local screenProps = p2.props.screenProps
	local navigation = p2.props.navigation
	local descriptors = p2.props.descriptors

	return React.createElement(Transitioner, {
		render = p2._doRender,
		configureTransition = p2._doConfigureTransition,
		screenProps = screenProps,
		navigation = navigation,
		descriptors = descriptors,
		onTransitionStart = p2._doOnTransitionStart,
		onTransitionEnd = p2._doOnTransitionEnd,
		onTransitionStep = p2._doOnTransitionStep
	})
end
function v11.didMount(p3) -- line: 61
	-- upvalues: StackActions (copy)
	local navigation = p3.props.navigation

	if navigation.state.isTransitioning then
		navigation.dispatch(StackActions.completeTransition({
			key = navigation.state.key
		}))
	end
end
function v11._render(p4, p5, p6) -- line: 70
	-- upvalues: Object (copy), t1 (copy), React (copy), StackViewLayout (copy)
	local screenProps = p4.props.screenProps
	local v23 = Object.assign(table.clone(t1), p4.props.navigationConfig)
	local descriptors = p4.props.descriptors

	return React.createElement(StackViewLayout, Object.assign(v23, {
		screenProps = screenProps,
		descriptors = descriptors,
		transitionProps = p5,
		lastTransitionProps = p6
	}))
end
function v11._configureTransition(p7, p8, p9) -- line: 86
	-- upvalues: StackViewTransitionConfigs (copy)
	return StackViewTransitionConfigs.getTransitionConfig(p7.props.navigationConfig.transitionConfig, p8, p9, p7.props.navigationConfig.mode).transitionSpec
end
function v11._onTransitionStart(p10, p11, p12) -- line: 95
	local v31 = p10.props.onTransitionStart or p10.props.navigationConfig.onTransitionStart

	if v31 and p11.index ~= p12.index then
		v31(p11.navigation, p12.navigation)
	end
end
function v11._onTransitionEnd(p13, p14, p15) -- line: 106
	-- upvalues: StackActions (copy)
	local navigationConfig = p13.props.navigationConfig
	local navigation = p13.props.navigation
	local v37 = p13.props.onTransitionEnd or navigationConfig.onTransitionEnd
	local key = p14.scene.route.key
	local v39 = key == navigation.state.routes[navigation.state.index].key

	if p14.navigation.state.isTransitioning and v39 then
		navigation.dispatch(StackActions.completeTransition({
			key = navigation.state.key,
			toChildKey = key
		}))
	end

	if v37 and p14.index ~= p15.index then
		v37(p14.navigation, p15.navigation)
	end
end
function v11._onTransitionStep(p16, p17, p18, p19) -- line: 128
	local v44 = p16.props.onTransitionStep or p16.props.navigationConfig.onTransitionStep

	if v44 and p17.index ~= p18.index then
		v44(p17.navigation, p18.navigation, p19)
	end
end

return v11
