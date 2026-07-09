return function(p1, p2) -- line: 7
	if p1.order and p2.order then
		return p1.order < p2.order
	end

	if p1.order ~= nil and (not p1.moderated and not p1.failed) or p2.order ~= nil and (not p2.moderated and not p2.failed) then
		return p2.order ~= nil and (not p2.moderated and not p2.failed)
	end

	local v4 = p1.sent and p1.sent:GetUnixTimestamp()
	local v5 = p2.sent and p2.sent:GetUnixTimestamp()

	if v4 and v5 and v4 ~= v5 then
		return v4 < v5
	end

	if p1.id and p2.id and p1.id ~= p2.id then
		return p1.id > p2.id
	end

	return p2.moderated == true or p2.failed == true
end
