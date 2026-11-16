local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local Localization = require(parent.Localization)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Loading = Foundation.Loading
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local useLocalization = Localization.Hooks.useLocalization

require(MomentsCreation.Components.Voice.voiceCatalog)

local Speaker = BuilderIcons.Icon.Speaker
local PlaySmall = BuilderIcons.Icon.PlaySmall

local snapPoints = { 0.9 }

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function VoiceRow(props)
	local id = props.voice.id
	local onAudition = props.onAudition
	local play

	if onAudition ~= nil then
		if props.isAuditioning then
			play = React.createElement(View, {
				tag = "align-x-center align-y-center size-800-800",
				LayoutOrder = 2
			}, {
				Spinner = React.createElement(Loading, {
					size = IconSize.Small,
					testId = `voice-audition-loading-{id}`
				})
			})
		else
			play = React.createElement(IconButton, {
				icon = PlaySmall,
				variant = ButtonVariant.Standard,
				isCircular = true,
				size = InputSize.Small,
				onActivated = function()
					onAudition(id)
				end,
				testId = `voice-audition-{id}`,
				LayoutOrder = 2
			})
		end
	end

	return React.createElement(View, {
		ref = props.focusRef,
		onActivated = function()
			props.onSelect(id)
		end,
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small radius-medium",
		testId = `voice-row-{id}`,
		LayoutOrder = props.LayoutOrder
	}, {
		Info = React.createElement(View, {
			tag = "row align-y-center fill gap-medium auto-y",
			LayoutOrder = 1
		}, {
			IconTile = React.createElement(
				View,
				{
					tag = "align-x-center align-y-center size-1000-1000 radius-medium bg-surface-300",
					LayoutOrder = 1
				},
				{
					VoiceIcon = React.createElement(Icon, { name = Speaker, size = IconSize.Medium })
				}
			),
			Name = React.createElement(Text, {
				tag = "fill auto-y text-title-medium text-align-x-left content-emphasis",
				Text = props.voice.name,
				LayoutOrder = 2
			})
		}),
		Play = play
	})
end

local function VoiceSelectorDialog(props)
	local onSelect = props.onSelect
	local onAudition = props.onAudition
	local onClose = props.onClose

	local v = useLocalization({ title = "Feature.Moments.Label.ChooseVoice" })

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onClose()
					object:cancel()
				end)
			}
		}
	end, { onClose })
	local v2, ref = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})))

	local hasCloseAffordance = useLastInputMode() ~= "Focus"

	local v3 = React.useMemo(function()
		return (Signals.createSignal(nil))
	end, {})
	local v4 = SignalsReact.useSignalState(props.getAuditioningVoiceId or v3)

	local children = {}

	for k, voice in props.voices do
		local formatted = `Voice_{voice.id}`
		local createElement = React.createElement
		local v5 = {
			voice = voice,
			onSelect = onSelect,
			onAudition = onAudition,
			isAuditioning = v4 == voice.id,
			focusRef = 0,
			LayoutOrder = 0
		}
		local focusRef

		if voice.id == props.selectedVoiceId then
			focusRef = v2
		end

		v5.focusRef = focusRef
		v5.LayoutOrder = k
		children[formatted] = createElement(VoiceRow, v5)
	end

	return React.createElement(
		Sheet.Root,
		{ ref = ref, size = DialogSize.Medium, snapPoints = snapPoints, onClose = onClose },
		{
			Header = React.createElement(Sheet.Header, { hasCloseAffordance = hasCloseAffordance }, {
				Title = React.createElement(Text, {
					tag = "fill auto-y text-heading-small text-align-x-left content-emphasis",
					Text = v.title,
					LayoutOrder = 1
				})
			}),
			Content = React.createElement(Sheet.Content, {}, {
				List = React.createElement(View, { tag = "col gap-xsmall size-full-0 auto-y" }, children)
			})
		}
	)
end

return VoiceSelectorDialog
