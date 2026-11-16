local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local v = {
	registered = function(p, p2)
		local v = p[p2.name] or {}

		for _, v2 in v do
			if v2 == p2.guiObject then
				return p
			end
		end

		local clone = table.clone(p)
		local clone2 = table.clone(v)
		table.insert(clone2, p2.guiObject)
		clone[p2.name] = clone2
		return clone
	end,
	deRegistered = function(p, p2)
		local v = p[p2.name]

		if not v or #v == 0 then
			return p
		end

		local v2 = {}

		for _, v3 in v do
			if v3 ~= p2.guiObject then
				table.insert(v2, v3)
			end
		end

		local clone = table.clone(p)

		if #v2 == 0 then
			clone[p2.name] = nil
			return clone
		end

		clone[p2.name] = v2

		return clone
	end
}

local function registryReducer(p, p2)
	local v2 = v[p2.type]

	if v2 then
		return v2(p, p2.payload)
	end

	error("Unknown action: " .. p2.type)
end

local context = React.createContext(nil)
local function FocusNavigableSurfaceRegistryProvider(p)
	local state, dispatch = React.useReducer(registryReducer, {})
	return React.createElement(context.Provider, {
		value = { state = state, dispatch = dispatch }
	}, p.children)
end

local function useRegistryEntry(p: string) -- 1 equivalent call inferred from this helper
	local v2 = React.useContext(context)

	if v2 == nil then
		return nil
	end

	local v3 = v2.state[p]

	if v3 == nil or #v3 == 0 then
		return nil
	end

	return v3[#v3]
end

local FocusNavigableSurfaceRegistry = {}
FocusNavigableSurfaceRegistry.Provider = FocusNavigableSurfaceRegistryProvider
FocusNavigableSurfaceRegistry.registryContext = context

function FocusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface()
	local v2 = React.useContext(context)
	local dispatch

	if v2 then
		dispatch = v2.dispatch
	else
		dispatch = nil
	end

	return React.useCallback(function(name: string, guiObject)
		if dispatch then
			dispatch({
				type = "registered",
				payload = { name = name, guiObject = guiObject }
			})
		end
	end, { dispatch })
end

function FocusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface()
	local v2 = React.useContext(context)
	local dispatch

	if v2 then
		dispatch = v2.dispatch
	else
		dispatch = nil
	end

	return React.useCallback(function(name: string, guiObject)
		if dispatch then
			dispatch({
				type = "deRegistered",
				payload = { name = name, guiObject = guiObject }
			})
		end
	end, { dispatch })
end

FocusNavigableSurfaceRegistry.useRegistryEntry = useRegistryEntry

function FocusNavigableSurfaceRegistry.useRegistryEntries(p: string)
	local v2 = React.useContext(context)

	if v2 == nil then
		return nil
	end

	return v2.state[p]
end

function FocusNavigableSurfaceRegistry.useFocusRegistryEntry(p: string)
	local v2 = useFocusGuiObject()
	local v3 = useRegistryEntry(p) -- inferred equivalent call
	return React.useCallback(function()
		if v3 then
			v2(v3)
		end
	end, { v2, v3 })
end

return FocusNavigableSurfaceRegistry
