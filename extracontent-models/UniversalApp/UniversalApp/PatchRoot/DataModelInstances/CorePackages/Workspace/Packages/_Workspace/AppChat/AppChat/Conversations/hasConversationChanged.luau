local hasSameParticipants = require(script.Parent.hasSameParticipants)

return function(p1) -- line: 3
	-- upvalues: hasSameParticipants (copy)
	if not p1.existing then
		return true
	end

	if p1.new.lastUpdated and p1.existing.lastUpdated and math.floor((p1.existing.lastUpdated:GetUnixTimestamp())) ~= math.floor((p1.new.lastUpdated:GetUnixTimestamp())) then
		return true
	end

	if p1.existing.title ~= p1.new.title then
		return true
	end

	if not hasSameParticipants({
		existing = p1.existing.participants,
		new = p1.new.participants
	}) then
		return true
	end

	if p1.new.hasUnreadMessages and not p1.existing.hasUnreadMessages then
		return true
	end

	return false
end
