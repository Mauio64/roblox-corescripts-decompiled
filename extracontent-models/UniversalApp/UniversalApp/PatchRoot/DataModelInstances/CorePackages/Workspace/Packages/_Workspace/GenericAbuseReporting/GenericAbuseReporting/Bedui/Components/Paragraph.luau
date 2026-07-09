local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FoundationText = Foundation.Text
local View = Foundation.View
local AbuseReportBeduiTypes = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local createTextWithLinks = require(GenericAbuseReporting.Bedui.Utils.createTextWithLinks)
local NotificationType = AbuseReportBeduiTypes.NotificationType
local WebViewLink = require(GenericAbuseReporting.Bedui.Components.WebViewLink)
local FFlagChangeWebViewReportButtonToText = require(GenericAbuseReportingParent.SharedFlags).FFlagChangeWebViewReportButtonToText

local function Paragraph(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), createTextWithLinks (copy), FFlagChangeWebViewReportButtonToText (copy), WebViewLink (copy), Button (copy), ButtonVariant (copy), HttpService (copy), GuiService (copy), NotificationType (copy), View (copy), FoundationText (copy)
	local v18 = React.useMemo(function() -- line: 29
		-- upvalues: createTextWithLinks (copy), t1 (copy)
		return createTextWithLinks(t1.component.paragraph.text, t1.component.paragraph.links)
	end, {
		t1.component.paragraph.text,
		t1.component.paragraph.links
	})
	local v19 = React.useMemo(function() -- line: 37
		-- upvalues: t1 (copy), FFlagChangeWebViewReportButtonToText (copy), React (copy), WebViewLink (copy), Button (copy), ButtonVariant (copy), HttpService (copy), GuiService (copy), NotificationType (copy)
		if not t1.component.paragraph.links then
			return {}
		end

		local t2 = {}

		for _, v22 in t1.component.paragraph.links do
			if FFlagChangeWebViewReportButtonToText then
				table.insert(t2, React.createElement(WebViewLink, {
					component = {
						componentType = "link",
						isOptional = true,
						formDataKey = nil,
						link = v22
					}
				}))
			else
				table.insert(t2, React.createElement(Button, {
					text = v22.linkButtonLabel,
					variant = ButtonVariant.Text,
					onActivated = function() -- line: 62
						-- upvalues: HttpService (copy), v22 (copy), GuiService (copy), NotificationType (copy)
						local ok, result = pcall(function() -- line: 63
							-- upvalues: HttpService (copy), v22 (copy)
							return HttpService:JSONEncode({
								presentationStyle = nil,
								visible = true,
								title = v22.label,
								url = v22.url
							})
						end)

						if not ok then
							warn("Failed to encode notification data for bedui paragraph")

							return
						end

						GuiService:BroadcastNotification(result, NotificationType.OpenCustomWebView)
					end
				}))
			end
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
			Text = v18,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Links = React.createElement(View, {
			tag = "size-full-0 auto-y col wraps",
			LayoutOrder = 1
		}, v19)
	})
end

return React.memo(Paragraph)
