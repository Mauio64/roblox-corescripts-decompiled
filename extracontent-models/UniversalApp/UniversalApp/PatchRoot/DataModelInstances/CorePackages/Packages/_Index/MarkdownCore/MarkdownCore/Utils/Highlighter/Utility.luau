local Utility = {}

function Utility.sanitizeRichText(value: string)
	return string.gsub(
		string.gsub(
			string.gsub(string.gsub(string.gsub(value, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"),
			"\"",
			"&quot;"
		),
		"'",
		"&apos;"
	)
end

function Utility.convertTabsToSpaces(value: string)
	return string.gsub(value, "\t", "    ")
end

function Utility.removeControlChars(value: string)
	return string.gsub(value, "[\0\1\2\3\4\5\6\7\8\11\f\r\14\15\16\17\18\19\20\21\22\23\24\25\26\27\28\29\30\31]+", "")
end

return Utility
