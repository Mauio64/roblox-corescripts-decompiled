local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local SocialTestHelpers = require(Parent.Dev.SocialTestHelpers)
local findElementWithAssert = SocialTestHelpers.TestHelpers.findElementWithAssert
local findImageSet = SocialTestHelpers.TestHelpers.findImageSet

return {
	findTopBar = findElementWithAssert({
		Name = "TopBar"
	}),
	findBackButton = findElementWithAssert(findImageSet("icons/navigation/pushBack"))
}
