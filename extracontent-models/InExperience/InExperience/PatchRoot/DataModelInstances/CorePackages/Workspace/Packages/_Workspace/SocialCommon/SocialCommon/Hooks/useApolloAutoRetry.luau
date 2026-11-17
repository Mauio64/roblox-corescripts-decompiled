local parent = script:FindFirstAncestor("SocialCommon").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local config = LuaSocialLibrariesDeps.SocialLibraries.config({})
local StatusCodesToRetry = require(script.Parent.StatusCodesToRetry)

local function shouldRetryRequest(object) -- 2 equivalent calls inferred from this helper
	if not object.error then
		return false
	end

	local deepValue = config.Dictionary.getDeepValue(object, "error.graphQLErrors")

	if deepValue and deepValue[1] then
		return StatusCodesToRetry[config.Dictionary.getDeepValue(deepValue[1], "extensions.status")] or false
	end

	return false
end

local function useApolloAutoRetry(object, p)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(false)

	React.useEffect(function()
		if shouldRetryRequest(object) and state < p.retryCount and not state2 then -- inferred equivalent call
			setState2(true)

			task.delay(2 ^ state + math.random(), function()
				object:refetch()
				setState2(false)
				setState(state + 1)
			end)
		end
	end, { object, state2, state })

	return (React.useMemo(function()
		return Cryo.Dictionary.join(object, {
			isRetrying = shouldRetryRequest(object) and state < p.retryCount, -- inferred equivalent call
			retryCount = state
		})
	end, { object, state }))
end

return useApolloAutoRetry
