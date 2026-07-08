local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(script.Parent.useTimeoutBannerProps)

local function TimeoutBanner(p1) -- line: 17
	-- upvalues: React (copy), Foundation (copy)
	if not p1.shouldShow then
		return nil
	end

	local onBannerActivated = p1.onBannerActivated
	local messageText = p1.messageText

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
			LayoutOrder = 2,
			Text = messageText
		})
	})
end

return TimeoutBanner
