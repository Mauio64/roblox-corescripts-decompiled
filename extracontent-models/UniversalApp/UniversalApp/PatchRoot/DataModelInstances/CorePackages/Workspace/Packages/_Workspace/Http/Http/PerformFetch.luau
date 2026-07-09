local Http = script:FindFirstAncestor("Http")
local HttpParent = Http.Parent
local Result = require(HttpParent.Result)
local Promise = require(HttpParent.Promise)
local PromiseUtilities = require(HttpParent.AppCommonLib).Utils.PromiseUtilities
local RetrievalStatus = require(Http.Enum).RetrievalStatus
local BatchUpdateFetchingStatus = require(Http.Actions).BatchUpdateFetchingStatus
local t1 = {}
local t2 = {}

function t1.ClearOutstandingPromiseStatus() -- line: 37
	-- upvalues: t2 (ref)
	t2 = {}
end

local function singleFetchKeymapper(p1) -- line: 41
	return p1
end

function t1.GetStatus(p2, p3) -- line: 50
	-- upvalues: RetrievalStatus (copy)
	assert(typeof(p2) == "table")
	assert(typeof(p3) == "string")
	assert(#p3 > 0)

	return p2.FetchingStatus[p3] or RetrievalStatus.NotStarted
end
function t1.Single(p4, p5) -- line: 81
	-- upvalues: t1 (copy), singleFetchKeymapper (copy), Promise (copy), Result (copy)
	assert(typeof(p4) == "string")
	assert(typeof(p5) == "function")
	assert(#p4 > 0)

	return function(p6) -- line: 86
		-- upvalues: t1 (copy), p4 (copy), singleFetchKeymapper (copy), p5 (copy), Promise (copy), Result (copy)
		return t1.Batch({ p4 }, singleFetchKeymapper, function(p7, p8) -- line: 88
			-- upvalues: p5 (copy), Promise (copy), p4 (copy), Result (copy)
			assert(#p8 == 1)

			local v36 = p5(p7)

			assert(Promise.is(v36))

			return v36:andThen(function(...) -- line: 94
				-- upvalues: Promise (copy), p4 (copy), Result (copy)
				assert(#{ ... } <= 1)

				return Promise.resolve({
					[p4] = Result.new(true, (...))
				})
			end, function(...) -- line: 97
				-- upvalues: Promise (copy), p4 (copy), Result (copy)
				assert(#{ ... } <= 1)

				return Promise.resolve({
					[p4] = Result.new(false, (...))
				})
			end)
		end)(p6):andThen(function(p9) -- line: 101
			-- upvalues: p4 (copy), Promise (copy)
			local v38, v39 = p9[p4]:unwrap()

			if v38 then
				return Promise.resolve(v39)
			end

			return Promise.reject(v39)
		end)
	end
end
function t1.Batch(p10, p11, p12) -- line: 154
	-- upvalues: t2 (ref), Promise (copy), RetrievalStatus (copy), BatchUpdateFetchingStatus (copy), PromiseUtilities (copy), Result (copy)
	assert(typeof(p10) == "table")
	assert(typeof(p11) == "function")
	assert(typeof(p12) == "function")

	return function(p13) -- line: 159
		-- upvalues: p10 (copy), p11 (copy), t2 (ref), Promise (copy), RetrievalStatus (copy), BatchUpdateFetchingStatus (copy), p12 (copy), PromiseUtilities (copy), Result (copy)
		local t3 = {}
		local t4 = {}
		local t5 = {}

		for _, v in ipairs(p10) do
			local v26 = p11(v)
			local v27 = t2[v26]

			if v27 then
				t5[v26] = v27
			else
				table.insert(t3, v)
				t4[v] = v26
			end
		end

		local u28 = nil
		local v29 = Promise.new(function(resolve) -- line: 178
			-- upvalues: u28 (ref)
			u28 = resolve
		end)
		local v33

		if #t3 > 0 then
			local t6 = {}

			for _, v in pairs(t4) do
				table.insert(t6, {
					key = v,
					status = RetrievalStatus.Fetching
				})
				t2[v] = v29
			end

			if #t6 > 0 then
				p13:dispatch(BatchUpdateFetchingStatus(t6))
			end

			v33 = p12(p13, t3)
			assert(Promise.is(v33))
		else
			v33 = Promise.resolve({})
		end

		v33:andThen(function(p14) -- line: 209
			-- upvalues: PromiseUtilities (copy), t5 (copy)
			local u42 = p14 or {}

			return PromiseUtilities.Batch(t5):andThen(function(p15) -- line: 212
				-- upvalues: u42 (ref)
				local t7 = {}

				for k, v in pairs(p15) do
					local _, v56 = v:unwrap()

					t7[k] = v56[k]
				end

				return u42, t7
			end)
		end, function() -- line: 222
			assert(false, "PerformFetch fetchFunctor should never reject")
		end):andThen(function(p16, p17) -- line: 225
			-- upvalues: t4 (copy), Result (copy), RetrievalStatus (copy), t2 (ref), p13 (copy), BatchUpdateFetchingStatus (copy)
			local t8 = {}

			for _, v in pairs(t4) do
				local v48 = p16[v]

				if Result.is(v48) then
					p17[v] = v48
				else
					p17[v] = Result.error()
				end

				local v49 = p17[v]:unwrap() and RetrievalStatus.Done or RetrievalStatus.Failed

				table.insert(t8, {
					key = v,
					status = v49
				})
				t2[v] = nil
			end

			if #t8 > 0 then
				p13:dispatch(BatchUpdateFetchingStatus(t8))
			end

			return p17
		end):andThen(function(p18) -- line: 255
			-- upvalues: u28 (ref)
			u28(p18)
		end)

		return v29
	end
end

return t1
