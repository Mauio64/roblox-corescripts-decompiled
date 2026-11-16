local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local React = require(parent2.React)
local Events = require(parent.Events)

local extended = React.Component:extend("NavigationEventManager")

function extended:didMount()
	local navigation = self.props.navigation

	self._actionSubscription = navigation.addListener(Events.Action, function(...)
		return self:_handleAction(...)
	end)

	self._willFocusSubscription = navigation.addListener(Events.WillFocus, function(...)
		return self:_handleWillFocus(...)
	end)

	self._willBlurSubscription = navigation.addListener(Events.WillBlur, function(...)
		return self:_handleWillBlur(...)
	end)

	self._didFocusSubscription = navigation.addListener(Events.DidFocus, function(...)
		return self:_handleDidFocus(...)
	end)

	self._didBlurSubscription = navigation.addListener(Events.DidBlur, function(...)
		return self:_handleDidBlur(...)
	end)

	self._refocusSubscription = navigation.addListener(Events.Refocus, function(...)
		return self:_handleRefocus(...)
	end)
end

function extended:willUnmount()
	if self._actionSubscription then
		self._actionSubscription.remove()
	end

	if self._willFocusSubscription then
		self._willFocusSubscription.remove()
	end

	if self._willBlurSubscription then
		self._willBlurSubscription.remove()
	end

	if self._didFocusSubscription then
		self._didFocusSubscription.remove()
	end

	if self._didBlurSubscription then
		self._didBlurSubscription.remove()
	end

	if self._refocusSubscription then
		self._refocusSubscription.remove()
	end
end

function extended:_handleAction(data)
	local state = data.state
	local lastState = data.lastState
	local action = data.action
	local kind = data.type
	local context = data.context

	local navigation = self.props.navigation
	local onEvent = self.props.onEvent

	if not navigation.isFocused() then
		return
	end

	local lastState2

	if lastState and lastState.routes then
		lastState2 = lastState.routes[lastState.index]
	end

	local route = state.routes[state.index]

	local v = {
		context = ("%s:%s_%s"):format(route.key, tostring(action.type), context or "Root"),
		state = route,
		lastState = lastState2,
		action = action,
		type = kind
	}

	if (lastState2 and lastState2.key) ~= route.key then
		self:_emitWillFocus(route.key, v)

		if lastState2 and lastState2.key then
			self:_emitWillBlur(lastState2.key, v)
		end
	end

	if lastState and lastState.isTransitioning ~= state.isTransitioning and state.isTransitioning == false then
		if self._lastWillBlurKey then
			self:_emitDidBlur(self._lastWillBlurKey, v)
		end

		if self._lastWillFocusKey then
			self:_emitDidFocus(self._lastWillFocusKey, v)
		end
	end

	onEvent(route.key, Events.Action, v)
end

function extended:_handleWillFocus(data)
	local lastState = data.lastState
	local action = data.action
	local context = data.context
	local kind = data.type

	local navigation = self.props.navigation
	local route = navigation.state.routes[navigation.state.index]

	local lastState2 = nil

	if lastState and lastState.routes then
		local v = not lastState and -1 or Array.findIndex(lastState.routes, function(p): boolean
			return p.key == route.key
		end)

		if v > 0 then
			lastState2 = lastState.routes[v]
		end
	end

	self:_emitWillFocus(route.key, {
		context = ("%s:%s_%s"):format(route.key, tostring(action.type), context or "Root"),
		state = route,
		lastState = lastState2,
		action = action,
		type = kind
	})
end

function extended:_handleWillBlur(data)
	local lastState = data.lastState
	local action = data.action
	local context = data.context
	local kind = data.type

	local navigation = self.props.navigation
	local route = navigation.state.routes[navigation.state.index]

	local lastState2 = nil

	if lastState and lastState.routes then
		local v = not lastState and -1 or Array.findIndex(lastState.routes, function(p): boolean
			return p.key == route.key
		end)

		if v > 0 then
			lastState2 = lastState.routes[v]
		end
	end

	self:_emitWillBlur(route.key, {
		context = ("%s:%s_%s"):format(route.key, tostring(action.type), context or "Root"),
		state = route,
		lastState = lastState2,
		action = action,
		type = kind
	})
end

function extended:_handleDidFocus(data)
	local lastState = data.lastState
	local action = data.action
	local context = data.context
	local kind = data.type

	local navigation = self.props.navigation

	if self._lastWillFocusKey then
		local index = Array.findIndex(navigation.state.routes, function(p): boolean
			return p.key == self._lastWillFocusKey
		end)

		if index > 0 then
			local route = navigation.state.routes[index]

			local lastState2 = nil

			if lastState and lastState.routes then
				local v = not lastState and -1 or Array.findIndex(lastState.routes, function(p): boolean
					return p.key == route.key
				end)

				if v > 0 then
					lastState2 = lastState.routes[v]
				end
			end

			self:_emitDidFocus(route.key, {
				context = ("%s:%s_%s"):format(route.key, tostring(action.type), context or "Root"),
				state = route,
				lastState = lastState2,
				action = action,
				type = kind
			})
		end
	end
end

function extended:_handleDidBlur(data)
	local lastState = data.lastState
	local action = data.action
	local context = data.context
	local kind = data.type

	local navigation = self.props.navigation

	if self._lastWillBlurKey then
		local index = Array.findIndex(navigation.state.routes, function(p): boolean
			return p.key == self._lastWillBlurKey
		end)

		if index > 0 then
			local route = navigation.state.routes[index]

			local lastState2 = nil

			if lastState and lastState.routes then
				local v = not lastState and -1 or Array.findIndex(lastState.routes, function(p): boolean
					return p.key == route.key
				end)

				if v > 0 then
					lastState2 = lastState.routes[v]
				end
			end

			self:_emitDidBlur(route.key, {
				context = ("%s:%s_%s"):format(route.key, tostring(action.type), context or "Root"),
				state = route,
				lastState = lastState2,
				action = action,
				type = kind
			})
		end
	end
end

function extended:_handleRefocus()
	local onEvent = self.props.onEvent
	local navigation = self.props.navigation
	onEvent(navigation.state.routes[navigation.state.index].key, Events.Refocus)
end

function extended:_emitWillFocus(lastWillFocusKey, p)
	if self._lastWillBlurKey == lastWillFocusKey then
		self._lastWillBlurKey = nil
	end

	if self._lastWillFocusKey == lastWillFocusKey then
		return
	end

	self._lastDidFocusKey = nil
	self._lastWillFocusKey = lastWillFocusKey

	local navigation = self.props.navigation
	self.props.onEvent(lastWillFocusKey, Events.WillFocus, p)

	if
		type(navigation.state.isTransitioning) ~= "boolean"
		or navigation.state.isTransitioning ~= true and not navigation._dangerouslyGetParent()
	then
		self:_emitDidFocus(lastWillFocusKey, p)
	end
end

function extended:_emitWillBlur(lastWillBlurKey, p)
	if self._lastWillFocusKey == lastWillBlurKey then
		self._lastWillFocusKey = nil
	end

	if self._lastWillBlurKey == lastWillBlurKey then
		return
	end

	self._lastDidBlurKey = nil
	self._lastWillBlurKey = lastWillBlurKey

	local navigation = self.props.navigation
	self.props.onEvent(lastWillBlurKey, Events.WillBlur, p)

	if
		type(navigation.state.isTransitioning) ~= "boolean"
		or navigation.state.isTransitioning ~= true and not navigation._dangerouslyGetParent()
	then
		self:_emitDidBlur(lastWillBlurKey, p)
	end
end

function extended:_emitDidFocus(lastDidFocusKey, p)
	if self._lastWillFocusKey ~= lastDidFocusKey or self._lastDidFocusKey == lastDidFocusKey then
		return
	end

	self._lastDidFocusKey = lastDidFocusKey

	self.props.onEvent(lastDidFocusKey, Events.DidFocus, p)
end

function extended:_emitDidBlur(lastDidBlurKey, p)
	if self._lastWillBlurKey ~= lastDidBlurKey or self._lastDidBlurKey == lastDidBlurKey then
		return
	end

	self._lastDidBlurKey = lastDidBlurKey

	self.props.onEvent(lastDidBlurKey, Events.DidBlur, p)
end

function extended.render(_): nil
	return nil
end

return extended
