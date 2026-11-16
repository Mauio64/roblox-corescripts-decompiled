local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Foundation")
local headerBar = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/UIBlox").App.Bar.HeaderBar
local makeBackButton = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/AppHeaderBar").makeBackButton
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Localization").Hooks.useLocalization
local useLastInputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/FocusNavigationUtils").useLastInputMode

local view = Foundation.View

local function EditProfileBackgroundTopBar(p2)
	local v5 = useLastInputMode() == "Focus"
	local v6 = useLocalization({
		EditBackground = "Feature.Profile.Label.EditBackground"
	})

	local backButton = makeBackButton(p2.onClose)

	local createElement = React.createElement
	local v8 = { tag = "size-full-1200", LayoutOrder = p2.layoutOrder, ZIndex = 2 }

	local createElement2 = React.createElement
	local v11 = {
		isSecondary = true,
		title = v6.EditBackground,
		backgroundTransparency = 1,
		barHeight = 48,
		renderLeft = 0
	}

	if v5 then
		backButton = nil
	end

	v11.renderLeft = backButton
	return createElement(view, v8, { headerBar = createElement2(headerBar, v11) })
end

return EditProfileBackgroundTopBar
