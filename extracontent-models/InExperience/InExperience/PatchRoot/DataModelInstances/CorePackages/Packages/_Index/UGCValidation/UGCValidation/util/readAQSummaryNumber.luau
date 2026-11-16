local function readAQSummaryNumber(p, p2: string, p3: string, p4: number?, p5: number?)
	local v = tonumber(p[p2])

	if v == nil or v ~= v then
		error(`{p3}: {p2} is not a number: {tostring(p[p2])}`)
	end

	if p4 ~= nil and v < p4 or p5 ~= nil and p5 < v then
		error(`{p3}: {p2} is outside [{p4}, {p5}]: {tostring(p[p2])}`)
	end

	return v
end

return readAQSummaryNumber
