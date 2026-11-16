local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local text = Foundation.Text
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local createTextWithLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/createTextWithLinks")
local WebViewLink = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Components/WebViewLink")

local function Paragraph(p2)
	local v5 = React.useMemo(function()
		return createTextWithLinks(p2.component.paragraph.text, p2.component.paragraph.links)
	end, { p2.component.paragraph.text, p2.component.paragraph.links })

	local v6 = React.useMemo(function()
		if not p2.component.paragraph.links then
			return {}
		end

		local children = {}

		for k, link in p2.component.paragraph.links do
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
	end, { p2.component })

	return React.createElement(view, {
		tag = "size-full-0 auto-y col",
		LayoutOrder = p2.layoutOrder
	}, {
		Text = React.createElement(text, {
			Text = v5,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			tag = "auto-xy padding-bottom-small",
			LayoutOrder = 0
		}),
		Links = React.createElement(view, {
			tag = "size-full-0 auto-y col wraps",
			LayoutOrder = 1
		}, v6)
	})
end

return React.memo(Paragraph)
