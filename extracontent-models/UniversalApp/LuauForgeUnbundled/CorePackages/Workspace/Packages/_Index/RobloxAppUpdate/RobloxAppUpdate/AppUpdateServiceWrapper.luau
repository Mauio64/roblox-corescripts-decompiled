local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppUpdate/Promise")

local class = {}
class.__index = class

function class.new(p2)
	local v5 = { _appUpdate = p2 }

	setmetatable(v5, class)
	return v5
end

function class:checkForUpdate()
	return Promise.new(function(callback, p3)
		local success, result = pcall(function()
			self._appUpdate:CheckForUpdate(function(p4)
				callback({ appUpdateStatus = p4 })
			end)
		end)

		if not success then
			callback({ errorMessage = result })
		end
	end)
end

function class:performManagedUpdate()
	self._appUpdate:PerformManagedUpdate()
end

function class:canPerformBinaryUpdate()
	return self._appUpdate:CanPerformBinaryUpdate()
end

return class
