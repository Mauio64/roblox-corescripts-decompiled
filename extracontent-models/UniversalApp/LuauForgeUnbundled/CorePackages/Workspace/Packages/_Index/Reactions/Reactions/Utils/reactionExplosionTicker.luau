local RunService = game:GetService("RunService")

local function createTicker(p2)
	local stepSignal = if p2 ~= nil then p2.stepSignal else nil
	local v6 = (if p2 ~= nil then p2.clock else nil) or os.clock

	local v7 = {}
	local connection = nil

	local function connectIfNeeded()
		if connection ~= nil or #v7 == 0 then
			return
		end

		connection = (stepSignal or RunService.PreRender):Connect(function()
			local v8 = v6()

			for k, v9 in table.clone(v7) do
				v9(v8)
			end
		end)
	end

	local function disconnectIfEmpty()
		if connection ~= nil and #v7 == 0 then
			connection:Disconnect()
			connection = nil
		end
	end

	return {
		add = function(p3)
			table.insert(v7, p3)

			if connection == nil and #v7 ~= 0 then
				connection = (stepSignal or RunService.PreRender):Connect(function()
					local v8 = v6()

					for k, v9 in table.clone(v7) do
						v9(v8)
					end
				end)
			end

			local flag = false
			return function()
				if flag then
					return
				end

				flag = true
				local index = table.find(v7, p3)

				if index ~= nil then
					table.remove(v7, index)
				end

				if connection ~= nil and #v7 == 0 then
					connection:Disconnect()
					connection = nil
				end
			end
		end,
		step = function(self)
			local v8 = self or v6()

			for k, v9 in table.clone(v7) do
				v9(v8)
			end
		end,
		getActiveCount = function()
			return #v7
		end,
		isConnected = function(): boolean
			return connection ~= nil
		end
	}
end

return { createTicker = createTicker, shared = createTicker() }
