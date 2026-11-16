return function(p2): boolean
	if not p2.existing then
		return false
	end

	if
		p2.new.lastUpdated
		and p2.existing.lastUpdated
		and math.floor((p2.existing.lastUpdated:GetUnixTimestamp())) < math.floor((p2.new.lastUpdated:GetUnixTimestamp()))
	then
		return true
	end

	if p2.new.hasUnreadMessages and not p2.existing.hasUnreadMessages then
		return true
	end

	return false
end
