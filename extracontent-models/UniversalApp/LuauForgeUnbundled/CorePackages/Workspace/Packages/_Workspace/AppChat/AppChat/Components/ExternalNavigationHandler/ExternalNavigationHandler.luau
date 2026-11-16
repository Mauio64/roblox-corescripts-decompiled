local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local memo = React.memo
local useEffect = React.useEffect
local useRef = React.useRef
local usePrevious = RoactUtils.Hooks.usePrevious

function LUAUFORGE_MODULE_GLOBALS_ikl_ExternalNavigationHandler(data): nil
	local v5 = useRef({})

	local function fn()
		local screen = data.screen
		local v6 = data.navigationByScreen[screen]

		if v6 then
			v6(data.params)
		else
			assert(v5.current, "Queue for ExternalNavigationHandler can't be nil")
			local params = v5.current[screen] or {}
			table.insert(params, data.params)
			v5.current[screen] = params
		end

		data.completeExternalNavigation(data.requestId)
	end

	useEffect(function()
		local v6 = not (data.requestId == data.completedRequestId) and data.screen

		if v6 then
			fn()
		end
	end, { data.requestId, data.completedRequestId, data.screen })

	local v6 = usePrevious(data.navigationByScreen)
	useEffect(function()
		assert(v5.current, "Queue for ExternalNavigationHandler can't be nil")

		if v6 == nil then
			return
		end

		for k, list in pairs(v5.current) do
			assert(v6, "")
			local v7 = v6[k]
			local v8 = data.navigationByScreen[k]

			if not (v7 ~= v8 and v8) then
				continue
			end

			for i, item in ipairs(list) do
				v8(item)
			end

			v5.current[k] = nil
		end
	end, { data.navigationByScreen })

	return nil
end

return memo(LUAUFORGE_MODULE_GLOBALS_ikl_ExternalNavigationHandler)
