local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewContext = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewContext)
local Signals = require(ViewRecyclerReact.Parent.Signals)

local function initialize(callback) -- 4 equivalent calls inferred from this helper
	if type(callback) == "function" then
		return (callback())
	end

	return callback
end

local function useRecyclableViewContext() -- 4 equivalent calls inferred from this helper
	local v = React.useContext(RecyclableViewContext)
	assert(type(v) == "table", "Recycling hooks must be called within a Recyclable view")
	return v
end

local v = {}

function v.useRecyclingItem()
	return useRecyclableViewContext().itemSignal -- inferred equivalent call
end

function v.useRecyclingAssignment()
	return useRecyclableViewContext().assignmentSignal -- inferred equivalent call
end

function v.useRecyclingIndex()
	return useRecyclableViewContext().indexSignal -- inferred equivalent call
end

local function sameValues(values, list): boolean -- 2 equivalent calls inferred from this helper
	if #values ~= #list then
		return false
	end

	for k, item in list do
		if values[k] ~= item then
			return false
		end
	end

	return true
end

local function useRecyclingToken(options)
	local itemKeySignal = useRecyclableViewContext().itemKeySignal -- inferred equivalent call
	local v2 = table.create(#(options or {}) + 1)
	v2[1] = itemKeySignal

	if options ~= nil then
		for _, option in options do
			table.insert(v2, option)
		end
	end

	local values = table.create(#v2)

	for k, v3 in v2 do
		values[k] = v3(false)
	end

	local state, setState = React.useState(function()
		return { token = {}, values = values }
	end)

	if not sameValues(state.values, values) then -- inferred equivalent call
		state = { token = {}, values = values }

		setState(state)
	end

	React.useLayoutEffect(function()
		return Signals.createEffect(function(p)
			local values2 = table.create(#v2)

			for k, v3 in v2 do
				values2[k] = v3(p)
			end

			setState(function(p2)
				if sameValues(p2.values, values2) then -- inferred equivalent call
					return p2
				end

				return { token = {}, values = values2 }
			end)
		end)
	end, v2)

	return state.token
end

function v.useRecyclingState(callback, p, current)
	local token = useRecyclingToken(p)
	local state, setState = React.useState(function()
		return { token = token, value = initialize(callback) } -- inferred equivalent call
	end)

	if state.token ~= token then
		state = { token = token, value = 0 }
		state.value = initialize(callback) -- inferred equivalent call
		setState(state)
	end

	local ref = React.useRef(false)
	local ref2 = React.useRef(current)
	React.useLayoutEffect(function()
		ref2.current = current
	end, { current })
	React.useLayoutEffect(function()
		if ref.current then
			local current2 = ref2.current

			if current2 ~= nil then
				current2()
			end
		else
			ref.current = true
		end
	end, { token })

	local v2 = React.useCallback(function(callback2)
		setState(function(p2)
			if p2.token ~= token then
				return p2
			end

			local v2

			if type(callback2) == "function" then
				v2 = callback2(p2.value)
			else
				v2 = callback2
			end

			return { token = p2.token, value = v2 }
		end)
	end, { token })
	return state.value, v2
end

function v.useRecyclingSignal(callback, p, callback2)
	local committedToken = useRecyclingToken(p)
	local v2 = React.useState(function()
		local signal, setter = Signals.createSignal(initialize(callback)) -- inferred equivalent call
		return { getter = signal, setter = setter, committedToken = committedToken }
	end)

	local ref = React.useRef(false)
	React.useLayoutEffect(function()
		if ref.current then
			v2.committedToken = committedToken
			v2.setter(initialize(callback)) -- inferred equivalent call

			if callback2 ~= nil then
				callback2()
			end
		else
			ref.current = true
		end
	end, { committedToken })

	local v3 = React.useCallback(function(p2)
		if v2.committedToken == committedToken then
			v2.setter(p2)
		end
	end, { committedToken, v2 })
	return v2.getter, v3
end

return table.freeze(v)
