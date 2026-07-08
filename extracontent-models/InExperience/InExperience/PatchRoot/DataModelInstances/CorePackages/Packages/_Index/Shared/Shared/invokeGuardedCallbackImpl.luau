local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local describeError = require(script.Parent["ErrorHandling.roblox"]).describeError

local function invokeGuardedCallbackProd(p1, _, p3, p4, ...) -- line: 19
	-- upvalues: ReactGlobals (copy), describeError (copy)
	local result = nil
	local ok

	if not ReactGlobals.__YOLO__ then
		if p4 == nil then
			ok, result = xpcall(p3, describeError, ...)
		else
			ok, result = xpcall(p3, describeError, p4, ...)
		end
	else
		ok = true

		if p4 == nil then
			p3(...)
		else
			p3(p4, ...)
		end
	end

	if not ok then
		p1.onError(result)
	end
end

if not ReactGlobals.__DEV__ then
end

return invokeGuardedCallbackProd
