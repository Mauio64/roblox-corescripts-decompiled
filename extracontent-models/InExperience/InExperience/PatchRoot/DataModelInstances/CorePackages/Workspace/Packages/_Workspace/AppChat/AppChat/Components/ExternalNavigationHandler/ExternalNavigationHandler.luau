local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local memo = React.memo
local useEffect = React.useEffect
local useRef = React.useRef
local usePrevious = RoactUtils.Hooks.usePrevious

function ExternalNavigationHandler(data): nil
	local v = useRef({})

	local function fn()
		local screen = data.screen
		local v2 = data.navigationByScreen[screen]

		if v2 then
			v2(data.params)
		else
			assert(v.current, "Queue for ExternalNavigationHandler can't be nil")
			local params = v.current[screen] or {}
			table.insert(params, data.params)
			v.current[screen] = params
		end

		data.completeExternalNavigation(data.requestId)
	end

	local function fn2() -- 1 equivalent call inferred from this helper
		return data.requestId ~= data.completedRequestId and data.screen
	end

	useEffect(function()
		if fn2() then -- inferred equivalent call
			fn()
		end
	end, { data.requestId, data.completedRequestId, data.screen })

	local v2 = usePrevious(data.navigationByScreen)
	useEffect(function()
		assert(v.current, "Queue for ExternalNavigationHandler can't be nil")

		if v2 == nil then
			return
		end

		for k, list in pairs(v.current) do
			assert(v2, "")
			local v3 = v2[k]
			local v4 = data.navigationByScreen[k]

			if not (v3 ~= v4 and v4) then
				continue
			end

			for _, item in ipairs(list) do
				v4(item)
			end

			v.current[k] = nil
		end
	end, { data.navigationByScreen })

	return nil
end

return memo(ExternalNavigationHandler)
