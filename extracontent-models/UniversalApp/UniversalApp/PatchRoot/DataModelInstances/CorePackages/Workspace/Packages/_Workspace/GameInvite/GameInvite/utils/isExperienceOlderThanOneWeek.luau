local Workspace = game:GetService("Workspace")

return function(t1: {[any]: any}) -- line: 7
	-- upvalues: Workspace (copy)
	if t1 ~= nil and t1.Created ~= nil then
		local dateTime = DateTime.fromIsoDate(t1.Created)

		if dateTime then
			local UnixTimestampMillis = dateTime.UnixTimestampMillis

			if Workspace:GetServerTimeNow() * 1000 - UnixTimestampMillis > 604800000 then
				return true
			end
		end
	end

	return false
end
