local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent.Parent

local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object
local React = require(parent3.React)
local StackPresentationStyle = require(parent.StackPresentationStyle)
local StackViewTransitionConfigs = require(parent.StackViewTransitionConfigs)
local StackViewOverlayFrame = require(parent.StackViewOverlayFrame)
local StackViewCard = require(parent.StackViewCard)
local SceneView = require(parent2.SceneView)

local v = {
	absorbInput = true,
	absorbInputSelectable = true,
	overlayEnabled = false,
	overlayColor3 = Color3.new(0, 0, 0),
	overlayTransparency = 0.7,
	renderOverlay = function(navigationOptions, initialTransitionValue, transitionChangedSignal)
		return React.createElement(StackViewOverlayFrame, {
			navigationOptions = navigationOptions,
			initialTransitionValue = initialTransitionValue,
			transitionChangedSignal = transitionChangedSignal
		})
	end,
	transparent = false
}

local function calculateTransitionValue(index, p) -- 2 equivalent calls inferred from this helper
	return (math.max(math.min(1 + p - index, 1), 0))
end

local extended = React.Component:extend("StackViewLayout")

function extended:init()
	self:setState({})
	local index = self.props.transitionProps.navigation.state.index

	self._isMounted = false
	self._positionLastValue = index

	function self._renderScene(p)
		return self:_renderInnerScene(p)
	end

	function self._subscribeToOverlayUpdates(callback)
		local position = self.props.transitionProps.position
		local index2 = self.props.transitionProps.scene.index

		return position:onStep(function(p)
			callback(calculateTransitionValue(index2, p)) -- inferred equivalent call
		end)
	end
end

function extended:_renderCard(scene, props)
	local transitionProps = self.props.transitionProps
	local lastTransitionProps = self.props.lastTransitionProps
	local transitionConfig = self.state.transitionConfig

	local cardColor3 = props.cardColor3
	local overlayEnabled = props.overlayEnabled
	local transparent = props.transparent

	local index = transitionProps.scene.index

	if lastTransitionProps then
		index = lastTransitionProps.scene.index
	end

	local screenInterpolator = transitionConfig.screenInterpolator
	local v2 = not screenInterpolator and {}
		or screenInterpolator(Object.assign(table.clone(transitionProps), {
			initialPositionValue = index,
			scene = scene
		}))

	local createElement = React.createElement

	local assign = Object.assign
	local clone = table.clone(transitionProps)
	local v3 = {
		key = "card_" .. tostring(scene.key),
		scene = scene,
		renderScene = self._renderScene,
		cardColor3 = 0
	}

	if overlayEnabled or transparent then
		cardColor3 = nil
	end

	v3.cardColor3 = cardColor3
	return createElement(StackViewCard, assign(clone, v2, v3))
end

function extended:_renderInnerScene(p)
	local navigation = p.descriptor.navigation

	local component = p.descriptor.getComponent()
	local screenProps = self.props.screenProps

	return React.createElement(SceneView, {
		screenProps = screenProps,
		navigation = navigation,
		component = component
	})
end

function extended:render()
	local transitionProps = self.props.transitionProps
	local topMostOpaqueSceneIndex = self.state.topMostOpaqueSceneIndex

	local elements = {}

	for _, scene in transitionProps.scenes do
		local v2

		if scene.index < topMostOpaqueSceneIndex then
			v2 = not scene.isActive
		else
			v2 = false
		end

		local v3

		if scene.descriptor.options then
			v3 = Object.assign(table.clone(v), scene.descriptor.options)
		else
			v3 = table.clone(v)
		end

		local overlayEnabled = v3.overlayEnabled
		local absorbInput = v3.absorbInput
		local absorbInputSelectable = v3.absorbInputSelectable
		local renderOverlay = v3.renderOverlay
		local stationaryContent

		if overlayEnabled then
			stationaryContent = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				BorderSizePixel = 0,
				ZIndex = 1
			}, {
				Overlay = renderOverlay(
					v3,
					calculateTransitionValue(scene.index, self._positionLastValue), -- inferred equivalent call
					self._subscribeToOverlayUpdates
				)
			})
		end

		local absorbInput2

		if not (v2 or not absorbInput) then
			absorbInput2 = React.createElement("TextButton", {
				Active = true,
				Selectable = absorbInputSelectable,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Text = " ",
				ZIndex = 2 * scene.index - 1
			})
		end

		local element = React.createElement(React.Fragment, {}, {
			AbsorbInput = absorbInput2,
			[tostring(scene.index)] = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				ZIndex = 2 * scene.index,
				Visible = not v2
			}, {
				StationaryContent = stationaryContent,
				DynamicContent = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					ClipsDescendants = false,
					BorderSizePixel = 0,
					ZIndex = 2
				}, {
					["card_" .. scene.key] = self:_renderCard(scene, v3)
				})
			})
		})

		elements[tostring(scene.key)] = element
	end

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			BorderSizePixel = 0
		},
		elements
	)
end

function extended.getDerivedStateFromProps(data, _)
	local transitionProps = data.transitionProps
	local scenes = transitionProps.scenes
	local isTransitioning = transitionProps.navigation.state.isTransitioning
	local count = #scenes

	local v2 = data.mode == StackPresentationStyle.Modal or data.mode == StackPresentationStyle.Overlay
	local topMostOpaqueSceneIndex = 0

	for i = count, 1, -1 do
		local scene = scenes[i]
		local v3

		if scene.descriptor.options then
			v3 = Object.assign(table.clone(v), scene.descriptor.options)
		else
			v3 = table.clone(v)
		end

		if not (v3.transparent or v2 and v3.overlayEnabled) and (not isTransitioning or i ~= count) then
			topMostOpaqueSceneIndex = i
			break
		end
	end

	return {
		topMostOpaqueSceneIndex = topMostOpaqueSceneIndex,
		transitionConfig = StackViewTransitionConfigs.getTransitionConfig(
			data.transitionConfig,
			data.transitionProps,
			data.lastTransitionProps,
			data.mode
		)
	}
end

function extended:didMount()
	self._isMounted = true

	self._positionDisconnector = self.props.transitionProps.position:onStep(function(...)
		self:_onPositionStep(...)
	end)
end

function extended:willUnmount()
	self._isMounted = false

	if self._positionDisconnector then
		self._positionDisconnector()
		self._positionDisconnector = nil
	end
end

function extended:didUpdate(p)
	local position = self.props.transitionProps.position

	if position ~= p.transitionProps.position then
		self._positionDisconnector()
		self._positionDisconnector = position:onStep(function(...)
			self:_onPositionStep(...)
		end)
	end
end

function extended:_onPositionStep(positionLastValue)
	if self._isMounted then
		self._positionLastValue = positionLastValue
	end
end

return extended
