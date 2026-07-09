local SocialOnboardingButtons = script:FindFirstAncestor("SocialOnboardingButtons")
local SocialOnboardingButtonsParent = SocialOnboardingButtons.Parent
local SocialOnboardingButtonsIXP = require(SocialOnboardingButtons.Experiments.SocialOnboardingButtonsIXP)
local ColorVariantsEnum = require(SocialOnboardingButtons.Enums.ColorVariantsEnum)
local UIBlox = require(SocialOnboardingButtonsParent.UIBlox)
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local ThemeName = UIBlox.App.Style.Constants.ThemeName
local color3 = Color3.fromHex("272930")
local color3_2 = Color3.fromHex("F4F4F6")
local t1 = {
	colorful = {
		lightTheme = {
			addFriends = Color3.fromHex("BFE6FF"),
			findContacts = Color3.fromHex("B2F5D5"),
			myQRCode = Color3.fromHex("FFD7DF"),
			searchPeople = Color3.fromHex("EED2FF"),
			unlockVoice = Color3.fromHex("FFF8DC"),
			myProfile = Color3.fromHex("#A2E7E4")
		},
		darkTheme = {
			addFriends = Color3.fromHex("2C3E50"),
			findContacts = Color3.fromHex("1B7740"),
			myQRCode = Color3.fromHex("9A2B1D"),
			searchPeople = Color3.fromHex("4D256D"),
			unlockVoice = Color3.fromHex("B98D5F"),
			myProfile = Color3.fromHex("#11816A")
		}
	},
	blackAndWhite = {
		lightTheme = {
			addFriends = color3,
			findContacts = color3,
			myQRCode = color3,
			searchPeople = color3,
			unlockVoice = color3,
			myProfile = color3
		},
		darkTheme = {
			addFriends = color3_2,
			findContacts = color3_2,
			myQRCode = color3_2,
			searchPeople = color3_2,
			unlockVoice = color3_2,
			myProfile = color3_2
		}
	}
}

return function() -- line: 53
	-- upvalues: SocialOnboardingButtonsIXP (copy), useStyleMetadata (copy), ThemeName (copy), ColorVariantsEnum (copy), t1 (copy), color3_2 (copy), color3 (copy)
	local v11 = SocialOnboardingButtonsIXP.useSocialOnboardingBtnsColor()
	local v12 = useStyleMetadata().ThemeName == ThemeName.Dark
	local t2 = {}
	local v14 = nil

	if v11 == ColorVariantsEnum.Colorful then
		if v12 then
			t2 = t1.colorful.darkTheme
			v14 = color3_2
		else
			t2 = t1.colorful.lightTheme
			v14 = color3
		end
	elseif v11 == ColorVariantsEnum.BlackAndWhite then
		if v12 then
			t2 = t1.blackAndWhite.darkTheme
			v14 = color3
		else
			t2 = t1.blackAndWhite.lightTheme
			v14 = color3_2
		end
	end

	return t2, v14, v11
end
