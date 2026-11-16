local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useStyle = UIBlox.Core.Style.useStyle

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileScrollContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileScrollContext/useProfileScrollContext")
local getPeekViewOpenHeightByProfileType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/getPeekViewOpenHeightByProfileType")
local fFlagProfilePlatformEnableImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableImpressions

local function ProfilePlatformPage(p2)
	local profileType = useProfileWrapperContext().profileType

	local v5 = useProfileScrollContext()

	local v6 = useProfileFormFactor()
	local v7 = v6.formFactor == Enums.ProfileFormFactor.Wide
	local isFullView = v6.isFullView

	local theme = useStyle().Theme

	local v8 = if fFlagProfilePlatformEnableImpressions then useProfileAnalyticsContext() else nil

	local scrollViewPositionChangedSignal = if fFlagProfilePlatformEnableImpressions then v8.scrollViewPositionChangedSignal else nil

	local joined = Cryo.Dictionary.join({
		bottomPadding = React.createElement("Frame", {
			Size = UDim2.fromOffset(0, 8),
			BackgroundTransparency = 1,
			LayoutOrder = 99999
		})
	}, p2.children)

	local createElement = React.createElement
	local v10 = {}
	v10.Position = UDim2.new(0, 0, 0, 0)
	v10.Size = UDim2.new(1, 0, 0, getPeekViewOpenHeightByProfileType(profileType))
	v10.AutomaticSize = Enum.AutomaticSize.Y
	v10.BorderSizePixel = 0
	local v11 = if profileType == Enums.ProfileTypes.Community and not (v7 or isFullView) then theme.BackgroundContrast.Transparency else theme.BackgroundDefault.Transparency
	v10.BackgroundTransparency = v11

	local v12 = if profileType == Enums.ProfileTypes.Community and not (v7 or isFullView) then theme.BackgroundContrast.Color else theme.BackgroundDefault.Color
	v10.BackgroundColor3 = v12

	v10[React.Change.AbsolutePosition] = function(p3)
		v5.setAbsoluteYPosition(p3.AbsolutePosition.Y)
		scrollViewPositionChangedSignal:fire()
	end

	return createElement("Frame", v10, joined)
end

return ProfilePlatformPage
