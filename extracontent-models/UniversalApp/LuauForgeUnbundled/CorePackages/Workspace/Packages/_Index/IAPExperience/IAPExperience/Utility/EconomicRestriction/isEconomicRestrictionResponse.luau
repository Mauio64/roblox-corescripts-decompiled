return function(data)
	local v5

	if data == nil or type(data) ~= "table" then
		v5 = false
	elseif data.failureReason == nil or data.expirationTimeInMinutes == nil then
		v5 = not (data.FailureReason == nil) and data.ExpirationTimeInMinutes ~= nil
	else
		v5 = true
	end

	return v5
end
