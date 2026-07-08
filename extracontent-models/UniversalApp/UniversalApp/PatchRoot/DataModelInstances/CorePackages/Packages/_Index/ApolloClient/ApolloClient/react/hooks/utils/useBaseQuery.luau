local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Promise = require(ParentParentParent.Promise)
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local React = require(ParentParentParent.React)
local useContext = React.useContext
local useEffect = React.useEffect
local useReducer = React.useReducer
local useRef = React.useRef

require(ParentParentParent.GraphQL)
require(ParentParent.jsutils.typedDocumentNode)
require(script.Parent.Parent.Parent.types.types)

local QueryData = require(script.Parent.Parent.Parent.data).QueryData
local useDeepMemo = require(script.Parent.useDeepMemo).useDeepMemo

require(script.Parent.Parent.Parent.Parent.core)

local getApolloContext = require(script.Parent.Parent.Parent.context).getApolloContext
local useAfterFastRefresh = require(script.Parent.useAfterFastRefresh).useAfterFastRefresh
local t2 = {
	__value = "nil placeholder"
}

function t1.useBaseQuery(p1, p2, b1: boolean?) -- line: 48
	-- upvalues: useContext (copy), getApolloContext (copy), useReducer (copy), Boolean (copy), Object (copy), useRef (copy), QueryData (copy), Promise (copy), useDeepMemo (copy), useAfterFastRefresh (copy), useEffect (copy), t2 (copy)
	if b1 == nil then
		b1 = false
	end

	local v22 = useContext(getApolloContext())
	local v23, v24 = useReducer(function(n1: number) -- line: 58
		return n1 + 1
	end, 0)
	local v25 = Boolean.toJSBoolean(p2) and Object.assign({}, p2, {
		query = p1
	}) or {
		query = p1
	}
	local v26 = useRef(nil)
	local u27 = nil

	u27 = v26.current or (function() -- line: 66
		-- upvalues: v26 (copy), QueryData (copy), v25 (copy), v22 (copy), Boolean (copy), u27 (ref), Promise (copy), v24 (copy)
		v26.current = QueryData.new({
			options = v25,
			context = v22,
			onNewData = function(_) -- line: 70
				-- upvalues: Boolean (copy), u27 (ref), Promise (copy), v26 (copy), v24 (copy)
				if not Boolean.toJSBoolean(u27:ssrInitiated()) then
					Promise.delay(0):andThen(function() -- line: 78
						-- upvalues: v26 (copy), v24 (copy)
						if v26.current ~= nil and v26.current.isMounted then
							return v24(nil)
						end
					end)

					return
				end

				v24(nil)
			end
		})

		return v26.current
	end)()
	u27:setOptions(v25)
	u27.context = v22

	local t3 = {
		options = Object.assign({}, v25, {
			onError = Object.None,
			onCompleted = Object.None
		}),
		context = v22,
		tick = v23
	}
	local v29 = useDeepMemo(function() -- line: 114
		-- upvalues: b1 (ref), u27 (ref)
		if b1 then
			return u27:executeLazy()
		end

		return u27:execute()
	end, t3)
	local v30 = if not b1 then v29 else v29[2]

	if _G.__DEV__ then
		useAfterFastRefresh(v24)
	end

	useEffect(function() -- line: 131
		-- upvalues: u27 (ref), v26 (copy)
		return function() -- line: 132
			-- upvalues: u27 (ref), v26 (copy)
			u27:cleanup()
			v26.current = nil
		end
	end, {})
	useEffect(function() -- line: 140
		-- upvalues: u27 (ref), b1 (ref)
		return u27:afterExecute({
			lazy = b1
		})
	end, {
		v30.loading ~= nil and v30.loading or t2,
		v30.networkStatus ~= nil and v30.networkStatus or t2,
		v30.error ~= nil and v30.error or t2,
		v30.data ~= nil and v30.data or t2
	})

	return v29
end

return t1
