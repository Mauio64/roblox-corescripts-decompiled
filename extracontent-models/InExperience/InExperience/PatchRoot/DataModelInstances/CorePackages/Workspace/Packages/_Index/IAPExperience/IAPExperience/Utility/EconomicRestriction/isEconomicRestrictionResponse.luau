return function(data): boolean
	if data == nil or type(data) ~= "table" then
		return false
	elseif data.failureReason == nil or data.expirationTimeInMinutes == nil then
		if data.FailureReason == nil then
			return false
		end

		return data.ExpirationTimeInMinutes ~= nil
	else
		return true
	end
end
