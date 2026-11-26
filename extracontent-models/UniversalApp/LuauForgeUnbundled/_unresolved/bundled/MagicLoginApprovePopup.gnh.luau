local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gjF")
local module3 = require("@luauforge/bundled/gjJ")
local button = module3.Button
local view = module3.View
local text = module3.Text
local buttonVariant = module3.Enums.ButtonVariant
local inputSize = module3.Enums.InputSize
local modalWindow = module2.App.Dialog.Modal.ModalWindow
local useSelector = require("@luauforge/bundled/ggY").Hooks.RoactRodux.useSelector
local useDispatch = require("@luauforge/bundled/ggY").Hooks.RoactRodux.useDispatch
local iconButton = module3.IconButton
local iconSize = module3.Enums.IconSize
local roactNetworking = require("@luauforge/bundled/gjY").RoactNetworking
local useRoactService = require("@luauforge/bundled/gjX").useRoactService
local crossDeviceLogin = require("@luauforge/bundled/ggL").Thunks.CrossDeviceLogin
local magicLoginPhaseType = require("@luauforge/bundled/ggO").MagicLoginPhaseType
local setMagicLoginAdvertisement = require("@luauforge/bundled/ggy").SetMagicLoginAdvertisement
local logger = require("@luauforge/bundled/ggN").Logger

local function MagicLoginApprovePopup(props)
	local state, setState = module.useState(props.phase or magicLoginPhaseType.WAITING_FOR_APPROVAL)

	local state2, setState2 = module.useState("If you still want to sign in, try again from your other device.")
	local state3, setState3 = module.useState({})
	local state4, setState4 = module.useState(false)
	local state5, setState5 = module.useState(false)

	local v5 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v6 = useDispatch()
	local v7 = useRoactService(roactNetworking)

	local v8 = {}

	module.useEffect(function()
		setMagicLoginAdvertisement(false)
		return function()
			setMagicLoginAdvertisement(true)
		end
	end, {})

	module.useEffect(function()
		local set = {}

		math.randomseed(os.time())
		local v9 = math.random(1, 3)
		set[props.authenticationDigits] = true
		local v10 = {}

		for i = 1, 3 do
			if i == v9 then
				table.insert(v10, props.authenticationDigits)
			else
				local v11

				repeat
					v11 = tostring(math.random(10, 99))
				until not set[v11]

				set[v11] = true
				table.insert(v10, v11)
			end
		end

		setState3(v10)
	end, { props.authenticationDigits })

	local v9 = module.useCallback(function()
		setState4(true)
		crossDeviceLogin.EnterCode(v7, props.authCode)(v6):andThen(function(p2)
			if p2 and p2.DeviceInfo then
				setState(magicLoginPhaseType.MATCH_CHALLENGE)
			else
				setState(magicLoginPhaseType.ERROR_OR_EXPIRED)
			end

			setState4(false)
		end, function(p2)
			logger:warning("Magic login enter code failed: " .. tostring(p2))
			setState(magicLoginPhaseType.ERROR_OR_EXPIRED)
			setState4(false)
		end)
	end, { props.authCode })

	local v10 = module.useCallback(function()
		setState4(true)
		crossDeviceLogin.CancelLoginCode(v7, props.authCode)(v6):andThen(function(p2)
			setState4(false)
		end, function(p2)
			logger:warning("Magic login cancel failed: " .. tostring(p2))
			setState4(false)
		end)

		if props.closeCentralOverlayThunk then
			v6(props.closeCentralOverlayThunk())
		end
	end, { props.authCode, state4 })

	local v11 = module.useCallback(function(p2)
		setState5(true)

		if p2 == props.authenticationDigits then
			crossDeviceLogin.ConfirmDeviceAccess(v7, props.authCode)(v6):andThen(function()
				setState(magicLoginPhaseType.SUCCESS)
			end, function(p3)
				logger:warning("Magic login confirm failed: " .. tostring(p3))
				setState(magicLoginPhaseType.ERROR_OR_EXPIRED)
				setState5(false)
			end)
			return
		end

		setState2("The number you selected does not match the number on your other device. If you still want to sign in, try again from your other device.")

		setState(magicLoginPhaseType.ERROR_OR_EXPIRED)
		setState5(false)
		crossDeviceLogin.CancelLoginCode(v7, props.authCode)(v6)
	end, { props.authCode, props.authenticationDigits })

	local v12 = module.useCallback(function()
		v6(props.closeCentralOverlayThunk())

		if state == magicLoginPhaseType.MATCH_CHALLENGE then
			crossDeviceLogin.CancelLoginCode(v7, props.authCode)(v6)
		end
	end, { props.closeCentralOverlayThunk, props.authCode, state })

	local v13 = module.useCallback(function()
		local children = {}

		for i = 1, 3 do
			table.insert(children, module.createElement(button, {
				text = tostring(state3[i]),
				variant = buttonVariant.Standard,
				onActivated = function()
					v11(state3[i])
				end,
				isLoading = state5,
				size = inputSize.Large,
				width = UDim.new(0.315, 1),
				LayoutOrder = 0
			}))
		end

		return children
	end, { state3, state5 })
	local v14

	if state == magicLoginPhaseType.WAITING_FOR_APPROVAL then
		v14 = {
			TitleText = module.createElement(text, {
				Text = "Trying to sign in from another device?",
				tag = "auto-xy text-heading-large text-wrap text-align-x-left ",
				LayoutOrder = 0
			}),
			DescriptionText = module.createElement(text, {
				Text = string.format(
					"Someone is requesting to sign in on <b>%s (%s)</b>. If it's you, press Yes to continue.",
					props.endpointName,
					props.endpointType
				),
				RichText = true,
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1
			}),
			PositiveButton = module.createElement(button, {
				text = "Yes",
				variant = buttonVariant.Emphasis,
				onActivated = v9,
				isLoading = state4,
				size = inputSize.Medium,
				width = UDim.new(1, 1),
				LayoutOrder = 2
			}),
			NegativeButton = module.createElement(button, {
				text = "No",
				variant = buttonVariant.Standard,
				onActivated = v10,
				isLoading = state4,
				size = inputSize.Medium,
				width = UDim.new(1, 1),
				LayoutOrder = 3
			})
		}
	elseif state == magicLoginPhaseType.MATCH_CHALLENGE then
		v14 = {
			TitleText = module.createElement(text, {
				Text = "Which number do you see on your other device?",
				tag = "auto-xy text-heading-large text-wrap text-align-x-left padding-right-xxlarge",
				LayoutOrder = 0
			}),
			DescriptionText = module.createElement(text, {
				Text = string.format(
					"Click the number that matches what is shown on <b>%s (%s)</b>.",
					props.endpointName,
					props.endpointType
				),
				RichText = true,
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1
			}),
			ButtonContainer = module.createElement(
				view,
				{ tag = "row gap-small auto-y size-full-0", LayoutOrder = 2 },
				v13()
			)
		}
	elseif state == magicLoginPhaseType.SUCCESS then
		v14 = {
			TitleText = module.createElement(text, {
				Text = string.format("You're signed in on %s", props.endpointName),
				tag = "auto-xy text-heading-large text-wrap text-align-x-left padding-right-xxlarge",
				LayoutOrder = 0
			}),
			DescriptionText = module.createElement(text, {
				Text = "Feel free to explore Roblox.",
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1
			}),
			DoneButton = module.createElement(button, {
				text = "Done",
				variant = buttonVariant.Emphasis,
				onActivated = v12,
				size = inputSize.Medium,
				width = UDim.new(1, 1),
				LayoutOrder = 2
			})
		}
	else
		v14 = state == magicLoginPhaseType.ERROR_OR_EXPIRED and {
			TitleText = module.createElement(text, {
				Text = "Couldn't sign you in",
				tag = "auto-xy text-heading-large text-wrap text-align-x-left padding-right-xxlarge",
				LayoutOrder = 0
			}),
			DescriptionText = module.createElement(text, {
				Text = state2,
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1
			}),
			OkayButton = module.createElement(button, {
				text = "Okay",
				variant = buttonVariant.Emphasis,
				onActivated = v12,
				size = inputSize.Medium,
				width = UDim.new(1, 1),
				LayoutOrder = 2
			})
		} or v8
	end

	local createElement = module.createElement

	local createElement2 = module.createElement
	local v19 = {
		position = UDim2.new(0.5, 0, 0.5, 0),
		isFullHeight = false,
		screenSize = v5 + Vector2.new(-30, 0),
		anchorPoint = Vector2.new(0.5, 0.5)
	}

	local createElement3 = module.createElement

	local v24 = if state == magicLoginPhaseType.MATCH_CHALLENGE then module.createElement(
		view,
		{ tag = "auto-xy position-top-right padding-large anchor-top-right" },
		{
			CloseButton = module.createElement(iconButton, {
				size = iconSize.Medium,
				icon = "icons/navigation/close",
				onActivated = v12,
				tag = ""
			})
		}
	) else nil
	return createElement(view, { tag = "size-full bg-action-alert padding-large" }, {
		ContentModal = createElement2(modalWindow, v19, {
			OverlayContent = createElement3(view, { tag = "auto-y size-full-0" }, {
				CloseButtonContainer = v24,
				ContentContainer = module.createElement(
					view,
					{ tag = "col gap-medium auto-y size-full-0 padding-xxlarge" },
					v14
				)
			})
		})
	})
end

return MagicLoginApprovePopup
