local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local React = require(ParentParentParent.React)
local Events = require(ParentParent.Events)
local v6 = React.Component:extend("NavigationEventManager")

function v6.didMount(p1) -- line: 13
	-- upvalues: Events (copy)
	local navigation = p1.props.navigation

	p1._actionSubscription = navigation.addListener(Events.Action, function(...) -- line: 16
		-- upvalues: p1 (copy)
		return p1:_handleAction(...)
	end)
	p1._willFocusSubscription = navigation.addListener(Events.WillFocus, function(...) -- line: 20
		-- upvalues: p1 (copy)
		return p1:_handleWillFocus(...)
	end)
	p1._willBlurSubscription = navigation.addListener(Events.WillBlur, function(...) -- line: 24
		-- upvalues: p1 (copy)
		return p1:_handleWillBlur(...)
	end)
	p1._didFocusSubscription = navigation.addListener(Events.DidFocus, function(...) -- line: 28
		-- upvalues: p1 (copy)
		return p1:_handleDidFocus(...)
	end)
	p1._didBlurSubscription = navigation.addListener(Events.DidBlur, function(...) -- line: 32
		-- upvalues: p1 (copy)
		return p1:_handleDidBlur(...)
	end)
	p1._refocusSubscription = navigation.addListener(Events.Refocus, function(...) -- line: 36
		-- upvalues: p1 (copy)
		return p1:_handleRefocus(...)
	end)
end
function v6.willUnmount(p2) -- line: 41
	if p2._actionSubscription then
		p2._actionSubscription.remove()
	end

	if p2._willFocusSubscription then
		p2._willFocusSubscription.remove()
	end

	if p2._willBlurSubscription then
		p2._willBlurSubscription.remove()
	end

	if p2._didFocusSubscription then
		p2._didFocusSubscription.remove()
	end

	if p2._didBlurSubscription then
		p2._didBlurSubscription.remove()
	end

	if p2._refocusSubscription then
		p2._refocusSubscription.remove()
	end
end
function v6._handleAction(p3, p4) -- line: 62
	-- upvalues: Events (copy)
	local state = p4.state
	local lastState = p4.lastState
	local action = p4.action
	local type2 = p4.type
	local context = p4.context
	local navigation = p3.props.navigation
	local onEvent = p3.props.onEvent

	if not navigation.isFocused() then
		return
	end

	local v19 = nil

	if lastState and lastState.routes then
		v19 = lastState.routes[lastState.index]
	end

	local v20 = state.routes[state.index]
	local t1 = {
		context = ("%s:%s_%s"):format(v20.key, tostring(action.type), context or "Root"),
		state = v20,
		lastState = v19,
		action = action,
		type = type2
	}

	if (v19 and v19.key) ~= v20.key then
		p3:_emitWillFocus(v20.key, t1)

		if v19 and v19.key then
			p3:_emitWillBlur(v19.key, t1)
		end
	end

	if lastState and lastState.isTransitioning ~= state.isTransitioning and state.isTransitioning == false then
		if p3._lastWillBlurKey then
			p3:_emitDidBlur(p3._lastWillBlurKey, t1)
		end

		if p3._lastWillFocusKey then
			p3:_emitDidFocus(p3._lastWillFocusKey, t1)
		end
	end

	onEvent(v20.key, Events.Action, t1)
end
function v6._handleWillFocus(p5, p6) -- line: 113
	-- upvalues: Array (copy)
	local lastState = p6.lastState
	local action = p6.action
	local context = p6.context
	local type3 = p6.type
	local navigation = p5.props.navigation
	local v29 = navigation.state.routes[navigation.state.index]
	local v30 = nil

	if lastState and lastState.routes then
		local v31 = not lastState and -1 or Array.findIndex(lastState.routes, function(p7) -- line: 125
			-- upvalues: v29 (copy)
			return p7.key == v29.key
		end)

		if v31 > 0 then
			v30 = lastState.routes[v31]
		end
	end

	p5:_emitWillFocus(v29.key, {
		context = ("%s:%s_%s"):format(v29.key, tostring(action.type), context or "Root"),
		state = v29,
		lastState = v30,
		action = action,
		type = type3
	})
end
function v6._handleWillBlur(p8, p9) -- line: 143
	-- upvalues: Array (copy)
	local lastState = p9.lastState
	local action = p9.action
	local context = p9.context
	local type4 = p9.type
	local navigation = p8.props.navigation
	local v39 = navigation.state.routes[navigation.state.index]
	local v40 = nil

	if lastState and lastState.routes then
		local v41 = not lastState and -1 or Array.findIndex(lastState.routes, function(p10) -- line: 155
			-- upvalues: v39 (copy)
			return p10.key == v39.key
		end)

		if v41 > 0 then
			v40 = lastState.routes[v41]
		end
	end

	p8:_emitWillBlur(v39.key, {
		context = ("%s:%s_%s"):format(v39.key, tostring(action.type), context or "Root"),
		state = v39,
		lastState = v40,
		action = action,
		type = type4
	})
end
function v6._handleDidFocus(p11, p12) -- line: 173
	-- upvalues: Array (copy)
	local lastState = p12.lastState
	local action = p12.action
	local context = p12.context
	local type5 = p12.type
	local navigation = p11.props.navigation

	if p11._lastWillFocusKey then
		local v49 = Array.findIndex(navigation.state.routes, function(p13) -- line: 182
			-- upvalues: p11 (copy)
			return p13.key == p11._lastWillFocusKey
		end)

		if v49 > 0 then
			local v50 = navigation.state.routes[v49]
			local v51 = nil

			if lastState and lastState.routes then
				local v52 = not lastState and -1 or Array.findIndex(lastState.routes, function(p14) -- line: 192
					-- upvalues: v50 (copy)
					return p14.key == v50.key
				end)

				if v52 > 0 then
					v51 = lastState.routes[v52]
				end
			end

			p11:_emitDidFocus(v50.key, {
				context = ("%s:%s_%s"):format(v50.key, tostring(action.type), context or "Root"),
				state = v50,
				lastState = v51,
				action = action,
				type = type5
			})
		end
	end
end
function v6._handleDidBlur(p15, p16) -- line: 212
	-- upvalues: Array (copy)
	local lastState = p16.lastState
	local action = p16.action
	local context = p16.context
	local type6 = p16.type
	local navigation = p15.props.navigation

	if p15._lastWillBlurKey then
		local v60 = Array.findIndex(navigation.state.routes, function(p17) -- line: 221
			-- upvalues: p15 (copy)
			return p17.key == p15._lastWillBlurKey
		end)

		if v60 > 0 then
			local v61 = navigation.state.routes[v60]
			local v62 = nil

			if lastState and lastState.routes then
				local v63 = not lastState and -1 or Array.findIndex(lastState.routes, function(p18) -- line: 231
					-- upvalues: v61 (copy)
					return p18.key == v61.key
				end)

				if v63 > 0 then
					v62 = lastState.routes[v63]
				end
			end

			p15:_emitDidBlur(v61.key, {
				context = ("%s:%s_%s"):format(v61.key, tostring(action.type), context or "Root"),
				state = v61,
				lastState = v62,
				action = action,
				type = type6
			})
		end
	end
end
function v6._handleRefocus(p19) -- line: 251
	-- upvalues: Events (copy)
	local onEvent = p19.props.onEvent
	local navigation = p19.props.navigation

	onEvent(navigation.state.routes[navigation.state.index].key, Events.Refocus)
end
function v6._emitWillFocus(p20, p21, p22) -- line: 259
	-- upvalues: Events (copy)
	if p21 == p20._lastWillBlurKey then
		p20._lastWillBlurKey = nil
	end

	if p21 == p20._lastWillFocusKey then
		return
	end

	p20._lastDidFocusKey = nil
	p20._lastWillFocusKey = p21

	local navigation = p20.props.navigation

	p20.props.onEvent(p21, Events.WillFocus, p22)

	if type(navigation.state.isTransitioning) ~= "boolean" or navigation.state.isTransitioning ~= true and not navigation._dangerouslyGetParent() then
		p20:_emitDidFocus(p21, p22)
	end
end
function v6._emitWillBlur(p23, p24, p25) -- line: 284
	-- upvalues: Events (copy)
	if p24 == p23._lastWillFocusKey then
		p23._lastWillFocusKey = nil
	end

	if p24 == p23._lastWillBlurKey then
		return
	end

	p23._lastDidBlurKey = nil
	p23._lastWillBlurKey = p24

	local navigation = p23.props.navigation

	p23.props.onEvent(p24, Events.WillBlur, p25)

	if type(navigation.state.isTransitioning) ~= "boolean" or navigation.state.isTransitioning ~= true and not navigation._dangerouslyGetParent() then
		p23:_emitDidBlur(p24, p25)
	end
end
function v6._emitDidFocus(p26, p27, p28) -- line: 309
	-- upvalues: Events (copy)
	if p27 ~= p26._lastWillFocusKey or p27 == p26._lastDidFocusKey then
		return
	end

	p26._lastDidFocusKey = p27
	p26.props.onEvent(p27, Events.DidFocus, p28)
end
function v6._emitDidBlur(p29, p30, p31) -- line: 321
	-- upvalues: Events (copy)
	if p30 ~= p29._lastWillBlurKey or p30 == p29._lastDidBlurKey then
		return
	end

	p29._lastDidBlurKey = p30
	p29.props.onEvent(p30, Events.DidBlur, p31)
end
function v6.render(_) -- line: 333
	return nil
end

return v6
