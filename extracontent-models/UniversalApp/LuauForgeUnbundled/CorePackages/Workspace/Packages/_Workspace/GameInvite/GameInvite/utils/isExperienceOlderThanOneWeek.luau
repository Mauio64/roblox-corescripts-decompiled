local Workspace = game:GetService("Workspace")

return function(p2): boolean
	local dateTime = p2 ~= nil and p2.Created ~= nil and DateTime.fromIsoDate(p2.Created)

	if dateTime then
		local unixTimestampMillis = dateTime.UnixTimestampMillis

		if Workspace:GetServerTimeNow() * 1000 - unixTimestampMillis > 604800000 then
			return true
		end
	end

	return false
end
