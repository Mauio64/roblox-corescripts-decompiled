local parent = script:FindFirstAncestor("EditProfileBackground").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local HeaderBar = UIBlox.App.Bar.HeaderBar
local AppHeaderBar = require(parent.AppHeaderBar)
local makeBackButton = AppHeaderBar.makeBackButton
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local View = Foundation.View

local function EditProfileBackgroundTopBar(p)
	local v = useLastInputMode() == "Focus"
	local v2 = useLocalization({ EditBackground = "Feature.Profile.Label.EditBackground" })

	local backButton = makeBackButton(p.onClose)

	local createElement = React.createElement
	local v3 = { tag = "size-full-1200", LayoutOrder = p.layoutOrder, ZIndex = 2 }

	local createElement2 = React.createElement
	local v4 = {
		isSecondary = true,
		title = v2.EditBackground,
		backgroundTransparency = 1,
		barHeight = 48,
		renderLeft = 0
	}

	if v then
		backButton = nil
	end

	v4.renderLeft = backButton
	return createElement(View, v3, { headerBar = createElement2(HeaderBar, v4) })
end

return EditProfileBackgroundTopBar
