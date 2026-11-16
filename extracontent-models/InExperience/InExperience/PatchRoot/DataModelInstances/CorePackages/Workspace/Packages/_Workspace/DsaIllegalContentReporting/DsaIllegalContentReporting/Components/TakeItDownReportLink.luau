local parent = script:FindFirstAncestor("DsaIllegalContentReporting").Parent

local Foundation = require(parent.Foundation)
local LinkingProtocol = require(parent.LinkingProtocol)
local default = LinkingProtocol.LinkingProtocol.default
local Localization = require(parent.Localization)
local React = require(parent.React)

local ControlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local Text = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local View = Foundation.View

local defineFastString = game:DefineFastString(
	"TakeItDownReportLink",
	"https://www.roblox.com/non-consensual-intimate-imagery-removal-request"
)

local function TakeItDownReportLink(p)
	local state, setState = React.useState(false)

	local formatted = `<b>{useLocalization({ TakeItDownReportLinkText = "Feature.ReportAbuse.Label.TakeItDownCopy" }).TakeItDownReportLinkText}</b> {getIconRichText(IconName.ArrowUpRightFromSquare)}`

	local onActivated = React.useCallback(function()
		default:openURL(defineFastString)
	end, {})

	local onStateChanged = React.useCallback(function(p2)
		setState(p2 == ControlState.Hover)
	end, {})

	local createElement = React.createElement

	local v = { tag = "auto-xy", LayoutOrder = p.layoutOrder }

	local createElement2 = React.createElement

	if state then
		formatted = `<u>{formatted}</u>`
	end

	return createElement(View, v, createElement2(Text, {
		Text = formatted,
		RichText = true,
		onActivated = onActivated,
		onStateChanged = onStateChanged,
		tag = "auto-xy radius-small padding-xsmall text-wrap text-body-small"
	}))
end

return React.memo(TakeItDownReportLink)
