local Workspace = game:GetService("Workspace")

return function(p): boolean
	local dateTime = p ~= nil and p.Created ~= nil and DateTime.fromIsoDate(p.Created)

	if dateTime then
		local unixTimestampMillis = dateTime.UnixTimestampMillis

		if Workspace:GetServerTimeNow() * 1000 - unixTimestampMillis > 604800000 then
			return true
		end
	end

	return false
end
