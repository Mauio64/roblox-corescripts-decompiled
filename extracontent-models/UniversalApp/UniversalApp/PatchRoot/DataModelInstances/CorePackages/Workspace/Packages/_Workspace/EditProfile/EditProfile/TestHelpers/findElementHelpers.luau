local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local SocialTestHelpers = require(EditProfileParent.Dev.SocialTestHelpers)
local findElementWithAssert = SocialTestHelpers.TestHelpers.findElementWithAssert
local findImageSet = SocialTestHelpers.TestHelpers.findImageSet

return {
	findTopBarTitle = findElementWithAssert({
		Text = require(EditProfile.Common.TextKeys).Title
	}),
	findTopBar = findElementWithAssert({
		Name = "TopBar"
	}),
	findBackButton = findElementWithAssert(findImageSet("icons/navigation/pushBack"))
}
