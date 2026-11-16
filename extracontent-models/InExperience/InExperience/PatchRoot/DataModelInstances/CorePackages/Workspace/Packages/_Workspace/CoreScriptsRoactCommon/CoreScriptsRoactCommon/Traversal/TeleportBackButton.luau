local TeleportService = game:GetService("TeleportService")

local CoreScriptsRoactCommon = script:FindFirstAncestor("CoreScriptsRoactCommon")
local parent = CoreScriptsRoactCommon.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local useTeleportBack = require(CoreScriptsRoactCommon.Hooks.useTeleportBack)
local TraversalTelemetry = require(script.Parent.TraversalTelemetry)

local function TeleportBackButton(p, ref)
	local thirdPartyTeleportInfo, v = TeleportService:GetThirdPartyTeleportInfo(false)
	local v2 = useTeleportBack(v)
	local v3 = Foundation.Hooks.useTokens()

	local foreground = v3.Color.ActionStandard.Foreground

	return React.createElement(View, {
		tag = "padding-left-small padding-right-medium align-x-center align-y-center auto-x bg-over-media-0 radius-circle row size-0-1100",
		onActivated = function()
			TraversalTelemetry.sendBackButtonActionEvent({
				integration_id = "back_button",
				destination_universe_id = thirdPartyTeleportInfo,
				event_type = "click"
			})

			v2()
		end,
		ref = ref
	}, {
		TeleportBackIcon = React.createElement(Icon, {
			name = IconName.ChevronLargeLeft,
			style = foreground,
			size = IconSize.Medium,
			LayoutOrder = 1
		}),
		TeleportText = p.text and React.createElement(Text, {
			Text = p.text,
			tag = "auto-x size-0-full text-truncate-split text-label-medium",
			sizeConstraint = p.textLimitWidth and {
				MaxSize = Vector2.new(p.textLimitWidth, v3.Size.Size_1100)
			},
			textStyle = foreground,
			LayoutOrder = 2
		})
	})
end

return React.memo(React.forwardRef(TeleportBackButton))
