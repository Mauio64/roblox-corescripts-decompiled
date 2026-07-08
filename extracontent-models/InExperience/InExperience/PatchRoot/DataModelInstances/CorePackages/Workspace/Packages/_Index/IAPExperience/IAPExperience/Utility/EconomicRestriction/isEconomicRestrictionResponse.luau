return function(p1) -- line: 8
	return p1 ~= nil and (type(p1) == "table" and (p1.failureReason ~= nil and p1.expirationTimeInMinutes ~= nil or p1.FailureReason ~= nil and p1.ExpirationTimeInMinutes ~= nil))
end
