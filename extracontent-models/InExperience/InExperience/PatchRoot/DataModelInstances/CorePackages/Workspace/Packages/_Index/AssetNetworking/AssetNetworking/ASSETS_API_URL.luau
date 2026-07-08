local ParentParent = script.Parent.Parent
local UrlBuilder = require(ParentParent.UrlBuilder).UrlBuilder
local UrlBase = require(ParentParent.UrlBuilder).UrlBase

return UrlBuilder.new({
	path = "assets/user-auth",
	base = UrlBase.APIS
})()
