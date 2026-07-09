local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local React = require(LoginV2Parent.React)
local UIBlox = require(LoginV2Parent.UIBlox)
local Foundation = require(LoginV2Parent.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local useSelector = require(LoginV2Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(LoginV2Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local RoactNetworking = require(LoginV2Parent.RoactServiceTags).RoactNetworking
local useRoactService = require(LoginV2Parent.RobloxAppHooks).useRoactService
local CrossDeviceLogin = require(LoginV2Parent.AuthCommon).Thunks.CrossDeviceLogin
local MagicLoginPhaseType = require(LoginV2.Enums).MagicLoginPhaseType
local SetMagicLoginAdvertisement = require(LoginV2.Thunks).SetMagicLoginAdvertisement
local Logger = require(LoginV2Parent.Loggers).Logger

local function MagicLoginApprovePopup(t1: {[any]: any}) -- line: 34
	-- upvalues: React (copy), MagicLoginPhaseType (copy), useSelector (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), SetMagicLoginAdvertisement (copy), CrossDeviceLogin (copy), Logger (copy), Button (copy), ButtonVariant (copy), InputSize (copy), FoundationText (copy), View (copy), ModalWindow (copy), IconButton (copy), IconSize (copy)
	local v24, v25 = React.useState(t1.phase or MagicLoginPhaseType.WAITING_FOR_APPROVAL)
	local v26, v27 = React.useState("If you still want to sign in, try again from your other device.")
	local v28, v29 = React.useState({})
	local v30, v31 = React.useState(false)
	local v32, v33 = React.useState(false)
	local v34 = useSelector(function(p1) -- line: 42
		return p1.ScreenSize
	end)
	local v35 = useDispatch()
	local v36 = useRoactService(RoactNetworking)
	local t2 = {}

	React.useEffect(function() -- line: 50
		-- upvalues: SetMagicLoginAdvertisement (copy)
		SetMagicLoginAdvertisement(false)

		return function() -- line: 52
			-- upvalues: SetMagicLoginAdvertisement (copy)
			SetMagicLoginAdvertisement(true)
		end
	end, {})
	React.useEffect(function() -- line: 57
		-- upvalues: t1 (copy), v29 (copy)
		local t3 = {}
		local t4 = {}

		math.randomseed(os.time())

		local v46 = math.random(1, 3)

		t3[t1.authenticationDigits] = true

		for i = 1, 3 do
			if i == v46 then
				table.insert(t4, t1.authenticationDigits)
			else
				local str

				repeat
					str = tostring(math.random(10, 99))
				until not t3[str]

				t3[str] = true
				table.insert(t4, str)
			end
		end

		v29(t4)
	end, { t1.authenticationDigits })

	local v38 = React.useCallback(function() -- line: 79
		-- upvalues: v31 (copy), CrossDeviceLogin (copy), v36 (copy), t1 (copy), v35 (copy), v25 (copy), MagicLoginPhaseType (copy), Logger (copy)
		v31(true)
		CrossDeviceLogin.EnterCode(v36, t1.authCode)(v35):andThen(function(p2) -- line: 81
			-- upvalues: v25 (copy), MagicLoginPhaseType (copy), v31 (copy)
			if p2 and p2.DeviceInfo then
				v25(MagicLoginPhaseType.MATCH_CHALLENGE)
			else
				v25(MagicLoginPhaseType.ERROR_OR_EXPIRED)
			end

			v31(false)
		end, function(p3) -- line: 88
			-- upvalues: Logger (copy), v25 (copy), MagicLoginPhaseType (copy), v31 (copy)
			Logger:warning("Magic login enter code failed: " .. tostring(p3))
			v25(MagicLoginPhaseType.ERROR_OR_EXPIRED)
			v31(false)
		end)
	end, { t1.authCode })
	local v39 = React.useCallback(function() -- line: 95
		-- upvalues: v31 (copy), CrossDeviceLogin (copy), v36 (copy), t1 (copy), v35 (copy), Logger (copy)
		v31(true)
		CrossDeviceLogin.CancelLoginCode(v36, t1.authCode)(v35):andThen(function(_) -- line: 97
			-- upvalues: v31 (copy)
			v31(false)
		end, function(p5) -- line: 99
			-- upvalues: Logger (copy), v31 (copy)
			Logger:warning("Magic login cancel failed: " .. tostring(p5))
			v31(false)
		end)

		if t1.closeCentralOverlayThunk then
			v35(t1.closeCentralOverlayThunk())
		end
	end, {
		t1.authCode,
		v30
	})
	local v40 = React.useCallback(function(s1: string) -- line: 108
		-- upvalues: v33 (copy), t1 (copy), CrossDeviceLogin (copy), v36 (copy), v35 (copy), v25 (copy), MagicLoginPhaseType (copy), Logger (copy), v27 (copy)
		v33(true)

		if s1 == t1.authenticationDigits then
			CrossDeviceLogin.ConfirmDeviceAccess(v36, t1.authCode)(v35):andThen(function() -- line: 111
				-- upvalues: v25 (copy), MagicLoginPhaseType (copy)
				v25(MagicLoginPhaseType.SUCCESS)
			end, function(p6) -- line: 113
				-- upvalues: Logger (copy), v25 (copy), MagicLoginPhaseType (copy), v33 (copy)
				Logger:warning("Magic login confirm failed: " .. tostring(p6))
				v25(MagicLoginPhaseType.ERROR_OR_EXPIRED)
				v33(false)
			end)

			return
		end

		v27("The number you selected does not match the number on your other device. If you still want to sign in, try again from your other device.")
		v25(MagicLoginPhaseType.ERROR_OR_EXPIRED)
		v33(false)
		CrossDeviceLogin.CancelLoginCode(v36, t1.authCode)(v35)
	end, {
		t1.authCode,
		t1.authenticationDigits
	})
	local v41 = React.useCallback(function() -- line: 128
		-- upvalues: v35 (copy), t1 (copy), v24 (copy), MagicLoginPhaseType (copy), CrossDeviceLogin (copy), v36 (copy)
		v35(t1.closeCentralOverlayThunk())

		if v24 == MagicLoginPhaseType.MATCH_CHALLENGE then
			CrossDeviceLogin.CancelLoginCode(v36, t1.authCode)(v35)
		end
	end, {
		t1.closeCentralOverlayThunk,
		t1.authCode,
		v24
	})
	local v42 = React.useCallback(function() -- line: 135
		-- upvalues: React (copy), Button (copy), v28 (copy), ButtonVariant (copy), v40 (copy), v32 (copy), InputSize (copy)
		local t5 = {}

		for i = 1, 3 do
			table.insert(t5, React.createElement(Button, {
				LayoutOrder = 0,
				text = tostring(v28[i]),
				variant = ButtonVariant.Standard,
				onActivated = function() -- line: 143
					-- upvalues: v40 (copy), v28 (copy), i (copy)
					v40(v28[i])
				end,
				isLoading = v32,
				size = InputSize.Large,
				width = UDim.new(0.315, 1)
			}))
		end

		return t5
	end, {
		v28,
		v32
	})

	if v24 == MagicLoginPhaseType.WAITING_FOR_APPROVAL then
		t2 = {
			TitleText = React.createElement(FoundationText, {
				Text = "Trying to sign in from another device?",
				tag = "auto-xy text-heading-large text-wrap text-align-x-left ",
				LayoutOrder = 0
			}),
			DescriptionText = React.createElement(FoundationText, {
				RichText = true,
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1,
				Text = string.format("Someone is requesting to sign in on <b>%s (%s)</b>. If it's you, press Yes to continue.", t1.endpointName, t1.endpointType)
			}),
			PositiveButton = React.createElement(Button, {
				text = "Yes",
				LayoutOrder = 2,
				variant = ButtonVariant.Emphasis,
				onActivated = v38,
				isLoading = v30,
				size = InputSize.Medium,
				width = UDim.new(1, 1)
			}),
			NegativeButton = React.createElement(Button, {
				text = "No",
				LayoutOrder = 3,
				variant = ButtonVariant.Standard,
				onActivated = v39,
				isLoading = v30,
				size = InputSize.Medium,
				width = UDim.new(1, 1)
			})
		}
	elseif v24 == MagicLoginPhaseType.MATCH_CHALLENGE then
		t2 = {
			TitleText = React.createElement(FoundationText, {
				Text = "Which number do you see on your other device?",
				tag = "auto-xy text-heading-large text-wrap text-align-x-left padding-right-xxlarge",
				LayoutOrder = 0
			}),
			DescriptionText = React.createElement(FoundationText, {
				RichText = true,
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1,
				Text = string.format("Click the number that matches what is shown on <b>%s (%s)</b>.", t1.endpointName, t1.endpointType)
			}),
			ButtonContainer = React.createElement(View, {
				tag = "row gap-small auto-y size-full-0",
				LayoutOrder = 2
			}, (v42()))
		}
	elseif v24 == MagicLoginPhaseType.SUCCESS then
		t2 = {
			TitleText = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-large text-wrap text-align-x-left padding-right-xxlarge",
				LayoutOrder = 0,
				Text = string.format("You're signed in on %s", t1.endpointName)
			}),
			DescriptionText = React.createElement(FoundationText, {
				Text = "Feel free to explore Roblox.",
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1
			}),
			DoneButton = React.createElement(Button, {
				text = "Done",
				LayoutOrder = 2,
				variant = ButtonVariant.Emphasis,
				onActivated = v41,
				size = InputSize.Medium,
				width = UDim.new(1, 1)
			})
		}
	elseif v24 == MagicLoginPhaseType.ERROR_OR_EXPIRED then
		t2 = {
			TitleText = React.createElement(FoundationText, {
				Text = "Couldn't sign you in",
				tag = "auto-xy text-heading-large text-wrap text-align-x-left padding-right-xxlarge",
				LayoutOrder = 0
			}),
			DescriptionText = React.createElement(FoundationText, {
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 1,
				Text = v26
			}),
			OkayButton = React.createElement(Button, {
				text = "Okay",
				LayoutOrder = 2,
				variant = ButtonVariant.Emphasis,
				onActivated = v41,
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
				CloseButtonContainer = if v24 ~= MagicLoginPhaseType.MATCH_CHALLENGE then nil else React.createElement(View, {
					tag = "auto-xy position-top-right padding-large anchor-top-right"
				}, {
					CloseButton = React.createElement(IconButton, {
						icon = "icons/navigation/close",
						tag = "",
						size = IconSize.Medium,
						onActivated = v41
					})
				}),
				ContentContainer = React.createElement(View, {
					tag = "col gap-medium auto-y size-full-0 padding-xxlarge"
				}, t2)
			})
		})
	})
end

return MagicLoginApprovePopup
