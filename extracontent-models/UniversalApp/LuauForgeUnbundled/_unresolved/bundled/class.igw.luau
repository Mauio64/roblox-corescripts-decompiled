local class = {}
class.__index = class

function class.new(data)
	local rorum = data.rorum
	local parentSpanContext = data.parentSpanContext

	local v5 = {
		id = rorum.generateId(),
		start_timestamp = data.start_timestamp or DateTime.now().UnixTimestampMillis,
		end_timestamp = data.end_timestamp,
		log_type = data.log_type or "default",
		category = data.category,
		level = data.level,
		featureKey = data.featureKey,
		userImpact = data.userImpact,
		message = data.message,
		extra_metadata = data.extra_metadata,
		traceId = 0,
		spanId = 0,
		parentSpanId = 0,
		rorum = 0
	}

	local v6 = if parentSpanContext then parentSpanContext.traceId else rorum.generateTraceId()
	v5.traceId = v6
	v5.spanId = rorum.generateSpanId()
	local v7 = if parentSpanContext then parentSpanContext.spanId else nil
	v5.parentSpanId = v7

	v5.rorum = rorum

	return (setmetatable(v5, class))
end

function class.spanContext(p2)
	return { traceId = p2.traceId, spanId = p2.spanId }
end

function class:setExtraMetadata(items)
	local extra_metadata = self.extra_metadata or {}

	for k, item in items do
		extra_metadata[k] = item
	end

	self.extra_metadata = extra_metadata
	return self
end

function class:endSpan(p3)
	self.end_timestamp = p3 or DateTime.now().UnixTimestampMillis

	if self.rorum then
		self.rorum:recordCompletedSpan(self)
	end

	return self
end

function class:toDisplay()
	return {
		start_timestamp = self.start_timestamp,
		log_type = self.log_type,
		category = self.category,
		level = self.level,
		payload = {
			id = self.id,
			end_timestamp = self.end_timestamp,
			traceId = self.traceId,
			spanId = self.spanId,
			parentSpanId = self.parentSpanId,
			featureKey = self.featureKey,
			userImpact = self.userImpact,
			message = self.message,
			extra_metadata = self.extra_metadata
		}
	}
end

return class
