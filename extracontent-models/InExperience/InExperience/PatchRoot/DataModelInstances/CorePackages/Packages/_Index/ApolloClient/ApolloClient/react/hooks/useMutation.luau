local UseMutation = {}

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

require(script.Parent.Parent.Parent.core)

local React = require(parent2.React)
local useContext = React.useContext
local useState = React.useState
local useRef = React.useRef
local useEffect = React.useEffect
require(parent2.GraphQL)

require(parent.jsutils.typedDocumentNode)

require(script.Parent.Parent.types.types)

local data = require(script.Parent.Parent.data)
local mutationData = data.MutationData

local context = require(script.Parent.Parent.context)
local getApolloContext = context.getApolloContext

function UseMutation.useMutation(mutation, p)
	local context2 = useContext(getApolloContext())
	local state, setState = useState({ called = false, loading = false })

	local options = not p and { mutation = mutation } or Object.assign({}, p, {
		mutation = mutation
	})

	local v = useRef(nil)
	local function getMutationDataRef()
		if not v.current then
			v.current = mutationData.new({
				options = options,
				context = context2,
				result = state,
				setResult = function(_, p2): nil
					setState(p2)
					return nil
				end
			})
		end

		return v.current
	end

	local mutationDataRef = getMutationDataRef()
	mutationDataRef:setOptions(options)
	mutationDataRef.context = context2

	useEffect(function()
		return mutationDataRef:afterExecute()
	end)

	return mutationDataRef:execute(state)
end

return UseMutation
