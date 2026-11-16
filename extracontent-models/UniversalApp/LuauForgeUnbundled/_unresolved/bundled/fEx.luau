local module = require("@luauforge/bundled/fEy")
local appBtidLayers = require("@luauforge/bundled/fEz").AppBtidLayers

local module2 = require("@luauforge/bundled/fEA")
local module3 = require("@luauforge/bundled/fEB")
local useDispatch = module3.Hooks.RoactRodux.useDispatch
local useSelector = module3.Hooks.RoactRodux.useSelector
local useRoactService = require("@luauforge/bundled/fEC").useRoactService
local roactNetworking = require("@luauforge/bundled/fED").RoactNetworking

local module4 = require("@luauforge/bundled/fEE")
local useStyle = module4.Core.Style.useStyle
local images = module4.App.ImageSet.Images

local appPage = require("@luauforge/bundled/fEF").AppPage
local withLocalization = require("@luauforge/bundled/fEG").withLocalization
local module5 = require("@luauforge/bundled/fEl")

local module6 = require("@luauforge/bundled/fEH")
local module7 = require("@luauforge/bundled/fEJ")
local module8 = require("@luauforge/bundled/fEK")
local module9 = require("@luauforge/bundled/fEM")
local module10 = require("@luauforge/bundled/fEL")
local setCurrentToastMessage = require("@luauforge/bundled/fEN").Actions.SetCurrentToastMessage
local view = module10.View
local image = module10.Image
local text = module10.Text
local useTokens = module10.Hooks.useTokens
local fullscreenPageWithSafeArea = require("@luauforge/bundled/fEO").FullscreenPageWithSafeArea
local scrollView = module10.ScrollView
local scrollBarVisibility = module10.Enums.ScrollBarVisibility
local module11 = require("@luauforge/bundled/fEv")
local module12 = require("@luauforge/bundled/fEI")
local authModalShown = module12.Events.authModalShown
local authPageload = module12.Events.authPageload
local authButtonClick = module12.Events.authButtonClick
local authMsgShown = module12.Events.authMsgShown
local eventStreamConstants = module12.EventStreamConstants
local module13 = require("@luauforge/bundled/fEj")

local module14 = require("@luauforge/bundled/fEp")

local fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment = module14.FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
local fFlagEmitPasskeyRegistrationSourceOnFinish = module14.FFlagEmitPasskeyRegistrationSourceOnFinish
local defineFastFlag = game:DefineFastFlag("DifferentiateAddAuthMethodPasskeyFlow", false)

return function(data)
	local v5 = useRoactService(roactNetworking)
	local v6 = useStyle()
	local v7 = useDispatch()
	local v8 = useTokens()
	local state, setState = module2.useState(false)
	local state2, setState2 = module2.useState(false)

	local v9 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local function determineScrollViewSize(p2)
		if not p2 then
			return UDim2.fromScale(1, 0.5)
		end

		local v10 = math.clamp(math.pow(v9.Y / 640, 3) * 100, 75, v9.Y)
		return UDim2.new(1, 0, 0, v10)
	end

	local v10 = module.useBrowserTrackerExperiment({ appBtidLayers.LoginLayer }, function(p2)
		local v11 = p2[appBtidLayers.LoginLayer] or {}
		return {
			shouldShowToastNotification = v11.shouldShowPasskeyUpsellToastNotification,
			shouldShowSuccessScreen = v11.shouldShowPasskeyUpsellSuccessScreen,
			shouldRenderGraphic = v11.shouldRenderPasskeyUpsellGraphic
		}
	end)

	local source = data.source or module13.Login

	authPageload(eventStreamConstants.Context.PasskeyUpsellScreen, nil, nil, source)

	local function onCancelButtonPressed(p2, p3)
		if
			fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
			and source == module13.AddAuthMethodPage
			and data.onDismiss
		then
			data.onDismiss()
		else
			v7(data.resetNavigationHistory({
				{ name = appPage.Home }
			}))
			module11(v5, v7)
		end

		authButtonClick(p2, p3, nil, nil, nil, source)
	end

	local v11 = defineFastFlag
		and source == module13.AddAuthMethodPage
		and "addAuthMethodPagePasskeyNudge"
		or nil

	local function fn()
		module5(v5, v11):andThen(function(p2)
			if not p2 then
				authModalShown(
					eventStreamConstants.Context.PasskeyUpsellErrorModalShown,
					eventStreamConstants.State.RegisterCredentialsError,
					nil,
					source
				)

				return
			end

			authPageload(
				eventStreamConstants.Context.PasskeyUpsellScreen,
				eventStreamConstants.State.PasskeyRegistrationComplete,
				nil,
				source
			)

			if fFlagEmitPasskeyRegistrationSourceOnFinish then
				authMsgShown(
					eventStreamConstants.Context.PasskeyCreationSource,
					eventStreamConstants.State.FinishRegistration,
					source
				)
			end

			if
				fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
				and source == module13.AddAuthMethodPage
			then
				data.resetNavigationHistory(nil)
			elseif v10.shouldShowToastNotification then
				v7(data.resetNavigationHistory({
					{ name = appPage.Home }
				}))
				v7(setCurrentToastMessage({
					toastMessage = "Authentication.Passkey.Label.UpsellToastTitle",
					toastIconColorStyle = {
						Color = v8.Color.Extended.Green.Green_500.Color3,
						Transparency = 0
					},
					toastIcon = images["icons/common/check_contained_fill"],
					slideIn = true
				}))

				authModalShown(
					eventStreamConstants.Context.PasskeyUpsellToastShown,
					eventStreamConstants.State.Success,
					nil,
					source
				)
			elseif v10.shouldShowSuccessScreen then
				task.wait(0.2)
				setState2(true)
			end
		end):catch(function()
			authModalShown(
				eventStreamConstants.Context.PasskeyUpsellErrorModalShown,
				eventStreamConstants.State.Unknown,
				nil,
				source
			)

			setState(true)
		end)
	end

	local function IconAndText(p2, p3, p4)
		local v12, v13

		if p2 == "icons/common/eye_slash" then
			v12 = " padding-left-xsmall"
			v13 = 24
		else
			v12 = ""
			v13 = 32
		end

		return module2.createElement(view, {
			tag = "row gap-medium size-full-0 auto-y text-wrap padding-right-xxlarge" .. v12,
			LayoutOrder = p4
		}, {
			Icon = module2.createElement(image, {
				Size = UDim2.new(0, v13, 0, v13),
				BackgroundTransparency = 1,
				imageStyle = { Color3 = v8.Color.Content.Default.Color3 },
				Image = p2,
				LayoutOrder = 1
			}),
			RowText = module2.createElement(text, {
				Text = p3,
				tag = "text-body-large text-align-x-left text-wrap auto-xy padding-right-xxlarge" .. v12,
				LayoutOrder = 2,
				Size = UDim2.new(1, -v13, 0, v13)
			})
		})
	end

	return withLocalization({
		upsellTitleText = "Authentication.Passkey.Label.UpsellTitle",
		passkeyPurposeText = "Authentication.Passkey.Description.Purpose",
		benefitsText = "Authentication.Passkey.Description.Benefits",
		dataPolicyText = "Authentication.Passkey.Description.DataPolicy",
		createPasskeyText = "Authentication.Passkey.Action.CreatePasskey",
		keepUsingPasswordText = "Authentication.Passkey.Action.KeepUsingPassword",
		skipText = "Authentication.SignUp.Label.Skip"
	})(function(props)
		local createElement = module2.createElement
		local v13 = {
			includeStatusBar = false,
			BackgroundColor3 = v6.Theme.BackgroundDefault.Color
		}
		local v14 = { [1] = nil, nil }
		local createElement2 = module2.createElement

		local v17 = state2
			and module2.createElement(module7, {
				onCancelButtonPressed = onCancelButtonPressed,
				shouldRenderGraphic = v10.shouldRenderGraphic
			})

		if not v17 then
			v17 = { [1] = nil, nil }

			local createElement3 = module2.createElement

			local createElement4 = module2.createElement

			local v23 = if fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and source == module13.AddAuthMethodPage then props.createPasskeyText else props.upsellTitleText
			local v20 = {
				nil,
				PasskeyUpsellHeaderContainer = createElement4(module8, {
					localizedTitleText = v23,
					onCancelButtonPressed = function()
						onCancelButtonPressed(
							eventStreamConstants.Context.PasskeyUpsellScreen,
							eventStreamConstants.Button.DismissCornerX
						)
					end,
					LayoutOrder = 0,
					isDisabled = state,
					shouldRenderGraphic = v10.shouldRenderGraphic
				})
			}

			local createElement5 = module2.createElement
			local udim

			if v10.shouldRenderGraphic then
				local v26 = math.clamp(math.pow(v9.Y / 640, 3) * 100, 75, v9.Y)
				udim = UDim2.new(1, 0, 0, v26)
			else
				udim = UDim2.fromScale(1, 0.5)
			end

			-- [TOVEK] unclear table creation
			-- Inserting from loop instead
			do
				local _values = table.pack(createElement5(scrollView, {
					LayoutOrder = 1,
					Size = udim,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.fromScale(1, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = scrollBarVisibility.Auto
					},
					layout = {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 24)
					}
				}, {
					PasskeyPurposeRow = IconAndText("icons/menu/passkey", props.passkeyPurposeText, 1),
					PasskeyBenefitsRow = IconAndText("icons/common/safety", props.benefitsText, 2),
					DataPolicyRow = IconAndText("icons/common/eye_slash", props.dataPolicyText, 3)
				}))
				for _k = 1, _values.n do
					v20[_k] = _values[_k]
				end
			end
			v17[1] = (createElement3(view, { tag = "col gap-small size-full-0 auto-xy", LayoutOrder = 1 }, v20))
			local createElement6 = module2.createElement
			local v27 = {
				localizedContinueText = props.createPasskeyText,
				localizedCancelText = 0,
				onContinueButtonPressed = 0,
				onCancelButtonPressed = 0,
				layoutOrder = 2,
				isDisabled = 0
			}

			local v28 = if fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and source == module13.AddAuthMethodPage then props.skipText else props.keepUsingPasswordText
			v27.localizedCancelText = v28

			function v27.onContinueButtonPressed()
				fn()
				authButtonClick(
					eventStreamConstants.Context.PasskeyUpsellScreen,
					eventStreamConstants.Button.RegisterPasskey,
					nil,
					nil,
					nil,
					source
				)
			end
			function v27.onCancelButtonPressed()
				onCancelButtonPressed(
					eventStreamConstants.Context.PasskeyUpsellScreen,
					eventStreamConstants.Button.Close
				)
			end

			v27.isDisabled = state
			v17.PasskeyUpsellButtonContainer = createElement6(module9, v27)
		end

		v14[1] = (createElement2(
	view,
	{
		tag = "size-full-full padding-right-xxlarge padding-left-xxlarge padding-bottom-xxlarge padding-top-xxlarge"
	},
	v17
))
		v14.ErrorToastContainer = state and module2.createElement(module6, {
			onCancel = function()
				setState(false)
				onCancelButtonPressed(
					eventStreamConstants.Context.PasskeyUpsellErrorModalShown,
					eventStreamConstants.Button.GoHome
				)
			end,
			onTryAgain = function()
				setState(false)
				authButtonClick(
					eventStreamConstants.Context.PasskeyUpsellErrorModalShown,
					eventStreamConstants.Button.TryAgain,
					nil,
					nil,
					nil,
					source
				)

				fn()
			end
		})
		return createElement(fullscreenPageWithSafeArea, v13, v14)
	end)
end
