local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewContext = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewContext)
local Signals = require(ViewRecyclerReact.Parent.Signals)

local function initialize(callback) -- 6 equivalent calls inferred from this helper
	if type(callback) == "function" then
		return (callback())
	end

	return callback
end

local function useRecyclableViewContext() -- 5 equivalent calls inferred from this helper
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

local function sameValues(values, list): boolean -- 5 equivalent calls inferred from this helper
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

local useRecyclingDependencies
local readValues
local useRecyclingToken

if FFlagViewRecyclerReact084 then
	useRecyclingDependencies = function(options)
		local result = table.create(#(options or {}) + 1)
		result[1] = useRecyclableViewContext().itemKeySignal -- inferred equivalent call

		if options ~= nil then
			for _, option in options do
				table.insert(result, option)
			end
		end

		return result
	end

	readValues = function(list, p)
		local values = table.create(#list)

		for k, item in list do
			values[k] = item(p)
		end

		return values
	end
else
	useRecyclingToken = function(options)
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
end

function v.useRecyclingState(initialState, p, current)
	local v2 = nil
	local v3 = nil
	local v4 = nil

	if FFlagViewRecyclerReact084 then
		v2 = useRecyclingDependencies(p)
		v3 = readValues(v2, false)
	else
		v4 = useRecyclingToken(p)
	end

	local state, setState = React.useState(function()
		local v5 = {
			token = FFlagViewRecyclerReact084 and {} or v4,
			values = 0,
			value = 0
		}
		local values

		if FFlagViewRecyclerReact084 then
			values = v3
		end

		v5.values = values
		v5.value = initialize(initialState) -- inferred equivalent call
		return v5
	end)
	local v5

	if FFlagViewRecyclerReact084 then
		v5 = not sameValues(state.values, v3) -- inferred equivalent call
	else
		v5 = not (state.token == v4)
	end

	if v5 then
		state = {
			token = FFlagViewRecyclerReact084 and {} or v4,
			values = 0,
			value = 0
		}
		local values

		if FFlagViewRecyclerReact084 then
			values = v3
		end

		state.values = values
		state.value = initialize(initialState) -- inferred equivalent call
		setState(state)
	end

	local ref

	if FFlagViewRecyclerReact084 then
		ref = React.useRef({ initialState = initialState, resetCallback = current })
		React.useLayoutEffect(function()
			ref.current = { initialState = initialState, resetCallback = current }
		end)
		React.useLayoutEffect(function()
			return Signals.createEffect(function(p2)
				local values = readValues(v2, p2)
				setState(function(p3)
					if sameValues(p3.values, values) then -- inferred equivalent call
						return p3
					end

					return {
						token = {},
						values = values,
						value = initialize(ref.current.initialState) -- inferred equivalent call
					}
				end)
			end)
		end, v2)

		v4 = state.token
	else
		ref = nil
	end

	local ref2 = React.useRef(false)
	local ref3

	if FFlagViewRecyclerReact084 then
		ref3 = nil
	else
		ref3 = React.useRef(current)
	end

	local useLayoutEffect = React.useLayoutEffect
	local function fn()
		if FFlagViewRecyclerReact084 then
			if not ref2.current then
				ref2.current = true
				return
			end

			local resetCallback = ref.current.resetCallback

			if resetCallback ~= nil then
				resetCallback()
			end
		else
			ref3.current = current
		end
	end

	local v6 = if FFlagViewRecyclerReact084 then v4 else current
	useLayoutEffect(fn, { v6 })
	local v7

	if FFlagViewRecyclerReact084 then
		v7 = nil
	else
		React.useLayoutEffect(function()
			if ref2.current then
				local current2 = ref3.current

				if current2 ~= nil then
					current2()
				end
			else
				ref2.current = true
			end
		end, { v4 })

		v7 = v4
	end

	local useCallback = React.useCallback
	local function fn2(callback)
		setState(function(data)
			local token = data.token
			local v8 = if FFlagViewRecyclerReact084 then v4 else v7

			if token ~= v8 then
				return data
			end

			local v9

			if type(callback) == "function" then
				v9 = callback(data.value)
			else
				v9 = callback
			end

			local v10 = { token = data.token, values = 0, value = 0 }
			local values

			if FFlagViewRecyclerReact084 then
				values = data.values
			end

			v10.values = values
			v10.value = v9
			return v10
		end)
	end

	local v8 = if FFlagViewRecyclerReact084 then v4 else v7
	local v9 = useCallback(fn2, { v8 })
	return state.value, v9
end

function v.useRecyclingSignal(initialState, p, callback)
	local v2 = nil
	local committedToken = nil

	if FFlagViewRecyclerReact084 then
		v2 = useRecyclingDependencies(p)
	else
		committedToken = useRecyclingToken(p)
	end

	local v3 = React.useState(function()
		local signal, setter = Signals.createSignal(initialize(initialState)) -- inferred equivalent call
		local values

		if FFlagViewRecyclerReact084 then
			values = readValues(v2, false)
		end

		local v3 = {
			getter = signal,
			setter = setter,
			values = values,
			unmounted = not FFlagViewRecyclerReact084 and nil,
			committedToken = nil
		}
		local committedToken2

		if not FFlagViewRecyclerReact084 then
			committedToken2 = committedToken
		end

		v3.committedToken = committedToken2
		return v3
	end)

	local ref = nil
	local ref2 = nil
	local v4 = nil

	if FFlagViewRecyclerReact084 then
		ref = React.useRef({ initialState = initialState, resetCallback = callback })
		React.useLayoutEffect(function()
			ref.current = { initialState = initialState, resetCallback = callback }
		end)
		React.useLayoutEffect(function()
			v3.unmounted = false
			return function()
				v3.unmounted = true
			end
		end, { v3 })
		React.useLayoutEffect(function()
			return Signals.createEffect(function(p2)
				local values = readValues(v2, p2)

				if sameValues(v3.values, values) then -- inferred equivalent call
					return
				end

				v3.values = values
				v3.setter(initialize(ref.current.initialState)) -- inferred equivalent call
				local resetCallback = ref.current.resetCallback

				if resetCallback ~= nil then
					resetCallback()
				end
			end)
		end, v2)
	else
		ref2 = React.useRef(false)
		React.useLayoutEffect(function()
			if ref2.current then
				v3.committedToken = committedToken
				v3.setter(initialize(initialState)) -- inferred equivalent call

				if callback ~= nil then
					callback()
				end
			else
				ref2.current = true
			end
		end, { committedToken })

		v4 = committedToken
	end

	local v5 = React.useCallback(function(p2)
		local v5

		if FFlagViewRecyclerReact084 then
			v5 = not v3.unmounted
		else
			v5 = v3.committedToken == v4
		end

		if v5 then
			v3.setter(p2)
		end
	end, FFlagViewRecyclerReact084 and { v3 } or { v4, v3 })
	return v3.getter, v5
end

return table.freeze(v)
