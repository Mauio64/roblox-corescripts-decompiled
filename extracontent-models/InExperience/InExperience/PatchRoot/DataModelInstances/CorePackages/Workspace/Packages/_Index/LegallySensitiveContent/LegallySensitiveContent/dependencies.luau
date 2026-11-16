local parent = script.Parent.Parent

local Dependencies = {
	Localization = require(parent.Localization),
	Promise = require(parent.Promise),
	UrlBuilder = 0,
	UrlBase = 0,
	Fetch = 0,
	Base64 = 0
}
local UrlBuilder = require(parent.UrlBuilder)
Dependencies.UrlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
Dependencies.UrlBase = UrlBuilder2.UrlBase
Dependencies.Fetch = require(parent.Fetch)
local AuthCommon = require(parent.AuthCommon)
Dependencies.Base64 = AuthCommon.Utils.Base64
return Dependencies
