local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ShareSheetItemContainer = require(script.Parent.ShareSheetItemContainer)
local ShareSheetRow = require(script.Parent.ShareSheetRow)

local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort
require(ShareSheet.Recipients.RecipientSource)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)
local copyLink = require(ShareSheet.copyLink)
local shareLink = require(ShareSheet.shareLink)

local IconName = Foundation.Enums.IconName
local View = Foundation.View

local FFlagShareSheetPeoplePickerEnabled = require(ShareSheet.Flags.FFlagShareSheetPeoplePickerEnabled)

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
		local logInteraction = ShareSheetTelemetry.logInteraction
		local v3 = {
			context = props.context,
			recipientSource = 0,
			telemetryId = 0,
			interactionType = 0
		}
		local recipientSource

		if FFlagShareSheetFriendsSort then
			recipientSource = props.recipientSource
		end

		v3.recipientSource = recipientSource
		v3.telemetryId = props.telemetryId or ""
		v3.interactionType = ShareSheetTelemetry.InteractionType.CopyLink
		logInteraction(v3)
	end, { props.context, props.recipientSource, props.telemetryId, props.url, v2 })

	local onActivated2 = React.useCallback(function()
		shareLink({ context = props.context, url = props.url })

		local logInteraction = ShareSheetTelemetry.logInteraction
		local v3 = {
			context = props.context,
			recipientSource = 0,
			telemetryId = 0,
			interactionType = 0
		}
		local recipientSource

		if FFlagShareSheetFriendsSort then
			recipientSource = props.recipientSource
		end

		v3.recipientSource = recipientSource
		v3.telemetryId = props.telemetryId or ""
		v3.interactionType = ShareSheetTelemetry.InteractionType.NativeShare
		logInteraction(v3)
	end, { props.context, props.recipientSource, props.telemetryId, props.url })
	React.useEffect(function()
		return function()
			if ref.current then
				task.cancel(ref.current)
			end
		end
	end, {})

	local createElement = React.createElement
	local icon = if state then IconName.Check else IconName.ChainLink
	local label = if state then v.copied else v.copyLink
	local v3 = {
		CopyLink = createElement(ShareSheetItemContainer, {
			icon = icon,
			label = label,
			onActivated = onActivated,
			shouldAnimate = state,
			LayoutOrder = 1
		}),
		Share = 0
	}
	local share

	if props.canShare then
		share = React.createElement(ShareSheetItemContainer, {
			icon = IconName.ArrowUpFromLandscapeRectangle,
			label = v.share,
			onActivated = onActivated2,
			LayoutOrder = 2
		})
	end

	v3.Share = share

	if FFlagShareSheetPeoplePickerEnabled then
		return (React.createElement(
			View,
			{ tag = "row gap-medium size-full-0 auto-y", LayoutOrder = props.LayoutOrder },
			v3
		))
	end

	return (React.createElement(ShareSheetRow, { LayoutOrder = props.LayoutOrder }, v3))
end

return ShareSheetActionRow
