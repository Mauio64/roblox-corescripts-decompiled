local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local createTextWithLinks = require(GenericAbuseReporting.Bedui.Utils.createTextWithLinks)
local WebViewLink = require(GenericAbuseReporting.Bedui.Components.WebViewLink)

local function Paragraph(p)
	local text = React.useMemo(function()
		return createTextWithLinks(p.component.paragraph.text, p.component.paragraph.links)
	end, { p.component.paragraph.text, p.component.paragraph.links })

	local v = React.useMemo(function()
		if not p.component.paragraph.links then
			return {}
		end

		local children = {}

		for _, link in p.component.paragraph.links do
			table.insert(children, React.createElement(WebViewLink, {
				component = {
					componentType = "link",
					isOptional = true,
					formDataKey = nil,
					link = link
				}
			}))
		end

		return children
	end, { p.component })

	return React.createElement(View, { tag = "size-full-0 auto-y col", LayoutOrder = p.layoutOrder }, {
		Text = React.createElement(Text, {
			Text = text,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			tag = "auto-xy padding-bottom-small",
			LayoutOrder = 0
		}),
		Links = React.createElement(View, { tag = "size-full-0 auto-y col wraps", LayoutOrder = 1 }, v)
	})
end

return React.memo(Paragraph)
