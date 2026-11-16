local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local EditProfileHeaderBar = require(EditProfile.BaseComponents.EditProfileHeaderBar)
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local useProfileCardWidth = ProfilePlatformCommon.Hooks.useProfileCardWidth
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab

return function(props)
	local v = useProfileCardWidth()
	local v2 = useLocalization({ title = props.titleKey })

	local sizefullfull = FFlagAXEnableProfileTab and props.fullBleed == true
	local createElement = React.createElement
	local v3 = {
		tag = FFlagAXEnableProfileTab and {
			["col items-start bg-surface-0"] = true,
			["position-top-right anchor-top-right"] = not sizefullfull,
			["size-full-full"] = sizefullfull
		} or "col bg-surface-0 anchor-top-right position-top-right items-start",
		Size = 0
	}
	local size

	if not sizefullfull then
		size = UDim2.new(0, v, 1, 0)
	end

	v3.Size = size
	return createElement(View, v3, {
		TopBar = React.createElement(EditProfileHeaderBar, {
			onClose = props.onClose,
			headerText = v2.title,
			onSave = props.onSave,
			isLoading = props.isLoading,
			isDisabled = props.isDisabled
		}),
		Content = React.createElement(
			View,
			{ tag = "col padding-xlarge gap-xxlarge size-full-0 auto-y" },
			props.component
		)
	})
end
