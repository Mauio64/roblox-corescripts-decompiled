local Parent = script:FindFirstAncestor("DsaIllegalContentReporting").Parent
local Foundation = require(Parent.Foundation)
local default = require(Parent.LinkingProtocol).LinkingProtocol.default
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local ControlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local View = Foundation.View
local v12 = game:DefineFastString("TakeItDownReportLink", "https://www.roblox.com/non-consensual-intimate-imagery-removal-request")

local function TakeItDownReportLink(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), useLocalization (copy), getIconRichText (copy), IconName (copy), default (copy), v12 (copy), ControlState (copy), View (copy), FoundationText (copy)
	local v15, v16 = React.useState(false)
	local v17 = `<b>{ useLocalization({
		TakeItDownReportLinkText = "Feature.ReportAbuse.Label.TakeItDownCopy"
	}).TakeItDownReportLinkText }</b> { getIconRichText(IconName.ArrowUpRightFromSquare) }`
	local v18 = React.useCallback(function() -- line: 37
		-- upvalues: default (copy), v12 (copy)
		default:openURL(v12)
	end, {})
	local v19 = React.useCallback(function(p1) -- line: 41
		-- upvalues: v16 (copy), ControlState (copy)
		v16(p1 == ControlState.Hover)
	end, {})

	return React.createElement(View, {
		tag = "auto-xy",
		LayoutOrder = t1.layoutOrder
	}, React.createElement(FoundationText, {
		RichText = true,
		tag = "auto-xy radius-small padding-xsmall text-wrap text-body-small",
		Text = if not v15 then v17 else `<u>{ v17 }</u>`,
		onActivated = v18,
		onStateChanged = v19
	}))
end

return React.memo(TakeItDownReportLink)
