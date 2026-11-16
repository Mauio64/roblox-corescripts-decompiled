local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens

local BuilderIcons = require(parent.BuilderIcons)
local IconVariant = BuilderIcons.IconVariant

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useEscapeDismiss = require(CoreScriptsPlayerFeedback.Hooks.useEscapeDismiss)
local FFlagPlayerSupportPromptEventIngest = require(CoreScriptsPlayerFeedback.Flags.FFlagPlayerSupportPromptEventIngest)
local PlayerSupportPromptTelemetry = require(CoreScriptsPlayerFeedback.Telemetry.PlayerSupportPromptTelemetry)

local v = {
	TICKET_CREATION_TEXT_FILTER_ERROR = {
		titleKey = "TextFilterTitle",
		bodyKey = "TextFilterBody",
		hasReportLink = true
	},
	TICKET_CREATION_GIBBERISH_ERROR = { titleKey = "TextFilterTitle", bodyKey = "GibberishBody" },
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
	RateLimited = { titleKey = "RateLimitedTitle", bodyKey = "RateLimitedBody" }
}

local v2 = { titleKey = "DefaultTitle", bodyKey = "DefaultBody" }

local function openAbuseReportPage()
	pcall(function()
		local CoreGui = game:GetService("CoreGui")
		local robloxGui = CoreGui:FindFirstChild("RobloxGui")
		local modules = robloxGui and robloxGui:FindFirstChild("Modules") or nil
		local settings = modules and modules:FindFirstChild("Settings") or nil
		local settingsHub = settings and settings:FindFirstChild("SettingsHub") or nil

		if not settingsHub then
			return
		end

		local module = require(settingsHub)
		module:SetVisibility(true, false, module.Instance.ReportAbusePage)
	end)
end

return (React.memo(function(props)
	local v3 = useTokens()

	local v4 = useLocalization({
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
		GibberishBody = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Unavailable.Gibberish.Body",
		TextFilterLink = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ReportAbuse.Link"
	})

	local v5 = v[props.reason or ""] or v2
	local v6 = { title = v4[v5.titleKey], body = v4[v5.bodyKey], hasReportLink = v5.hasReportLink }

	local reason = props.reason or ""

	if FFlagPlayerSupportPromptEventIngest then
		React.useEffect(function()
			PlayerSupportPromptTelemetry.logUnavailableShown(reason)
		end, { reason })
	end

	local useCallback = React.useCallback
	local function fn()
		if FFlagPlayerSupportPromptEventIngest and props.openPlayerSupportPrompt then
			PlayerSupportPromptTelemetry.log({
				action = PlayerSupportPromptTelemetry.Action.RejectionRetry,
				reason = reason
			})
		end

		props.closePrompt()

		if props.openPlayerSupportPrompt then
			props.openPlayerSupportPrompt()
		end
	end

	local v7

	if FFlagPlayerSupportPromptEventIngest then
		v7 = { props.closePrompt, props.openPlayerSupportPrompt, reason }
	else
		v7 = { props.closePrompt, props.openPlayerSupportPrompt }
	end

	local onActivated = useCallback(fn, v7)

	local useCallback2 = React.useCallback
	local function fn2()
		if FFlagPlayerSupportPromptEventIngest then
			PlayerSupportPromptTelemetry.log({
				action = PlayerSupportPromptTelemetry.Action.ReportAbuseClicked,
				reason = reason
			})
		end

		props.closePrompt()
		pcall(function()
			local CoreGui = game:GetService("CoreGui")
			local robloxGui = CoreGui:FindFirstChild("RobloxGui")
			local modules = robloxGui and robloxGui:FindFirstChild("Modules") or nil
			local settings = modules and modules:FindFirstChild("Settings") or nil
			local settingsHub = settings and settings:FindFirstChild("SettingsHub") or nil

			if not settingsHub then
				return
			end

			local module = require(settingsHub)
			module:SetVisibility(true, false, module.Instance.ReportAbusePage)
		end)
	end

	local v8

	if FFlagPlayerSupportPromptEventIngest then
		v8 = { props.closePrompt, reason }
	else
		v8 = { props.closePrompt }
	end

	local onActivated2 = useCallback2(fn2, v8)

	useEscapeDismiss("PlayerSupportUnavailableCancel", onActivated)

	local createElement = React.createElement
	local root = Dialog.Root

	local createElement2 = React.createElement
	local content = Dialog.Content

	local createElement3 = React.createElement
	local v9 = {
		tag = "col gap-large size-full-0 auto-y",
		padding = { top = UDim.new(0, v3.Size.Size_500) }
	}
	local v10 = {
		TitleRow = React.createElement(View, {
			tag = "row items-center gap-small auto-y",
			LayoutOrder = 1
		}, {
			AlertIcon = React.createElement(Icon, {
				name = BuilderIcons.Icon.TriangleExclamation,
				size = IconSize.Large,
				variant = IconVariant.Filled,
				style = v3.Color.System.Alert,
				LayoutOrder = 1
			}),
			TitleText = React.createElement(Text, {
				Text = v6.title,
				tag = "auto-xy text-heading-small text-align-x-left",
				TextYAlignment = Enum.TextYAlignment.Center,
				textStyle = v3.Color.Content.Emphasis,
				LayoutOrder = 2
			})
		}),
		Paragraph = React.createElement(Text, {
			Text = v6.body,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			textStyle = v3.Color.Content.Default,
			LayoutOrder = 2
		}),
		LinkRow = 0
	}
	local linkRow

	if v6.hasReportLink then
		linkRow = React.createElement(Text, {
			Text = v4.TextFilterLink,
			RichText = true,
			onActivated = onActivated2,
			selection = { Selectable = true },
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			textStyle = v3.Color.Content.Default,
			LayoutOrder = 3
		})
	end

	v10.LinkRow = linkRow
	return createElement(root, { hasBackdrop = true }, {
		Content = createElement2(content, { LayoutOrder = 1 }, {
			Body = createElement3(View, v9, v10)
		}),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 2,
			actions = {
				{
					text = v4.BackButton,
					variant = ButtonVariant.Emphasis,
					onActivated = onActivated
				}
			}
		})
	})
end))
