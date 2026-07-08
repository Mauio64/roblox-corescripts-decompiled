local function formatDate(p1, b1: boolean?) -- line: 1
	local dateTime = DateTime.now()
	local v5 = not (p1:ToLocalTime().Year > dateTime:ToLocalTime().Year) and "ddd, MMM DD" or "ll"

	if b1 then
		return ("%s at %s"):format(p1:FormatLocalTime(v5, "en-us"), p1:FormatLocalTime("LT", "en-us"))
	end

	return ("%s AT %s"):format(p1:FormatLocalTime(v5, "en-us"), p1:FormatLocalTime("LT", "en-us")):upper()
end

return formatDate
