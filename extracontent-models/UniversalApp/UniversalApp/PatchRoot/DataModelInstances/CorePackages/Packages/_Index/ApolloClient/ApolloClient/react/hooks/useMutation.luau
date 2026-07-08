local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Object = require(ParentParentParent.LuauPolyfill).Object

require(script.Parent.Parent.Parent.core)

local React = require(ParentParentParent.React)
local useContext = React.useContext
local useState = React.useState
local useRef = React.useRef
local useEffect = React.useEffect

require(ParentParentParent.GraphQL)
require(ParentParent.jsutils.typedDocumentNode)
require(script.Parent.Parent.types.types)

local MutationData = require(script.Parent.Parent.data).MutationData
local getApolloContext = require(script.Parent.Parent.context).getApolloContext

function t1.useMutation(p1, p2) -- line: 40
	-- upvalues: useContext (copy), getApolloContext (copy), useState (copy), Object (copy), useRef (copy), MutationData (copy), useEffect (copy)
	local v14 = useContext(getApolloContext())
	local v15, v16 = useState({
		called = false,
		loading = false
	})
	local v17 = if not p2 then {
		mutation = p1
	} else Object.assign({}, p2, {
		mutation = p1
	})
	local v18 = useRef(nil)

	local function getMutationDataRef() -- line: 52
		-- upvalues: v18 (copy), MutationData (copy), v17 (copy), v14 (copy), v15 (copy), v16 (copy)
		if not v18.current then
			v18.current = MutationData.new({
				options = v17,
				context = v14,
				result = v15,
				setResult = function(_, p4) -- line: 58
					-- upvalues: v16 (copy)
					v16(p4)

					return nil
				end
			})
		end

		return v18.current
	end

	local v20 = getMutationDataRef()

	v20:setOptions(v17)
	v20.context = v14
	useEffect(function() -- line: 72
		-- upvalues: v20 (copy)
		return v20:afterExecute()
	end)

	return v20:execute(v15)
end

return t1
