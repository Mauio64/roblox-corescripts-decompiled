local parent = script:FindFirstAncestor("AppChat").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local v = { screen = nil, params = nil, requestId = 0, completedRequestId = 0 }

local function createExternalNavigationRequestStore()
	local sessionScopedSignal, v2 = createSessionScopedSignal(v)

	return {
		getRequest = sessionScopedSignal,
		navigateIntoChat = function(screen: string?, params)
			local v3 = sessionScopedSignal(false)

			if screen == nil then
				screen = v3.screen
			end

			if params == nil then
				params = v3.params
			end

			v2({
				screen = screen,
				params = params,
				requestId = v3.requestId + 1,
				completedRequestId = v3.completedRequestId
			})
		end,
		completeExternalNavigation = function(completedRequestId: number)
			local v3 = sessionScopedSignal(false)
			v2({
				screen = v3.screen,
				params = v3.params,
				requestId = v3.requestId,
				completedRequestId = completedRequestId
			})
		end,
		reset = function()
			v2(v)
		end
	}
end

return createExternalNavigationRequestStore
