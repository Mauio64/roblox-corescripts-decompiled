local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Cryo = require(ProfilePlatformParent.Cryo)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local React = require(ProfilePlatformParent.React)
local useStyle = UIBlox.Core.Style.useStyle
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileScrollContext = require(ProfilePlatform.Contexts.ProfileScrollContext.useProfileScrollContext)
local getPeekViewOpenHeightByProfileType = require(ProfilePlatform.Utils.getPeekViewOpenHeightByProfileType)
local FFlagProfilePlatformEnableImpressions = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableImpressions

local function ProfilePlatformPage(t1: {[any]: any}) -- line: 23
	-- upvalues: useProfileWrapperContext (copy), useProfileScrollContext (copy), useProfileFormFactor (copy), Enums (copy), useStyle (copy), FFlagProfilePlatformEnableImpressions (copy), useProfileAnalyticsContext (copy), Cryo (copy), React (copy), getPeekViewOpenHeightByProfileType (copy)
	local profileType = useProfileWrapperContext().profileType
	local v17 = useProfileScrollContext()
	local v18 = useProfileFormFactor()
	local v19 = v18.formFactor == Enums.ProfileFormFactor.Wide
	local isFullView = v18.isFullView
	local Theme = useStyle().Theme
	local v22 = if not FFlagProfilePlatformEnableImpressions then nil else useProfileAnalyticsContext()
	local v23 = if not FFlagProfilePlatformEnableImpressions then nil else v22.scrollViewPositionChangedSignal
	local v24 = Cryo.Dictionary.join({
		bottomPadding = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 99999,
			Size = UDim2.fromOffset(0, 8)
		})
	}, t1.children)

	return React.createElement("Frame", {
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, getPeekViewOpenHeightByProfileType(profileType)),
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = if profileType ~= Enums.ProfileTypes.Community or (v19 or isFullView) then Theme.BackgroundDefault.Transparency else Theme.BackgroundContrast.Transparency,
		BackgroundColor3 = if profileType ~= Enums.ProfileTypes.Community or (v19 or isFullView) then Theme.BackgroundDefault.Color else Theme.BackgroundContrast.Color,
		[React.Change.AbsolutePosition] = function(p1) -- line: 65
			-- upvalues: v17 (copy), v23 (copy)
			v17.setAbsoluteYPosition(p1.AbsolutePosition.Y)
			v23:fire()
		end
	}, v24)
end

return ProfilePlatformPage
