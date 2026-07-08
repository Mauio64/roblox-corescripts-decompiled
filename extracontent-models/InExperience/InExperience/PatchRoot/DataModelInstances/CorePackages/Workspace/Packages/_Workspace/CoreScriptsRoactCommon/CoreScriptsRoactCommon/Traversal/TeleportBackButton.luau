local TeleportService = game:GetService("TeleportService")
local CoreScriptsRoactCommon = script:FindFirstAncestor("CoreScriptsRoactCommon")
local CoreScriptsRoactCommonParent = CoreScriptsRoactCommon.Parent
local React = require(CoreScriptsRoactCommonParent.React)
local Foundation = require(CoreScriptsRoactCommonParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTeleportBack = require(CoreScriptsRoactCommon.Hooks.useTeleportBack)
local TraversalTelemetry = require(script.Parent.TraversalTelemetry)

local function TeleportBackButton(t1: {[any]: any}, p1) -- line: 23
	-- upvalues: TeleportService (copy), useTeleportBack (copy), Foundation (copy), React (copy), View (copy), TraversalTelemetry (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy)
	local v16, v17 = TeleportService:GetThirdPartyTeleportInfo(false)
	local v18 = useTeleportBack(v17)
	local v19 = Foundation.Hooks.useTokens()
	local Foreground = v19.Color.ActionStandard.Foreground

	return React.createElement(View, {
		tag = "padding-left-small padding-right-medium align-x-center align-y-center auto-x bg-over-media-0 radius-circle row size-0-1100",
		onActivated = function() -- line: 32
			-- upvalues: TraversalTelemetry (copy), v16 (copy), v18 (copy)
			TraversalTelemetry.sendBackButtonActionEvent({
				integration_id = "back_button",
				event_type = "click",
				destination_universe_id = v16
			})
			v18()
		end,
		ref = p1
	}, {
		TeleportBackIcon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.ChevronLargeLeft,
			style = Foreground,
			size = IconSize.Medium
		}),
		TeleportText = t1.text and React.createElement(FoundationText, {
			tag = "auto-x size-0-full text-truncate-split text-label-medium",
			LayoutOrder = 2,
			Text = t1.text,
			sizeConstraint = t1.textLimitWidth and {
				MaxSize = Vector2.new(t1.textLimitWidth, v19.Size.Size_1100)
			},
			textStyle = Foreground
		})
	})
end

return React.memo(React.forwardRef(TeleportBackButton))
