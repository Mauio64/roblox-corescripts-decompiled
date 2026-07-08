local Regex = require(script.Parent.Regex)
local v2 = Regex.oneOf({
	Regex.set("\\w\\-\\.\\_\\~\\!\\$\\&\\'\\*\\+\\,\\;\\=\\(\\)\\:\\@"),
	"\\%[A-Fa-f0-9]{2}"
})
local v3 = Regex.oneOf({
	Regex.set("\\w\\-\\.\\_\\~\\!\\$\\&\\'\\*\\+\\,\\;\\=\\(\\)\\:\\@\\/\\?"),
	"\\%[A-Fa-f0-9]{2}"
})
local v4 = Regex.oneOf({
	Regex.set("\\w\\-\\.\\_\\~\\!\\$\\&\\'\\*\\+\\,\\;\\=\\(\\)\\:\\@\\/\\?\\#"),
	"\\%[A-Fa-f0-9]{2}"
})
local t1 = {
	"com",
	"net",
	"org",
	"[a-z]{2}"
}
local v6 = "\\w(?:[\\w\\-]{0,61}\\w)?" .. Regex.DOT .. Regex.zeroOrMore(Regex.oneOf(t1) .. Regex.DOT) .. Regex.oneOf(t1)

return {
	ANY_DOMAIN_NAME = "\\w(?:[\\w\\-]{0,61}\\w)?",
	PATH_CHAR = v2,
	QUERY_CHAR = v3,
	FRAGMENT_CHAR = v4,
	ANY_HOSTNAME_PATTERN = v6,
	HTTP_PROTOCOL_PATTERNS = {
		"https",
		"http"
	},
	COMMON_TLD_PATTERNS = t1,
	ANY_DOMAIN_PATTERN = v6
}
