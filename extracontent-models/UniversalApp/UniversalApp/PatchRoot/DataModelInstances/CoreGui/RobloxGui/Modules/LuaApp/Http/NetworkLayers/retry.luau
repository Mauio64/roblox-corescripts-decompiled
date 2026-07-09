local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local HttpError = require(Modules.LuaApp.Http.HttpError)

local function defer(p1) -- line: 10
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve) -- line: 11
		-- upvalues: p1 (copy)
		delay(p1, function() -- line: 12
			-- upvalues: resolve (copy)
			resolve()
		end)
	end)
end
local function retryRequest(p2, p3) -- line: 25
	-- upvalues: HttpError (copy), Promise (copy), retryRequest (copy)
	return p2():catch(function(p4) -- line: 26
		-- upvalues: p3 (copy), HttpError (copy), Promise (copy), retryRequest (copy), p2 (copy)
		p3.remainingAttempts = p3.remainingAttempts - 1

		if not (p3.remainingAttempts > 0) or p4.kind ~= HttpError.Kind.RequireExternalRetry and p4.kind ~= HttpError.Kind.LuaTimeout then
			return Promise.reject(p4)
		end

		if p3.shouldImmediateRetry then
			return retryRequest(p2, p3)
		end

		local v13 = p3.backoffRate ^ (p3.maxAttempts - p3.remainingAttempts)

		return Promise.new(function(resolve) -- line: 11
			-- upvalues: v13 (copy)
			delay(v13, function() -- line: 12
				-- upvalues: resolve (copy)
				resolve()
			end)
		end):andThen(function() -- line: 45
			-- upvalues: retryRequest (copy), p2 (copy), p3 (copy)
			return retryRequest(p2, p3)
		end)
	end)
end

return function(p5, p6) -- line: 55
	-- upvalues: HttpError (copy), Promise (copy), retryRequest (copy)
	return function(p7, p8, p9) -- line: 56
		-- upvalues: p6 (copy), p5 (copy), HttpError (copy), Promise (copy), retryRequest (copy)
		local t1 = {
			maxAttempts = 3,
			backoffRate = 2,
			shouldImmediateRetry = false
		}

		if p6 and p6.shouldImmediateRetry then
			assert(type(p6.shouldImmediateRetry) == "boolean", "shouldImmediateRetry must be a bool")
			t1.shouldImmediateRetry = p6.shouldImmediateRetry
		end

		t1.remainingAttempts = t1.maxAttempts

		local function makeRequest() -- line: 72
			-- upvalues: p5 (copy), p7 (copy), p8 (copy), p9 (copy)
			return p5(p7, p8, p9)
		end

		return (p5(p7, p8, p9):catch(function(p10) -- line: 26
			-- upvalues: t1 (copy), HttpError (copy), Promise (copy), retryRequest (copy), makeRequest (copy)
			t1.remainingAttempts = t1.remainingAttempts - 1

			if not (t1.remainingAttempts > 0) or p10.kind ~= HttpError.Kind.RequireExternalRetry and p10.kind ~= HttpError.Kind.LuaTimeout then
				return Promise.reject(p10)
			end

			if t1.shouldImmediateRetry then
				return retryRequest(makeRequest, t1)
			end

			local v21 = t1.backoffRate ^ (t1.maxAttempts - t1.remainingAttempts)

			return Promise.new(function(resolve) -- line: 11
				-- upvalues: v21 (copy)
				delay(v21, function() -- line: 12
					-- upvalues: resolve (copy)
					resolve()
				end)
			end):andThen(function() -- line: 45
				-- upvalues: retryRequest (copy), makeRequest (copy), t1 (copy)
				return retryRequest(makeRequest, t1)
			end)
		end))
	end
end
