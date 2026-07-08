return {
	sanitizeRichText = function(s1: string) -- line: 3
		return string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(s1, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"), "\"", "&quot;"), "'", "&apos;")
	end,
	convertTabsToSpaces = function(s2: string) -- line: 11
		return string.gsub(s2, "\t", "    ")
	end,
	removeControlChars = function(s3: string) -- line: 15
		return string.gsub(s3, "[\000\001\002\003\004\005\006\a\b\v\f\r\014\015\016\017\018\019\020\021\022\023\024\025\026\027\028\029\030\031]+", "")
	end
}
