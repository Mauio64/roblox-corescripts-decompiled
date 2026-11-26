local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/InputHandlers")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/ReactFocusNavigation")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local loading = Foundation.Loading
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize

local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local useLocalization = Localization.Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/voiceCatalog")

local speaker = BuilderIcons.Icon.Speaker
local playSmall = BuilderIcons.Icon.PlaySmall

local v5 = { 0.9 }

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function VoiceRow(props)
	local id = props.voice.id
	local onAudition = props.onAudition
	local v6

	if onAudition ~= nil then
		if props.isAuditioning then
			v6 = React.createElement(
				view,
				{ tag = "align-x-center align-y-center size-800-800", LayoutOrder = 2 },
				{
					Spinner = React.createElement(loading, {
						size = iconSize.Small,
						testId = `voice-audition-loading-{id}`
					})
				}
			)
		else
			v6 = React.createElement(iconButton, {
				icon = playSmall,
				variant = buttonVariant.Standard,
				isCircular = true,
				size = inputSize.Small,
				onActivated = function()
					onAudition(id)
				end,
				testId = `voice-audition-{id}`,
				LayoutOrder = 2
			})
		end
	end

	return React.createElement(view, {
		ref = props.focusRef,
		onActivated = function()
			props.onSelect(id)
		end,
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small radius-medium",
		testId = `voice-row-{id}`,
		LayoutOrder = props.LayoutOrder
	}, {
		Info = React.createElement(
			view,
			{ tag = "row align-y-center fill gap-medium auto-y", LayoutOrder = 1 },
			{
				IconTile = React.createElement(
					view,
					{
						tag = "align-x-center align-y-center size-1000-1000 radius-medium bg-surface-300",
						LayoutOrder = 1
					},
					{
						VoiceIcon = React.createElement(icon, {
							name = speaker,
							size = iconSize.Medium
						})
					}
				),
				Name = React.createElement(text, {
					tag = "fill auto-y text-title-medium text-align-x-left content-emphasis",
					Text = props.voice.name,
					LayoutOrder = 2
				})
			}
		),
		Play = v6
	})
end

local function VoiceSelectorDialog(props)
	local onSelect = props.onSelect
	local onAudition = props.onAudition
	local onClose = props.onClose

	local v6 = useLocalization({ title = "Feature.Moments.Label.ChooseVoice" })

	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onClose()
					object:cancel()
				end)
			}
		}
	end, { onClose })
	local v9, v10 = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		eventMap = navigateBacks,
		eventHandlers = v7
	})))

	local v11 = useLastInputMode() ~= "Focus"

	local v12 = React.useMemo(function()
		return (Signals.createSignal(nil))
	end, {})
	local v13 = SignalsReact.useSignalState(props.getAuditioningVoiceId or v12)

	local children = {}

	for k, voice in props.voices do
		local formatted = `Voice_{voice.id}`
		local createElement = React.createElement
		local v15 = {
			voice = voice,
			onSelect = onSelect,
			onAudition = onAudition,
			isAuditioning = v13 == voice.id,
			focusRef = 0,
			LayoutOrder = 0
		}
		local v16 = if voice.id == props.selectedVoiceId then v9 else nil
		v15.focusRef = v16
		v15.LayoutOrder = k
		children[formatted] = createElement(VoiceRow, v15)
	end

	return React.createElement(
		sheet.Root,
		{ ref = v10, size = dialogSize.Medium, snapPoints = v5, onClose = onClose },
		{
			Header = React.createElement(sheet.Header, { hasCloseAffordance = v11 }, {
				Title = React.createElement(text, {
					tag = "fill auto-y text-heading-small text-align-x-left content-emphasis",
					Text = v6.title,
					LayoutOrder = 1
				})
			}),
			Content = React.createElement(sheet.Content, {}, {
				List = React.createElement(view, {
					tag = "col gap-xsmall size-full-0 auto-y"
				}, children)
			})
		}
	)
end

return VoiceSelectorDialog
