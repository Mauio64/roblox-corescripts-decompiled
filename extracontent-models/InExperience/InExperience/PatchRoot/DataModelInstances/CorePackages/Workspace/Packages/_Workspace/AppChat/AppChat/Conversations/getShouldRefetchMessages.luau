return function(p1) -- line: 1
	if not p1.existing then
		return false
	end

	if p1.new.lastUpdated and p1.existing.lastUpdated and math.floor((p1.existing.lastUpdated:GetUnixTimestamp())) < math.floor((p1.new.lastUpdated:GetUnixTimestamp())) then
		return true
	end

	if p1.new.hasUnreadMessages and not p1.existing.hasUnreadMessages then
		return true
	end

	return false
end
