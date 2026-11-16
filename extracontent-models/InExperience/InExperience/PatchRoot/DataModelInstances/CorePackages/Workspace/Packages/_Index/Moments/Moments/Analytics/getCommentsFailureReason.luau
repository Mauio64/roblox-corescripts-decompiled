local v = {
	AuthenticationRequired = "authentication_required",
	CommentsEndpointDisabled = "endpoint_disabled",
	CommentsDisabledByCreator = "comments_disabled",
	MomentUnavailable = "moment_unavailable",
	MomentNotFound = "moment_unavailable",
	MomentNotVisible = "moment_unavailable",
	ViewerNotEligibleToRead = "not_eligible",
	ViewerNotEligibleToWrite = "not_eligible",
	TextFilterRejected = "text_rejected",
	RateLimited = "rate_limited",
	InvalidCursor = "invalid_cursor",
	InvalidRequest = "invalid_request"
}

local function getCommentsFailureReason(p: string?, p2: number?)
	if p ~= nil and v[p] ~= nil then
		return v[p]
	end

	if p2 == 408 or p2 == 504 then
		return "timeout"
	end

	if p2 == 429 then
		return "rate_limited"
	elseif p2 == 401 then
		return "authentication_required"
	end

	if p2 ~= nil and p2 >= 500 then
		return "server_error"
	end

	if p2 ~= nil and p2 >= 400 then
		return "request_rejected"
	end

	if p2 == nil then
		return "unknown"
	end

	return `unknown_{p2}`
end

return getCommentsFailureReason
