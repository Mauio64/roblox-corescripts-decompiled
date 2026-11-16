local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local React = require(parent2.React)
local Otter = require(parent2.Otter)
local ScenesReducer = require(script.Parent.ScenesReducer)
local invariant = require(parent.utils.invariant)

local v = { frequency = 4 }

local function buildTransitionProps(p, data)
	local navigation = p.navigation
	local options = p.options

	local layout = data.layout
	local position = data.position
	local scenes = data.scenes
	local scene2 = nil

	for _, scene in scenes do
		if scene.isActive then
			scene2 = scene
			break
		end
	end

	invariant(scene2, "Could not find active scene")

	return {
		layout = layout,
		navigation = navigation,
		position = position,
		scenes = scenes,
		scene = scene2,
		options = options,
		index = scene2.index
	}
end

local function filterStale(list)
	local filtered = Array.filter(list, function(p): boolean
		return not p.isStale
	end)

	return if #filtered == #list then list else filtered
end

local extended = React.Component:extend("Transitioner")

function extended:init()
	local state = self.props.navigation.state
	local descriptors = self.props.descriptors

	self._ref = React.createRef()

	self.state = {
		layout = { initWidth = 0, initHeight = 0, isMeasured = false },
		position = Otter.createSingleMotor(state.index),
		scenes = ScenesReducer({}, state, nil, descriptors)
	}

	function self._doOnAbsoluteSizeChanged(...)
		return self:_onAbsoluteSizeChanged(...)
	end

	self._positionLastValue = state.index

	self._prevTransitionProps = nil
	self._transitionProps = buildTransitionProps(self.props, self.state)

	self._isMounted = false
	self._isTransitionRunning = false
	self._transitionQueue = {}

	self._completeSignalDisconnector = self.state.position:onComplete(function()
		if self._isMounted then
			self:_onTransitionEnd()
		end
	end)

	self._stepSignalDisconnector = self.state.position:onStep(function(p)
		if self._isMounted then
			self:_onPositionStep(p)
		end
	end)
end

function extended:didMount()
	self._isMounted = true
end

function extended:willUnmount()
	self._isMounted = false

	if self._completeSignalDisconnector then
		self._completeSignalDisconnector()
		self._completeSignalDisconnector = nil
	end

	if self._stepSignalDisconnector then
		self._stepSignalDisconnector()
		self._stepSignalDisconnector = nil
	end
end

function extended:didUpdate(prevProps)
	if not self.state.layout.isMeasured and self._ref.current then
		self:_onAbsoluteSizeChanged(self._ref.current)
	end

	if self.props ~= prevProps then
		if self._isTransitionRunning then
			if (self._transitionQueue[#self._transitionQueue] or {}).prevProps ~= prevProps then
				table.insert(self._transitionQueue, { prevProps = prevProps })
			end
		else
			self:_startTransition(prevProps, self.props)
		end
	end
end

function extended:render()
	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		[React.Change.AbsoluteSize] = self._doOnAbsoluteSizeChanged,
		ref = self._ref
	}, {
		TransitionerScenes = self.props.render(self._transitionProps, self._prevTransitionProps, self)
	})
end

function extended:_onAbsoluteSizeChanged(p)
	if not self._isMounted then
		return
	end

	local x = p.AbsoluteSize.X
	local y = p.AbsoluteSize.Y

	if x == self.state.layout.initWidth and y == self.state.layout.initHeight then
		return
	end

	local layout = Object.assign(table.clone(self.state.layout), {
		initWidth = x,
		initHeight = y,
		isMeasured = true
	})

	local v2 = Object.assign(table.clone(self.state), { layout = layout })

	self._transitionProps = buildTransitionProps(self.props, v2)

	self:setState({ layout = layout })
end

function extended:_computeScenes(p, data)
	local scenes = ScenesReducer(self.state.scenes, data.navigation.state, p.navigation.state, data.descriptors)

	if not data.navigation.state.isTransitioning then
		local filtered = Array.filter(scenes, function(p2): boolean
			return not p2.isStale
		end)

		if #filtered ~= #scenes then
			scenes = filtered
		end
	end

	if data.screenProps ~= self.props.screenProps then
		self:setState({ scenes = scenes })
	end

	return if scenes ~= self.state.scenes then scenes else nil
end

function extended:_startTransition(p, data)
	local v2 = p.navigation.state.index ~= data.navigation.state.index
	local scenes = self:_computeScenes(p, data)

	if scenes then
		local v3 = Object.assign(table.clone(self.state), { scenes = scenes })

		local position = v3.position
		local index = data.navigation.state.index

		self._prevTransitionProps = self._transitionProps
		self._transitionProps = buildTransitionProps(data, v3)
		local isTransitioning = self._transitionProps.navigation.state.isTransitioning

		if isTransitioning and v2 then
			self._isTransitionRunning = true
		end

		self:setState(v3, function()
			if isTransitioning and v2 then
				if data.onTransitionStart then
					data.onTransitionStart(self._transitionProps, self._prevTransitionProps)
				end

				if self._positionLastValue == index then
					position:setGoal(Otter.instant(data.navigation.state.index))
					return
				end

				local v4 = data.configureTransition
					and data.configureTransition(self._transitionProps, self._prevTransitionProps)
					or {}

				local v5 = Object.assign(table.clone(v), v4)

				position:setGoal(Otter.spring(data.navigation.state.index, v5))
			else
				if data.onTransitionStart then
					data.onTransitionStart(self._transitionProps, self._prevTransitionProps)
				end

				position:setGoal(Otter.instant(index))
			end
		end)
	else
		self._prevTransitionProps = self._transitionProps

		if self._isTransitionRunning then
			self:_onTransitionEnd()
		end
	end
end

function extended:_onTransitionEnd()
	local prevTransitionProps = self._prevTransitionProps
	self._prevTransitionProps = nil

	local scenes = self.state.scenes
	local filtered = Array.filter(scenes, function(p): boolean
		return not p.isStale
	end)

	if #filtered ~= #scenes then
		scenes = filtered
	end

	local v2 = Object.assign(table.clone(self.state), { scenes = scenes })

	self._transitionProps = buildTransitionProps(self.props, v2)

	self:setState(v2, function()
		if self.props.onTransitionEnd then
			self.props.onTransitionEnd(self._transitionProps, prevTransitionProps)
		end

		local v3 = self._transitionQueue[1]

		if not v3 then
			self._isTransitionRunning = false

			return
		end

		local prevProps = v3.prevProps

		self._transitionQueue = table.clone(self._transitionQueue)
		table.remove(self._transitionQueue, 1)
		self:_startTransition(prevProps, self.props)
	end)
end

function extended:_onPositionStep(positionLastValue)
	self._positionLastValue = positionLastValue

	local index = self._transitionProps.index
	local v2

	if self._prevTransitionProps then
		v2 = self._prevTransitionProps.index
	else
		v2 = index
	end

	if self.props.onTransitionStep and v2 ~= index then
		local v3 = (positionLastValue - v2) / (index - v2)
		self.props.onTransitionStep(self._transitionProps, self._prevTransitionProps, v3)
	end
end

return extended
