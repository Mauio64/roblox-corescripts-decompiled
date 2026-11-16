local TeleportService = game:GetService("TeleportService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Foundation")

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local useTeleportBack = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Hooks/useTeleportBack")
local TraversalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TraversalTelemetry")

local function TeleportBackButton(p2, p3)
	local thirdPartyTeleportInfo, v5 = TeleportService:GetThirdPartyTeleportInfo(false)
	local v6 = useTeleportBack(v5)
	local v7 = Foundation.Hooks.useTokens()

	local foreground = v7.Color.ActionStandard.Foreground

	return React.createElement(view, {
		tag = "padding-left-small padding-right-medium align-x-center align-y-center auto-x bg-over-media-0 radius-circle row size-0-1100",
		onActivated = function()
			TraversalTelemetry.sendBackButtonActionEvent({
				integration_id = "back_button",
				destination_universe_id = thirdPartyTeleportInfo,
				event_type = "click"
			})

			v6()
		end,
		ref = p3
	}, {
		TeleportBackIcon = React.createElement(icon, {
			name = iconName.ChevronLargeLeft,
			style = foreground,
			size = iconSize.Medium,
			LayoutOrder = 1
		}),
		TeleportText = p2.text and React.createElement(text, {
			Text = p2.text,
			tag = "auto-x size-0-full text-truncate-split text-label-medium",
			sizeConstraint = p2.textLimitWidth and {
				MaxSize = Vector2.new(p2.textLimitWidth, v7.Size.Size_1100)
			},
			textStyle = foreground,
			LayoutOrder = 2
		})
	})
end

return React.memo(React.forwardRef(TeleportBackButton))
