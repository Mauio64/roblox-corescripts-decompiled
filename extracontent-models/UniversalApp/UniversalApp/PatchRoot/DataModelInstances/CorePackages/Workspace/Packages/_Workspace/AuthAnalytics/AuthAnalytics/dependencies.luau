local ParentParent = script.Parent.Parent

return {
	Analytics = require(ParentParent.Analytics),
	Logging = require(ParentParent.AppCommonLib).Logging
}
