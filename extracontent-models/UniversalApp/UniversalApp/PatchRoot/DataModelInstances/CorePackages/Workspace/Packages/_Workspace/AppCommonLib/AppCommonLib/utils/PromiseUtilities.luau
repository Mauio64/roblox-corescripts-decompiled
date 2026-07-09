local Parent = script:FindFirstAncestor("AppCommonLib").Parent
local Result = require(Parent.Result)
local Promise = require(Parent.Promise)

return {
	Batch = function(p1, p2: ((...any) -> ...any)?) -- line: 30
		-- upvalues: Promise (copy), Result (copy)
		assert(type(p1) == "table", "PromiseUtilities expects a list of Promises!")

		local n1 = 0

		for _, v in pairs(p1) do
			assert(Promise.is(v), "PromiseUtilities expects a list of Promises!")
			n1 += 1
		end

		return Promise.new(function(resolve, _) -- line: 40
			-- upvalues: Result (copy), n1 (ref), p1 (copy), p2 (copy)
			local n2 = 0
			local t1 = {}

			local function promiseCompleted(p4, p5, p6) -- line: 44
				-- upvalues: t1 (copy), Result (copy), n2 (ref), n1 (ref), resolve (copy)
				t1[p4] = Result.new(p5, p6)
				n2 += 1

				if n2 == n1 then
					resolve(t1)
				end
			end

			if next(p1) == nil then
				resolve(t1)
			end

			for k, v in pairs(p1) do
				v:andThen(function(p7, ...) -- line: 58
					-- upvalues: k (copy), t1 (copy), Result (copy), n2 (ref), n1 (ref), resolve (copy)
					if select("#", ...) > 0 then
						warn("Promises in PromiseUtilities.Batch should not return tuple")
					end

					t1[k] = Result.new(true, p7)
					n2 += 1

					if n2 == n1 then
						resolve(t1)
					end
				end, function(p8) -- line: 63
					-- upvalues: k (copy), t1 (copy), Result (copy), n2 (ref), n1 (ref), resolve (copy), p2 (copy)
					t1[k] = Result.new(false, p8)
					n2 += 1

					if n2 == n1 then
						resolve(t1)
					end

					if p2 then
						p2(p8)
					end
				end)
			end
		end)
	end,
	CountResults = function(p9) -- line: 73
		local n3 = 0
		local n4 = 0

		for _, v in pairs(p9) do
			local v14, _ = v:unwrap()

			if not v14 then
				n4 += 1
			end

			n3 += 1
		end

		return {
			successCount = n3 - n4,
			failureCount = n4,
			totalCount = n3
		}
	end
}
