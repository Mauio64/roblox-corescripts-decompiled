local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local CoreScriptsPlayerFeedbackParent = CoreScriptsPlayerFeedback.Parent
local React = require(CoreScriptsPlayerFeedbackParent.React)
local Foundation = require(CoreScriptsPlayerFeedbackParent.Foundation)
local Dialog = Foundation.Dialog
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local BuilderIcons = require(CoreScriptsPlayerFeedbackParent.BuilderIcons)
local IconVariant = BuilderIcons.IconVariant
local useLocalization = require(CoreScriptsPlayerFeedbackParent.Localization).Hooks.useLocalization
local useEscapeDismiss = require(CoreScriptsPlayerFeedback.Hooks.useEscapeDismiss)
local t1 = {
	TICKET_CREATION_TEXT_FILTER_ERROR = {
		titleKey = "TextFilterTitle",
		bodyKey = "TextFilterBody",
		hasReportLink = true
	},
	TICKET_CREATION_ELIGIBILITY_FAILURE_REASON_UNDER13 = {
		titleKey = "Under13Title",
		bodyKey = "Under13Body"
	},
	TICKET_CREATION_ELIGIBILITY_FAILURE_REASON_NOT_RECENTLY_VISITED = {
		titleKey = "NotRecentlyVisitedTitle",
		bodyKey = "NotRecentlyVisitedBody"
	},
	TICKET_CREATION_ELIGIBILITY_FAILURE_REASON_OPEN_TICKET_LIMIT_REACHED = {
		titleKey = "OpenTicketLimitTitle",
		bodyKey = "OpenTicketLimitBody"
	},
	RateLimited = {
		titleKey = "RateLimitedTitle",
		bodyKey = "RateLimitedBody"
	}
}
local t2 = {
	titleKey = "DefaultTitle",
	bodyKey = "DefaultBody"
}

local function openAbuseReportPage() -- line: 99
	pcall(function() -- line: 100
		local RobloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
		local v27 = RobloxGui and RobloxGui:FindFirstChild("Modules") or nil
		local v28 = v27 and v27:FindFirstChild("Settings") or nil
		local v29 = v28 and v28:FindFirstChild("SettingsHub") or nil

		if not v29 then
			return
		end

		local lib = require(v29)

		lib:SetVisibility(true, false, lib.Instance.ReportAbusePage)
	end)
end

return (React.memo(function(t3: {[any]: any}) -- line: 114
	-- upvalues: useTokens (copy), useLocalization (copy), t1 (copy), t2 (copy), React (copy), useEscapeDismiss (copy), Dialog (copy), View (copy), Icon (copy), BuilderIcons (copy), IconSize (copy), IconVariant (copy), FoundationText (copy), ButtonVariant (copy)
	local v20 = useTokens()
	local v21 = useLocalization({
		BackButton = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.BackButton",
		Under13Title = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.Under13.Title",
		Under13Body = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.Under13.Body",
		NotRecentlyVisitedTitle = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.NotRecentlyVisited.Title",
		NotRecentlyVisitedBody = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.NotRecentlyVisited.Body",
		OpenTicketLimitTitle = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.OpenTicketLimit.Title",
		OpenTicketLimitBody = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.OpenTicketLimit.Body",
		RateLimitedTitle = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.RateLimited.Title",
		RateLimitedBody = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.RateLimited.Body",
		DefaultTitle = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.Default.Title",
		DefaultBody = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.Default.Body",
		TextFilterTitle = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.TextFilter.Title",
		TextFilterBody = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.TextFilter.Body",
		TextFilterLink = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ReportAbuse.Link"
	})
	local v22 = t1[t3.reason or ""] or t2
	local t4 = {
		title = v21[v22.titleKey],
		body = v21[v22.bodyKey],
		hasReportLink = v22.hasReportLink
	}
	local v24 = React.useCallback(function() -- line: 141
		-- upvalues: t3 (copy)
		t3.closePrompt()

		if t3.openPlayerSupportPrompt then
			t3.openPlayerSupportPrompt()
		end
	end, {
		t3.closePrompt,
		t3.openPlayerSupportPrompt
	})
	local v25 = React.useCallback(function() -- line: 148
		-- upvalues: t3 (copy)
		t3.closePrompt()
		pcall(function() -- line: 100
			local RobloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
			local v32 = RobloxGui and RobloxGui:FindFirstChild("Modules") or nil
			local v33 = v32 and v32:FindFirstChild("Settings") or nil
			local v34 = v33 and v33:FindFirstChild("SettingsHub") or nil

			if not v34 then
				return
			end

			local lib = require(v34)

			lib:SetVisibility(true, false, lib.Instance.ReportAbusePage)
		end)
	end, { t3.closePrompt })

	useEscapeDismiss("PlayerSupportUnavailableCancel", v24)

	return React.createElement(Dialog.Root, {
		hasBackdrop = true
	}, {
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 1
		}, {
			Body = React.createElement(View, {
				tag = "col gap-large size-full-0 auto-y",
				padding = {
					top = UDim.new(0, v20.Size.Size_500)
				}
			}, {
				TitleRow = React.createElement(View, {
					tag = "row items-center gap-small auto-y",
					LayoutOrder = 1
				}, {
					AlertIcon = React.createElement(Icon, {
						LayoutOrder = 1,
						name = BuilderIcons.Icon.TriangleExclamation,
						size = IconSize.Large,
						variant = IconVariant.Filled,
						style = v20.Color.System.Alert
					}),
					TitleText = React.createElement(FoundationText, {
						tag = "auto-xy text-heading-small text-align-x-left",
						LayoutOrder = 2,
						Text = t4.title,
						TextYAlignment = Enum.TextYAlignment.Center,
						textStyle = v20.Color.Content.Emphasis
					})
				}),
				Paragraph = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
					LayoutOrder = 2,
					Text = t4.body,
					textStyle = v20.Color.Content.Default
				}),
				LinkRow = if not t4.hasReportLink then nil else React.createElement(FoundationText, {
					RichText = true,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
					LayoutOrder = 3,
					Text = v21.TextFilterLink,
					onActivated = v25,
					selection = {
						Selectable = true
					},
					textStyle = v20.Color.Content.Default
				})
			})
		}),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 2,
			actions = {{
				text = v21.BackButton,
				variant = ButtonVariant.Emphasis,
				onActivated = v24
			}}
		})
	})
end))
