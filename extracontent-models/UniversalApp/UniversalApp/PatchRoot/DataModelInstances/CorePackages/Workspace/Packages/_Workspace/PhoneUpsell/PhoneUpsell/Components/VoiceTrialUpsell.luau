local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local React = require(PhoneUpsellParent.React)
local UIBlox = require(PhoneUpsellParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(PhoneUpsellParent.Localization).Hooks.useLocalization
local useRef = React.useRef
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local Images = UIBlox.App.ImageSet.Images
local Cryo = require(PhoneUpsellParent.Cryo)
local PostUserOptIn = require(PhoneUpsellParent.VoiceChat).PostUserOptIn
local useRoactService = require(PhoneUpsellParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(PhoneUpsellParent.RoactServiceTags).RoactNetworking
local FocusNavigationUtils = require(PhoneUpsellParent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useDispatch = require(PhoneUpsellParent.RoactUtils).Hooks.RoactRodux.useDispatch
local ToastRodux = require(PhoneUpsellParent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local PostUpsellTrialOptIn = require(PhoneUpsell.Http.Requests.PostUpsellTrialOptIn)
local t1 = {}

local function getButtonStackProps(s1: string, n1: number, p1: ((...any) -> ...any), s2: string, p2: ((...any) -> ...any)) -- line: 32
	-- upvalues: ButtonType (copy)
	local t2 = {{
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = p1,
			text = s1
		}
	}}

	if s2 and s2 ~= "" then
		table.insert(t2, 1, {
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = p2,
				text = s2
			}
		})
	end

	return {
		buttonHeight = n1,
		buttons = t2
	}
end
local function VoiceTrialUpsell(t3: {[any]: any}) -- line: 64
	-- upvalues: Cryo (copy), t1 (copy), useDispatch (copy), useRef (copy), useStyle (copy), useLocalization (copy), useRoactService (copy), RoactNetworking (copy), PostUserOptIn (copy), PostUpsellTrialOptIn (copy), SetCurrentToastMessage (copy), ToastRodux (copy), Images (copy), React (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), InteractiveAlert (copy), getButtonStackProps (copy)
	local v32 = Cryo.Dictionary.union(t1, t3)
	local t4 = {
		titleKey = "Feature.VerificationUpsell.Heading.TryVoiceChat",
		descriptionKey = "Feature.VerificationUpsell.Description.VoiceLegalConsent2",
		buttonKey = "Feature.VerificationUpsell.Action.TurnOn",
		extraButtonKey = "Feature.VerificationUpsell.Action.NotNow.2"
	}
	local v34 = useDispatch()
	local v35 = useRef(nil)
	local v36 = useStyle()
	local BaseSize = v36.Font.BaseSize
	local v38 = useLocalization(t4)
	local v39 = useRoactService(RoactNetworking)

	local function handleTurnOn() -- line: 81
		-- upvalues: v32 (copy), PostUserOptIn (copy), v39 (copy), PostUpsellTrialOptIn (copy), v34 (copy), SetCurrentToastMessage (copy), ToastRodux (copy), Images (copy), v36 (copy)
		v32.onClose()
		PostUserOptIn(v39, true, false):andThen(function(_) -- line: 84
			-- upvalues: PostUpsellTrialOptIn (copy), v39 (copy), v32 (copy)
			return PostUpsellTrialOptIn(v39, v32.upsellCardType)
		end):andThen(function() -- line: 87
			-- upvalues: v34 (copy), SetCurrentToastMessage (copy), ToastRodux (copy), Images (copy), v36 (copy), v32 (copy)
			v34(SetCurrentToastMessage({
				toastMessage = "Feature.VerificationUpsell.Heading.VoiceChatTurnedOn",
				isLocalized = false,
				slideIn = true,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation,
				toastIcon = Images["icons/status/success_large"],
				toastIconColorStyle = {
					Color = v36.Tokens.Color.System.Success.Color3
				}
			}))
			v32.onCompletion()
		end):catch(function() -- line: 100
			-- upvalues: v34 (copy), SetCurrentToastMessage (copy), ToastRodux (copy), v36 (copy)
			v34(SetCurrentToastMessage({
				toastMessage = "Feature.VerificationUpsell.Heading.VoiceChatJoinFailed",
				isLocalized = false,
				slideIn = true,
				toastType = ToastRodux.Enums.ToastType.NetworkingError,
				toastIconColorStyle = {
					Color = v36.Tokens.Color.System.Alert.Color3
				}
			}))
		end)
	end

	return React.createElement(FocusNavigableSurfaceWrapper, {
		isIsolated = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		frameProps = {
			ref = v35
		}
	}, {
		Modal = React.createElement(InteractiveAlert, {
			title = v38.titleKey,
			screenSize = if not v35 or not v35.current then Vector2.new(500, 500) else v35.current.AbsoluteSize,
			buttonStackInfo = getButtonStackProps(v38.buttonKey, v36.Tokens.Size.Size_1200, handleTurnOn, v38.extraButtonKey, v32.onClose),
			onCloseClicked = v32.onClose,
			middleContent = function() -- line: 132
				-- upvalues: React (copy), v38 (copy), BaseSize (copy), v36 (copy)
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					BodyText = React.createElement("TextLabel", {
						LayoutOrder = 0,
						BackgroundTransparency = 1,
						TextWrapped = true,
						RichText = true,
						Text = v38.descriptionKey,
						TextSize = BaseSize,
						TextColor3 = v36.Theme.TextDefault.Color,
						TextTransparency = v36.Theme.TextDefault.Transparency,
						Font = v36.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					})
				})
			end
		})
	})
end

return VoiceTrialUpsell
