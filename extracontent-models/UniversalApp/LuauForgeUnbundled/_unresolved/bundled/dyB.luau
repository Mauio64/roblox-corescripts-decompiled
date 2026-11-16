local v5 = {}

function v5.new()
	return { isSubscribed = false, isRenewing = false }
end

function v5.mock(isSubscribed, isRenewing)
	local v6 = v5.new()

	v6.isSubscribed = isSubscribed
	v6.isRenewing = isRenewing
	return v6
end

function v5.fromJsonData(p2)
	local v6 = v5.new()

	v6.isSubscribed = p2.isSubscribed
	v6.isRenewing = p2.isRenewing
	return v6
end

return v5
