local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local useFocusGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ReactFocusNavigation").useFocusGuiObject

local v5 = {
	registered = function(p2, p3)
		local v6 = p2[p3.name] or {}

		for k, v7 in v6 do
			if v7 == p3.guiObject then
				return p2
			end
		end

		local clone = table.clone(p2)
		local clone2 = table.clone(v6)
		table.insert(clone2, p3.guiObject)
		clone[p3.name] = clone2
		return clone
	end,
	deRegistered = function(p2, p3)
		local v6 = p2[p3.name]

		if not v6 or #v6 == 0 then
			return p2
		end

		local v7 = {}

		for k, v8 in v6 do
			if v8 ~= p3.guiObject then
				table.insert(v7, v8)
			end
		end

		local clone = table.clone(p2)

		if #v7 == 0 then
			clone[p3.name] = nil
			return clone
		end

		clone[p3.name] = v7

		return clone
	end
}

local function registryReducer(p2, p3)
	local v6 = v5[p3.type]

	if v6 then
		return v6(p2, p3.payload)
	end

	error("Unknown action: " .. p3.type)
end

local context = React.createContext(nil)
local function FocusNavigableSurfaceRegistryProvider(p2)
	local v6, v7 = React.useReducer(registryReducer, {})
	return React.createElement(context.Provider, {
		value = { state = v6, dispatch = v7 }
	}, p2.children)
end

return {
	Provider = FocusNavigableSurfaceRegistryProvider,
	registryContext = context,
	useRegisterFocusNavigableSurface = function()
		local v6 = React.useContext(context)
		local dispatch = if v6 then v6.dispatch else nil
		return React.useCallback(function(p2, p3)
			if dispatch then
				dispatch({
					type = "registered",
					payload = { name = p2, guiObject = p3 }
				})
			end
		end, { dispatch })
	end,
	useDeRegisterFocusNavigableSurface = function()
		local v6 = React.useContext(context)
		local dispatch = if v6 then v6.dispatch else nil
		return React.useCallback(function(p2, p3)
			if dispatch then
				dispatch({
					type = "deRegistered",
					payload = { name = p2, guiObject = p3 }
				})
			end
		end, { dispatch })
	end,
	useRegistryEntry = function(p2)
		local v6 = React.useContext(context)

		if v6 == nil then
			return nil
		end

		local v7 = v6.state[p2]

		if v7 == nil or #v7 == 0 then
			return nil
		end

		return v7[#v7]
	end,
	useRegistryEntries = function(p2)
		local v6 = React.useContext(context)

		if v6 == nil then
			return nil
		end

		return v6.state[p2]
	end,
	useFocusRegistryEntry = function(p2)
		local v6 = useFocusGuiObject()
		local v7 = React.useContext(context)
		local v8

		if v7 == nil then
			v8 = nil
		else
			local v9 = v7.state[p2]

			v8 = if not (v9 == nil or #v9 == 0) then v9[#v9] else nil
		end

		return React.useCallback(function()
			if v8 then
				v6(v8)
			end
		end, { v6, v8 })
	end
}
