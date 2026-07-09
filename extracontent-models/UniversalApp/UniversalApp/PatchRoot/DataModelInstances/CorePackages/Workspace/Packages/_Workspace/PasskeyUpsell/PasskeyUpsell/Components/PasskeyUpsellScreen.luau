local _select = select

local function v93(tbl, idx, ...)
	local va = { ... }

	for i = 1, _select("#", ...) do
		tbl[idx + i - 1] = va[i]
	end
end

local PasskeyUpsell = script:FindFirstAncestor("PasskeyUpsell")
local PasskeyUpsellParent = PasskeyUpsell.Parent
local RoactAppExperiment = require(PasskeyUpsellParent.RoactAppExperiment)
local AppBtidLayers = require(PasskeyUpsellParent.ExperimentLayers).AppBtidLayers
local React = require(PasskeyUpsellParent.React)
local RoactUtils = require(PasskeyUpsellParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(PasskeyUpsellParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(PasskeyUpsellParent.RoactServiceTags).RoactNetworking
local UIBlox = require(PasskeyUpsellParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local AppPage = require(PasskeyUpsellParent.RobloxAppEnums).AppPage
local withLocalization = require(PasskeyUpsellParent.Localization).withLocalization
local HandlePasskeyRegistration = require(PasskeyUpsell.Thunks.HandlePasskeyRegistration)
local PasskeyUpsellErrorModal = require(script.Parent.PasskeyUpsellErrorModal)
local PasskeyUpsellSuccessScreen = require(script.Parent.PasskeyUpsellSuccessScreen)
local PasskeyUpsellHeaderContainer = require(script.Parent.PasskeyUpsellHeaderContainer)
local PasskeyUpsellButtonContainer = require(script.Parent.PasskeyUpsellButtonContainer)
local Foundation = require(PasskeyUpsellParent.Foundation)
local SetCurrentToastMessage = require(PasskeyUpsellParent.ToastRodux).Actions.SetCurrentToastMessage
local View = Foundation.View
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local FullscreenPageWithSafeArea = require(PasskeyUpsellParent.AppBlox).FullscreenPageWithSafeArea
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local UpdateCooldown = require(PasskeyUpsell.Utils.UpdateCooldown)
local AuthAnalytics = require(PasskeyUpsellParent.AuthAnalytics)
local authModalShown = AuthAnalytics.Events.authModalShown
local authPageload = AuthAnalytics.Events.authPageload
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authMsgShown = AuthAnalytics.Events.authMsgShown
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local PasskeyUpsellSource = require(PasskeyUpsell.Enums.PasskeyUpsellSource)
local SharedFlags = require(PasskeyUpsellParent.SharedFlags)
local FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment = SharedFlags.FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
local FFlagEmitPasskeyRegistrationSourceOnFinish = SharedFlags.FFlagEmitPasskeyRegistrationSourceOnFinish
local v41 = game:DefineFastFlag("DifferentiateAddAuthMethodPasskeyFlow", false)

return function(t1: {[any]: any}) -- line: 69
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useStyle (copy), useDispatch (copy), useTokens (copy), React (copy), useSelector (copy), RoactAppExperiment (copy), AppBtidLayers (copy), PasskeyUpsellSource (copy), authPageload (copy), EventStreamConstants (copy), FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment (copy), AppPage (copy), UpdateCooldown (copy), authButtonClick (copy), v41 (copy), HandlePasskeyRegistration (copy), authModalShown (copy), FFlagEmitPasskeyRegistrationSourceOnFinish (copy), authMsgShown (copy), SetCurrentToastMessage (copy), Images (copy), View (copy), FoundationImage (copy), FoundationText (copy), withLocalization (copy), FullscreenPageWithSafeArea (copy), PasskeyUpsellSuccessScreen (copy), PasskeyUpsellHeaderContainer (copy), ScrollView (copy), ScrollBarVisibility (copy), PasskeyUpsellButtonContainer (copy), PasskeyUpsellErrorModal (copy)
	local v43 = useRoactService(RoactNetworking)
	local v44 = useStyle()
	local v45 = useDispatch()
	local v46 = useTokens()
	local v47, v48 = React.useState(false)
	local v49, v50 = React.useState(false)
	local v51 = useSelector(function(p1) -- line: 77
		return p1.ScreenSize
	end)

	local function determineScrollViewSize(b1: boolean) -- line: 87
		-- upvalues: v51 (copy)
		if not b1 then
			return UDim2.fromScale(1, 0.5)
		end

		local v61 = math.clamp(math.pow(v51.Y / 640, 3) * 100, 75, v51.Y)

		return UDim2.new(1, 0, 0, v61)
	end

	local v53 = RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.LoginLayer }, function(p2) -- line: 100
		-- upvalues: AppBtidLayers (copy)
		local v63 = p2[AppBtidLayers.LoginLayer] or {}

		return {
			shouldShowToastNotification = v63.shouldShowPasskeyUpsellToastNotification,
			shouldShowSuccessScreen = v63.shouldShowPasskeyUpsellSuccessScreen,
			shouldRenderGraphic = v63.shouldRenderPasskeyUpsellGraphic
		}
	end)
	local v54 = t1.source or PasskeyUpsellSource.Login

	authPageload(EventStreamConstants.Context.PasskeyUpsellScreen, nil, nil, v54)

	local function v55(p3, p4) -- line: 115
		-- upvalues: FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment (copy), v54 (copy), PasskeyUpsellSource (copy), t1 (copy), v45 (copy), AppPage (copy), UpdateCooldown (copy), v43 (copy), authButtonClick (copy)
		if FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v54 == PasskeyUpsellSource.AddAuthMethodPage and t1.onDismiss then
			t1.onDismiss()
		else
			v45(t1.resetNavigationHistory({{
				name = AppPage.Home
			}}))
			UpdateCooldown(v43, v45)
		end

		authButtonClick(p3, p4, nil, nil, nil, v54)
	end

	local v56 = if not v41 or v54 ~= PasskeyUpsellSource.AddAuthMethodPage then nil else "addAuthMethodPagePasskeyNudge"

	local function v57() -- line: 132
		-- upvalues: HandlePasskeyRegistration (copy), v43 (copy), v56 (copy), authModalShown (copy), EventStreamConstants (copy), v54 (copy), authPageload (copy), FFlagEmitPasskeyRegistrationSourceOnFinish (copy), authMsgShown (copy), FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment (copy), PasskeyUpsellSource (copy), t1 (copy), v53 (copy), v45 (copy), AppPage (copy), SetCurrentToastMessage (copy), v46 (copy), Images (copy), v50 (copy), v48 (copy)
		HandlePasskeyRegistration(v43, v56):andThen(function(p5) -- line: 133
			-- upvalues: authModalShown (copy), EventStreamConstants (copy), v54 (copy), authPageload (copy), FFlagEmitPasskeyRegistrationSourceOnFinish (copy), authMsgShown (copy), FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment (copy), PasskeyUpsellSource (copy), t1 (copy), v53 (copy), v45 (copy), AppPage (copy), SetCurrentToastMessage (copy), v46 (copy), Images (copy), v50 (copy)
			if not p5 then
				authModalShown(EventStreamConstants.Context.PasskeyUpsellErrorModalShown, EventStreamConstants.State.RegisterCredentialsError, nil, v54)

				return
			end

			authPageload(EventStreamConstants.Context.PasskeyUpsellScreen, EventStreamConstants.State.PasskeyRegistrationComplete, nil, v54)

			if FFlagEmitPasskeyRegistrationSourceOnFinish then
				authMsgShown(EventStreamConstants.Context.PasskeyCreationSource, EventStreamConstants.State.FinishRegistration, v54)
			end

			if FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v54 == PasskeyUpsellSource.AddAuthMethodPage then
				t1.resetNavigationHistory(nil)

				return
			end

			if v53.shouldShowToastNotification then
				v45(t1.resetNavigationHistory({{
					name = AppPage.Home
				}}))
				v45(SetCurrentToastMessage({
					toastMessage = "Authentication.Passkey.Label.UpsellToastTitle",
					slideIn = true,
					toastIconColorStyle = {
						Transparency = 0,
						Color = v46.Color.Extended.Green.Green_500.Color3
					},
					toastIcon = Images["icons/common/check_contained_fill"]
				}))
				authModalShown(EventStreamConstants.Context.PasskeyUpsellToastShown, EventStreamConstants.State.Success, nil, v54)

				return
			end

			if v53.shouldShowSuccessScreen then
				task.wait(0.2)
				v50(true)
			end
		end):catch(function() -- line: 186
			-- upvalues: authModalShown (copy), EventStreamConstants (copy), v54 (copy), v48 (copy)
			authModalShown(EventStreamConstants.Context.PasskeyUpsellErrorModalShown, EventStreamConstants.State.Unknown, nil, v54)
			v48(true)
		end)
	end
	local function IconAndText(p6, p7, p8) -- line: 197
		-- upvalues: React (copy), View (copy), FoundationImage (copy), v46 (copy), FoundationText (copy)
		local n1 = 32
		local s1 = ""

		if p6 == "icons/common/eye_slash" then
			n1 = 24
			s1 = " padding-left-xsmall"
		end

		return React.createElement(View, {
			tag = "row gap-medium size-full-0 auto-y text-wrap padding-right-xxlarge" .. s1,
			LayoutOrder = p8
		}, {
			Icon = React.createElement(FoundationImage, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(0, n1, 0, n1),
				imageStyle = {
					Color3 = v46.Color.Content.Default.Color3
				},
				Image = p6
			}),
			RowText = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = p7,
				tag = "text-body-large text-align-x-left text-wrap auto-xy padding-right-xxlarge" .. s1,
				Size = UDim2.new(1, -n1, 0, n1)
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
	})(function(p9) -- line: 237
		-- upvalues: React (copy), FullscreenPageWithSafeArea (copy), v44 (copy), View (copy), v49 (copy), PasskeyUpsellSuccessScreen (copy), v55 (copy), v53 (copy), PasskeyUpsellHeaderContainer (copy), FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment (copy), v54 (copy), PasskeyUpsellSource (copy), EventStreamConstants (copy), v47 (copy), ScrollView (copy), v51 (copy), ScrollBarVisibility (copy), IconAndText (copy), PasskeyUpsellButtonContainer (copy), v57 (copy), authButtonClick (copy), PasskeyUpsellErrorModal (copy), v48 (copy)
		local createElement = React.createElement
		local v73 = FullscreenPageWithSafeArea
		local t2 = {
			includeStatusBar = false,
			BackgroundColor3 = v44.Theme.BackgroundDefault.Color
		}
		local t3 = {}
		local createElement2 = React.createElement
		local v77 = View
		local t4 = {
			tag = "size-full-full padding-right-xxlarge padding-left-xxlarge padding-bottom-xxlarge padding-top-xxlarge"
		}
		local g80 = nil
		local v79 = nil

		if v49 then
			v79 = React.createElement(PasskeyUpsellSuccessScreen, {
				onCancelButtonPressed = v55,
				shouldRenderGraphic = v53.shouldRenderGraphic
			})

			if v79 then
				g80 = true
			end
		end

		if not g80 then
			v79 = {}

			local createElement3 = React.createElement
			local v82 = View
			local t5 = {
				tag = "col gap-small size-full-0 auto-xy",
				LayoutOrder = 1
			}
			local t6 = {
				PasskeyUpsellHeaderContainer = React.createElement(PasskeyUpsellHeaderContainer, {
					LayoutOrder = 0,
					localizedTitleText = if not FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment or v54 ~= PasskeyUpsellSource.AddAuthMethodPage then p9.upsellTitleText else p9.createPasskeyText,
					onCancelButtonPressed = function() -- line: 258
						-- upvalues: v55 (copy), EventStreamConstants (copy)
						v55(EventStreamConstants.Context.PasskeyUpsellScreen, EventStreamConstants.Button.DismissCornerX)
					end,
					isDisabled = v47,
					shouldRenderGraphic = v53.shouldRenderGraphic
				})
			}
			local createElement4 = React.createElement
			local v86 = ScrollView
			local t7 = {
				LayoutOrder = 1
			}
			local uDim2

			if not v53.shouldRenderGraphic then
				uDim2 = UDim2.fromScale(1, 0.5)
			else
				local v89 = math.clamp(math.pow(v51.Y / 640, 3) * 100, 75, v51.Y)

				uDim2 = UDim2.new(1, 0, 0, v89)
			end

			t7.Size = uDim2
			t7.scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(1, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = ScrollBarVisibility.Auto
			}
			t7.layout = {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 24)
			}
			v93(t6, 1, createElement4(v86, t7, {
				PasskeyPurposeRow = IconAndText("icons/menu/passkey", p9.passkeyPurposeText, 1),
				PasskeyBenefitsRow = IconAndText("icons/common/safety", p9.benefitsText, 2),
				DataPolicyRow = IconAndText("icons/common/eye_slash", p9.dataPolicyText, 3)
			}))

			local v90 = createElement3(v82, t5, t6)

			v79[1] = v90
			v79.PasskeyUpsellButtonContainer = React.createElement(PasskeyUpsellButtonContainer, {
				layoutOrder = 2,
				localizedContinueText = p9.createPasskeyText,
				localizedCancelText = if not FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment or v54 ~= PasskeyUpsellSource.AddAuthMethodPage then p9.keepUsingPasswordText else p9.skipText,
				onContinueButtonPressed = function() -- line: 297
					-- upvalues: v57 (copy), authButtonClick (copy), EventStreamConstants (copy), v54 (copy)
					v57()
					authButtonClick(EventStreamConstants.Context.PasskeyUpsellScreen, EventStreamConstants.Button.RegisterPasskey, nil, nil, nil, v54)
				end,
				onCancelButtonPressed = function() -- line: 308
					-- upvalues: v55 (copy), EventStreamConstants (copy)
					v55(EventStreamConstants.Context.PasskeyUpsellScreen, EventStreamConstants.Button.Close)
				end,
				isDisabled = v47
			})
		end

		g80 = false

		local v91 = createElement2(v77, t4, v79)

		t3[1] = v91
		t3.ErrorToastContainer = v47 and React.createElement(PasskeyUpsellErrorModal, {
			onCancel = function() -- line: 319
				-- upvalues: v48 (copy), v55 (copy), EventStreamConstants (copy)
				v48(false)
				v55(EventStreamConstants.Context.PasskeyUpsellErrorModalShown, EventStreamConstants.Button.GoHome)
			end,
			onTryAgain = function() -- line: 326
				-- upvalues: v48 (copy), authButtonClick (copy), EventStreamConstants (copy), v54 (copy), v57 (copy)
				v48(false)
				authButtonClick(EventStreamConstants.Context.PasskeyUpsellErrorModalShown, EventStreamConstants.Button.TryAgain, nil, nil, nil, v54)
				v57()
			end
		})

		return createElement(v73, t2, t3)
	end)
end
