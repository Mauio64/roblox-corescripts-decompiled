local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local toggle = Foundation.Toggle
local toggleSize = Foundation.Enums.ToggleSize

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local horizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local styledTextLabel = UIBlox.App.Text.StyledTextLabel

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useDispatch

local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local UserProfileSettingsNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/UserProfileSettingsNetworking")

local refreshProfilePlatformUserProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformUserProfileHeader")

local function UserProfileSettingsToggle(props)
	local v5 = useProfileWrapperContext()
	local v6 = useStyle()
	local v7 = useDispatch()

	local v8 = React.useCallback(function(p2)
		v7(UserProfileSettingsNetworking.SetUserProfileSettings.API({ isInExperienceNameEnabled = p2 })):andThen(function(p3)
			if p3.responseBody.successfullyUpdated then
				v7(refreshProfilePlatformUserProfileHeader(v5.profileId))
			end
		end)
	end)

	return React.createElement(
		horizontalPageMargin,
		{
			size = props.size,
			layoutOrder = props.layoutOrder,
			backgroundTransparency = 1
		},
		{
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 8)
			}),
			Label = React.createElement(styledTextLabel, {
				text = "In-experience name:",
				fontStyle = v6.Font.CaptionHeader,
				colorStyle = v6.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			}),
			Toggle = React.createElement(toggle, {
				label = "",
				size = toggleSize.Medium,
				isChecked = props.isInExperienceNameEnabled,
				onActivated = v8
			})
		}
	)
end

return UserProfileSettingsToggle
