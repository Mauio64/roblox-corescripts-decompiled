local RunService = game:GetService("RunService")

local function createTicker(t1: {[any]: any}?) -- line: 32
	-- upvalues: RunService (copy)
	local v4 = if t1 == nil then nil else t1.stepSignal
	local v5 = ((if t1 == nil then nil else t1.clock)) or os.clock
	local t2 = {}
	local connection = nil

	local function connectIfNeeded() -- line: 48
		-- upvalues: connection (ref), t2 (copy), v4 (copy), RunService (copy), v5 (copy)
		if connection ~= nil or #t2 == 0 then
			return
		end

		connection = (v4 or RunService.PreRender):Connect(function() -- line: 53
			-- upvalues: v5 (copy), t2 (copy)
			local v16 = v5()

			for _, v18 in table.clone(t2) do
				v18(v16)
			end
		end)
	end
	local function disconnectIfEmpty() -- line: 58
		-- upvalues: connection (ref), t2 (copy)
		if connection ~= nil and #t2 == 0 then
			connection:Disconnect()
			connection = nil
		end
	end

	return {
		add = function(p1: ((...any) -> ...any)) -- line: 65
			-- upvalues: t2 (copy), connection (ref), v4 (copy), RunService (copy), v5 (copy)
			table.insert(t2, p1)

			if connection == nil and #t2 ~= 0 then
				connection = (v4 or RunService.PreRender):Connect(function() -- line: 53
					-- upvalues: v5 (copy), t2 (copy)
					local v19 = v5()

					for _, v21 in table.clone(t2) do
						v21(v19)
					end
				end)
			end

			local u15 = false

			return function() -- line: 70
				-- upvalues: u15 (ref), t2 (copy), p1 (copy), connection (ref)
				if u15 then
					return
				end

				u15 = true

				local v22 = table.find(t2, p1)

				if v22 ~= nil then
					table.remove(t2, v22)
				end

				if connection ~= nil and #t2 == 0 then
					connection:Disconnect()
					connection = nil
				end
			end
		end,
		step = function(n1: number?) -- line: 39
			-- upvalues: v5 (copy), t2 (copy)
			local v11 = n1 or v5()

			for _, v13 in table.clone(t2) do
				v13(v11)
			end
		end,
		getActiveCount = function() -- line: 86
			-- upvalues: t2 (copy)
			return #t2
		end,
		isConnected = function() -- line: 89
			-- upvalues: connection (ref)
			return connection ~= nil
		end
	}
end

return {
	createTicker = createTicker,
	shared = createTicker()
}
