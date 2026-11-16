local function formatDate(object, flag: boolean?)
	local now = DateTime.now()

	local v = object:ToLocalTime().Year > now:ToLocalTime().Year and "ll" or "ddd, MMM DD"

	if flag then
		return ("%s at %s"):format(object:FormatLocalTime(v, "en-us"), object:FormatLocalTime("LT", "en-us"))
	end

	return (("%s AT %s"):format(object:FormatLocalTime(v, "en-us"), object:FormatLocalTime("LT", "en-us"))):upper()
end

return formatDate
