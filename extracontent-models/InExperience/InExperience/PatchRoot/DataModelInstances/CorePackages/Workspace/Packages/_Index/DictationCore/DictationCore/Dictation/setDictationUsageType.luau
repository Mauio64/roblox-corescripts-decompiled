local function setDictationUsageType(p, flag: boolean)
	return (pcall(function()
		p.UsageType = flag and "continuous" or "dictation"
	end))
end

return setDictationUsageType
