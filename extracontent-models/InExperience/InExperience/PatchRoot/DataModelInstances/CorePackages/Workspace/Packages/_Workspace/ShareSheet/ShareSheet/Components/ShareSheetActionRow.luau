local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ShareSheetItemContainer = require(script.Parent.ShareSheetItemContainer)
local ShareSheetRow = require(script.Parent.ShareSheetRow)
require(script.Parent.getShareSheetRowLayout)

local FFlagShareSheetDesktopReadiness = require(ShareSheet.Flags.FFlagShareSheetDesktopReadiness)

require(ShareSheet.Recipients.RecipientSource)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)
local copyLink = require(ShareSheet.copyLink)
local shareLink = require(ShareSheet.shareLink)

local IconName = Foundation.Enums.IconName
local View = Foundation.View

local function ShareSheetActionRow(props)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local v = useLocalization({
		copied = "Feature.UniversalShareSheet.Action.CopiedLink",
		copyLink = "Feature.SocialShare.Action.CopyLink",
		share = "Feature.SocialShare.Action.Share"
	})

	local v2 = React.useCallback(function()
		setState(true)

		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(2, function()
			ref.current = nil
			setState(false)
		end)
	end, {})
	local onActivated = React.useCallback(function()
		copyLink({ context = props.context, url = props.url })

		v2()
		ShareSheetTelemetry.logInteraction({
			context = props.context,
			recipientSource = props.recipientSource,
			telemetryId = props.telemetryId or "",
			interactionType = ShareSheetTelemetry.InteractionType.CopyLink
		})
	end, { props.context, props.recipientSource, props.telemetryId, props.url, v2 })

	local onActivated2 = React.useCallback(function()
		shareLink({ context = props.context, url = props.url })

		ShareSheetTelemetry.logInteraction({
			context = props.context,
			recipientSource = props.recipientSource,
			telemetryId = props.telemetryId or "",
			interactionType = ShareSheetTelemetry.InteractionType.NativeShare
		})
	end, { props.context, props.recipientSource, props.telemetryId, props.url })
	React.useEffect(function()
		return function()
			if ref.current then
				task.cancel(ref.current)
			end
		end
	end, {})
	local v3

	if FFlagShareSheetDesktopReadiness then
		v3 = createNextOrder()
	end

	local v4

	if FFlagShareSheetDesktopReadiness then
		v4 = v3()
	end

	local v5

	if FFlagShareSheetDesktopReadiness then
		v5 = v3()
	end

	local createElement = React.createElement
	local icon = if state then IconName.Check else IconName.ChainLink
	local label = if state then v.copied else v.copyLink
	local width

	if FFlagShareSheetDesktopReadiness then
		width = props.rowLayout.getTileWidth(v4)
	end

	local v6 = {
		CopyLink = createElement(ShareSheetItemContainer, {
			icon = icon,
			label = label,
			onActivated = onActivated,
			shouldAnimate = state,
			width = width,
			LayoutOrder = not FFlagShareSheetDesktopReadiness and 1 or v4
		}),
		Share = 0
	}
	local share

	if props.canShare then
		local createElement2 = React.createElement
		local v7 = {
			icon = IconName.ArrowUpFromLandscapeRectangle,
			label = v.share,
			onActivated = onActivated2,
			width = 0,
			LayoutOrder = 0
		}
		local width2

		if FFlagShareSheetDesktopReadiness then
			width2 = props.rowLayout.getTileWidth(v5)
		end

		v7.width = width2

		v7.LayoutOrder = not FFlagShareSheetDesktopReadiness and 2 or v5
		share = createElement2(ShareSheetItemContainer, v7)
	end

	v6.Share = share

	if FFlagShareSheetDesktopReadiness then
		return (React.createElement(
			ShareSheetRow,
			{
				LayoutOrder = props.LayoutOrder,
				margin = props.rowLayout.margin,
				gap = props.rowLayout.gap,
				isScrollingEnabled = false
			},
			v6
		))
	end

	return (React.createElement(View, { tag = "row gap-medium size-full-0 auto-y" }, v6))
end

return ShareSheetActionRow
