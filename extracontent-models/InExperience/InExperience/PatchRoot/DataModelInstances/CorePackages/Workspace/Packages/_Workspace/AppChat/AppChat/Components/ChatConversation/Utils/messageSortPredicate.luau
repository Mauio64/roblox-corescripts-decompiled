local function fn(data): boolean -- 3 equivalent calls inferred from this helper
	return data.order ~= nil and not (data.moderated or data.failed)
end

return function(data, data2)
	if data.order and data2.order then
		return data.order < data2.order
	end

	if not fn(data) and not fn(data2) then -- inferred equivalent call
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

	return fn(data2) -- inferred equivalent call
end
