local function resolveCapacity(value: number?) -- 1 equivalent call inferred from this helper
	if value == nil then
		return 256
	elseif value == 1e999 then
		return nil
	end

	local v = type(value) == "number" and value >= 0 and value < 1e999 and value % 1 == 0
	assert(v, "Layout.measured: detachedMeasurementCapacity must be zero, a positive integer, or math.huge")

	return value
end

return {
	new = function(p: number?)
		p = resolveCapacity(p) -- inferred equivalent call
		local v = {}
		local v2 = nil
		local previous = nil
		local v3 = 0

		local function unlink(state) -- 3 equivalent calls inferred from this helper
			if state.previous == nil then
				v2 = state.next
			else
				state.previous.next = state.next
			end

			if state.next == nil then
				previous = state.previous
			else
				state.next.previous = state.previous
			end

			state.previous = nil
			state.next = nil
		end

		local function append(nextNode) -- 2 equivalent calls inferred from this helper
			nextNode.previous = previous

			if previous == nil then
				v2 = nextNode
			else
				previous.next = nextNode
			end

			previous = nextNode
		end

		return {
			put = function(p2: string, p3: number)
				if p == 0 then
					return
				end

				local nextNode = v[p2]

				if nextNode == nil then
					local nextNode2 = { key = p2, value = p3, previous = nil, next = nil }

					v[p2] = nextNode2
					append(nextNode2) -- inferred equivalent call
					v3 += 1

					if p ~= nil and p < v3 then
						local v4 = v2
						unlink(v4) -- inferred equivalent call
						v[v4.key] = nil
						v3 -= 1
					end
				else
					nextNode.value = p3
					unlink(nextNode) -- inferred equivalent call
					append(nextNode) -- inferred equivalent call
				end
			end,
			take = function(p2: string)
				local v4 = v[p2]

				if v4 == nil then
					return nil
				end

				unlink(v4) -- inferred equivalent call
				v[p2] = nil
				v3 -= 1
				return v4.value
			end
		}
	end
}
