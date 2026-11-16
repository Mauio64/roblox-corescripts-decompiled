local hasSameParticipants = require(script.Parent.hasSameParticipants)

return function(p): boolean
	if not p.existing then
		return true
	end

	if
		p.new.lastUpdated
		and p.existing.lastUpdated
		and math.floor((p.existing.lastUpdated:GetUnixTimestamp())) ~= math.floor((p.new.lastUpdated:GetUnixTimestamp()))
	then
		return true
	end

	if not (p.existing.title == p.new.title and hasSameParticipants({
		existing = p.existing.participants,
		new = p.new.participants
	})) then
		return true
	end

	if p.new.hasUnreadMessages and not p.existing.hasUnreadMessages then
		return true
	end

	return false
end
