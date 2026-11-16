local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/TimeoutBanner/useTimeoutBannerProps")

local function TimeoutBanner(props)
	if not props.shouldShow then
		return nil
	end

	local onBannerActivated = props.onBannerActivated
	local messageText = props.messageText

	return React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 padding-x-medium padding-y-small row align-x-center align-y-center gap-small",
		onActivated = onBannerActivated or nil
	}, {
		WarningIcon = React.createElement(Foundation.Image, {
			tag = "content-system-warning size-600",
			Image = "icons/status/alert",
			LayoutOrder = 1
		}),
		Text = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-large text-wrap content-emphasis",
			Text = messageText,
			LayoutOrder = 2
		})
	})
end

return TimeoutBanner
