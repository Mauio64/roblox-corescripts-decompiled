local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local ParentParent = scriptParentParent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local React = require(ParentParent.React)
local StackPresentationStyle = require(scriptParent.StackPresentationStyle)
local StackViewTransitionConfigs = require(scriptParent.StackViewTransitionConfigs)
local StackViewOverlayFrame = require(scriptParent.StackViewOverlayFrame)
local StackViewCard = require(scriptParent.StackViewCard)
local SceneView = require(scriptParentParent.SceneView)
local t1 = {
	absorbInput = true,
	absorbInputSelectable = true,
	overlayEnabled = false,
	overlayTransparency = 0.7,
	transparent = false,
	overlayColor3 = Color3.new(0, 0, 0),
	renderOverlay = function(p1, p2, p3) -- line: 22
		-- upvalues: React (copy), StackViewOverlayFrame (copy)
		return React.createElement(StackViewOverlayFrame, {
			navigationOptions = p1,
			initialTransitionValue = p2,
			transitionChangedSignal = p3
		})
	end
}

local function calculateTransitionValue(p4, p5) -- line: 34
	return (math.max(math.min(1 + p5 - p4, 1), 0))
end

local v13 = React.Component:extend("StackViewLayout")

function v13.init(p6) -- line: 40
	p6:setState({})

	local index = p6.props.transitionProps.navigation.state.index

	p6._isMounted = false
	p6._positionLastValue = index

	function p6._renderScene(p7) -- line: 47
		-- upvalues: p6 (copy)
		return p6:_renderInnerScene(p7)
	end
	function p6._subscribeToOverlayUpdates(p8) -- line: 51
		-- upvalues: p6 (copy)
		local position = p6.props.transitionProps.position
		local index2 = p6.props.transitionProps.scene.index

		return position:onStep(function(p9) -- line: 55
			-- upvalues: p8 (copy), index2 (copy)
			local v80 = p8
			local v81 = index2

			v80((math.max(math.min(1 + p9 - v81, 1), 0)))
		end)
	end
end
function v13._renderCard(p10, p11, p12) -- line: 61
	-- upvalues: Object (copy), React (copy), StackViewCard (copy)
	local transitionProps = p10.props.transitionProps
	local lastTransitionProps = p10.props.lastTransitionProps
	local transitionConfig = p10.state.transitionConfig
	local cardColor3 = p12.cardColor3
	local overlayEnabled = p12.overlayEnabled
	local transparent = p12.transparent
	local index = transitionProps.scene.index

	if lastTransitionProps then
		index = lastTransitionProps.scene.index
	end

	local t2 = {}
	local screenInterpolator = transitionConfig.screenInterpolator

	if screenInterpolator then
		t2 = screenInterpolator(Object.assign(table.clone(transitionProps), {
			initialPositionValue = index,
			scene = p11
		}))
	end

	return React.createElement(StackViewCard, Object.assign(table.clone(transitionProps), t2, {
		key = "card_" .. tostring(p11.key),
		scene = p11,
		renderScene = p10._renderScene,
		cardColor3 = if not overlayEnabled and not transparent then cardColor3 else nil
	}))
end
function v13._renderInnerScene(p13, p14) -- line: 96
	-- upvalues: React (copy), SceneView (copy)
	local navigation = p14.descriptor.navigation
	local v36 = p14.descriptor.getComponent()
	local screenProps = p13.props.screenProps

	return React.createElement(SceneView, {
		screenProps = screenProps,
		navigation = navigation,
		component = v36
	})
end
function v13.render(p15) -- line: 109
	-- upvalues: Object (copy), t1 (copy), React (copy)
	local transitionProps = p15.props.transitionProps
	local topMostOpaqueSceneIndex = p15.state.topMostOpaqueSceneIndex
	local t3 = {}

	for _, v43 in transitionProps.scenes do
		local v44 = topMostOpaqueSceneIndex > v43.index and not v43.isActive
		local v45 = if not v43.descriptor.options then table.clone(t1) else Object.assign(table.clone(t1), v43.descriptor.options)
		local overlayEnabled = v45.overlayEnabled
		local absorbInput = v45.absorbInput
		local absorbInputSelectable = v45.absorbInputSelectable
		local renderOverlay = v45.renderOverlay
		local v50 = nil

		if overlayEnabled then
			local createElement = React.createElement
			local t4 = {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				BorderSizePixel = 0,
				ZIndex = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}
			local t5 = {}
			local index = v43.index

			t5.Overlay = renderOverlay(v45, math.max(math.min(1 + p15._positionLastValue - index, 1), 0), p15._subscribeToOverlayUpdates)
			v50 = createElement("Frame", t4, t5)
		end

		local v55 = nil

		if not v44 and absorbInput then
			v55 = React.createElement("TextButton", {
				Active = true,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = " ",
				Selectable = absorbInputSelectable,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 2 * v43.index - 1
			})
		end

		local v56 = React.createElement(React.Fragment, {}, {
			AbsorbInput = v55,
			[tostring(v43.index)] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 2 * v43.index,
				Visible = not v44
			}, {
				StationaryContent = v50,
				DynamicContent = React.createElement("Frame", {
					BackgroundTransparency = 1,
					ClipsDescendants = false,
					BorderSizePixel = 0,
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					["card_" .. v43.key] = p15:_renderCard(v43, v45)
				})
			})
		})

		t3[tostring(v43.key)] = v56
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, t3)
end
function v13.getDerivedStateFromProps(p16, _) -- line: 204
	-- upvalues: StackPresentationStyle (copy), Object (copy), t1 (copy), StackViewTransitionConfigs (copy)
	local transitionProps = p16.transitionProps
	local scenes = transitionProps.scenes
	local isTransitioning = transitionProps.navigation.state.isTransitioning
	local v62 = #scenes
	local v63 = p16.mode == StackPresentationStyle.Modal or p16.mode == StackPresentationStyle.Overlay
	local n1 = 0

	for i = v62, 1, -1 do
		local v66 = scenes[i]
		local v67 = if not v66.descriptor.options then table.clone(t1) else Object.assign(table.clone(t1), v66.descriptor.options)

		if not v67.transparent and (not v63 or not v67.overlayEnabled) and (not isTransitioning or i ~= v62) then
			n1 = i

			return {
				topMostOpaqueSceneIndex = n1,
				transitionConfig = StackViewTransitionConfigs.getTransitionConfig(p16.transitionConfig, p16.transitionProps, p16.lastTransitionProps, p16.mode)
			}
		end
	end

	return {
		topMostOpaqueSceneIndex = n1,
		transitionConfig = StackViewTransitionConfigs.getTransitionConfig(p16.transitionConfig, p16.transitionProps, p16.lastTransitionProps, p16.mode)
	}
end
function v13.didMount(p18) -- line: 243
	p18._isMounted = true
	p18._positionDisconnector = p18.props.transitionProps.position:onStep(function(...) -- line: 246
		-- upvalues: p18 (copy)
		p18:_onPositionStep(...)
	end)
end
function v13.willUnmount(p19) -- line: 251
	p19._isMounted = false

	if p19._positionDisconnector then
		p19._positionDisconnector()
		p19._positionDisconnector = nil
	end
end
function v13.didUpdate(p20, p21) -- line: 260
	local position = p20.props.transitionProps.position

	if position ~= p21.transitionProps.position then
		p20._positionDisconnector()
		p20._positionDisconnector = position:onStep(function(...) -- line: 265
			-- upvalues: p20 (copy)
			p20:_onPositionStep(...)
		end)
	end
end
function v13._onPositionStep(p22, p23) -- line: 271
	if p22._isMounted then
		p22._positionLastValue = p23
	end
end

return v13
