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

local defineFastString = game:DefineFastString("GenericReportLink", "https://www.roblox.com/illegal-content-reporting")
local defineFastFlag = game:DefineFastFlag("ImproveIllegalContentReportingLinkLook", false)

function GenericReportLink()
	local state, setState

	if defineFastFlag then
		state, setState = React.useState(false)
	else
		setState = nil
	end

	local v = useLocalization({
		GenericReportLinkText = "Feature.ReportAbuse.Label.GenericReportIllegalContentMessage"
	})
	local text

	if defineFastFlag then
		text = `<b>{v.GenericReportLinkText}</b> {getIconRichText(IconName.ArrowUpRightFromSquare)}`
	end

	local onActivated = React.useCallback(function()
		default:openURL(defineFastString)
	end, {})
	local onStateChanged

	if defineFastFlag then
		onStateChanged = React.useCallback(function(p)
			setState(p == ControlState.Hover)
		end, {})
	end

	local createElement = React.createElement

	local createElement2 = React.createElement

	if defineFastFlag then
		if state then
			text = `<u>{text}</u>`
		end
	else
		text = `<b>{v.GenericReportLinkText}</b>`
	end

	if not defineFastFlag then
		onStateChanged = nil
	end

	return createElement(View, { tag = "auto-xy col gap-small" }, { createElement2(Text, {
			Text = text,
			RichText = true,
			onActivated = onActivated,
			onStateChanged = onStateChanged,
			tag = "auto-xy radius-small padding-xsmall text-wrap text-body-small"
		}) })
end

return React.memo(GenericReportLink)
