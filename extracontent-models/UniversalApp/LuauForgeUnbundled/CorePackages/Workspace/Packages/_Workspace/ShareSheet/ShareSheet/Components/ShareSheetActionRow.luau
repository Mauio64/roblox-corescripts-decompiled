local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Localization").Hooks.useLocalization
local ShareSheetItemContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetItemContainer")
local ShareSheetRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetRow")

local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local ShareSheetTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/telemetry/ShareSheetTelemetry")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/copyLink")
local shareLink = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/shareLink")

local iconName = Foundation.Enums.IconName
local view = Foundation.View

local FFlagShareSheetPeoplePickerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetPeoplePickerEnabled")

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
		module6({ context = props.context, url = props.url })

		v6()
		local logInteraction = ShareSheetTelemetry.logInteraction
		local v8 = {
			context = props.context,
			recipientSource = 0,
			telemetryId = 0,
			interactionType = 0
		}
		local v9 = if fFlagShareSheetFriendsSort then props.recipientSource else nil
		v8.recipientSource = v9
		v8.telemetryId = props.telemetryId or ""
		v8.interactionType = ShareSheetTelemetry.InteractionType.CopyLink
		logInteraction(v8)
	end, { props.context, props.recipientSource, props.telemetryId, props.url, v6 })

	local v8 = React.useCallback(function()
		shareLink({ context = props.context, url = props.url })

		local logInteraction = ShareSheetTelemetry.logInteraction
		local v9 = {
			context = props.context,
			recipientSource = 0,
			telemetryId = 0,
			interactionType = 0
		}
		local v10 = if fFlagShareSheetFriendsSort then props.recipientSource else nil
		v9.recipientSource = v10
		v9.telemetryId = props.telemetryId or ""
		v9.interactionType = ShareSheetTelemetry.InteractionType.NativeShare
		logInteraction(v9)
	end, { props.context, props.recipientSource, props.telemetryId, props.url })
	React.useEffect(function()
		return function()
			if ref.current then
				task.cancel(ref.current)
			end
		end
	end, {})

	local createElement = React.createElement
	local v12 = if state then iconName.Check else iconName.ChainLink
	local v13 = if state then v5.copied else v5.copyLink
	local v9 = {
		CopyLink = createElement(ShareSheetItemContainer, {
			icon = v12,
			label = v13,
			onActivated = v7,
			shouldAnimate = state,
			LayoutOrder = 1
		}),
		Share = 0
	}

	local v14 = if props.canShare then React.createElement(ShareSheetItemContainer, {
		icon = iconName.ArrowUpFromLandscapeRectangle,
		label = v5.share,
		onActivated = v8,
		LayoutOrder = 2
	}) else nil
	v9.Share = v14

	if FFlagShareSheetPeoplePickerEnabled then
		return (React.createElement(
			view,
			{
				tag = "row gap-medium size-full-0 auto-y",
				LayoutOrder = props.LayoutOrder
			},
			v9
		))
	end

	return (React.createElement(ShareSheetRow, { LayoutOrder = props.LayoutOrder }, v9))
end

return ShareSheetActionRow
