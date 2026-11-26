require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsUtils").createSessionScopedSignal

local v5 = { screen = nil, params = nil, requestId = 0, completedRequestId = 0 }

local function createExternalNavigationRequestStore()
	local sessionScopedSignal, v6 = createSessionScopedSignal(v5)

	return {
		getRequest = sessionScopedSignal,
		navigateIntoChat = function(screen, params)
			local v7 = sessionScopedSignal(false)

			if screen == nil then
				screen = v7.screen
			end

			if params == nil then
				params = v7.params
			end

			v6({
				screen = screen,
				params = params,
				requestId = v7.requestId + 1,
				completedRequestId = v7.completedRequestId
			})
		end,
		completeExternalNavigation = function(p2)
			local v7 = sessionScopedSignal(false)
			v6({
				screen = v7.screen,
				params = v7.params,
				requestId = v7.requestId,
				completedRequestId = p2
			})
		end,
		reset = function()
			v6(v5)
		end
	}
end

return createExternalNavigationRequestStore
