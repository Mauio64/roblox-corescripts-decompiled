return function(p): boolean
	if not p.existing then
		return false
	end

	if
		p.new.lastUpdated
		and p.existing.lastUpdated
		and math.floor((p.existing.lastUpdated:GetUnixTimestamp())) < math.floor((p.new.lastUpdated:GetUnixTimestamp()))
	then
		return true
	end

	if p.new.hasUnreadMessages and not p.existing.hasUnreadMessages then
		return true
	end

	return false
end
