local UseBaseQuery = {}
local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Promise = require(parent2.Promise)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local React = require(parent2.React)
local useContext = React.useContext
local useEffect = React.useEffect
local useReducer = React.useReducer
local useRef = React.useRef

require(parent2.GraphQL)

require(parent.jsutils.typedDocumentNode)

require(script.Parent.Parent.Parent.types.types)

local data = require(script.Parent.Parent.Parent.data)
local queryData = data.QueryData

local useDeepMemo = require(script.Parent.useDeepMemo)
local useDeepMemo2 = useDeepMemo.useDeepMemo
require(script.Parent.Parent.Parent.Parent.core)

local context = require(script.Parent.Parent.Parent.context)
local getApolloContext = context.getApolloContext

local useAfterFastRefresh = require(script.Parent.useAfterFastRefresh)
local useAfterFastRefresh2 = useAfterFastRefresh.useAfterFastRefresh

local v = { __value = "nil placeholder" }

function UseBaseQuery.useBaseQuery(query, p, lazy: boolean?)
	if lazy == nil then
		lazy = false
	end

	local context2 = useContext(getApolloContext())

	local tick, v2 = useReducer(function(p2: number)
		return p2 + 1
	end, 0)

	local options = Boolean.toJSBoolean(p) and Object.assign({}, p, { query = query }) or {
		query = query
	}
	local v3 = useRef(nil)
	local v4 = nil
	local current = v3.current

	if not current then
		v3.current = queryData.new({
			options = options,
			context = context2,
			onNewData = function(_)
				if Boolean.toJSBoolean(v4:ssrInitiated()) then
					v2(nil)
				else
					Promise.delay(0):andThen(function()
						if v3.current == nil or not v3.current.isMounted then
							return
						end

						return v2(nil)
					end)
				end
			end
		})

		current = v3.current
	end

	v4 = current

	v4:setOptions(options)
	v4.context = context2

	local v5 = {
		options = Object.assign({}, options, { onError = Object.None, onCompleted = Object.None }),
		context = context2,
		tick = tick
	}

	local v6 = useDeepMemo2(function()
		if lazy then
			return v4:executeLazy()
		end

		return v4:execute()
	end, v5)

	local v7 = if lazy then v6[2] else v6

	if _G.__DEV__ then
		useAfterFastRefresh2(v2)
	end

	useEffect(function()
		return function()
			v4:cleanup()

			v3.current = nil
		end
	end, {})

	useEffect(function()
		return v4:afterExecute({ lazy = lazy })
	end, {
		v7.loading ~= nil and v7.loading or v,
		v7.networkStatus ~= nil and v7.networkStatus or v,
		v7.error ~= nil and v7.error or v,
		v7.data ~= nil and v7.data or v
	})

	return v6
end
return UseBaseQuery
