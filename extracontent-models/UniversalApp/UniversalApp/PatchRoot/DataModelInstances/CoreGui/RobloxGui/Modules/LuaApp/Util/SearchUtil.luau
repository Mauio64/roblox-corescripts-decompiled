return {
	KeywordNormalize = function(p1) -- line: 7
		return (p1:gsub("\239\191\188", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
	end
}
