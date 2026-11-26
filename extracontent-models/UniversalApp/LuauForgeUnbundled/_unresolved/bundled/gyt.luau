local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local module = require("@luauforge/bundled/gxM")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useModalFocus = require("@luauforge/bundled/ghc").useModalFocus
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal

local sheet = Foundation.Sheet
local text = Foundation.Text
local iconButton = Foundation.IconButton
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local module2 = require("@luauforge/bundled/gyu")

local fFlagLoginV2ModalFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLoginV2ModalFocusNavigation

local function noop() end

return function(props)
	local v5 = useDesignTokens()
	local ref = React.useRef(nil)

	local v6 = if fFlagLoginV2ModalFocusNavigation then useModalFocus(props.useFoundationSheet) else nil

	local v7 = module(props.useFoundationSheet and {
		qrCodeSheetTitle = "Authentication.CrossDevice.Heading.SignInWithQrCode",
		waitingSheetTitle = "Authentication.CrossDevice.Heading.WaitingForConfirmation"
	} or { alertTitle = "Authentication.CrossDevice.Heading.QuickLogin" })

	if props.useFoundationSheet then
		local onLeaveLogin = props.onLeaveLogin
		local createElement = Roact.createElement
		local root = sheet.Root
		local v8 = {
			preferCenterSheet = true,
			size = dialogSize.Medium,
			onClose = onLeaveLogin or props.onCloseClicked or noop,
			sheetRef = ref,
			ref = v6
		}

		local createElement2 = Roact.createElement
		local header = sheet.Header

		local v10 = if onLeaveLogin then Roact.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, -v5.Size.Size_250)
			}),
			BackAffordance = Roact.createElement(iconButton, {
				testId = "--auth-login-iconbutton-back",
				icon = iconName.ChevronLargeLeft,
				variant = buttonVariant.Utility,
				size = inputSize.Medium,
				isCircular = true,
				onActivated = props.onCloseClicked or noop,
				NextSelectionDown = props.contentStartRef
			})
		}) else nil

		local createElement3 = Roact.createElement

		local v13 = if props.isWaitingForConfirmation then v7.waitingSheetTitle else v7.qrCodeSheetTitle
		return createElement(root, v8, {
			Header = createElement2(header, { hasCloseAffordance = false }, {
				BackAffordanceSlot = v10,
				Title = createElement3(text, {
					LayoutOrder = 2,
					Text = v13,
					tag = "shrink size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
				}),
				CloseAffordance = Roact.createElement(iconButton, {
					testId = "--auth-login-iconbutton-close",
					LayoutOrder = 3,
					icon = iconName.X,
					variant = buttonVariant.Utility,
					size = inputSize.Medium,
					isCircular = true,
					onActivated = function()
						if ref.current then
							ref.current.close()
						end
					end,
					NextSelectionDown = props.contentStartRef
				})
			}),
			Content = Roact.createElement(sheet.Content, nil, {
				ViewContainer = props.loginCode
			})
		})
	else
		local createElement = Roact.createElement
		local v9 = {
			title = v7.alertTitle,
			screenSize = props.screenSize,
			onCloseClicked = props.onCloseClicked,
			position = UDim2.new(0.5, 0, 0.5, 0),
			anchorPoint = 0
		}
		local v10 = if module2() then Vector2.new(0.5, 0) else Vector2.new(0.5, 0.5)
		v9.anchorPoint = v10
		return createElement(partialPageModal, v9, { ViewContainer = props.loginCode })
	end
end
