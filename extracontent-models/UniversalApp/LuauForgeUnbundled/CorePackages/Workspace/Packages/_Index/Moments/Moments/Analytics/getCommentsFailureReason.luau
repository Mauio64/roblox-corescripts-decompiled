local v5 = {
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

local function getCommentsFailureReason(p2, p3)
	if p2 ~= nil and v5[p2] ~= nil then
		return v5[p2]
	end

	if p3 == 408 or p3 == 504 then
		return "timeout"
	end

	if p3 == 429 then
		return "rate_limited"
	elseif p3 == 401 then
		return "authentication_required"
	end

	if p3 ~= nil and p3 >= 500 then
		return "server_error"
	end

	if p3 ~= nil and p3 >= 400 then
		return "request_rejected"
	end

	if p3 == nil then
		return "unknown"
	end

	return `unknown_{p3}`
end

return getCommentsFailureReason
