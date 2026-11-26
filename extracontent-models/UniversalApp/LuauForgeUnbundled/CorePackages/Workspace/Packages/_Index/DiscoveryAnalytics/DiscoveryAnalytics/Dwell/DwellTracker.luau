return {
	new = function(data)
		local v5 = {}
		local v6 = nil

		local function finish(state, p2, p3, p4)
			state.maxGap = math.max(state.maxGap, p3 - state.lastPresent)
			return {
				view = state,
				timestamp = p4,
				duration = p3 - state.start,
				reason = p2
			}
		end

		return {
			sample = function(items)
				local now = data.now()
				local wallNow = data.wallNow()
				local identitySet = {}
				local v7 = {}
				local v8 = {}

				for k, item in items do
					local item2 = data.getItem(item)

					if not item2 then
						continue
					end

					local identity = data.identity(item2)

					if identitySet[identity] then
						continue
					end

					identitySet[identity] = true
					local v9 = v5[identity]

					if v9 then
						v9.maxGap = math.max(v9.maxGap, now - v9.lastPresent)
						v9.lastPresent = now
						v9.count += 1
						v9.cell = item
					else
						local v10 = {
							item = item2,
							cell = item,
							uuid = data.newUuid(),
							start = now,
							startTimestamp = wallNow,
							precedingGap = not v6 and -1 or now - v6,
							lastPresent = now,
							count = 1,
							maxGap = 0
						}

						v5[identity] = v10
						table.insert(v7, v10)
					end
				end

				for k, v9 in v5 do
					if identitySet[k] then
						continue
					end

					local item = data.getItem(v9.cell)
					local v10 = item and data.identity(item) ~= k and "identityChanged" or "notVisible"
					v9.maxGap = math.max(v9.maxGap, now - v9.lastPresent)
					table.insert(v8, {
						view = v9,
						timestamp = wallNow,
						duration = now - v9.start,
						reason = v10
					})
					v5[k] = nil
				end

				v6 = now

				if #v8 > 0 then
					data.sendEnds(v8)
				end

				if #v7 > 0 then
					data.sendStarts(v7)
				end
			end,
			close = function(p2)
				local now = data.now()
				local wallNow = data.wallNow()
				local v7 = {}

				for k, v8 in v5 do
					v8.maxGap = math.max(v8.maxGap, now - v8.lastPresent)
					table.insert(v7, {
						view = v8,
						timestamp = wallNow,
						duration = now - v8.start,
						reason = p2
					})
				end

				table.clear(v5)
				v6 = nil

				if #v7 > 0 then
					data.sendEnds(v7)
				end
			end
		}
	end
}
