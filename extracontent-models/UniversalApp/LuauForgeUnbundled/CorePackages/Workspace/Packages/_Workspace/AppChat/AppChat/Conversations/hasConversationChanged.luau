local hasSameParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/hasSameParticipants")

return function(p2): boolean
	if not p2.existing then
		return true
	end

	if
		p2.new.lastUpdated
		and p2.existing.lastUpdated
		and math.floor((p2.existing.lastUpdated:GetUnixTimestamp())) ~= math.floor((p2.new.lastUpdated:GetUnixTimestamp()))
	then
		return true
	end

	if not (p2.existing.title == p2.new.title and hasSameParticipants({
		existing = p2.existing.participants,
		new = p2.new.participants
	})) then
		return true
	end

	if p2.new.hasUnreadMessages and not p2.existing.hasUnreadMessages then
		return true
	end

	return false
end
