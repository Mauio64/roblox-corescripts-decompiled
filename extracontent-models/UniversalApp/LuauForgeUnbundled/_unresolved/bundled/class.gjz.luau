local module = require("@luauforge/bundled/egs")
local MessageBusService = game:GetService("MessageBusService")

local v5 = require("@luauforge/bundled/gjA")()
local defineFastFlag = game:DefineFastFlag("EnableSessionCheckManagerToListenOnce", false)

local v6 = { NotStarted = 0, InProgress = 1, Success = 2, Failed = 3 }

local class = {}
class.__index = class

function class.new()
	return (setmetatable(
		{ _currentStatus = v6.NotStarted, _connection = nil, _resolveFunction = nil },
		class
	))
end

function class:registerSessionStatusChange()
	if self._connection then
		self._connection:Disconnect()
	end

	self._connection = MessageBusService:Subscribe("SessionCheckStatusChanged", function(data)
		if data and data.status then
			self._currentStatus = data.status

			if (data.status == v6.Success or data.status == v6.Failed) and self._resolveFunction then
				if data.status == v6.Failed then
					self._resolveFunction({
						status = data.status,
						errorStatus = data.httpStatusCode or data.errorStatus
					})
				else
					self._resolveFunction({ status = data.status })
				end

				self._resolveFunction = nil
			end
		end
	end, false, true)
end

function class:waitForSessionCheckTerminalStatus(p2)
	local v7 = p2 or v5

	return module.new(function(resolveFunction, callback)
		if self._currentStatus == v6.Success or self._currentStatus == v6.Failed then
			resolveFunction(self._currentStatus)
			return
		end

		self._resolveFunction = resolveFunction

		module.delay(v7):andThen(function()
			if self._resolveFunction then
				self._resolveFunction = nil
				callback("Session check timeout after " .. v7 .. " seconds")
			end
		end)
	end)
end

function class:listenToSessionStatusChange(callback)
	if self._connection then
		self._connection:Disconnect()
	end

	self._connection = MessageBusService:Subscribe("SessionCheckStatusChanged", function(p3)
		if callback and p3 then
			callback(p3)
		end
	end, defineFastFlag, true)

	return self._connection
end

class.Status = v6

class.default = class.new()

return class
