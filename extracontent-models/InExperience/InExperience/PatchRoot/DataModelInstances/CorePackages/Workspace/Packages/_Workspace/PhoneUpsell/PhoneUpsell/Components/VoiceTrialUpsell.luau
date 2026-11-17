local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useRef = React.useRef
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local Images = UIBlox.App.ImageSet.Images
local Cryo = require(parent.Cryo)
local VoiceChat = require(parent.VoiceChat)
local PostUserOptIn = VoiceChat.PostUserOptIn
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local PostUpsellTrialOptIn = require(PhoneUpsell.Http.Requests.PostUpsellTrialOptIn)

local v = {}

local function getButtonStackProps(buttonKey: string, size_1200: number, onActivated, extraButtonKey: string, onActivated2)
	local buttons = {
		{
			buttonType = ButtonType.PrimarySystem,
			props = { onActivated = onActivated, text = buttonKey }
		}
	}

	if extraButtonKey and extraButtonKey ~= "" then
		table.insert(buttons, 1, {
			buttonType = ButtonType.Secondary,
			props = { onActivated = onActivated2, text = extraButtonKey }
		})
	end

	return { buttonHeight = size_1200, buttons = buttons }
end

local function VoiceTrialUpsell(p)
	local union = Cryo.Dictionary.union(v, p)

	local v2 = useDispatch()
	local ref = useRef(nil)
	local v3 = useStyle()
	local baseSize = v3.Font.BaseSize
	local v4 = useLocalization({
		titleKey = "Feature.VerificationUpsell.Heading.TryVoiceChat",
		descriptionKey = "Feature.VerificationUpsell.Description.VoiceLegalConsent2",
		buttonKey = "Feature.VerificationUpsell.Action.TurnOn",
		extraButtonKey = "Feature.VerificationUpsell.Action.NotNow.2"
	})

	local v5 = useRoactService(RoactNetworking)

	local function handleTurnOn()
		union.onClose()
		PostUserOptIn(v5, true, false):andThen(function(_)
			return PostUpsellTrialOptIn(v5, union.upsellCardType)
		end):andThen(function()
			v2(SetCurrentToastMessage({
				toastMessage = "Feature.VerificationUpsell.Heading.VoiceChatTurnedOn",
				isLocalized = false,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation,
				toastIcon = Images["icons/status/success_large"],
				toastIconColorStyle = { Color = v3.Tokens.Color.System.Success.Color3 },
				slideIn = true
			}))

			union.onCompletion()
		end):catch(function()
			v2(SetCurrentToastMessage({
				toastMessage = "Feature.VerificationUpsell.Heading.VoiceChatJoinFailed",
				isLocalized = false,
				toastType = ToastRodux.Enums.ToastType.NetworkingError,
				toastIconColorStyle = { Color = v3.Tokens.Color.System.Alert.Color3 },
				slideIn = true
			}))
		end)
	end

	local createElement = React.createElement
	local v6 = {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		frameProps = { ref = ref }
	}

	local createElement2 = React.createElement
	local v7 = {
		title = v4.titleKey,
		screenSize = 0,
		buttonStackInfo = 0,
		onCloseClicked = 0,
		middleContent = 0
	}
	local screenSize

	if ref and ref.current then
		screenSize = ref.current.AbsoluteSize
	else
		screenSize = Vector2.new(500, 500)
	end

	v7.screenSize = screenSize
	v7.buttonStackInfo = getButtonStackProps(
		v4.buttonKey,
		v3.Tokens.Size.Size_1200,
		handleTurnOn,
		v4.extraButtonKey,
		union.onClose
	)

	v7.onCloseClicked = union.onClose
	function v7.middleContent()
		return React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				BodyText = React.createElement("TextLabel", {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					Text = v4.descriptionKey,
					TextSize = baseSize,
					TextColor3 = v3.Theme.TextDefault.Color,
					TextTransparency = v3.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v3.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					RichText = true
				})
			}
		)
	end

	return createElement(FocusNavigableSurfaceWrapper, v6, {
		Modal = createElement2(InteractiveAlert, v7)
	})
end

return VoiceTrialUpsell
