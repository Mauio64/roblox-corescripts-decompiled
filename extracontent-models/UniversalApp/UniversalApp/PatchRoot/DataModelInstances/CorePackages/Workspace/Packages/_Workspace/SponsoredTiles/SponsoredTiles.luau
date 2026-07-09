local scriptParent = script.Parent

return {
	WhyThisAdModal = if not require(scriptParent.SharedFlags).FFlagLuaAppEnableWhyThisAdModal then nil else require(script.WhyThisAdModal)
}
