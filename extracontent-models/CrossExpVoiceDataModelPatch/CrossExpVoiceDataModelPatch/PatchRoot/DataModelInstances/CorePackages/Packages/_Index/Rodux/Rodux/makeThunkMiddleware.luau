local function tracebackReporter(p1) -- line: 9
	return debug.traceback(p1)
end
local function makeThunkMiddleware(p2) -- line: 13
	-- upvalues: tracebackReporter (copy)
	local function thunkMiddleware(p3, p4) -- line: 14
		-- upvalues: p2 (copy), tracebackReporter (copy)
		return function(p5) -- line: 15
			-- upvalues: p4 (copy), p2 (copy), tracebackReporter (copy), p3 (copy)
			if typeof(p5) == "function" then
				local ok, result = xpcall(function() -- line: 17
					-- upvalues: p5 (copy), p4 (copy), p2 (copy)
					return p5(p4, p2)
				end, tracebackReporter)

				if not ok then
					p4._errorReporter.reportReducerError(p4:getState(), p5, {
						message = "Caught error in thunk",
						thrownValue = result
					})

					return nil
				end

				return result
			end

			return p3(p5)
		end
	end

	return thunkMiddleware
end

return makeThunkMiddleware
