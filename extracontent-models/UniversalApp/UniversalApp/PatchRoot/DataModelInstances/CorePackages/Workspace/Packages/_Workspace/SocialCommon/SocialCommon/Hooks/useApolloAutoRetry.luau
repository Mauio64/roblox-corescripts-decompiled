local Parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local v4 = require(Parent.LuaSocialLibrariesDeps).SocialLibraries.config({})
local StatusCodesToRetry = require(script.Parent.StatusCodesToRetry)

local function shouldRetryRequest(p1) -- line: 10
	-- upvalues: v4 (copy), StatusCodesToRetry (copy)
	if p1.error then
		local v9 = v4.Dictionary.getDeepValue(p1, "error.graphQLErrors")

		if v9 and v9[1] then
			return StatusCodesToRetry[v4.Dictionary.getDeepValue(v9[1], "extensions.status")] or false
		end
	end

	return false
end
local function useApolloAutoRetry(p2, t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), v4 (copy), StatusCodesToRetry (copy), Cryo (copy)
	local v12, v13 = React.useState(0)
	local v14, v15 = React.useState(false)

	React.useEffect(function() -- line: 26
		-- upvalues: p2 (copy), v4 (copy), StatusCodesToRetry (copy), v12 (copy), t1 (copy), v14 (copy), v15 (copy), v13 (copy)
		local v16 = p2
		local g17 = nil
		local v18 = nil
		local v19 = nil

		repeat
			if g17 or v16.error then
				if not g17 then
					v18 = v4.Dictionary.getDeepValue(v16, "error.graphQLErrors")
				end

				if g17 or v18 and v18[1] then
					if not g17 then
						v19 = StatusCodesToRetry[v4.Dictionary.getDeepValue(v18[1], "extensions.status")] or false
					end

					g17 = false

					if v19 and v12 < t1.retryCount and not v14 then
						v15(true)
						task.delay(2 ^ v12 + math.random(), function() -- line: 30
							-- upvalues: p2 (copy), v15 (copy), v13 (copy), v12 (copy)
							p2:refetch()
							v15(false)
							v13(v12 + 1)
						end)
					end

					return
				end
			end

			v19 = false
			g17 = true
		until not g17
	end, {
		p2,
		v14,
		v12
	})

	return (React.useMemo(function() -- line: 38
		-- upvalues: Cryo (copy), p2 (copy), v4 (copy), StatusCodesToRetry (copy), v12 (copy), t1 (copy)
		local join = Cryo.Dictionary.join
		local v21 = p2
		local t2 = {}
		local v23 = p2
		local g24 = nil
		local v25 = nil
		local v26 = nil

		repeat
			if g24 or v23.error then
				if not g24 then
					v25 = v4.Dictionary.getDeepValue(v23, "error.graphQLErrors")
				end

				if g24 or v25 and v25[1] then
					if not g24 then
						v26 = StatusCodesToRetry[v4.Dictionary.getDeepValue(v25[1], "extensions.status")] or false
					end

					g24 = false

					if v26 then
						v26 = v12 < t1.retryCount
					end

					t2.isRetrying = v26
					t2.retryCount = v12

					return join(v21, t2)
				end
			end

			v26 = false
			g24 = true
		until not g24
	end, {
		p2,
		v12
	}))
end

return useApolloAutoRetry
