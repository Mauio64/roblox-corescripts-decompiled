local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local memo = React.memo
local useEffect = React.useEffect
local useRef = React.useRef
local usePrevious = RoactUtils.Hooks.usePrevious

function ExternalNavigationHandler(t1: {[any]: any}) -- line: 24
	-- upvalues: useRef (copy), useEffect (copy), usePrevious (copy)
	local v9 = useRef({})

	local function v10() -- line: 31
		-- upvalues: t1 (copy), v9 (copy)
		local screen = t1.screen
		local v13 = t1.navigationByScreen[screen]

		if v13 then
			v13(t1.params)
		else
			assert(v9.current, "Queue for ExternalNavigationHandler can't be nil")

			local v14 = v9.current[screen] or {}

			table.insert(v14, t1.params)
			v9.current[screen] = v14
		end

		t1.completeExternalNavigation(t1.requestId)
	end

	useEffect(function() -- line: 49
		-- upvalues: t1 (copy), v10 (copy)
		if t1.requestId ~= t1.completedRequestId and t1.screen then
			v10()
		end
	end, {
		t1.requestId,
		t1.completedRequestId,
		t1.screen
	})

	local v11 = usePrevious(t1.navigationByScreen)

	useEffect(function() -- line: 57
		-- upvalues: v9 (copy), v11 (copy), t1 (copy)
		assert(v9.current, "Queue for ExternalNavigationHandler can't be nil")

		if v11 == nil then
			return
		end

		for k, v in pairs(v9.current) do
			assert(v11, "")

			local v17 = v11[k]
			local v18 = t1.navigationByScreen[k]

			if v17 ~= v18 and v18 then
				for _, v2 in ipairs(v) do
					v18(v2)
				end

				v9.current[k] = nil
			end
		end
	end, { t1.navigationByScreen })

	return nil
end

return memo(ExternalNavigationHandler)
