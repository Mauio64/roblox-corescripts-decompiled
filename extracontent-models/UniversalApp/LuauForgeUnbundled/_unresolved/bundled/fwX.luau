return {
	KeywordNormalize = function(value)
		return (value:gsub("￼", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
	end
}
