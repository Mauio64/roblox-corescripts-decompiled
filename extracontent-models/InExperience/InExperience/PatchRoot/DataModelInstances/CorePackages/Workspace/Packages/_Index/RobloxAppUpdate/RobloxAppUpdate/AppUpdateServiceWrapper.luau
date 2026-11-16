local parent = script:FindFirstAncestor("RobloxAppUpdate").Parent
local Promise = require(parent.Promise)

local AppUpdateServiceWrapper = {}
AppUpdateServiceWrapper.__index = AppUpdateServiceWrapper

function AppUpdateServiceWrapper.new(appUpdate)
	local v = { _appUpdate = appUpdate }

	setmetatable(v, AppUpdateServiceWrapper)
	return v
end

function AppUpdateServiceWrapper:checkForUpdate()
	return Promise.new(function(callback, _)
		local success, result = pcall(function()
			self._appUpdate:CheckForUpdate(function(appUpdateStatus)
				callback({ appUpdateStatus = appUpdateStatus })
			end)
		end)

		if not success then
			callback({ errorMessage = result })
		end
	end)
end

function AppUpdateServiceWrapper:performManagedUpdate()
	self._appUpdate:PerformManagedUpdate()
end

function AppUpdateServiceWrapper:canPerformBinaryUpdate()
	return self._appUpdate:CanPerformBinaryUpdate()
end

return AppUpdateServiceWrapper
