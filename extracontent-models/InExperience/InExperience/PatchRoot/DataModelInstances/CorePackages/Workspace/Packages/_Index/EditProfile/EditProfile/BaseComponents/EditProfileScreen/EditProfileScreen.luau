local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local View = require(EditProfileParent.Foundation).View
local EditProfileHeaderBar = require(EditProfile.BaseComponents.EditProfileHeaderBar)
local useProfileCardWidth = require(EditProfileParent.ProfilePlatformCommon).Hooks.useProfileCardWidth
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local FFlagAXEnableProfileTab = require(EditProfileParent.SharedFlags).FFlagAXEnableProfileTab

return function(t1: {[any]: any}) -- line: 24
	-- upvalues: useProfileCardWidth (copy), useLocalization (copy), FFlagAXEnableProfileTab (copy), React (copy), View (copy), EditProfileHeaderBar (copy)
	local v10 = useProfileCardWidth()
	local v11 = useLocalization({
		title = t1.titleKey
	})
	local v12 = FFlagAXEnableProfileTab and t1.fullBleed == true

	return React.createElement(View, {
		tag = not FFlagAXEnableProfileTab and "col bg-surface-0 anchor-top-right position-top-right items-start" or {
			["col items-start bg-surface-0"] = true,
			["position-top-right anchor-top-right"] = not v12,
			["size-full-full"] = v12
		},
		Size = if not v12 then UDim2.new(0, v10, 1, 0) else nil
	}, {
		TopBar = React.createElement(EditProfileHeaderBar, {
			onClose = t1.onClose,
			headerText = v11.title,
			onSave = t1.onSave,
			isLoading = t1.isLoading,
			isDisabled = t1.isDisabled
		}),
		Content = React.createElement(View, {
			tag = "col padding-xlarge gap-xxlarge size-full-0 auto-y"
		}, t1.component)
	})
end
