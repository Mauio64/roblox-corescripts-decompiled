local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation").Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization
local useRef = React.useRef
local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local images = UIBlox.App.ImageSet.Images
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Cryo")
local postUserOptIn = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/VoiceChat").PostUserOptIn
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactServiceTags").RoactNetworking
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactUtils").Hooks.RoactRodux.useDispatch
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/ToastRodux")
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local PostUpsellTrialOptIn = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Http/Requests/PostUpsellTrialOptIn")

local v5 = {}

local function getButtonStackProps(buttonKey, size_1200, onActivated, extraButtonKey, onActivated2)
	local v6 = {
		{
			buttonType = buttonType.PrimarySystem,
			props = { onActivated = onActivated, text = buttonKey }
		}
	}

	if extraButtonKey and extraButtonKey ~= "" then
		table.insert(v6, 1, {
			buttonType = buttonType.Secondary,
			props = { onActivated = onActivated2, text = extraButtonKey }
		})
	end

	return { buttonHeight = size_1200, buttons = v6 }
end

local function VoiceTrialUpsell(p2)
	local union = Cryo.Dictionary.union(v5, p2)

	local v6 = useDispatch()
	local v7 = useRef(nil)
	local v8 = useStyle()
	local baseSize = v8.Font.BaseSize
	local v9 = useLocalization({
		titleKey = "Feature.VerificationUpsell.Heading.TryVoiceChat",
		descriptionKey = "Feature.VerificationUpsell.Description.VoiceLegalConsent2",
		buttonKey = "Feature.VerificationUpsell.Action.TurnOn",
		extraButtonKey = "Feature.VerificationUpsell.Action.NotNow.2"
	})

	local v10 = useRoactService(roactNetworking)

	local function handleTurnOn()
		union.onClose()
		postUserOptIn(v10, true, false):andThen(function(p3)
			return PostUpsellTrialOptIn(v10, union.upsellCardType)
		end):andThen(function()
			v6(setCurrentToastMessage({
				toastMessage = "Feature.VerificationUpsell.Heading.VoiceChatTurnedOn",
				isLocalized = false,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation,
				toastIcon = images["icons/status/success_large"],
				toastIconColorStyle = { Color = v8.Tokens.Color.System.Success.Color3 },
				slideIn = true
			}))

			union.onCompletion()
		end):catch(function()
			v6(setCurrentToastMessage({
				toastMessage = "Feature.VerificationUpsell.Heading.VoiceChatJoinFailed",
				isLocalized = false,
				toastType = ToastRodux.Enums.ToastType.NetworkingError,
				toastIconColorStyle = { Color = v8.Tokens.Color.System.Alert.Color3 },
				slideIn = true
			}))
		end)
	end

	local createElement = React.createElement
	local v12 = {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		frameProps = { ref = v7 }
	}

	local createElement2 = React.createElement
	local v15 = {
		title = v9.titleKey,
		screenSize = 0,
		buttonStackInfo = 0,
		onCloseClicked = 0,
		middleContent = 0
	}
	local v16 = if v7 and v7.current then v7.current.AbsoluteSize else Vector2.new(500, 500)
	v15.screenSize = v16
	v15.buttonStackInfo = getButtonStackProps(
		v9.buttonKey,
		v8.Tokens.Size.Size_1200,
		handleTurnOn,
		v9.extraButtonKey,
		union.onClose
	)

	v15.onCloseClicked = union.onClose
	function v15.middleContent()
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
					Text = v9.descriptionKey,
					TextSize = baseSize,
					TextColor3 = v8.Theme.TextDefault.Color,
					TextTransparency = v8.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					RichText = true
				})
			}
		)
	end

	return createElement(focusNavigableSurfaceWrapper, v12, {
		Modal = createElement2(interactiveAlert, v15)
	})
end

return VoiceTrialUpsell
