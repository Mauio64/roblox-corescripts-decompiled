local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Toggle = Foundation.Toggle
local ToggleSize = Foundation.Enums.ToggleSize

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local UserProfileSettingsNetworking = require(ProfilePlatform.Networking.UserProfileSettingsNetworking)

local refreshProfilePlatformUserProfileHeader = require(ProfilePlatform.Networking.refreshProfilePlatformUserProfileHeader)

local function UserProfileSettingsToggle(props)
	local v = useProfileWrapperContext()
	local v2 = useStyle()
	local v3 = useDispatch()

	local onActivated = React.useCallback(function(isInExperienceNameEnabled: boolean)
		v3(UserProfileSettingsNetworking.SetUserProfileSettings.API({
			isInExperienceNameEnabled = isInExperienceNameEnabled
		})):andThen(function(p)
			if p.responseBody.successfullyUpdated then
				v3(refreshProfilePlatformUserProfileHeader(v.profileId))
			end
		end)
	end)

	return React.createElement(
		HorizontalPageMargin,
		{ size = props.size, layoutOrder = props.layoutOrder, backgroundTransparency = 1 },
		{
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 8)
			}),
			Label = React.createElement(StyledTextLabel, {
				text = "In-experience name:",
				fontStyle = v2.Font.CaptionHeader,
				colorStyle = v2.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			}),
			Toggle = React.createElement(Toggle, {
				label = "",
				size = ToggleSize.Medium,
				isChecked = props.isInExperienceNameEnabled,
				onActivated = onActivated
			})
		}
	)
end

return UserProfileSettingsToggle
