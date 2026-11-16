local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")

local view = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation").View
local EditProfileHeaderBar = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/BaseComponents/EditProfileHeaderBar")
local useProfileCardWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/ProfilePlatformCommon").Hooks.useProfileCardWidth
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagAXEnableProfileTab

return function(props)
	local v5 = useProfileCardWidth()
	local v6 = useLocalization({ title = props.titleKey })

	local v7 = fFlagAXEnableProfileTab and props.fullBleed == true
	local createElement = React.createElement
	local v9 = {
		tag = fFlagAXEnableProfileTab and {
			["col items-start bg-surface-0"] = true,
			["position-top-right anchor-top-right"] = not v7,
			["size-full-full"] = v7
		} or "col bg-surface-0 anchor-top-right position-top-right items-start",
		Size = 0
	}

	local v10 = if not v7 then UDim2.new(0, v5, 1, 0) else nil
	v9.Size = v10
	return createElement(view, v9, {
		TopBar = React.createElement(EditProfileHeaderBar, {
			onClose = props.onClose,
			headerText = v6.title,
			onSave = props.onSave,
			isLoading = props.isLoading,
			isDisabled = props.isDisabled
		}),
		Content = React.createElement(
			view,
			{ tag = "col padding-xlarge gap-xxlarge size-full-0 auto-y" },
			props.component
		)
	})
end
