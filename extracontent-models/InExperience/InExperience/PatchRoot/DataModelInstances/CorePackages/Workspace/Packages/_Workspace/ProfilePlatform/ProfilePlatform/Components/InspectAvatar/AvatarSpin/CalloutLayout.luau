require(script.Parent.ViewportProjection)

local v = { 16, 44, 72 }

local function rectOverlapArea(data, data2, p: number)
	return math.max(0, math.min(data.x + data.width + p, data2.x + data2.width + p) - math.max(data.x - p, data2.x - p)) * math.max(
		0,
		math.min(data.y + data.height + p, data2.y + data2.height + p) - math.max(data.y - p, data2.y - p)
	)
end

local function pointInRect(p: number, p2: number, data, p3: number): boolean -- 5 equivalent calls inferred from this helper
	return data.x - p3 <= p and p <= data.x + data.width + p3 and data.y - p3 <= p2 and p2 <= data.y + data.height + p3
end

local function clipEdge(p: number, p2: number, p3: number, p4: number)
	if p == 0 then
		return p2 > 0, p3, p4
	end

	local v2 = p2 / p

	if p < 0 then
		p3 = math.max(p3, v2)
	else
		p4 = math.min(p4, v2)
	end

	return p3 < p4, p3, p4
end

local function segmentCrossesRect(p: number, p2: number, p3: number, p4: number, data)
	local v2 = p3 - p
	local v3 = p4 - p2
	local v4 = -v2
	local v5 = p - data.x
	local maxValue = 0
	local minValue = 1
	local v6

	if v4 == 0 then
		v6 = v5 > 0
	else
		local v7 = v5 / v4

		if v4 < 0 then
			maxValue = math.max(maxValue, v7)
		else
			minValue = math.min(minValue, v7)
		end

		v6 = maxValue < minValue
	end

	if v6 then
		local v7 = data.x + data.width - p

		if v2 == 0 then
			v6 = v7 > 0
		else
			local v8 = v7 / v2

			if v2 < 0 then
				maxValue = math.max(maxValue, v8)
			else
				minValue = math.min(minValue, v8)
			end

			v6 = maxValue < minValue
		end
	end

	if v6 then
		local v7 = -v3
		local v8 = p2 - data.y

		if v7 == 0 then
			v6 = v8 > 0
		else
			local v9 = v8 / v7

			if v7 < 0 then
				maxValue = math.max(maxValue, v9)
			else
				minValue = math.min(minValue, v9)
			end

			v6 = maxValue < minValue
		end
	end

	if not v6 then
		return v6
	end

	local v7 = data.y + data.height - p2

	if v3 == 0 then
		return v7 > 0
	end

	local v8 = v7 / v3

	if v3 < 0 then
		maxValue = math.max(maxValue, v8)
	else
		minValue = math.min(minValue, v8)
	end

	return maxValue < minValue
end

local function orientation(p: number, p2: number, p3: number, p4: number, p5: number, p6: number): number -- 4 equivalent calls inferred from this helper
	local v2 = (p3 - p) * (p6 - p2) - (p4 - p2) * (p5 - p)

	if v2 > 0 then
		return 1
	end

	return if v2 < 0 then -1 else 0
end

local function segmentsCross(p: number, p2: number, p3: number, p4: number, anchorX: number, anchorY: number, attachX: number, attachY: number): boolean
	local v2 = orientation(p, p2, p3, p4, anchorX, anchorY) -- inferred equivalent call
	return v2 * orientation(p, p2, p3, p4, attachX, attachY) < 0 -- inferred equivalent call
		and orientation(anchorX, anchorY, attachX, attachY, p, p2) * orientation(anchorX, anchorY, attachX, attachY, p3, p4) < 0 -- inferred equivalent call
end

local function optionsFor(data, x: number, y: number, margin: number, p: number)
	local result = {}

	for _, v2 in v do
		for _, directionX in { -1, 1 } do
			local v3

			if directionX > 0 then
				v3 = data.x + v2
			else
				v3 = data.x - v2 - x
			end

			local v4

			if directionX > 0 then
				v4 = data.x + v2 * 0.4
			else
				v4 = data.x - v2 * 0.4 - x
			end

			table.insert(result, {
				key = `s{directionX}{v2}`,
				directionX = directionX,
				x = v3,
				y = data.y - y / 2
			})

			table.insert(result, {
				key = `u{directionX}{v2}`,
				directionX = directionX,
				x = v4,
				y = data.y - y - v2 * 0.7
			})

			table.insert(result, {
				key = `d{directionX}{v2}`,
				directionX = directionX,
				x = v4,
				y = data.y + v2 * 0.7
			})
		end
	end

	table.insert(result, {
		key = "gl",
		directionX = -1,
		x = margin,
		y = data.y - y / 2
	})
	table.insert(result, {
		key = "gr",
		directionX = 1,
		x = p,
		y = data.y - y / 2
	})
	return result
end

local CalloutLayout = {}

function CalloutLayout.findProblems(list, items)
	local v2 = {}

	for _, item in items do
		v2[item.id] = item
	end

	local v3 = {}

	for k, item in list do
		local v4 = v2[item.id]
		local anchorX = if v4 then v4.x else item.anchorX
		local anchorY = if v4 then v4.y else item.anchorY
		v3[k] = {
			anchorX = anchorX,
			anchorY = anchorY,
			attachX = math.clamp(anchorX, item.x, item.x + item.width),
			attachY = math.clamp(anchorY, item.y, item.y + item.height)
		}
	end

	local problems = {}

	for k, item in list do
		local v4 = v3[k]

		for _, item2 in items do
			local v5 = item2.id == item.id and 6 or 4

			if pointInRect(item2.x, item2.y, item, v5) then -- inferred equivalent call
				table.insert(problems, "coversPin")
			end
		end

		for i = k + 1, #list do
			local item2 = list[i]
			local v5 = v3[i]

			if rectOverlapArea(item, item2, 0) > 0 then
				table.insert(problems, "overlap")
			end

			if segmentsCross(
				v4.anchorX,
				v4.anchorY,
				v4.attachX,
				v4.attachY,
				v5.anchorX,
				v5.anchorY,
				v5.attachX,
				v5.attachY
			) then
				table.insert(problems, "leadersCross")
			end

			if not (segmentCrossesRect(v4.anchorX, v4.anchorY, v4.attachX, v4.attachY, item2) or segmentCrossesRect(
				v5.anchorX,
				v5.anchorY,
				v5.attachX,
				v5.attachY,
				item
			)) then
				continue
			end

			table.insert(problems, "leaderThroughCard")
		end
	end

	return problems
end

function CalloutLayout.layout(p, data)
	local clone = table.clone(p)
	table.sort(clone, function(a, b)
		local v2 = a.id == data.focusId

		if v2 ~= (b.id == data.focusId) then
			return v2
		end

		if a.score == b.score then
			return a.id < b.id
		end

		return a.score > b.score
	end)

	local v2 = {}

	while #clone > data.maxCount do
		table.insert(v2, 1, (table.remove(clone)))
	end

	local x = data.cardSize.X
	local y = data.cardSize.Y
	local margin = data.margin
	local v3 = data.viewportSize.X - data.margin - x
	local top = data.top
	local v4 = data.viewportSize.Y - data.bottom - y
	local v5 = data.viewportSize.X / 2
	local pins = data.pins or {}

	local function place(data2, items, p2: string?)
		local v6 = nil

		for _, v7 in optionsFor(data2, x, y, margin, v3) do
			if not (not p2 or v7.key == p2) then
				continue
			end

			local v8 = math.clamp(v7.x, margin, (math.max(margin, v3)))
			local v9 = math.clamp(v7.y, top, (math.max(top, v4)))
			local v10 = { x = v8, y = v9, width = x, height = y }
			local attachX = math.clamp(data2.x, v8, v8 + x)
			local attachY = math.clamp(data2.y, v9, v9 + y)

			local v11 = math.abs(v8 - v7.x) + math.abs(v9 - v7.y)

			if pointInRect(data2.x, data2.y, v10, 6) then -- inferred equivalent call
				v11 += 5000
			end

			local v12 = math.sign(v8 + x / 2 - data2.x)

			for _, item in items do
				v11 += rectOverlapArea(v10, item, data.gap) * 2400 / (x * y)

				if rectOverlapArea(v10, item, 0) > 0 then
					v11 += 1000
				end

				if segmentsCross(
					data2.x,
					data2.y,
					attachX,
					attachY,
					item.anchorX,
					item.anchorY,
					item.attachX,
					item.attachY
				) then
					v11 += 1000
				end

				if pointInRect(item.anchorX, item.anchorY, v10, 4) then -- inferred equivalent call
					v11 += 1000
				end

				if
					segmentCrossesRect(data2.x, data2.y, attachX, attachY, item)
					or segmentCrossesRect(item.anchorX, item.anchorY, item.attachX, item.attachY, v10)
				then
					v11 += 1000
				end

				if not (v12 == math.sign(item.x + x / 2 - item.anchorX) and (data2.y - item.anchorY) * (v9 - item.y) < 0) then
					continue
				end

				v11 += 120
			end

			for _, pin in pins do
				if not (pin.id ~= data2.id and pointInRect(pin.x, pin.y, v10, 4)) then -- inferred equivalent call
					continue
				end

				v11 += 1000
			end

			if data.avatarRect then
				v11 += rectOverlapArea(v10, data.avatarRect, 0) * 200 / (x * y)
			end

			local cost = v11 + math.sqrt((attachX - data2.x) ^ 2 + (attachY - data2.y) ^ 2) * 0.5

			if v7.directionX * (data2.x - v5) < -8 then
				cost += 22
			end

			if data.previousKeys and data.previousKeys[data2.id] == v7.key then
				cost -= 30
			end

			if v6 == nil or cost < v6.cost then
				v6 = {
					id = data2.id,
					x = v8,
					y = v9,
					width = x,
					height = y,
					anchorX = data2.x,
					anchorY = data2.y,
					attachX = attachX,
					attachY = attachY,
					key = v7.key,
					cost = cost
				}
			end
		end

		return v6
	end

	local v6 = {}

	for _, v7 in clone do
		table.insert(v6, place(v7, v6))
	end

	local function othersOf(i: number) -- 2 equivalent calls inferred from this helper
		local result = {}

		for k, v7 in v6 do
			if k ~= i then
				table.insert(result, v7)
			end
		end

		return result
	end

	local function refine()
		for _ = 1, 2 do
			for i = 1, #v6 do
				v6[i] = place(clone[i], othersOf(i)) -- inferred equivalent call
			end
		end

		for i = 1, #v6 do
			v6[i] = place(clone[i], othersOf(i), v6[i].key) -- inferred equivalent call
		end
	end
	refine()

	local function isCoveredByFocus(p2): boolean
		for _, v7 in v6 do
			if v7.id == data.focusId and v7 ~= p2 and pointInRect(p2.anchorX, p2.anchorY, v7, 4) then -- inferred equivalent call
				return true
			end
		end

		return false
	end

	while true do
		local v7 = nil

		for k, v8 in v6 do
			if not (v8.id ~= data.focusId and (v8.cost > 520 or isCoveredByFocus(v8)) and (v7 == nil or clone[k].score <= clone[v7].score)) then
				continue
			end

			v7 = k
		end

		if v7 == nil then
			break
		end

		table.remove(clone, v7)
		table.remove(v6, v7)
		local v8 = table.remove(v2, 1)

		if v8 then
			table.insert(clone, v8)
			table.insert(v6, place(v8, v6))
		end

		refine()
	end

	local result = {}

	for _, v7 in v6 do
		table.insert(result, {
			id = v7.id,
			x = v7.x,
			y = v7.y,
			width = v7.width,
			height = v7.height,
			anchorX = v7.anchorX,
			anchorY = v7.anchorY,
			attachX = v7.attachX,
			attachY = v7.attachY,
			key = v7.key
		})
	end

	return result
end

return CalloutLayout
