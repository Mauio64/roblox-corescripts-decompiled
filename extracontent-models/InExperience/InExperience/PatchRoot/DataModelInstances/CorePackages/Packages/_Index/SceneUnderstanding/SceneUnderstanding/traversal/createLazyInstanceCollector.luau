local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local DataModelTraversalOptions = require(SceneUnderstanding.options.DataModelTraversalOptions)

local function createLazyInstanceCollector(t1: {[any]: any}, p1: ((...any) -> ...any)?, p2) -- line: 9
	-- upvalues: DataModelTraversalOptions (copy)
	local v7 = DataModelTraversalOptions.new(p2)
	local u8 = false
	local t2 = {}
	local n1 = 0
	local t3 = {}
	local thread = nil
	local t4 = {}
	local t5 = {}

	local function getBatchCount() -- line: 24
		-- upvalues: t4 (copy), v7 (copy)
		return (math.min(#t4, v7.instanceProcessingLimit))
	end
	local function onAncestryChanged(p3) -- line: 28
		-- upvalues: t2 (copy)
		if p3.Parent == nil then
			local v21 = table.find(t2, p3)

			if v21 then
				table.remove(t2, v21)
			end
		end
	end
	local function processStack() -- line: 37
		-- upvalues: t4 (copy), v7 (copy), p1 (copy), t2 (copy), t3 (copy), onAncestryChanged (copy), n1 (ref), t5 (ref), u8 (ref)
		local v22 = math.min(#t4, v7.instanceProcessingLimit)

		for _ = 1, v22 do
			local v24 = table.remove(t4, #t4)

			if v24 then
				if not p1 or p1(v24) then
					table.insert(t2, v24)
					table.insert(t3, v24.AncestryChanged:Connect(onAncestryChanged))
				end

				for _, child in v24:GetChildren() do
					table.insert(t4, child)
				end
			end
		end

		n1 += v22

		for v27 in t5 do
			task.spawn(function() -- line: 58
				-- upvalues: v27 (copy), t2 (copy)
				v27(t2)
			end)
		end

		if #t4 == 0 then
			u8 = false

			return false
		end

		if n1 >= v7.instanceProcessingLimit then
			n1 = 0

			return true
		end

		return false
	end
	local function startProcessingLoop() -- line: 80
		-- upvalues: u8 (ref), t4 (copy), v7 (copy), processStack (copy), thread (ref)
		if u8 or math.min(#t4, v7.instanceProcessingLimit) == 0 then
			return
		end

		u8 = true
		processStack()
		thread = task.spawn(function() -- line: 89
			-- upvalues: u8 (ref), processStack (copy)
			task.wait()

			while u8 do
				local v37 = processStack()

				if u8 and v37 then
					task.wait()
				end
			end
		end)
	end
	local function onDescendantAdded(p4) -- line: 102
		-- upvalues: t4 (copy), u8 (ref), v7 (copy), processStack (copy), thread (ref)
		table.insert(t4, p4)

		if not u8 and not u8 then
			if math.min(#t4, v7.instanceProcessingLimit) == 0 then
				return
			end

			u8 = true
			processStack()
			thread = task.spawn(function() -- line: 89
				-- upvalues: u8 (ref), processStack (copy)
				task.wait()

				while u8 do
					local v38 = processStack()

					if u8 and v38 then
						task.wait()
					end
				end
			end)
		end
	end

	return {
		setInstancesProcessedPerFrame = function(n2: number) -- line: 143
			-- upvalues: v7 (copy), u8 (ref), t4 (copy), processStack (copy), thread (ref)
			v7.instanceProcessingLimit = math.clamp(n2, 0, 1e999)

			if not u8 then
				if math.min(#t4, v7.instanceProcessingLimit) == 0 then
					return
				end

				u8 = true
				processStack()
				thread = task.spawn(function() -- line: 89
					-- upvalues: u8 (ref), processStack (copy)
					task.wait()

					while u8 do
						local v40 = processStack()

						if u8 and v40 then
							task.wait()
						end
					end
				end)
			end
		end,
		listen = function() -- line: 110
			-- upvalues: t1 (copy), t3 (copy), onDescendantAdded (copy), t4 (copy), u8 (ref), v7 (copy), processStack (copy), thread (ref)
			for _, v30 in t1 do
				table.insert(t3, v30.DescendantAdded:Connect(onDescendantAdded))

				for _, child in v30:GetChildren() do
					table.insert(t4, child)
				end
			end

			if not u8 then
				if math.min(#t4, v7.instanceProcessingLimit) == 0 then
					return
				end

				u8 = true
				processStack()
				thread = task.spawn(function() -- line: 89
					-- upvalues: u8 (ref), processStack (copy)
					task.wait()

					while u8 do
						local v39 = processStack()

						if u8 and v39 then
							task.wait()
						end
					end
				end)
			end
		end,
		get = function() -- line: 148
			-- upvalues: t2 (copy)
			return t2
		end,
		destroy = function() -- line: 129
			-- upvalues: u8 (ref), t3 (copy), t5 (ref), thread (ref)
			u8 = false

			for _, v35 in t3 do
				v35:Disconnect()
			end

			t5 = {}

			if thread then
				task.cancel(thread)
			end
		end,
		onStepped = function(p5: ((...any) -> ...any)) -- line: 122
			-- upvalues: t5 (ref)
			t5[p5] = true

			return function() -- line: 124
				-- upvalues: t5 (ref), p5 (copy)
				t5[p5] = nil
			end
		end
	}
end

return createLazyInstanceCollector
