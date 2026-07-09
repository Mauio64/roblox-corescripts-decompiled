local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local AccountService = game:GetService("AccountService")
local EngineFeature = game:GetEngineFeature("MagicLogin")
local React = require(LoginV2Parent.React)
local UIBlox = require(LoginV2Parent.UIBlox)
local Foundation = require(LoginV2Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local useSelector = require(LoginV2Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(LoginV2Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local RoactNetworking = require(LoginV2Parent.RoactServiceTags).RoactNetworking
local useRoactService = require(LoginV2Parent.RobloxAppHooks).useRoactService
local CrossDeviceLogin = require(LoginV2Parent.AuthCommon).Thunks.CrossDeviceLogin
local PollMagicLoginStatus = require(LoginV2.Thunks).PollMagicLoginStatus
local HttpService = game:GetService("HttpService")
local Constants = require(script.Parent.Constants)
local MagicLoginPhaseType = require(LoginV2.Enums).MagicLoginPhaseType
local Logger = require(LoginV2Parent.Loggers).Logger

local function MagicLoginRequestPopup(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), MagicLoginPhaseType (copy), useSelector (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), PollMagicLoginStatus (copy), CrossDeviceLogin (copy), AccountService (copy), EngineFeature (copy), HttpService (copy), Constants (copy), Logger (copy), FoundationText (copy), View (copy), Button (copy), ButtonVariant (copy), InputSize (copy), ModalWindow (copy), IconButton (copy), IconSize (copy)
	local v28, v29 = React.useState("")
	local v30, v31 = React.useState(MagicLoginPhaseType.WAITING_FOR_APPROVAL)
	local v32, v33 = React.useState(nil)
	local v34 = useSelector(function(p1) -- line: 42
		return p1.ScreenSize
	end)
	local v35 = useDispatch()
	local v36 = useRoactService(RoactNetworking)
	local v37 = React.useRef(true)
	local v38 = React.useCallback(function() -- line: 55
		-- upvalues: v35 (copy), t1 (copy), v30 (copy), MagicLoginPhaseType (copy), CrossDeviceLogin (copy), v36 (copy), v32 (copy)
		v35(t1.closeCentralOverlayThunk())

		if v30 == MagicLoginPhaseType.WAITING_FOR_APPROVAL then
			CrossDeviceLogin.CancelLoginCode(v36, v32)(v35)
		end
	end, {
		t1.closeCentralOverlayThunk,
		v32,
		v30
	})

	React.useEffect(function() -- line: 62
		-- upvalues: v29 (copy), v35 (copy), CrossDeviceLogin (copy), v36 (copy), v37 (copy), AccountService (copy), EngineFeature (copy), HttpService (copy), Constants (copy), t1 (copy), v33 (copy), PollMagicLoginStatus (copy), v31 (copy), MagicLoginPhaseType (copy), Logger (copy)
		math.randomseed(os.time())

		local str = tostring(math.random(10, 99))

		v29(str)
		v35(CrossDeviceLogin.FetchDeviceCode(v36)):andThen(function(p2) -- line: 68
			-- upvalues: v37 (copy), AccountService (copy), EngineFeature (copy), HttpService (copy), Constants (copy), t1 (copy), str (copy), v33 (copy), v35 (copy), PollMagicLoginStatus (copy), v36 (copy), v31 (copy), MagicLoginPhaseType (copy)
			if v37.current then
				if AccountService and EngineFeature then
					local json = HttpService:JSONEncode({
						magicLoginActionKey = Constants.REQUEST_CONNECTION,
						endpointId = t1.endpointId,
						code = p2.DeviceCode,
						authenticationDigits = str
					})

					AccountService:MagicLogin(json)
				end

				v33(p2.DeviceCode)

				local DeviceCode = p2.DeviceCode
				local PrivateKey = p2.PrivateKey

				v35(PollMagicLoginStatus(v36, DeviceCode, PrivateKey, v37, t1.launchApp, function() -- line: 50
					-- upvalues: v31 (copy), MagicLoginPhaseType (copy)
					v31(MagicLoginPhaseType.ERROR_OR_EXPIRED)
				end))
			end
		end):catch(function(p3) -- line: 83
			-- upvalues: v37 (copy), Logger (copy), v31 (copy), MagicLoginPhaseType (copy)
			if v37.current then
				Logger:warning("Magic login Failed : " .. p3)
				v31(MagicLoginPhaseType.ERROR_OR_EXPIRED)
			end
		end)

		return function() -- line: 90
			-- upvalues: v37 (copy)
			v37.current = false
		end
	end, {})

	local t2 = {}

	if v30 == MagicLoginPhaseType.WAITING_FOR_APPROVAL then
		t2 = {
			TitleText = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-large text-wrap text-align-x-left padding-right-xxlarge",
				LayoutOrder = 0,
				Text = string.format("Check your %s", t1.endpointType)
			}),
			DescriptionText = React.createElement(FoundationText, {
				RichText = true,
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1,
				Text = string.format("A request has been sent to <b>%s (%s)</b>. Approve the request by tapping yes, then tap the following number on your device.", t1.endpointName, t1.endpointType)
			}),
			NumberContainer = React.createElement(View, {
				tag = "auto-y size-full-0 position-center-center padding-xxlarge bg-action-alert radius-medium",
				LayoutOrder = 2
			}, {
				NumberText = React.createElement(FoundationText, {
					tag = "auto-y size-full-0 text-display-small text-wrap text-align-x-center",
					Text = v28
				})
			})
		}
	elseif v30 == MagicLoginPhaseType.ERROR_OR_EXPIRED then
		t2 = {
			TitleText = React.createElement(FoundationText, {
				Text = "Couldn't sign you in",
				tag = "auto-xy text-heading-large text-wrap text-align-x-left padding-right-xxlarge",
				LayoutOrder = 0
			}),
			DescriptionText = React.createElement(FoundationText, {
				Text = "If you still want to sign in, try again.",
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1
			}),
			OkayButton = React.createElement(Button, {
				text = "Okay",
				LayoutOrder = 2,
				variant = ButtonVariant.Emphasis,
				onActivated = v38,
				size = InputSize.Medium,
				width = UDim.new(1, 1)
			})
		}
	end

	return React.createElement(View, {
		tag = "size-full bg-action-alert padding-large"
	}, {
		ContentModal = React.createElement(ModalWindow, {
			isFullHeight = false,
			position = UDim2.new(0.5, 0, 0.5, 0),
			screenSize = v34 + Vector2.new(-30, 0),
			anchorPoint = Vector2.new(0.5, 0.5)
		}, {
			OverlayContent = React.createElement(View, {
				tag = "auto-y size-full-0"
			}, {
				VisibilityText = React.createElement(FoundationText, {
					Text = "",
					tag = "size-full-0 text-body"
				}),
				CloseButtonContainer = if v30 ~= MagicLoginPhaseType.WAITING_FOR_APPROVAL then nil else React.createElement(View, {
					tag = "auto-xy position-top-right padding-large anchor-top-right"
				}, {
					CloseButton = React.createElement(IconButton, {
						icon = "icons/navigation/close",
						tag = "",
						size = IconSize.Medium,
						onActivated = v38
					})
				}),
				ContentContainer = React.createElement(View, {
					tag = "col gap-medium auto-y size-full-0 padding-xxlarge"
				}, t2)
			})
		})
	})
end

return MagicLoginRequestPopup
