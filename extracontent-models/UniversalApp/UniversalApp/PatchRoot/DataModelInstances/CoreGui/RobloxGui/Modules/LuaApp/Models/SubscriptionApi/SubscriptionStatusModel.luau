local t1 = {
	new = function() -- line: 8
		return {
			isSubscribed = false,
			isRenewing = false
		}
	end
}

function t1.mock(p1, p2) -- line: 17
	-- upvalues: t1 (copy)
	local v4 = t1.new()

	v4.isSubscribed = p1
	v4.isRenewing = p2

	return v4
end
function t1.fromJsonData(p3) -- line: 25
	-- upvalues: t1 (copy)
	local v6 = t1.new()

	v6.isSubscribed = p3.isSubscribed
	v6.isRenewing = p3.isRenewing

	return v6
end

return t1
