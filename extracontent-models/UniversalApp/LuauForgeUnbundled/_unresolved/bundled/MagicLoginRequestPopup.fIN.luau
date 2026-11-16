local AccountService = game:GetService("AccountService")
local engineFeature = game:GetEngineFeature("MagicLogin")

local module = require("@luauforge/bundled/fCE")
local module2 = require("@luauforge/bundled/fFl")
local module3 = require("@luauforge/bundled/fFp")
local view = module3.View
local text = module3.Text
local modalWindow = module2.App.Dialog.Modal.ModalWindow
local useSelector = require("@luauforge/bundled/fCF").Hooks.RoactRodux.useSelector
local useDispatch = require("@luauforge/bundled/fCF").Hooks.RoactRodux.useDispatch
local iconButton = module3.IconButton
local iconSize = module3.Enums.IconSize
local button = module3.Button
local buttonVariant = module3.Enums.ButtonVariant
local inputSize = module3.Enums.InputSize
local roactNetworking = require("@luauforge/bundled/fFE").RoactNetworking
local useRoactService = require("@luauforge/bundled/fFD").useRoactService
local crossDeviceLogin = require("@luauforge/bundled/fCs").Thunks.CrossDeviceLogin
local pollMagicLoginStatus = require("@luauforge/bundled/fCf").PollMagicLoginStatus
local HttpService = game:GetService("HttpService")
local module4 = require("@luauforge/bundled/fCC")
local magicLoginPhaseType = require("@luauforge/bundled/fCv").MagicLoginPhaseType
local logger = require("@luauforge/bundled/fCu").Logger

local function MagicLoginRequestPopup(props)
	local state, setState = module.useState("")
	local state2, setState2 = module.useState(magicLoginPhaseType.WAITING_FOR_APPROVAL)
	local state3, setState3 = module.useState(nil)
	local v5 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v6 = useDispatch()
	local v7 = useRoactService(roactNetworking)
	local ref = module.useRef(true)

	local v8 = module.useCallback(function()
		v6(props.closeCentralOverlayThunk())

		if state2 == magicLoginPhaseType.WAITING_FOR_APPROVAL then
			crossDeviceLogin.CancelLoginCode(v7, state3)(v6)
		end
	end, { props.closeCentralOverlayThunk, state3, state2 })

	module.useEffect(function()
		math.randomseed(os.time())
		local v9 = tostring(math.random(10, 99))
		setState(v9)

		v6(crossDeviceLogin.FetchDeviceCode(v7)):andThen(function(p2)
			if ref.current then
				if AccountService and engineFeature then
					AccountService:MagicLogin((HttpService:JSONEncode({
						magicLoginActionKey = module4.REQUEST_CONNECTION,
						endpointId = props.endpointId,
						code = p2.DeviceCode,
						authenticationDigits = v9
					})))
				end

				setState3(p2.DeviceCode)
				v6(pollMagicLoginStatus(v7, p2.DeviceCode, p2.PrivateKey, ref, props.launchApp, function()
					setState2(magicLoginPhaseType.ERROR_OR_EXPIRED)
				end))
			end
		end):catch(function(p2)
			if ref.current then
				logger:warning("Magic login Failed : " .. p2)
				setState2(magicLoginPhaseType.ERROR_OR_EXPIRED)
			end
		end)

		return function()
			ref.current = false
		end
	end, {})

	local v9 = {}
	local v10

	if state2 == magicLoginPhaseType.WAITING_FOR_APPROVAL then
		v10 = {
			TitleText = module.createElement(text, {
				Text = string.format("Check your %s", props.endpointType),
				tag = "auto-xy text-heading-large text-wrap text-align-x-left padding-right-xxlarge",
				LayoutOrder = 0
			}),
			DescriptionText = module.createElement(text, {
				Text = string.format(
					"A request has been sent to <b>%s (%s)</b>. Approve the request by tapping yes, then tap the following number on your device.",
					props.endpointName,
					props.endpointType
				),
				RichText = true,
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1
			}),
			NumberContainer = module.createElement(
				view,
				{
					tag = "auto-y size-full-0 position-center-center padding-xxlarge bg-action-alert radius-medium",
					LayoutOrder = 2
				},
				{
					NumberText = module.createElement(text, {
						Text = state,
						tag = "auto-y size-full-0 text-display-small text-wrap text-align-x-center"
					})
				}
			)
		}
	else
		v10 = state2 == magicLoginPhaseType.ERROR_OR_EXPIRED and {
			TitleText = module.createElement(text, {
				Text = "Couldn't sign you in",
				tag = "auto-xy text-heading-large text-wrap text-align-x-left padding-right-xxlarge",
				LayoutOrder = 0
			}),
			DescriptionText = module.createElement(text, {
				Text = "If you still want to sign in, try again.",
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1
			}),
			OkayButton = module.createElement(button, {
				text = "Okay",
				variant = buttonVariant.Emphasis,
				onActivated = v8,
				size = inputSize.Medium,
				width = UDim.new(1, 1),
				LayoutOrder = 2
			})
		} or v9
	end

	local createElement = module.createElement

	local createElement2 = module.createElement
	local v15 = {
		position = UDim2.new(0.5, 0, 0.5, 0),
		isFullHeight = false,
		screenSize = v5 + Vector2.new(-30, 0),
		anchorPoint = Vector2.new(0.5, 0.5)
	}

	local createElement3 = module.createElement

	local v19 = {
		VisibilityText = module.createElement(text, {
			Text = "",
			tag = "size-full-0 text-body"
		}),
		CloseButtonContainer = 0,
		ContentContainer = 0
	}

	local v20 = if state2 == magicLoginPhaseType.WAITING_FOR_APPROVAL then module.createElement(
		view,
		{ tag = "auto-xy position-top-right padding-large anchor-top-right" },
		{
			CloseButton = module.createElement(iconButton, {
				size = iconSize.Medium,
				icon = "icons/navigation/close",
				onActivated = v8,
				tag = ""
			})
		}
	) else nil
	v19.CloseButtonContainer = v20

	v19.ContentContainer = module.createElement(
		view,
		{ tag = "col gap-medium auto-y size-full-0 padding-xxlarge" },
		v10
	)
	return createElement(view, { tag = "size-full bg-action-alert padding-large" }, {
		ContentModal = createElement2(modalWindow, v15, {
			OverlayContent = createElement3(view, { tag = "auto-y size-full-0" }, v19)
		})
	})
end

return MagicLoginRequestPopup
