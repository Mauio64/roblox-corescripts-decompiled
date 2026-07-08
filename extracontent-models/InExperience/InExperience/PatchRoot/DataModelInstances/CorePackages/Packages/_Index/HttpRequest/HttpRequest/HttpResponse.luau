local t1 = {}

t1.__index = t1

function t1.__tostring(p1) -- line: 3
	local t2 = {}

	for k, v in pairs(p1) do
		table.insert(t2, string.format("%s = %s", tostring(k), (tostring(v))))
	end

	table.sort(t2)

	return "<HttpResponse: " .. table.concat(t2, ", ") .. ">"
end
function t1.success(p2, p3) -- line: 14
	-- upvalues: t1 (copy)
	return (setmetatable({
		responseCode = p2,
		responseBody = p3
	}, t1))
end
function t1.error(p4) -- line: 21
	-- upvalues: t1 (copy)
	return (setmetatable({
		HttpError = p4
	}, t1))
end

return t1
