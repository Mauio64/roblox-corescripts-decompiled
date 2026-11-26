local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/Foundation")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/LinkingProtocol").LinkingProtocol.default
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/React")

local controlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local iconName = Foundation.Enums.IconName
local text = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local view = Foundation.View

local defineFastString = game:DefineFastString(
	"TakeItDownReportLink",
	"https://www.roblox.com/non-consensual-intimate-imagery-removal-request"
)

local function TakeItDownReportLink(p2)
	local state, setState = React.useState(false)

	local formatted = `<b>{useLocalization({ TakeItDownReportLinkText = "Feature.ReportAbuse.Label.TakeItDownCopy" }).TakeItDownReportLinkText}</b> {getIconRichText(iconName.ArrowUpRightFromSquare)}`

	local v5 = React.useCallback(function()
		default:openURL(defineFastString)
	end, {})

	local v6 = React.useCallback(function(p3)
		setState(p3 == controlState.Hover)
	end, {})

	local createElement = React.createElement

	local v8 = { tag = "auto-xy", LayoutOrder = p2.layoutOrder }

	local createElement2 = React.createElement

	if state then
		formatted = `<u>{formatted}</u>`
	end

	return createElement(view, v8, createElement2(text, {
		Text = formatted,
		RichText = true,
		onActivated = v5,
		onStateChanged = v6,
		tag = "auto-xy radius-small padding-xsmall text-wrap text-body-small"
	}))
end

return React.memo(TakeItDownReportLink)
