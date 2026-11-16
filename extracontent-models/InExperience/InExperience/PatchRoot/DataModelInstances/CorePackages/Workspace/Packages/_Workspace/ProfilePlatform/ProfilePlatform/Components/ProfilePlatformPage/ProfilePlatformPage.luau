local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Cryo = require(parent.Cryo)
local UIBlox = require(parent.UIBlox)
local React = require(parent.React)
local useStyle = UIBlox.Core.Style.useStyle

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileScrollContext = require(ProfilePlatform.Contexts.ProfileScrollContext.useProfileScrollContext)
local getPeekViewOpenHeightByProfileType = require(ProfilePlatform.Utils.getPeekViewOpenHeightByProfileType)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableImpressions = SharedFlags.FFlagProfilePlatformEnableImpressions

local function ProfilePlatformPage(p)
	local profileType = useProfileWrapperContext().profileType

	local v = useProfileScrollContext()

	local v2 = useProfileFormFactor()
	local v3 = v2.formFactor == Enums.ProfileFormFactor.Wide
	local isFullView = v2.isFullView

	local theme = useStyle().Theme
	local v4

	if FFlagProfilePlatformEnableImpressions then
		v4 = useProfileAnalyticsContext()
	end

	local scrollViewPositionChangedSignal

	if FFlagProfilePlatformEnableImpressions then
		scrollViewPositionChangedSignal = v4.scrollViewPositionChangedSignal
	else
		scrollViewPositionChangedSignal = nil
	end

	local joined = Cryo.Dictionary.join({
		bottomPadding = React.createElement("Frame", {
			Size = UDim2.fromOffset(0, 8),
			BackgroundTransparency = 1,
			LayoutOrder = 99999
		})
	}, p.children)

	local createElement = React.createElement
	local v5 = {}
	v5.Position = UDim2.new(0, 0, 0, 0)
	v5.Size = UDim2.new(1, 0, 0, getPeekViewOpenHeightByProfileType(profileType))
	v5.AutomaticSize = Enum.AutomaticSize.Y
	v5.BorderSizePixel = 0
	local backgroundTransparency

	if profileType == Enums.ProfileTypes.Community and not (v3 or isFullView) then
		backgroundTransparency = theme.BackgroundContrast.Transparency
	else
		backgroundTransparency = theme.BackgroundDefault.Transparency
	end

	v5.BackgroundTransparency = backgroundTransparency
	local backgroundColor

	if profileType == Enums.ProfileTypes.Community and not (v3 or isFullView) then
		backgroundColor = theme.BackgroundContrast.Color
	else
		backgroundColor = theme.BackgroundDefault.Color
	end

	v5.BackgroundColor3 = backgroundColor

	v5[React.Change.AbsolutePosition] = function(p2)
		v.setAbsoluteYPosition(p2.AbsolutePosition.Y)
		scrollViewPositionChangedSignal:fire()
	end

	return createElement("Frame", v5, joined)
end

return ProfilePlatformPage
