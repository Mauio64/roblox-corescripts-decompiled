local Regex = require(script.Parent.Regex)

local one = Regex.oneOf({ Regex.set("\\w\\-\\.\\_\\~\\!\\$\\&\\'\\*\\+\\,\\;\\=\\(\\)\\:\\@"), "\\%[A-Fa-f0-9]{2}" })
local one2 = Regex.oneOf({
	Regex.set("\\w\\-\\.\\_\\~\\!\\$\\&\\'\\*\\+\\,\\;\\=\\(\\)\\:\\@\\/\\?"),
	"\\%[A-Fa-f0-9]{2}"
})
local one3 = Regex.oneOf({
	Regex.set("\\w\\-\\.\\_\\~\\!\\$\\&\\'\\*\\+\\,\\;\\=\\(\\)\\:\\@\\/\\?\\#"),
	"\\%[A-Fa-f0-9]{2}"
})

local v = { "com", "net", "org", "[a-z]{2}" }

local v2 = "\\w(?:[\\w\\-]{0,61}\\w)?" .. Regex.DOT .. Regex.zeroOrMore(Regex.oneOf(v) .. Regex.DOT) .. Regex.oneOf(v)
return {
	PATH_CHAR = one,
	QUERY_CHAR = one2,
	FRAGMENT_CHAR = one3,
	ANY_DOMAIN_NAME = "\\w(?:[\\w\\-]{0,61}\\w)?",
	ANY_HOSTNAME_PATTERN = v2,
	HTTP_PROTOCOL_PATTERNS = { "https", "http" },
	COMMON_TLD_PATTERNS = v,
	ANY_DOMAIN_PATTERN = v2
}
