local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/React")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/LuauPolyfill")
local array = LuauPolyfill.Array
local object = LuauPolyfill.Object
local stackActions = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/RoactNavigation").StackActions

local fFlagLuaAppDerivedStackAndSwitchState = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/SharedFlags").FFlagLuaAppDerivedStackAndSwitchState

local ViewState = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/ViewState")

require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

local v5 = {
	SetCurrent = "SetCurrent",
	SetOpening = "SetOpening",
	SetOpened = "SetOpened",
	SetClosing = "SetClosing",
	SetClosed = "SetClosed"
}
local function RouteViewStatesReducer(list, data)
	local index = array.findIndex(list, function(p2): boolean
		return p2.descriptor.key == data.key
	end)

	if data.type == "SetCurrent" then
		for k, route in data.navigationState.routes do
			list = RouteViewStatesReducer(list, {
				type = "SetOpening",
				key = route.key,
				descriptor = data.descriptors[route.key]
			})
		end

		for k, item in list do
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
			table.insert(clone, {
				viewState = ViewState.Opening,
				descriptor = data.descriptor
			})
			return clone
		elseif list[index].viewState == ViewState.Closing then
			local clone = table.clone(list)
			clone[index] = object.assign({}, clone[index], {
				viewState = ViewState.Opening,
				descriptor = data.descriptor
			})
			return clone
		else
			if list[index].descriptor == data.descriptor then
				return list
			end

			local clone = table.clone(list)
			clone[index] = object.assign({}, clone[index], {
				descriptor = data.descriptor
			})
			return clone
		end
	elseif data.type == "SetOpened" then
		if index == -1 or list[index].viewState ~= ViewState.Opening then
			return list
		end

		local clone = table.clone(list)
		clone[index] = object.assign({}, clone[index], { viewState = ViewState.Opened })
		return clone
	elseif data.type == "SetClosing" then
		if index == -1 or list[index].viewState == ViewState.Closing then
			return list
		end

		local clone = table.clone(list)
		clone[index] = object.assign({}, clone[index], { viewState = ViewState.Closing })
		return clone
	else
		if data.type == "SetClosed" and index ~= -1 and list[index].viewState == ViewState.Closing then
			list = table.clone(list)
			table.remove(list, index)
		end

		return list
	end
end

local function useStackScreens(p2)
	local navigation = p2.navigation
	local state = navigation.state
	local descriptors = p2.descriptors

	local v6, v7 = React.useReducer(RouteViewStatesReducer, {})

	if fFlagLuaAppDerivedStackAndSwitchState then
		React.useMemo(function()
			v7({
				type = "SetCurrent",
				navigationState = state,
				descriptors = descriptors
			})
		end, { state, descriptors })
	else
		React.useLayoutEffect(function()
			v7({
				type = "SetCurrent",
				navigationState = state,
				descriptors = descriptors
			})
		end, { state, descriptors })
	end

	local v8 = React.useCallback(function(p3)
		if navigation.state.isTransitioning then
			navigation.dispatch(stackActions.completeTransition({
				key = navigation.state.key,
				toChildKey = p3
			}))
		end
	end, { navigation })

	local v9 = React.useCallback(function(p3)
		v7({ type = "SetOpened", key = p3.descriptor.key })

		v8(p3.descriptor.key)
	end, { v8 })

	local v10 = React.useCallback(function(p3)
		v7({ type = "SetClosed", key = p3.descriptor.key })
	end, {})

	return (React.useMemo(function()
		return array.map(v6, function(p3)
			return object.assign({}, p3, {
				setOpened = function()
					v9(p3)
				end,
				setClosed = function()
					v10(p3)
				end
			})
		end)
	end, { v6, v9, v10 }))
end

return useStackScreens
