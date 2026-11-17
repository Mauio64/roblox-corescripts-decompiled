return {
	new = function(data)
		local v = {}
		local v2 = nil

		local function finish(state, reason: string, now: number, wallNow: number) -- 2 equivalent calls inferred from this helper
			state.maxGap = math.max(state.maxGap, now - state.lastPresent)
			return {
				view = state,
				timestamp = wallNow,
				duration = now - state.start,
				reason = reason
			}
		end

		return {
			sample = function(items)
				local now = data.now()
				local wallNow = data.wallNow()
				local identitySet = {}
				local v3 = {}
				local v4 = {}

				for _, item in items do
					local item2 = data.getItem(item)

					if not item2 then
						continue
					end

					local identity = data.identity(item2)

					if identitySet[identity] then
						continue
					end

					identitySet[identity] = true
					local v5 = v[identity]

					if v5 then
						v5.maxGap = math.max(v5.maxGap, now - v5.lastPresent)
						v5.lastPresent = now
						v5.count += 1
						v5.cell = item
					else
						local v6 = {
							item = item2,
							cell = item,
							uuid = data.newUuid(),
							start = now,
							startTimestamp = wallNow,
							precedingGap = not v2 and -1 or now - v2,
							lastPresent = now,
							count = 1,
							maxGap = 0
						}

						v[identity] = v6
						table.insert(v3, v6)
					end
				end

				for k, v5 in v do
					if identitySet[k] then
						continue
					end

					local item = data.getItem(v5.cell)
					table.insert(
						v4,
						finish( -- inferred equivalent call
							v5,
							item and data.identity(item) ~= k and "identityChanged" or "notVisible",
							now,
							wallNow
						)
					)
					v[k] = nil
				end

				v2 = now

				if #v4 > 0 then
					data.sendEnds(v4)
				end

				if #v3 > 0 then
					data.sendStarts(v3)
				end
			end,
			close = function(reason: string)
				local now = data.now()
				local wallNow = data.wallNow()
				local v3 = {}

				for _, v4 in v do
					table.insert(v3, finish(v4, reason, now, wallNow)) -- inferred equivalent call
				end

				table.clear(v)
				v2 = nil

				if #v3 > 0 then
					data.sendEnds(v3)
				end
			end
		}
	end
}
