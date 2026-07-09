local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local StackActions = require(ParentParent.RoactNavigation).StackActions
local FFlagLuaAppDerivedStackAndSwitchState = require(ParentParent.SharedFlags).FFlagLuaAppDerivedStackAndSwitchState
local ViewState = require(script.Parent.ViewState)

require(script.Parent.types)

local _ = {
	SetCurrent = "SetCurrent",
	SetOpening = "SetOpening",
	SetOpened = "SetOpened",
	SetClosing = "SetClosing",
	SetClosed = "SetClosed"
}

local function RouteViewStatesReducer(t1: {[any]: any}, p1) -- line: 73
	-- upvalues: Array (copy), RouteViewStatesReducer (copy), ViewState (copy), Object (copy)
	local v14 = Array.findIndex(t1, function(p2) -- line: 74
		-- upvalues: p1 (copy)
		return p2.descriptor.key == p1.key
	end)

	if p1.type == "SetCurrent" then
		for _, v16 in p1.navigationState.routes do
			t1 = RouteViewStatesReducer(t1, {
				type = "SetOpening",
				key = v16.key,
				descriptor = p1.descriptors[v16.key]
			})
		end

		for _, v18 in t1 do
			if p1.descriptors[v18.descriptor.key] == nil then
				t1 = RouteViewStatesReducer(t1, {
					type = "SetClosing",
					key = v18.descriptor.key
				})
			end
		end

		return t1
	end

	if p1.type == "SetOpening" then
		if v14 == -1 then
			local v19 = table.clone(t1)

			table.insert(v19, {
				viewState = ViewState.Opening,
				descriptor = p1.descriptor
			})

			return v19
		end

		if t1[v14].viewState == ViewState.Closing then
			local v20 = table.clone(t1)

			v20[v14] = Object.assign({}, v20[v14], {
				viewState = ViewState.Opening,
				descriptor = p1.descriptor
			})

			return v20
		end

		if t1[v14].descriptor ~= p1.descriptor then
			local v21 = table.clone(t1)

			v21[v14] = Object.assign({}, v21[v14], {
				descriptor = p1.descriptor
			})

			return v21
		end
	elseif p1.type == "SetOpened" then
		if v14 ~= -1 and t1[v14].viewState == ViewState.Opening then
			local v22 = table.clone(t1)

			v22[v14] = Object.assign({}, v22[v14], {
				viewState = ViewState.Opened
			})

			return v22
		end
	elseif p1.type == "SetClosing" then
		if v14 ~= -1 and t1[v14].viewState ~= ViewState.Closing then
			local v23 = table.clone(t1)

			v23[v14] = Object.assign({}, v23[v14], {
				viewState = ViewState.Closing
			})

			return v23
		end
	elseif p1.type == "SetClosed" and v14 ~= -1 and t1[v14].viewState == ViewState.Closing then
		t1 = table.clone(t1)
		table.remove(t1, v14)
	end

	return t1
end
local function useStackScreens(t2: {[any]: any}) -- line: 147
	-- upvalues: React (copy), RouteViewStatesReducer (copy), FFlagLuaAppDerivedStackAndSwitchState (copy), StackActions (copy), Array (copy), Object (copy)
	local navigation = t2.navigation
	local state = navigation.state
	local descriptors = t2.descriptors
	local v28, v29 = React.useReducer(RouteViewStatesReducer, {})

	if FFlagLuaAppDerivedStackAndSwitchState then
		React.useMemo(function() -- line: 158
			-- upvalues: v29 (copy), state (copy), descriptors (copy)
			v29({
				type = "SetCurrent",
				navigationState = state,
				descriptors = descriptors
			})
		end, {
			state,
			descriptors
		})
	else
		React.useLayoutEffect(function() -- line: 166
			-- upvalues: v29 (copy), state (copy), descriptors (copy)
			v29({
				type = "SetCurrent",
				navigationState = state,
				descriptors = descriptors
			})
		end, {
			state,
			descriptors
		})
	end

	local v30 = React.useCallback(function(s1: string) -- line: 175
		-- upvalues: navigation (copy), StackActions (copy)
		if navigation.state.isTransitioning then
			navigation.dispatch(StackActions.completeTransition({
				key = navigation.state.key,
				toChildKey = s1
			}))
		end
	end, { navigation })
	local v31 = React.useCallback(function(t3: {[any]: any}) -- line: 184
		-- upvalues: v29 (copy), v30 (copy)
		v29({
			type = "SetOpened",
			key = t3.descriptor.key
		})
		v30(t3.descriptor.key)
	end, { v30 })
	local v32 = React.useCallback(function(t4: {[any]: any}) -- line: 192
		-- upvalues: v29 (copy)
		v29({
			type = "SetClosed",
			key = t4.descriptor.key
		})
	end, {})

	return (React.useMemo(function() -- line: 199
		-- upvalues: Array (copy), v28 (copy), Object (copy), v31 (copy), v32 (copy)
		return Array.map(v28, function(t5: {[any]: any}) -- line: 200
			-- upvalues: Object (copy), v31 (copy), v32 (copy)
			return Object.assign({}, t5, {
				setOpened = function() -- line: 202
					-- upvalues: v31 (copy), t5 (copy)
					v31(t5)
				end,
				setClosed = function() -- line: 205
					-- upvalues: v32 (copy), t5 (copy)
					v32(t5)
				end
			})
		end)
	end, {
		v28,
		v31,
		v32
	}))
end

return useStackScreens
