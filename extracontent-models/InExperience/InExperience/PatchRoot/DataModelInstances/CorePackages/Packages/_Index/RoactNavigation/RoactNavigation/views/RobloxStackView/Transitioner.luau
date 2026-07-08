local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local React = require(ParentParentParent.React)
local Otter = require(ParentParentParent.Otter)
local ScenesReducer = require(script.Parent.ScenesReducer)
local invariant = require(ParentParent.utils.invariant)
local t1 = {
	frequency = 4
}

local function buildTransitionProps(p1, p2) -- line: 17
	-- upvalues: invariant (copy)
	local navigation = p1.navigation
	local options = p1.options
	local layout = p2.layout
	local position = p2.position
	local scenes = p2.scenes
	local v21 = nil

	for _, v23 in scenes do
		if v23.isActive then
			v21 = v23

			break
		end
	end

	invariant(v21, "Could not find active scene")

	return {
		layout = layout,
		navigation = navigation,
		position = position,
		scenes = scenes,
		scene = v21,
		options = options,
		index = v21.index
	}
end
local function filterStale(p3) -- line: 46
	-- upvalues: Array (copy)
	local v25 = Array.filter(p3, function(p4) -- line: 47
		return not p4.isStale
	end)

	if #v25 == #p3 then
		return p3
	end

	return v25
end

local v13 = React.Component:extend("Transitioner")

function v13.init(p5) -- line: 60
	-- upvalues: React (copy), Otter (copy), ScenesReducer (copy), buildTransitionProps (copy)
	local state = p5.props.navigation.state
	local descriptors = p5.props.descriptors

	p5._ref = React.createRef()
	p5.state = {
		layout = {
			initWidth = 0,
			initHeight = 0,
			isMeasured = false
		},
		position = Otter.createSingleMotor(state.index),
		scenes = ScenesReducer({}, state, nil, descriptors)
	}

	function p5._doOnAbsoluteSizeChanged(...) -- line: 78
		-- upvalues: p5 (copy)
		return p5:_onAbsoluteSizeChanged(...)
	end

	p5._positionLastValue = state.index
	p5._prevTransitionProps = nil
	p5._transitionProps = buildTransitionProps(p5.props, p5.state)
	p5._isMounted = false
	p5._isTransitionRunning = false
	p5._transitionQueue = {}
	p5._completeSignalDisconnector = p5.state.position:onComplete(function() -- line: 91
		-- upvalues: p5 (copy)
		if p5._isMounted then
			p5:_onTransitionEnd()
		end
	end)
	p5._stepSignalDisconnector = p5.state.position:onStep(function(p6) -- line: 97
		-- upvalues: p5 (copy)
		if p5._isMounted then
			p5:_onPositionStep(p6)
		end
	end)
end
function v13.didMount(p7) -- line: 104
	p7._isMounted = true
end
function v13.willUnmount(p8) -- line: 108
	p8._isMounted = false

	if p8._completeSignalDisconnector then
		p8._completeSignalDisconnector()
		p8._completeSignalDisconnector = nil
	end

	if p8._stepSignalDisconnector then
		p8._stepSignalDisconnector()
		p8._stepSignalDisconnector = nil
	end
end
function v13.didUpdate(p9, p10) -- line: 122
	if not p9.state.layout.isMeasured and p9._ref.current then
		p9:_onAbsoluteSizeChanged(p9._ref.current)
	end

	if p10 ~= p9.props then
		if p9._isTransitionRunning then
			if p10 ~= (p9._transitionQueue[#p9._transitionQueue] or {}).prevProps then
				table.insert(p9._transitionQueue, {
					prevProps = p10
				})
			end

			return
		end

		p9:_startTransition(p10, p9.props)
	end
end
function v13.render(p11) -- line: 147
	-- upvalues: React (copy)
	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		[React.Change.AbsoluteSize] = p11._doOnAbsoluteSizeChanged,
		ref = p11._ref
	}, {
		TransitionerScenes = p11.props.render(p11._transitionProps, p11._prevTransitionProps, p11)
	})
end
function v13._onAbsoluteSizeChanged(p12, p13) -- line: 165
	-- upvalues: Object (copy), buildTransitionProps (copy)
	if not p12._isMounted then
		return
	end

	local AbsoluteSizeX = p13.AbsoluteSize.X
	local AbsoluteSizeY = p13.AbsoluteSize.Y

	if AbsoluteSizeX == p12.state.layout.initWidth and AbsoluteSizeY == p12.state.layout.initHeight then
		return
	end

	local v38 = Object.assign(table.clone(p12.state.layout), {
		isMeasured = true,
		initWidth = AbsoluteSizeX,
		initHeight = AbsoluteSizeY
	})
	local v39 = Object.assign(table.clone(p12.state), {
		layout = v38
	})

	p12._transitionProps = buildTransitionProps(p12.props, v39)
	p12:setState({
		layout = v38
	})
end
function v13._computeScenes(p14, p15, p16) -- line: 194
	-- upvalues: ScenesReducer (copy), Array (copy)
	local v43 = ScenesReducer(p14.state.scenes, p16.navigation.state, p15.navigation.state, p16.descriptors)

	if not p16.navigation.state.isTransitioning then
		local v44 = Array.filter(v43, function(p17) -- line: 47
			return not p17.isStale
		end)

		v43 = if #v44 ~= #v43 then v44 else v43
	end

	if p16.screenProps ~= p14.props.screenProps then
		p14:setState({
			scenes = v43
		})
	end

	if v43 == p14.state.scenes then
		return nil
	end

	return v43
end
function v13._startTransition(p18, p19, p20) -- line: 213
	-- upvalues: Object (copy), buildTransitionProps (copy), t1 (copy), Otter (copy)
	local v48 = p19.navigation.state.index ~= p20.navigation.state.index
	local v49 = p18:_computeScenes(p19, p20)

	if not v49 then
		p18._prevTransitionProps = p18._transitionProps

		if p18._isTransitionRunning then
			p18:_onTransitionEnd()
		end

		return
	end

	local v50 = Object.assign(table.clone(p18.state), {
		scenes = v49
	})
	local position = v50.position
	local index = p20.navigation.state.index

	p18._prevTransitionProps = p18._transitionProps
	p18._transitionProps = buildTransitionProps(p20, v50)

	local isTransitioning = p18._transitionProps.navigation.state.isTransitioning

	if isTransitioning and v48 then
		p18._isTransitionRunning = true
	end

	p18:setState(v50, function() -- line: 245
		-- upvalues: isTransitioning (copy), v48 (copy), p20 (copy), p18 (copy), index (copy), Object (copy), t1 (copy), position (copy), Otter (copy)
		if isTransitioning and v48 then
			if p20.onTransitionStart then
				p20.onTransitionStart(p18._transitionProps, p18._prevTransitionProps)
			end

			if p18._positionLastValue ~= index then
				local t2 = {}

				if p20.configureTransition then
					t2 = p20.configureTransition(p18._transitionProps, p18._prevTransitionProps) or {}
				end

				local v69 = Object.assign(table.clone(t1), t2)

				position:setGoal(Otter.spring(p20.navigation.state.index, v69))

				return
			end

			position:setGoal(Otter.instant(p20.navigation.state.index))

			return
		end

		if p20.onTransitionStart then
			p20.onTransitionStart(p18._transitionProps, p18._prevTransitionProps)
		end

		position:setGoal(Otter.instant(index))
	end)
end
function v13._onTransitionEnd(p21) -- line: 284
	-- upvalues: Array (copy), Object (copy), buildTransitionProps (copy)
	local _prevTransitionProps = p21._prevTransitionProps

	p21._prevTransitionProps = nil

	local scenes = p21.state.scenes
	local v57 = Array.filter(scenes, function(p22) -- line: 47
		return not p22.isStale
	end)
	local v58 = if #v57 ~= #scenes then v57 else scenes
	local v59 = Object.assign(table.clone(p21.state), {
		scenes = v58
	})

	p21._transitionProps = buildTransitionProps(p21.props, v59)
	p21:setState(v59, function() -- line: 296
		-- upvalues: p21 (copy), _prevTransitionProps (copy)
		if p21.props.onTransitionEnd then
			p21.props.onTransitionEnd(p21._transitionProps, _prevTransitionProps)
		end

		local v71 = p21._transitionQueue[1]

		if v71 then
			local prevProps = v71.prevProps

			p21._transitionQueue = table.clone(p21._transitionQueue)
			table.remove(p21._transitionQueue, 1)
			p21:_startTransition(prevProps, p21.props)

			return
		end

		p21._isTransitionRunning = false
	end)
end
function v13._onPositionStep(p23, p24) -- line: 315
	p23._positionLastValue = p24

	local index = p23._transitionProps.index
	local v63 = index

	if p23._prevTransitionProps then
		v63 = p23._prevTransitionProps.index
	end

	if p23.props.onTransitionStep and v63 ~= index then
		local v64 = (p24 - v63) / (index - v63)

		p23.props.onTransitionStep(p23._transitionProps, p23._prevTransitionProps, v64)
	end
end

return v13
