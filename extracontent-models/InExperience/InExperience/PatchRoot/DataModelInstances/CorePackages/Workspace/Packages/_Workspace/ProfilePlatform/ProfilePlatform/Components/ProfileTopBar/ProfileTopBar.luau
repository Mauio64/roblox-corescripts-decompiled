local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local FocusNavigationUtils = require(ProfilePlatformParent.FocusNavigationUtils)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local Constants = require(ProfilePlatform.Common.Constants)
local useProfileScrollContext = require(ProfilePlatform.Contexts.ProfileScrollContext.useProfileScrollContext)
local FFlagProfilePlatformNewProfileHeader = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local Foundation = require(ProfilePlatformParent.Foundation)
local View = Foundation.View
local Divider = Foundation.Divider
local v16 = Images["icons/navigation/close"]
local v17 = Constants.USER_PROFILE_HEADER_HEIGHT + Constants.CTA_BUTTON_HEIGHT + Constants.PAGE_PADDING

return function(t1: {[any]: any}) -- line: 35
	-- upvalues: useLastInputMode (copy), useStyle (copy), useProfileScrollContext (copy), React (copy), FFlagProfilePlatformNewProfileHeader (copy), v17 (copy), View (copy), ImageSetLabel (copy), v16 (copy), Divider (copy)
	local v19 = useLastInputMode() == "Focus"
	local v20 = useStyle()
	local v21 = useProfileScrollContext()
	local v22 = not v21 and 0 or v21.scrollY
	local v23 = React.useCallback(function() -- line: 43
		-- upvalues: t1 (copy)
		t1.navigateBack()
	end, { t1.navigateBack })
	local v24 = not FFlagProfilePlatformNewProfileHeader and 10 or nil
	local v25 = React.useMemo(function() -- line: 49
		-- upvalues: t1 (copy), v17 (copy), v22 (copy)
		if t1.backgroundTransparency ~= nil then
			return t1.backgroundTransparency
		end

		local v26 = v17 - 50

		if v26 > v22 then
			return 1
		end

		if v22 >= v17 then
			return 0
		end

		return 1 - (v22 - v26) / 50
	end, {
		t1.backgroundTransparency,
		v22
	})

	return (React.createElement(View, {
		tag = "bg-surface-0 position-top-left size-full-full",
		ZIndex = 100,
		backgroundStyle = {
			Transparency = v25
		}
	}, {
		LeftNavigationButton = if v19 or t1.hideNavigationButton then nil else React.createElement(View, {
			tag = "bg-over-media-0 radius-circle",
			AnchorPoint = if not FFlagProfilePlatformNewProfileHeader then nil else Vector2.new(0, 0.5),
			Position = if not FFlagProfilePlatformNewProfileHeader then UDim2.new(0, 10, 0, v24) else UDim2.new(0, 10, 0.5, 0),
			Size = UDim2.new(0, 36, 0, 36),
			onActivated = v23,
			backgroundStyle = {
				Transparency = 1 - v25
			}
		}, {
			InnerButton = React.createElement("ImageButton", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				[React.Event.Activated] = v23
			}, {
				CloseButtonImage = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = v16,
					ImageColor3 = v20.Theme.IconEmphasis.Color,
					ImageTransparency = v20.Theme.IconEmphasis.Transparency
				})
			})
		}),
		BottomDivider = React.createElement(Divider, {
			Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 0, 1),
			Visible = v25 < 1
		})
	}))
end
