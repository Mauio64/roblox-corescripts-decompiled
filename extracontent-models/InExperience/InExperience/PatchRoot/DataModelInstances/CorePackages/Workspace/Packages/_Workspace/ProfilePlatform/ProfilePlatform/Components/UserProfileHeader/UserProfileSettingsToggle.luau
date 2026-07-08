local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local Toggle = Foundation.Toggle
local ToggleSize = Foundation.Enums.ToggleSize
local UIBlox = require(ProfilePlatformParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useDispatch = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local UserProfileSettingsNetworking = require(ProfilePlatform.Networking.UserProfileSettingsNetworking)
local refreshProfilePlatformUserProfileHeader = require(ProfilePlatform.Networking.refreshProfilePlatformUserProfileHeader)

local function UserProfileSettingsToggle(t1: {[any]: any}) -- line: 27
	-- upvalues: useProfileWrapperContext (copy), useStyle (copy), useDispatch (copy), React (copy), UserProfileSettingsNetworking (copy), refreshProfilePlatformUserProfileHeader (copy), HorizontalPageMargin (copy), StyledTextLabel (copy), Toggle (copy), ToggleSize (copy)
	local v17 = useProfileWrapperContext()
	local v18 = useStyle()
	local v19 = useDispatch()
	local v20 = React.useCallback(function(b1: boolean) -- line: 32
		-- upvalues: v19 (copy), UserProfileSettingsNetworking (copy), refreshProfilePlatformUserProfileHeader (copy), v17 (copy)
		v19(UserProfileSettingsNetworking.SetUserProfileSettings.API({
			isInExperienceNameEnabled = b1
		})):andThen(function(p1) -- line: 35
			-- upvalues: v19 (copy), refreshProfilePlatformUserProfileHeader (copy), v17 (copy)
			if p1.responseBody.successfullyUpdated then
				v19(refreshProfilePlatformUserProfileHeader(v17.profileId))
			end
		end)
	end)

	return React.createElement(HorizontalPageMargin, {
		backgroundTransparency = 1,
		size = t1.size,
		layoutOrder = t1.layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 8)
		}),
		Label = React.createElement(StyledTextLabel, {
			text = "In-experience name:",
			fontStyle = v18.Font.CaptionHeader,
			colorStyle = v18.Theme.TextEmphasis,
			automaticSize = Enum.AutomaticSize.XY
		}),
		Toggle = React.createElement(Toggle, {
			label = "",
			size = ToggleSize.Medium,
			isChecked = t1.isInExperienceNameEnabled,
			onActivated = v20
		})
	})
end

return UserProfileSettingsToggle
