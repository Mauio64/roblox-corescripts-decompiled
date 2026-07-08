local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local FocusNavigationUtils = require(EditProfileParent.FocusNavigationUtils)
local HeaderBar = require(EditProfileParent.UIBlox).App.Bar.HeaderBar
local Localization = require(EditProfileParent.Localization)
local TextKeys = require(EditProfile.Common.TextKeys)
local useLocalization = Localization.Hooks.useLocalization
local makeBackButton = require(EditProfileParent.AppHeaderBar).makeBackButton
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)

local function EditProfileTopBar(t1: {[any]: any}) -- line: 22
	-- upvalues: FFlagEditProfileFixFocusNavigation (copy), useLastInputMode (copy), useLocalization (copy), TextKeys (copy), makeBackButton (copy), React (copy), HeaderBar (copy)
	local v14 = if not FFlagEditProfileFixFocusNavigation then nil else useLastInputMode() == "Focus"
	local v15 = useLocalization({
		title = TextKeys.Title
	})
	local v16 = makeBackButton(t1.onClose)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, 48),
		LayoutOrder = t1.layoutOrder
	}, {
		headerBar = React.createElement(HeaderBar, {
			isSecondary = true,
			backgroundTransparency = 1,
			barHeight = 48,
			title = v15.title,
			renderLeft = if not (not not FFlagEditProfileFixFocusNavigation and not v14) and FFlagEditProfileFixFocusNavigation then nil else v16
		})
	})
end

return EditProfileTopBar
