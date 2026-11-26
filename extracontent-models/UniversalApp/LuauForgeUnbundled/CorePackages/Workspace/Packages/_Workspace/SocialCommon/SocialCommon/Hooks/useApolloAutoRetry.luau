local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Cryo")
local config = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/LuaSocialLibrariesDeps").SocialLibraries.config({})
local StatusCodesToRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Hooks/StatusCodesToRetry")

local function shouldRetryRequest(p2)
	if not p2.error then
		return false
	end

	local deepValue = config.Dictionary.getDeepValue(p2, "error.graphQLErrors")

	if deepValue and deepValue[1] then
		return StatusCodesToRetry[config.Dictionary.getDeepValue(deepValue[1], "extensions.status")] or false
	end

	return false
end

local function useApolloAutoRetry(object, p2)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(false)

	React.useEffect(function()
		local v5 = object
		local v6

		if v5.error then
			local deepValue = config.Dictionary.getDeepValue(v5, "error.graphQLErrors")

			if deepValue and deepValue[1] then
				v6 = StatusCodesToRetry[config.Dictionary.getDeepValue(deepValue[1], "extensions.status")] or false
			else
				v6 = false
			end
		else
			v6 = false
		end

		if v6 and state < p2.retryCount and not state2 then
			setState2(true)

			task.delay(2 ^ state + math.random(), function()
				object:refetch()
				setState2(false)
				setState(state + 1)
			end)
		end
	end, { object, state2, state })

	return (React.useMemo(function()
		local join = Cryo.Dictionary.join
		local v7 = object
		local v8

		if v7.error then
			local deepValue = config.Dictionary.getDeepValue(v7, "error.graphQLErrors")

			if deepValue and deepValue[1] then
				v8 = StatusCodesToRetry[config.Dictionary.getDeepValue(deepValue[1], "extensions.status")] or false
			else
				v8 = false
			end
		else
			v8 = false
		end

		return join(object, {
			isRetrying = v8 and state < p2.retryCount,
			retryCount = state
		})
	end, { object, state }))
end

return useApolloAutoRetry
