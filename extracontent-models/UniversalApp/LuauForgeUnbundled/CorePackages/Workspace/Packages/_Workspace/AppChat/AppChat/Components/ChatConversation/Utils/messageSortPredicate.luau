return function(data, data2): boolean
	if data.order and data2.order then
		return data.order < data2.order
	end

	local v5 = not (data.order == nil) and not (data.moderated or data.failed)

	if not v5 then
		local v6 = not (data2.order == nil) and not (data2.moderated or data2.failed)

		if not v6 then
			local unixTimestamp = data.sent and data.sent:GetUnixTimestamp()
			local unixTimestamp2 = data2.sent and data2.sent:GetUnixTimestamp()

			if unixTimestamp and unixTimestamp2 and unixTimestamp ~= unixTimestamp2 then
				return unixTimestamp < unixTimestamp2
			end

			if data.id and data2.id and data.id ~= data2.id then
				return data.id > data2.id
			end

			return data2.moderated == true or data2.failed == true
		end
	end

	return data2.order ~= nil and not (data2.moderated or data2.failed)
end
