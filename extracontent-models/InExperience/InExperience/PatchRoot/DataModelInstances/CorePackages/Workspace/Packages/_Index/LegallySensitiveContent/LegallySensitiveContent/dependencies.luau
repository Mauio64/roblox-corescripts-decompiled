local ParentParent = script.Parent.Parent

return {
	Localization = require(ParentParent.Localization),
	Promise = require(ParentParent.Promise),
	UrlBuilder = require(ParentParent.UrlBuilder).UrlBuilder,
	UrlBase = require(ParentParent.UrlBuilder).UrlBase,
	Fetch = require(ParentParent.Fetch),
	Base64 = require(ParentParent.AuthCommon).Utils.Base64
}
