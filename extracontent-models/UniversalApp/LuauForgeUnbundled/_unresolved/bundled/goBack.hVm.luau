require("@luauforge/bundled/hUX")

local function focusedChild(p2)
	local state = p2.getState(false)
	local route = state.routes[state.index]

	if route == nil then
		return nil
	end

	return p2.children[route.key]
end

local function popStack(data): boolean
	local state = data.getState(false)

	if state.index <= 1 then
		return false
	end

	local v5 = state.index - 1
	local v6 = {}

	for i = 1, v5 do
		table.insert(v6, state.routes[i])
	end

	for i = v5 + 1, #state.routes do
		data.children[state.routes[i].key] = nil
	end

	data.setState(table.freeze({ index = v5, routes = table.freeze(v6) }))

	return true
end

local function goBack(data)
	local state = data.getState(false)
	local route = state.routes[state.index]

	local v5 = if route ~= nil then data.children[route.key] else nil

	if v5 ~= nil and v5.navigator.back() then
		return true
	end

	if data.navigator.type == "stack" then
		return popStack(data)
	end

	return false
end

return goBack
