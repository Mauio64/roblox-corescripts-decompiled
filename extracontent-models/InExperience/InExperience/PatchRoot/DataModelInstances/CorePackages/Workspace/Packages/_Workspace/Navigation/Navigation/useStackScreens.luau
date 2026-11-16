local parent = script.Parent.Parent
local React = require(parent.React)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local RoactNavigation = require(parent.RoactNavigation)
local StackActions = RoactNavigation.StackActions

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDerivedStackAndSwitchState = SharedFlags.FFlagLuaAppDerivedStackAndSwitchState

local ViewState = require(script.Parent.ViewState)

require(script.Parent.types)

local _ = {
	SetCurrent = "SetCurrent",
	SetOpening = "SetOpening",
	SetOpened = "SetOpened",
	SetClosing = "SetClosing",
	SetClosed = "SetClosed"
}
local function RouteViewStatesReducer(list, data)
	local index = Array.findIndex(list, function(p): boolean
		return p.descriptor.key == data.key
	end)

	if data.type == "SetCurrent" then
		for _, route in data.navigationState.routes do
			list = RouteViewStatesReducer(list, {
				type = "SetOpening",
				key = route.key,
				descriptor = data.descriptors[route.key]
			})
		end

		for _, item in list do
			if data.descriptors[item.descriptor.key] == nil then
				list = RouteViewStatesReducer(list, {
					type = "SetClosing",
					key = item.descriptor.key
				})
			end
		end

		return list
	elseif data.type == "SetOpening" then
		if index == -1 then
			local clone = table.clone(list)
			table.insert(clone, { viewState = ViewState.Opening, descriptor = data.descriptor })
			return clone
		elseif list[index].viewState == ViewState.Closing then
			local clone = table.clone(list)
			clone[index] = Object.assign({}, clone[index], {
				viewState = ViewState.Opening,
				descriptor = data.descriptor
			})
			return clone
		else
			if list[index].descriptor == data.descriptor then
				return list
			end

			local clone = table.clone(list)
			clone[index] = Object.assign({}, clone[index], { descriptor = data.descriptor })
			return clone
		end
	elseif data.type == "SetOpened" then
		if index == -1 or list[index].viewState ~= ViewState.Opening then
			return list
		end

		local clone = table.clone(list)
		clone[index] = Object.assign({}, clone[index], { viewState = ViewState.Opened })
		return clone
	elseif data.type == "SetClosing" then
		if index == -1 or list[index].viewState == ViewState.Closing then
			return list
		end

		local clone = table.clone(list)
		clone[index] = Object.assign({}, clone[index], { viewState = ViewState.Closing })
		return clone
	else
		if data.type == "SetClosed" and index ~= -1 and list[index].viewState == ViewState.Closing then
			list = table.clone(list)
			table.remove(list, index)
		end

		return list
	end
end

local function useStackScreens(p)
	local navigation = p.navigation
	local state = navigation.state
	local descriptors = p.descriptors

	local v, v2 = React.useReducer(RouteViewStatesReducer, {})

	if FFlagLuaAppDerivedStackAndSwitchState then
		React.useMemo(function()
			v2({ type = "SetCurrent", navigationState = state, descriptors = descriptors })
		end, { state, descriptors })
	else
		React.useLayoutEffect(function()
			v2({ type = "SetCurrent", navigationState = state, descriptors = descriptors })
		end, { state, descriptors })
	end

	local v3 = React.useCallback(function(toChildKey: string)
		if navigation.state.isTransitioning then
			navigation.dispatch(StackActions.completeTransition({
				key = navigation.state.key,
				toChildKey = toChildKey
			}))
		end
	end, { navigation })

	local v4 = React.useCallback(function(p2)
		v2({ type = "SetOpened", key = p2.descriptor.key })

		v3(p2.descriptor.key)
	end, { v3 })

	local v5 = React.useCallback(function(p2)
		v2({ type = "SetClosed", key = p2.descriptor.key })
	end, {})

	return (React.useMemo(function()
		return Array.map(v, function(p2)
			return Object.assign({}, p2, {
				setOpened = function()
					v4(p2)
				end,
				setClosed = function()
					v5(p2)
				end
			})
		end)
	end, { v, v4, v5 }))
end

return useStackScreens
