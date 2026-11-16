local messageIdSet = {}

local function shouldReportMessageRender(p): boolean
	if not p.isHistorical then
		return true
	end

	if messageIdSet[p.messageId] then
		return false
	end

	messageIdSet[p.messageId] = true
	return true
end

return shouldReportMessageRender
