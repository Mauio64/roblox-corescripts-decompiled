local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Parent.Constants)
local Mono = Constants.Font.Mono

local v = {
	inflight = Color3.fromRGB(255, 165, 0),
	retrying = Color3.fromRGB(255, 165, 0),
	success = Color3.fromRGB(66, 135, 245),
	failure = Color3.fromRGB(220, 50, 50),
	exhausted = Color3.fromRGB(220, 50, 50),
	queueOp = Color3.fromRGB(0, 149, 235),
	queueRetry = Color3.fromRGB(239, 68, 68),
	batchOutline = Color3.fromRGB(255, 171, 37),
	labelText = Color3.fromRGB(200, 200, 200),
	queueText = Color3.fromRGB(160, 160, 160),
	cacheHot = Color3.fromRGB(100, 255, 180),
	cacheCold = Color3.fromRGB(60, 120, 95),
	cacheEmpty = Constants.Color.BaseGray,
	idleText = Color3.fromRGB(70, 70, 70),
	timelineTick = Color3.fromRGB(50, 50, 50),
	timelineBackground = Color3.fromRGB(20, 20, 20),
	rowBackground = Color3.fromRGB(28, 28, 28)
}

local function lerp(fromX, toX, p) -- 2 equivalent calls inferred from this helper
	return fromX + (toX - fromX) * p
end

local function smooth(p) -- 2 equivalent calls inferred from this helper
	return p * p * (3 - 2 * p)
end

local function renderTypeLabel(orchestratorType)
	return Roact.createElement("TextLabel", {
		Size = UDim2.new(0, 130, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = orchestratorType,
		TextColor3 = v.labelText,
		TextSize = 12,
		Font = Mono,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top
	})
end

local function resolveMaxSize(props) -- 1 equivalent call inferred from this helper
	local observedMaxBatchSize = props.observedMaxBatchSize

	if observedMaxBatchSize and observedMaxBatchSize > 0 then
		return observedMaxBatchSize
	end

	return nil
end

local function renderBatchOutline(props, maxSize)
	local v2 = math.min(maxSize, 30)
	local panelWidth = props.panelWidth

	if panelWidth and panelWidth > 0 then
		v2 = math.min(v2, (math.floor((panelWidth - 374 - 8 - 8 + 3) / 19)))
	end

	local v3 = math.max(1, v2)
	local v4 = v3 < maxSize

	local v5 = v3 * 16 + math.max(0, v3 - 1) * 3 + 8

	local createElement = Roact.createElement
	local v6 = {
		Size = UDim2.new(0, v5, 0, 21),
		Position = UDim2.new(0, 374, 0, 1.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v7 = {
		Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
		Stroke = Roact.createElement("UIStroke", {
			Color = v.batchOutline,
			Thickness = 1.5,
			Transparency = 0.15
		}),
		Overflow = 0
	}
	local overflow

	if v4 then
		overflow = Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -2, 0.5, 0),
			Size = UDim2.new(0, 10, 1, 0),
			BackgroundTransparency = 1,
			Text = "»",
			TextColor3 = v.batchOutline,
			TextSize = 12,
			Font = Mono,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	end

	v7.Overflow = overflow
	return createElement("Frame", v6, v7)
end

local function renderIdleQueue()
	return Roact.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "idle",
		TextColor3 = v.idleText,
		TextSize = 10,
		Font = Mono,
		TextXAlignment = Enum.TextXAlignment.Left
	})
end

local function renderCacheChildren(cache, now)
	local v2 = not cache and {} or cache.items
	local count = #v2
	local children = {
		Count = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 12),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Text = string.format("cache %d", count),
			TextColor3 = v.queueText,
			TextSize = 10,
			Font = Mono,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	}

	for i, v3 in ipairs(v2) do
		if i > 48 then
			break
		end

		local v4 = (i - 1) % 12
		local v5 = math.floor((i - 1) / 12)

		local v6 = not v3.lastHitTime and 0 or math.clamp(1 - (now - v3.lastHitTime) / 0.6, 0, 1)

		children["c" .. i] = Roact.createElement("Frame", {
			Position = UDim2.new(0, v4 * 10, 0, v5 * 10 + 12),
			Size = UDim2.new(0, 8, 0, 8),
			BackgroundColor3 = v.cacheCold:Lerp(v.cacheHot, v6),
			BorderSizePixel = 0
		}, {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 2) })
		})
	end

	for i = count + 1, 48 do
		local v3 = math.floor((i - 1) / 12)
		children["e" .. i] = Roact.createElement("Frame", {
			Position = UDim2.new(0, (i - 1) % 12 * 10, 0, v3 * 10 + 12),
			Size = UDim2.new(0, 8, 0, 8),
			BackgroundColor3 = v.cacheEmpty,
			BorderSizePixel = 0
		}, {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 2) })
		})
	end

	return children
end

local function renderTimelineChildren(batches, now)
	local v2 = now - 30
	local children = {}

	for k, item in pairs(batches) do
		local attempts = item.attempts or {}
		local v3 = #attempts

		for i, attempt in ipairs(attempts) do
			local finish = attempt.finish or now

			if not (v2 <= finish) then
				continue
			end

			local v4 = math.max(0, (attempt.start - v2) / 30)
			local v5 = math.min(1, (finish - v2) / 30)

			if not (v4 < v5) then
				continue
			end

			local backgroundColor

			if i == v3 then
				backgroundColor = v[item.state] or v.inflight
			else
				backgroundColor = v.retrying
			end

			children["batch_" .. k .. "_" .. i] = Roact.createElement("Frame", {
				Position = UDim2.new(v4, 0, 0, 2),
				Size = UDim2.new(v5 - v4, 0, 1, -4),
				BackgroundColor3 = backgroundColor,
				BorderSizePixel = 0
			}, {
				Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) })
			})
		end
	end

	for i = 0, 2 do
		children["tick_" .. i] = Roact.createElement("Frame", {
			Position = UDim2.new(1 - i * 10 / 30, 0, 0, 0),
			Size = UDim2.new(0, 1, 1, 0),
			BackgroundColor3 = v.timelineTick,
			BorderSizePixel = 0
		})
	end

	return children
end

local extended = Roact.Component:extend("OrchestratorRow")

function extended:init()
	self.opAnim = {}
end

function extended:renderQueueChildren(props, p, start)
	local v2 = {}
	local children = {}

	for _, id in ipairs(props.retryOps or {}) do
		table.insert(v2, { id = id, isRetry = true })
	end

	for _, id in ipairs(props.ops or {}) do
		table.insert(v2, { id = id, isRetry = false })
	end

	local v3 = start - props.createdTime
	local count = #v2

	local createElement = Roact.createElement
	local v4 = {
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 120, 1, 0),
		BackgroundTransparency = 1,
		Text = 0,
		TextColor3 = 0,
		TextSize = 10,
		Font = 0,
		TextXAlignment = 0
	}
	local text

	if p then
		text = string.format("%d/%d ops  %.1fs", count, p, v3)
	else
		text = string.format("%d ops  %.1fs", count, v3)
	end

	v4.Text = text

	v4.TextColor3 = v.queueText

	v4.Font = Mono
	v4.TextXAlignment = Enum.TextXAlignment.Left
	children.Info = createElement("TextLabel", v4)

	local set = {}

	for i, v5 in ipairs(v2) do
		if i > 30 then
			break
		end

		local v6 = v5.id

		if set[v6] then
			v6 ..= "#" .. i
		end

		set[v6] = true

		local toX = 120 + (i - 1) * 19
		local v7 = self.opAnim[v6]

		if v7 then
			if v7.toX ~= toX then
				v7.fromX = lerp(v7.fromX, v7.toX, smooth(math.clamp((start - v7.start) / 0.25, 0, 1))) -- inferred equivalent call
				v7.toX = toX
				v7.start = start
			end
		else
			local fromX

			if v5.isRetry then
				fromX = toX - 19
			else
				fromX = toX
			end

			v7 = { fromX = fromX, toX = toX, start = start }
			self.opAnim[v6] = v7
		end

		local v8 = lerp(v7.fromX, v7.toX, smooth(math.clamp((start - v7.start) / 0.25, 0, 1))) -- inferred equivalent call

		local backgroundColor = v.queueOp
		local backgroundTransparency

		if v5.isRetry then
			backgroundColor = v.queueRetry
			backgroundTransparency = (math.sin(start * 7) * 0.5 + 0.5) * 0.75
		else
			backgroundTransparency = 0
		end

		children["op_" .. v6] = Roact.createElement("Frame", {
			Position = UDim2.new(0, v8, 0.5, -8),
			Size = UDim2.new(0, 16, 0, 16),
			BackgroundColor3 = backgroundColor,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0
		}, {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 3) })
		})
	end

	for k in pairs(self.opAnim) do
		if not set[k] then
			self.opAnim[k] = nil
		end
	end

	return children
end

function extended:render()
	local orchestratorType = self.props.orchestratorType
	local batches = self.props.batches
	local queue = self.props.queue
	local now = self.props.now
	local size = self.props.size
	local layoutOrder = self.props.layoutOrder

	local children = {}

	children.Label = renderTypeLabel(orchestratorType)

	children.CacheGrid = Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(0, 120, 1, 0),
			Position = UDim2.new(0, 134, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true
		},
		renderCacheChildren(self.props.cache, now)
	)

	local maxSize = resolveMaxSize(self.props) -- inferred equivalent call

	if maxSize then
		children.BatchOutline = renderBatchOutline(self.props, maxSize)
	end

	local v2

	if queue then
		v2 = self:renderQueueChildren(queue, maxSize, now)
	else
		self.opAnim = {}
		v2 = { Idle = renderIdleQueue() }
	end

	children.Queue = Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, -258, 0, 24),
			Position = UDim2.new(0, 258, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true
		},
		v2
	)

	children.Timeline = Roact.createElement("Frame", {
		Size = UDim2.new(1, -258, 0, 28),
		Position = UDim2.new(0, 258, 0, 24),
		BackgroundColor3 = v.timelineBackground,
		BorderSizePixel = 0,
		ClipsDescendants = true
	}, renderTimelineChildren(batches, now))

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundColor3 = v.rowBackground,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder
		},
		children
	)
end

return extended
