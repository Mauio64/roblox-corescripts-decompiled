local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local DataModelTraversalOptions = require(SceneUnderstanding.options.DataModelTraversalOptions)

local function createLazyInstanceCollector(items, callback, p)
	local v = DataModelTraversalOptions.new(p)

	local flag = false
	local result = {}
	local total = 0
	local connections = {}
	local thread = nil
	local v2 = {}
	local v3 = {}

	local function getBatchCount() -- 5 equivalent calls inferred from this helper
		return (math.min(#v2, v.instanceProcessingLimit))
	end

	local function onAncestryChanged(p2)
		local index = p2.Parent == nil and table.find(result, p2)

		if index then
			table.remove(result, index)
		end
	end

	local function processStack(): boolean
		local batchCount = getBatchCount() -- inferred equivalent call

		for _ = 1, batchCount do
			local v4 = table.remove(v2, #v2)

			if not v4 then
				continue
			end

			if not callback or callback(v4) then
				table.insert(result, v4)
				table.insert(connections, v4.AncestryChanged:Connect(onAncestryChanged))
			end

			for _, child in v4:GetChildren() do
				table.insert(v2, child)
			end
		end

		total += batchCount

		for k in v3 do
			task.spawn(function()
				k(result)
			end)
		end

		if #v2 == 0 then
			flag = false

			return false
		end

		if total >= v.instanceProcessingLimit then
			total = 0
			return true
		end

		return false
	end

	local function startProcessingLoop()
		if flag or getBatchCount() == 0 then -- inferred equivalent call
			return
		end

		flag = true

		processStack()

		thread = task.spawn(function()
			task.wait()

			while flag do
				local v4 = processStack()

				if flag and v4 then
					task.wait()
				end
			end
		end)
	end

	local function onDescendantAdded(p2)
		table.insert(v2, p2)

		if not (flag or flag) then
			if getBatchCount() == 0 then -- inferred equivalent call
				return
			end

			flag = true

			processStack()

			thread = task.spawn(function()
				task.wait()

				while flag do
					local v4 = processStack()

					if flag and v4 then
						task.wait()
					end
				end
			end)
		end
	end

	return {
		setInstancesProcessedPerFrame = function(value: number)
			v.instanceProcessingLimit = math.clamp(value, 0, 1e999)

			if not flag then
				if getBatchCount() == 0 then -- inferred equivalent call
					return
				end

				flag = true

				processStack()

				thread = task.spawn(function()
					task.wait()

					while flag do
						local v4 = processStack()

						if flag and v4 then
							task.wait()
						end
					end
				end)
			end
		end,
		listen = function()
			for _, item in items do
				table.insert(connections, item.DescendantAdded:Connect(onDescendantAdded))

				for _, child in item:GetChildren() do
					table.insert(v2, child)
				end
			end

			if not flag then
				if getBatchCount() == 0 then -- inferred equivalent call
					return
				end

				flag = true

				processStack()

				thread = task.spawn(function()
					task.wait()

					while flag do
						local v4 = processStack()

						if flag and v4 then
							task.wait()
						end
					end
				end)
			end
		end,
		get = function()
			return result
		end,
		destroy = function()
			flag = false

			for _, connection in connections do
				connection:Disconnect()
			end

			v3 = {}

			if thread then
				task.cancel(thread)
			end
		end,
		onStepped = function(callback2)
			v3[callback2] = true
			return function()
				v3[callback2] = nil
			end
		end
	}
end

return createLazyInstanceCollector
