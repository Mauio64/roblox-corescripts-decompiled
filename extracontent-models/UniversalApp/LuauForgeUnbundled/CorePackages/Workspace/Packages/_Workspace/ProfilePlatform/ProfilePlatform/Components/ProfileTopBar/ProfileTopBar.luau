local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FocusNavigationUtils")

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local useProfileScrollContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileScrollContext/useProfileScrollContext")
local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformNewProfileHeader
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local view = Foundation.View
local divider = Foundation.Divider

local iconsnavigationclose = images["icons/navigation/close"]

local v5 = Constants.USER_PROFILE_HEADER_HEIGHT + Constants.CTA_BUTTON_HEIGHT + Constants.PAGE_PADDING

return function(props)
	local v6 = useLastInputMode() == "Focus"
	local v7 = useStyle()

	local v8 = useProfileScrollContext()
	local v9 = not v8 and 0 or v8.scrollY

	local v10 = React.useCallback(function()
		props.navigateBack()
	end, { props.navigateBack })
	local v11 = not fFlagProfilePlatformNewProfileHeader and 10 or nil
	local v12 = React.useMemo(function()
		if props.backgroundTransparency ~= nil then
			return props.backgroundTransparency
		end

		local v13 = v5 - 50

		if v9 < v13 then
			return 1
		end

		if v5 <= v9 then
			return 0
		end

		return 1 - (v9 - v13) / 50
	end, { props.backgroundTransparency, v9 })
	local createElement = React.createElement
	local v16

	if not (v6 or props.hideNavigationButton) then
		local createElement2 = React.createElement

		local v19 = if fFlagProfilePlatformNewProfileHeader then Vector2.new(0, 0.5) else nil

		local v20 = if fFlagProfilePlatformNewProfileHeader then UDim2.new(0, 10, 0.5, 0) else UDim2.new(0, 10, 0, v11)
		v16 = createElement2(view, {
			tag = "bg-over-media-0 radius-circle",
			AnchorPoint = v19,
			Position = v20,
			Size = UDim2.new(0, 36, 0, 36),
			onActivated = v10,
			backgroundStyle = {
				Transparency = 1 - v12
			}
		}, {
			InnerButton = React.createElement(
				"ImageButton",
				{
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					[React.Event.Activated] = v10
				},
				{
					CloseButtonImage = React.createElement(imageSetLabel, {
						Size = UDim2.new(0, 24, 0, 24),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = iconsnavigationclose,
						ImageColor3 = v7.Theme.IconEmphasis.Color,
						ImageTransparency = v7.Theme.IconEmphasis.Transparency,
						BackgroundTransparency = 1
					})
				}
			)
		})
	end

	return createElement(view, {
		tag = "bg-surface-0 position-top-left size-full-full",
		backgroundStyle = { Transparency = v12 },
		ZIndex = 100
	}, {
		LeftNavigationButton = v16,
		BottomDivider = React.createElement(divider, {
			Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 0, 1),
			Visible = v12 < 1
		})
	})
end
