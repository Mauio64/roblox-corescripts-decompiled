local ParentParent = script.Parent.Parent.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean
local Promise = require(ParentParent.Promise)
local t1 = {}
local Observable = require(script.Parent.Observable).Observable

function t1.asyncMap(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?) -- line: 37
	-- upvalues: Observable (copy), Promise (copy), Boolean (copy)
	return Observable.new(function(p4) -- line: 42
		-- upvalues: Promise (copy), Boolean (copy), p2 (copy), p3 (copy), p1 (copy)
		local u10 = nil
		local next = p4.next
		local error2 = p4.error
		local complete = p4.complete
		local n1 = 0
		local u15 = false
		local t2 = {
			andThen = function(_, p6: ((...any) -> ...any)) -- line: 54
				-- upvalues: Promise (copy)
				return Promise.new(function(resolve) -- line: 55
					-- upvalues: p6 (copy)
					return resolve(p6())
				end)
			end
		}

		local function makeCallback(p7, p8) -- line: 62
			-- upvalues: Boolean (copy), n1 (ref), t2 (ref), Promise (copy), next (copy), p4 (copy), u15 (ref), u10 (ref), error2 (copy)
			if Boolean.toJSBoolean(p7) then
				return function(_, p10) -- line: 67
					-- upvalues: n1 (ref), p7 (copy), t2 (ref), Promise (copy), Boolean (copy), next (copy), p4 (copy), u15 (ref), u10 (ref), error2 (copy)
					n1 += 1

					local function both() -- line: 69
						-- upvalues: p7 (copy), p10 (copy)
						return p7(p10)
					end

					t2 = t2:andThen(function() -- line: 75
						-- upvalues: Promise (copy)
						return Promise.delay(0)
					end):andThen(both, both):andThen(function(p11) -- line: 80
						-- upvalues: n1 (ref), Boolean (copy), next (copy), p4 (copy), u15 (ref), u10 (ref)
						n1 -= 1

						if Boolean.toJSBoolean(next) then
							next(p4, p11)
						end

						if Boolean.toJSBoolean(u15) then
							u10.complete()
						end
					end, function(p12) -- line: 88
						-- upvalues: n1 (ref)
						n1 -= 1
						error(p12)
					end):catch(function(p13) -- line: 92
						-- upvalues: Boolean (copy), error2 (copy), p4 (copy)
						if Boolean.toJSBoolean(error2) then
							return error2(p4, p13)
						end
					end)
				end
			end

			return function(_, p15) -- line: 100
				-- upvalues: Boolean (copy), p8 (copy), p4 (copy)
				if Boolean.toJSBoolean(p8) then
					p8(p4, p15)
				end
			end
		end

		local t3 = {}
		local v19 = p2

		t3.next = not Boolean.toJSBoolean(v19) and function(_, p17) -- line: 100
			-- upvalues: Boolean (copy), next (copy), p4 (copy)
			if Boolean.toJSBoolean(next) then
				next(p4, p17)
			end
		end or function(_, p19) -- line: 67
			-- upvalues: n1 (ref), v19 (copy), t2 (ref), Promise (copy), Boolean (copy), next (copy), p4 (copy), u15 (ref), u10 (ref), error2 (copy)
			n1 += 1

			local function both() -- line: 69
				-- upvalues: v19 (copy), p19 (copy)
				return v19(p19)
			end

			t2 = t2:andThen(function() -- line: 75
				-- upvalues: Promise (copy)
				return Promise.delay(0)
			end):andThen(both, both):andThen(function(p20) -- line: 80
				-- upvalues: n1 (ref), Boolean (copy), next (copy), p4 (copy), u15 (ref), u10 (ref)
				n1 -= 1

				if Boolean.toJSBoolean(next) then
					next(p4, p20)
				end

				if Boolean.toJSBoolean(u15) then
					u10.complete()
				end
			end, function(p21) -- line: 88
				-- upvalues: n1 (ref)
				n1 -= 1
				error(p21)
			end):catch(function(p22) -- line: 92
				-- upvalues: Boolean (copy), error2 (copy), p4 (copy)
				if Boolean.toJSBoolean(error2) then
					return error2(p4, p22)
				end
			end)
		end

		local v20 = p3

		t3.error = not Boolean.toJSBoolean(v20) and function(_, p24) -- line: 100
			-- upvalues: Boolean (copy), error2 (copy), p4 (copy)
			if Boolean.toJSBoolean(error2) then
				error2(p4, p24)
			end
		end or function(_, p26) -- line: 67
			-- upvalues: n1 (ref), v20 (copy), t2 (ref), Promise (copy), Boolean (copy), next (copy), p4 (copy), u15 (ref), u10 (ref), error2 (copy)
			n1 += 1

			local function both() -- line: 69
				-- upvalues: v20 (copy), p26 (copy)
				return v20(p26)
			end

			t2 = t2:andThen(function() -- line: 75
				-- upvalues: Promise (copy)
				return Promise.delay(0)
			end):andThen(both, both):andThen(function(p27) -- line: 80
				-- upvalues: n1 (ref), Boolean (copy), next (copy), p4 (copy), u15 (ref), u10 (ref)
				n1 -= 1

				if Boolean.toJSBoolean(next) then
					next(p4, p27)
				end

				if Boolean.toJSBoolean(u15) then
					u10.complete()
				end
			end, function(p28) -- line: 88
				-- upvalues: n1 (ref)
				n1 -= 1
				error(p28)
			end):catch(function(p29) -- line: 92
				-- upvalues: Boolean (copy), error2 (copy), p4 (copy)
				if Boolean.toJSBoolean(error2) then
					return error2(p4, p29)
				end
			end)
		end

		function t3.complete() -- line: 111
			-- upvalues: u15 (ref), Boolean (copy), n1 (ref), complete (copy), p4 (copy)
			u15 = true

			if not Boolean.toJSBoolean(n1) and Boolean.toJSBoolean(complete) then
				complete(p4)
			end
		end

		u10 = t3

		local v21 = p1:subscribe(u10)

		return function() -- line: 122
			-- upvalues: v21 (copy)
			return v21:unsubscribe()
		end
	end)
end

return t1
