local Regex = require("@game/CorePackages/Workspace/Packages/_Index/UrlMatching/UrlMatching/Regex")

local one = Regex.oneOf({
	Regex.set("\\w\\-\\.\\_\\~\\!\\$\\&\\'\\*\\+\\,\\;\\=\\(\\)\\:\\@"),
	"\\%[A-Fa-f0-9]{2}"
})
local one2 = Regex.oneOf({
	Regex.set("\\w\\-\\.\\_\\~\\!\\$\\&\\'\\*\\+\\,\\;\\=\\(\\)\\:\\@\\/\\?"),
	"\\%[A-Fa-f0-9]{2}"
})
local one3 = Regex.oneOf({
	Regex.set("\\w\\-\\.\\_\\~\\!\\$\\&\\'\\*\\+\\,\\;\\=\\(\\)\\:\\@\\/\\?\\#"),
	"\\%[A-Fa-f0-9]{2}"
})

local v5 = { "com", "net", "org", "[a-z]{2}" }

local v6 = "\\w(?:[\\w\\-]{0,61}\\w)?" .. Regex.DOT .. Regex.zeroOrMore(Regex.oneOf(v5) .. Regex.DOT) .. Regex.oneOf(v5)
return {
	PATH_CHAR = one,
	QUERY_CHAR = one2,
	FRAGMENT_CHAR = one3,
	ANY_DOMAIN_NAME = "\\w(?:[\\w\\-]{0,61}\\w)?",
	ANY_HOSTNAME_PATTERN = v6,
	HTTP_PROTOCOL_PATTERNS = { "https", "http" },
	COMMON_TLD_PATTERNS = v5,
	ANY_DOMAIN_PATTERN = v6
}
