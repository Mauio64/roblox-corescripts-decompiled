local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local Constants = require(ProfilePlatform.Common.Constants)
local useProfileScrollContext = require(ProfilePlatform.Contexts.ProfileScrollContext.useProfileScrollContext)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Divider = Foundation.Divider

local iconsnavigationclose = Images["icons/navigation/close"]

local v = Constants.USER_PROFILE_HEADER_HEIGHT + Constants.CTA_BUTTON_HEIGHT + Constants.PAGE_PADDING

return function(props)
	local v2 = useLastInputMode() == "Focus"
	local v3 = useStyle()

	local v4 = useProfileScrollContext()
	local v5 = not v4 and 0 or v4.scrollY

	local onActivated = React.useCallback(function()
		props.navigateBack()
	end, { props.navigateBack })
	local v6 = not FFlagProfilePlatformNewProfileHeader and 10 or nil
	local transparency = React.useMemo(function()
		if props.backgroundTransparency ~= nil then
			return props.backgroundTransparency
		end

		local v7 = v - 50

		if v5 < v7 then
			return 1
		end

		if v <= v5 then
			return 0
		end

		return 1 - (v5 - v7) / 50
	end, { props.backgroundTransparency, v5 })
	local createElement = React.createElement
	local leftNavigationButton

	if not (v2 or props.hideNavigationButton) then
		local createElement2 = React.createElement
		local anchorPoint

		if FFlagProfilePlatformNewProfileHeader then
			anchorPoint = Vector2.new(0, 0.5)
		end

		local position

		if FFlagProfilePlatformNewProfileHeader then
			position = UDim2.new(0, 10, 0.5, 0)
		else
			position = UDim2.new(0, 10, 0, v6)
		end

		leftNavigationButton = createElement2(View, {
			tag = "bg-over-media-0 radius-circle",
			AnchorPoint = anchorPoint,
			Position = position,
			Size = UDim2.new(0, 36, 0, 36),
			onActivated = onActivated,
			backgroundStyle = {
				Transparency = 1 - transparency
			}
		}, {
			InnerButton = React.createElement(
				"ImageButton",
				{
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					[React.Event.Activated] = onActivated
				},
				{
					CloseButtonImage = React.createElement(ImageSetLabel, {
						Size = UDim2.new(0, 24, 0, 24),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = iconsnavigationclose,
						ImageColor3 = v3.Theme.IconEmphasis.Color,
						ImageTransparency = v3.Theme.IconEmphasis.Transparency,
						BackgroundTransparency = 1
					})
				}
			)
		})
	end

	return (createElement(View, {
		tag = "bg-surface-0 position-top-left size-full-full",
		backgroundStyle = { Transparency = transparency },
		ZIndex = 100
	}, {
		LeftNavigationButton = leftNavigationButton,
		BottomDivider = React.createElement(Divider, {
			Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 0, 1),
			Visible = transparency < 1
		})
	}))
end
