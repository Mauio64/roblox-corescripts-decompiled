local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local FoundationText = Foundation.Text
local View = Foundation.View

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local createTextWithLinks = require(GenericAbuseReporting.Bedui.Utils.createTextWithLinks)
local WebViewLink = require(GenericAbuseReporting.Bedui.Components.WebViewLink)

local function Paragraph(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), createTextWithLinks (copy), WebViewLink (copy), View (copy), FoundationText (copy)
	local v11 = React.useMemo(function() -- line: 22
		-- upvalues: createTextWithLinks (copy), t1 (copy)
		return createTextWithLinks(t1.component.paragraph.text, t1.component.paragraph.links)
	end, {
		t1.component.paragraph.text,
		t1.component.paragraph.links
	})
	local v12 = React.useMemo(function() -- line: 30
		-- upvalues: t1 (copy), React (copy), WebViewLink (copy)
		if not t1.component.paragraph.links then
			return {}
		end

		local t2 = {}

		for _, v15 in t1.component.paragraph.links do
			table.insert(t2, React.createElement(WebViewLink, {
				component = {
					componentType = "link",
					isOptional = true,
					formDataKey = nil,
					link = v15
				}
			}))
		end

		return t2
	end, { t1.component })

	return React.createElement(View, {
		tag = "size-full-0 auto-y col",
		LayoutOrder = t1.layoutOrder
	}, {
		Text = React.createElement(FoundationText, {
			TextWrapped = true,
			tag = "auto-xy padding-bottom-small",
			LayoutOrder = 0,
			Text = v11,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Links = React.createElement(View, {
			tag = "size-full-0 auto-y col wraps",
			LayoutOrder = 1
		}, v12)
	})
end

return React.memo(Paragraph)
