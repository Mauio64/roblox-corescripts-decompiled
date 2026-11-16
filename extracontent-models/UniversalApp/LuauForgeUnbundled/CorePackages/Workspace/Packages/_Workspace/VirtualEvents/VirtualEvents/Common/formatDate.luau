local function formatDate(object, p2)
	local now = DateTime.now()

	local v5 = object:ToLocalTime().Year > now:ToLocalTime().Year and "ll" or "ddd, MMM DD"

	if p2 then
		return ("%s at %s"):format(
			object:FormatLocalTime(v5, "en-us"),
			object:FormatLocalTime("LT", "en-us")
		)
	end

	return (("%s AT %s"):format(object:FormatLocalTime(v5, "en-us"), object:FormatLocalTime("LT", "en-us"))):upper()
end

return formatDate
