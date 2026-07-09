local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local MessageBusService = game:GetService("MessageBusService")
local v4 = require(Modules.LuaApp.Flags.getFFlagSessionCheckDefaultTimeoutInSeconds)()
local v5 = game:DefineFastFlag("EnableSessionCheckManagerToListenOnce", false)
local t1 = {
	NotStarted = 0,
	InProgress = 1,
	Success = 2,
	Failed = 3
}
local t2 = {}

t2.__index = t2

function t2.new() -- line: 23
	-- upvalues: t1 (copy), t2 (copy)
	return (setmetatable({
		_connection = nil,
		_resolveFunction = nil,
		_currentStatus = t1.NotStarted
	}, t2))
end
function t2.registerSessionStatusChange(p1) -- line: 33
	-- upvalues: MessageBusService (copy), t1 (copy)
	if p1._connection then
		p1._connection:Disconnect()
	end

	p1._connection = MessageBusService:Subscribe("SessionCheckStatusChanged", function(p2) -- line: 39
		-- upvalues: p1 (copy), t1 (copy)
		if p2 and p2.status then
			p1._currentStatus = p2.status

			if (p2.status == t1.Success or p2.status == t1.Failed) and p1._resolveFunction then
				if p2.status == t1.Failed then
					p1._resolveFunction({
						status = p2.status,
						errorStatus = p2.httpStatusCode or p2.errorStatus
					})
				else
					p1._resolveFunction({
						status = p2.status
					})
				end

				p1._resolveFunction = nil
			end
		end
	end, false, true)
end
function t2.waitForSessionCheckTerminalStatus(p3, p4) -- line: 67
	-- upvalues: v4 (copy), Promise (copy), t1 (copy)
	local u11 = p4 or v4

	return Promise.new(function(resolve, reject) -- line: 70
		-- upvalues: p3 (copy), t1 (copy), Promise (copy), u11 (ref)
		if p3._currentStatus == t1.Success or p3._currentStatus == t1.Failed then
			resolve(p3._currentStatus)

			return
		end

		p3._resolveFunction = resolve
		Promise.delay(u11):andThen(function() -- line: 81
			-- upvalues: p3 (copy), reject (copy), u11 (ref)
			if p3._resolveFunction then
				p3._resolveFunction = nil
				reject("Session check timeout after " .. u11 .. " seconds")
			end
		end)
	end)
end
function t2.listenToSessionStatusChange(p5, p6) -- line: 91
	-- upvalues: MessageBusService (copy), v5 (copy)
	if p5._connection then
		p5._connection:Disconnect()
	end

	p5._connection = MessageBusService:Subscribe("SessionCheckStatusChanged", function(p7) -- line: 95
		-- upvalues: p6 (copy)
		if p6 and p7 then
			p6(p7)
		end
	end, v5, true)

	return p5._connection
end

t2.Status = t1
t2.default = t2.new()

return t2
