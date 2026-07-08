local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local HeaderBar = require(Parent.UIBlox).App.Bar.HeaderBar
local makeBackButton = require(Parent.AppHeaderBar).makeBackButton
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useLastInputMode = require(Parent.FocusNavigationUtils).useLastInputMode
local View = Foundation.View

local function EditProfileBackgroundTopBar(t1: {[any]: any}) -- line: 22
	-- upvalues: useLastInputMode (copy), useLocalization (copy), makeBackButton (copy), React (copy), View (copy), HeaderBar (copy)
	local v11 = useLastInputMode() == "Focus"
	local v12 = useLocalization({
		EditBackground = "Feature.Profile.Label.EditBackground"
	})
	local v13 = makeBackButton(t1.onClose)

	return React.createElement(View, {
		tag = "size-full-1200",
		ZIndex = 2,
		LayoutOrder = t1.layoutOrder
	}, {
		headerBar = React.createElement(HeaderBar, {
			isSecondary = true,
			backgroundTransparency = 1,
			barHeight = 48,
			title = v12.EditBackground,
			renderLeft = if v11 then nil else v13
		})
	})
end

return EditProfileBackgroundTopBar
