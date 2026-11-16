local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local ErrorHandlingroblox = require(script.Parent["ErrorHandling.roblox"])
local describeError = ErrorHandlingroblox.describeError

local function invokeGuardedCallbackProd(p, _, callback, p2, ...)
	local result = nil
	local success

	if ReactGlobals.__YOLO__ then
		success = true

		if p2 == nil then
			callback(...)
		else
			callback(p2, ...)
		end
	elseif p2 == nil then
		success, result = xpcall(callback, describeError, ...)
	else
		success, result = xpcall(callback, describeError, p2, ...)
	end

	if not success then
		p.onError(result)
	end
end

local __DEV__ = ReactGlobals.__DEV__

return invokeGuardedCallbackProd
