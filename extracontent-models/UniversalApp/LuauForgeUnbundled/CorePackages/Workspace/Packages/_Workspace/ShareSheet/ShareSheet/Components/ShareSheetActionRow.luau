local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local createNextOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ReactUtils").createNextOrder
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Localization").Hooks.useLocalization
local ShareSheetItemContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetItemContainer")
local ShareSheetRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetRow")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/getShareSheetRowLayout")

local FFlagShareSheetDesktopReadiness = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetDesktopReadiness")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local ShareSheetTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/telemetry/ShareSheetTelemetry")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/copyLink")
local shareLink = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/shareLink")

local iconName = Foundation.Enums.IconName
local view = Foundation.View

local function ShareSheetActionRow(props)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local v5 = useLocalization({
		copied = "Feature.UniversalShareSheet.Action.CopiedLink",
		copyLink = "Feature.SocialShare.Action.CopyLink",
		share = "Feature.SocialShare.Action.Share"
	})

	local v6 = React.useCallback(function()
		setState(true)

		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(2, function()
			ref.current = nil
			setState(false)
		end)
	end, {})
	local v7 = React.useCallback(function()
		module7({ context = props.context, url = props.url })

		v6()
		ShareSheetTelemetry.logInteraction({
			context = props.context,
			recipientSource = props.recipientSource,
			telemetryId = props.telemetryId or "",
			interactionType = ShareSheetTelemetry.InteractionType.CopyLink
		})
	end, { props.context, props.recipientSource, props.telemetryId, props.url, v6 })

	local v8 = React.useCallback(function()
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

	local v9 = if FFlagShareSheetDesktopReadiness then createNextOrder() else nil
	local v10 = if FFlagShareSheetDesktopReadiness then v9() else nil
	local v11 = if FFlagShareSheetDesktopReadiness then v9() else nil

	local createElement = React.createElement
	local v15 = if state then iconName.Check else iconName.ChainLink
	local v16 = if state then v5.copied else v5.copyLink

	local v17 = if FFlagShareSheetDesktopReadiness then props.rowLayout.getTileWidth(v10) else nil
	local v12 = {
		CopyLink = createElement(ShareSheetItemContainer, {
			icon = v15,
			label = v16,
			onActivated = v7,
			shouldAnimate = state,
			width = v17,
			LayoutOrder = not FFlagShareSheetDesktopReadiness and 1 or v10
		}),
		Share = 0
	}
	local v18

	if props.canShare then
		local createElement2 = React.createElement
		local v20 = {
			icon = iconName.ArrowUpFromLandscapeRectangle,
			label = v5.share,
			onActivated = v8,
			width = 0,
			LayoutOrder = 0
		}

		local v21 = if FFlagShareSheetDesktopReadiness then props.rowLayout.getTileWidth(v11) else nil
		v20.width = v21

		v20.LayoutOrder = not FFlagShareSheetDesktopReadiness and 2 or v11
		v18 = createElement2(ShareSheetItemContainer, v20)
	end

	v12.Share = v18

	if FFlagShareSheetDesktopReadiness then
		return (React.createElement(
			ShareSheetRow,
			{
				LayoutOrder = props.LayoutOrder,
				margin = props.rowLayout.margin,
				gap = props.rowLayout.gap,
				isScrollingEnabled = false
			},
			v12
		))
	end

	return (React.createElement(view, { tag = "row gap-medium size-full-0 auto-y" }, v12))
end

return ShareSheetActionRow
