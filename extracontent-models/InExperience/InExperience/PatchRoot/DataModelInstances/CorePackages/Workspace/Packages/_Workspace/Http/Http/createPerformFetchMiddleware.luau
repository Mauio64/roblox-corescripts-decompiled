local Http = script:FindFirstAncestor("Http")
local UpdateFetchingStatus = require(Http.Actions).UpdateFetchingStatus
local BatchUpdateFetchingStatus = require(Http.Actions).BatchUpdateFetchingStatus

local function createPerformFetchMiddleware(p1) -- line: 5
	-- upvalues: BatchUpdateFetchingStatus (copy), UpdateFetchingStatus (copy)
	local t1 = {}
	local u7 = false
	local v8 = p1 or 0

	return function(p2, p3) -- line: 10
		-- upvalues: u7 (ref), v8 (copy), t1 (ref), BatchUpdateFetchingStatus (copy), UpdateFetchingStatus (copy)
		local function runBatchDispatcher() -- line: 11
			-- upvalues: u7 (ref), v8 (copy), t1 (ref), p3 (copy), BatchUpdateFetchingStatus (copy)
			if u7 then
				return
			end

			u7 = true
			task.delay(v8, function() -- line: 17
				-- upvalues: t1 (ref), u7 (ref), p3 (copy), BatchUpdateFetchingStatus (copy)
				local v15 = t1

				t1 = {}
				u7 = false
				p3:dispatch(BatchUpdateFetchingStatus(v15, true))
			end)
		end

		return function(p4) -- line: 26
			-- upvalues: UpdateFetchingStatus (copy), t1 (ref), u7 (ref), v8 (copy), p3 (copy), BatchUpdateFetchingStatus (copy), p2 (copy)
			if p4.type == UpdateFetchingStatus.name then
				table.insert(t1, p4)

				if not u7 then
					u7 = true
					task.delay(v8, function() -- line: 17
						-- upvalues: t1 (ref), u7 (ref), p3 (copy), BatchUpdateFetchingStatus (copy)
						local v16 = t1

						t1 = {}
						u7 = false
						p3:dispatch(BatchUpdateFetchingStatus(v16, true))
					end)
				end
			else
				if p4.type ~= BatchUpdateFetchingStatus.name or p4.shouldImmediatelyDispatch then
					return p2(p4)
				end

				for _, v in pairs(p4.fetchingStatuses) do
					table.insert(t1, v)
				end

				if not u7 then
					u7 = true
					task.delay(v8, function() -- line: 17
						-- upvalues: t1 (ref), u7 (ref), p3 (copy), BatchUpdateFetchingStatus (copy)
						local v17 = t1

						t1 = {}
						u7 = false
						p3:dispatch(BatchUpdateFetchingStatus(v17, true))
					end)
				end
			end

			return nil
		end
	end
end

return createPerformFetchMiddleware
