local RunService = game:GetService("RunService")

local function createTicker(p)
	local stepSignal

	if p == nil then
		stepSignal = nil
	else
		stepSignal = p.stepSignal
	end

	local v

	if p ~= nil then
		v = p.clock
	end

	local v2 = v or os.clock

	local v3 = {}
	local connection = nil

	local function step(p2: number?) -- 1 equivalent call inferred from this helper
		local v4 = p2 or v2()

		for _, v5 in table.clone(v3) do
			v5(v4)
		end
	end

	local function connectIfNeeded() -- 1 equivalent call inferred from this helper
		if connection ~= nil or #v3 == 0 then
			return
		end

		connection = (stepSignal or RunService.PreRender):Connect(function()
			step() -- inferred equivalent call
		end)
	end

	local function disconnectIfEmpty() -- 1 equivalent call inferred from this helper
		if connection ~= nil and #v3 == 0 then
			connection:Disconnect()
			connection = nil
		end
	end

	return {
		add = function(callback)
			table.insert(v3, callback)
			connectIfNeeded() -- inferred equivalent call
			local flag = false
			return function()
				if flag then
					return
				end

				flag = true
				local index = table.find(v3, callback)

				if index ~= nil then
					table.remove(v3, index)
				end

				disconnectIfEmpty() -- inferred equivalent call
			end
		end,
		step = step,
		getActiveCount = function()
			return #v3
		end,
		isConnected = function(): boolean
			return connection ~= nil
		end
	}
end

return { createTicker = createTicker, shared = createTicker() }
