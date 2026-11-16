local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object
local React = require(parent3.React)
local StackActions = require(parent2.routers.StackActions)
local StackViewLayout = require(parent.StackViewLayout)
local Transitioner = require(parent.Transitioner)
local StackViewTransitionConfigs = require(parent.StackViewTransitionConfigs)
local StackPresentationStyle = require(parent.StackPresentationStyle)

local v = { mode = StackPresentationStyle.Default }

local extended = React.Component:extend("StackView")

function extended:init()
	function self._doRender(...)
		return self:_render(...)
	end

	function self._doConfigureTransition(...)
		return self:_configureTransition(...)
	end

	function self._doOnTransitionStart(...)
		return self:_onTransitionStart(...)
	end

	function self._doOnTransitionEnd(...)
		return self:_onTransitionEnd(...)
	end

	function self._doOnTransitionStep(...)
		return self:_onTransitionStep(...)
	end
end

function extended:render()
	local screenProps = self.props.screenProps
	local navigation = self.props.navigation
	local descriptors = self.props.descriptors

	return React.createElement(Transitioner, {
		render = self._doRender,
		configureTransition = self._doConfigureTransition,
		screenProps = screenProps,
		navigation = navigation,
		descriptors = descriptors,
		onTransitionStart = self._doOnTransitionStart,
		onTransitionEnd = self._doOnTransitionEnd,
		onTransitionStep = self._doOnTransitionStep
	})
end

function extended.didMount(p)
	local navigation = p.props.navigation

	if navigation.state.isTransitioning then
		navigation.dispatch(StackActions.completeTransition({ key = navigation.state.key }))
	end
end

function extended:_render(transitionProps, lastTransitionProps)
	local screenProps = self.props.screenProps
	local v2 = Object.assign(table.clone(v), self.props.navigationConfig)
	local descriptors = self.props.descriptors

	return React.createElement(
		StackViewLayout,
		Object.assign(v2, {
			screenProps = screenProps,
			descriptors = descriptors,
			transitionProps = transitionProps,
			lastTransitionProps = lastTransitionProps
		})
	)
end

function extended:_configureTransition(p, p2)
	return StackViewTransitionConfigs.getTransitionConfig(
		self.props.navigationConfig.transitionConfig,
		p,
		p2,
		self.props.navigationConfig.mode
	).transitionSpec
end

function extended:_onTransitionStart(p, p2)
	local onTransitionStart = self.props.onTransitionStart or self.props.navigationConfig.onTransitionStart

	if onTransitionStart and p.index ~= p2.index then
		onTransitionStart(p.navigation, p2.navigation)
	end
end

function extended:_onTransitionEnd(data, p)
	local navigationConfig = self.props.navigationConfig
	local navigation = self.props.navigation
	local onTransitionEnd = self.props.onTransitionEnd or navigationConfig.onTransitionEnd
	local key = data.scene.route.key
	local v2 = navigation.state.routes[navigation.state.index].key == key

	if data.navigation.state.isTransitioning and v2 then
		navigation.dispatch(StackActions.completeTransition({
			key = navigation.state.key,
			toChildKey = key
		}))
	end

	if onTransitionEnd and data.index ~= p.index then
		onTransitionEnd(data.navigation, p.navigation)
	end
end

function extended:_onTransitionStep(p, p2, p3)
	local onTransitionStep = self.props.onTransitionStep or self.props.navigationConfig.onTransitionStep

	if onTransitionStep and p.index ~= p2.index then
		onTransitionStep(p.navigation, p2.navigation, p3)
	end
end

return extended
