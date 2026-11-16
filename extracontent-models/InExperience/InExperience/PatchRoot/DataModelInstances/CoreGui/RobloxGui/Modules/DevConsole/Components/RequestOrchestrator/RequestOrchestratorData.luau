local RequestOrchestratorData = {}

local function closeAttempt(p) -- 3 equivalent calls inferred from this helper
	local attempts = p.attempts
	local v = attempts and attempts[#attempts]

	if v and not v.finish then
		v.finish = tick()
	end
end

function RequestOrchestratorData.new()
	return {
		now = tick(),
		allTypes = {},
		typeSeen = {},
		batchesByType = {},
		queues = {},
		observedMaxByType = {},
		lastBatchSizeByType = {},
		cacheByType = {}
	}
end

function RequestOrchestratorData.observeType(p, p2)
	if p.typeSeen[p2] then
		return nil
	end

	p.typeSeen[p2] = true
	table.insert(p.allTypes, p2)
	return #p.allTypes
end

function RequestOrchestratorData.observeTypes(p, list)
	local result = {}

	for _, item in ipairs(list) do
		local v = RequestOrchestratorData.observeType(p, item)

		if v then
			table.insert(result, v)
		end
	end

	return result
end

function RequestOrchestratorData.batchesFor(p, p2)
	if not p.batchesByType[p2] then
		p.batchesByType[p2] = {}
	end

	return p.batchesByType[p2]
end

function RequestOrchestratorData.registerBatch(p, p2, p3)
	local batchesFor = RequestOrchestratorData.batchesFor(p, p2)
	batchesFor[tostring(p3.batchId)] = {
		state = "pending",
		sentTime = nil,
		settleTime = nil,
		operationCount = 0,
		attempts = {}
	}
end

function RequestOrchestratorData.openSendAttempt(p, p2, p3)
	local batchesFor = RequestOrchestratorData.batchesFor(p, p2)
	local batchId = tostring(p3.batchId)
	local v = batchesFor[batchId]

	if not v then
		v = { attempts = {} }
		batchesFor[batchId] = v
	end

	v.state = "inflight"
	local now = tick()
	v.attempts = v.attempts or {}
	table.insert(v.attempts, { start = now, finish = nil })
	v.sentTime = v.sentTime or now
	v.operationCount = p3.operationCount or 0
end

function RequestOrchestratorData.settleBatch(p, p2, data)
	local batch = p.batchesByType[p2]

	if not batch then
		return
	end

	local v = batch[tostring(data.batchId)]

	if not v then
		return
	end

	closeAttempt(v) -- inferred equivalent call
	v.settleTime = tick()
	v.state = data.success and "success" or "failure"
	v.httpStatus = data.httpStatus
end

function RequestOrchestratorData.reclassifyOnRetry(p, p2, p3)
	local batch = p.batchesByType[p2]

	if not batch then
		return
	end

	local v = batch[tostring(p3.batchId)]

	if not v then
		return
	end

	closeAttempt(v) -- inferred equivalent call

	if v.state == "pending" and not v.sentTime then
		local v2 = batch[tostring(p3.batchId - 1)]

		if v2 and v2.state == "failure" then
			v2.state = "retrying"
		end
	end

	v.state = "retrying"
	v.attemptNumber = p3.attemptNumber
end

function RequestOrchestratorData.markExhausted(p, p2, p3)
	local batch = p.batchesByType[p2]

	if not batch then
		return
	end

	local v = batch[tostring(p3.batchId)]

	if v then
		closeAttempt(v) -- inferred equivalent call
		v.state = "exhausted"
		v.settleTime = tick()
	end
end

function RequestOrchestratorData.trackQueueOnCreated(p, p2, p3)
	if p3.maxBatchSize then
		p.observedMaxByType[p2] = p3.maxBatchSize
	end

	local queue = p.queues[p2]

	if queue then
		queue.batchId = p3.batchId
	else
		p.queues[p2] = { batchId = p3.batchId, ops = {}, createdTime = tick(), retryOps = {} }
	end
end

function RequestOrchestratorData.drainQueueOnSent(p, p2, p3)
	local queue = p.queues[p2]
	local operationCount = p3.operationCount or queue and #queue.retryOps + #queue.ops or 0
	p.lastBatchSizeByType[p2] = operationCount

	if queue then
		for _ = 1, operationCount do
			if #queue.retryOps > 0 then
				table.remove(queue.retryOps, 1)
			elseif #queue.ops > 0 then
				table.remove(queue.ops, 1)
			else
				break
			end
		end

		if #queue.ops == 0 and #queue.retryOps == 0 then
			p.queues[p2] = nil
		end
	end
end

function RequestOrchestratorData.requeueRetryOps(p, p2, p3)
	local v = p.queues[p2]

	if not v then
		v = { batchId = p3.batchId, ops = {}, createdTime = tick(), retryOps = {} }

		p.queues[p2] = v
	end

	local v2 = p.lastBatchSizeByType[p2] or p3.operationCount or 0
	v.retryOps = {}

	for i = 1, v2 do
		table.insert(v.retryOps, "retry-" .. i)
	end
end

function RequestOrchestratorData.clearQueueOnExhausted(p, p2)
	local queue = p.queues[p2]

	if queue then
		queue.retryOps = {}

		if #queue.ops == 0 then
			p.queues[p2] = nil
		end
	end
end

function RequestOrchestratorData.enqueueOperation(p, p2, p3)
	local v = p.queues[p2]

	if not v then
		v = { batchId = p3.batchId, ops = {}, createdTime = tick(), retryOps = {} }
		p.queues[p2] = v
	end

	table.insert(v.ops, p3.message or "?")
end

function RequestOrchestratorData.recordCacheItemAdded(p, p2, p3)
	local v = p.cacheByType[p2]

	if not v then
		v = { items = {} }
		p.cacheByType[p2] = v
	end

	local message = p3.message or ""

	for _, item in ipairs(v.items) do
		if item.key == message then
			return
		end
	end

	table.insert(v.items, { key = message, lastHitTime = nil })

	if #v.items > 48 then
		table.remove(v.items, 1)
	end
end

function RequestOrchestratorData.recordCacheHit(p, p2, p3)
	local v = p.cacheByType[p2]

	if not v then
		v = { items = {} }
		p.cacheByType[p2] = v
	end

	local message = p3.message or ""

	for i = #v.items, 1, -1 do
		if v.items[i].key == message then
			v.items[i].lastHitTime = tick()
			return
		end
	end

	table.insert(v.items, { key = message, lastHitTime = tick() })

	if #v.items > 48 then
		table.remove(v.items, 1)
	end
end

function RequestOrchestratorData:advanceTime()
	self.now = tick()
	local v = self.now - 30

	for _, batch in pairs(self.batchesByType) do
		for k, v2 in pairs(batch) do
			if v2.settleTime and v2.settleTime < v then
				batch[k] = nil
			end
		end
	end
end

return RequestOrchestratorData
