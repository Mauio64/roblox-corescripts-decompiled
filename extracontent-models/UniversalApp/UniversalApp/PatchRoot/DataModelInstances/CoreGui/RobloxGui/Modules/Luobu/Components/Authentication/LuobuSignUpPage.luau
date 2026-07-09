local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local UserGender = require(CorePackages.Workspace.Packages.AuthCommon).Enums.UserGender
local InputValidity = require(CorePackages.Workspace.Packages.AuthCommon).Enums.InputValidity
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local BackgroundFill = AuthCommon.Components.BackgroundFill
local AuthBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer
local AuthBackgroundGate = AuthCommon.Components.AuthBackgroundGate
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local AuthBirthdayBar = require(Modules.LuaApp.Components.Authentication.AuthBirthdayBar)
local CollapsingTextInputValidator = require(Modules.LuaApp.Components.Authentication.CollapsingTextInputValidator)
local SignUpGenderSelector = require(Modules.LuaApp.Components.Authentication.SignUpGenderSelector)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local Birthday = require(CorePackages.Workspace.Packages.AuthCommon).Models.Birthday
local BackDisableStore = require(CorePackages.Workspace.Packages.BackDisableStore)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v38 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local DisplayNameValidator = require(Modules.LuaApp.Thunks.Authentication.DisplayNameValidator)
local RequestSignUp = require(Modules.Luobu.Thunks.RequestSignUp)
local SetSignUpInProgress = require(Modules.Luobu.Actions.SetSignUpInProgress)
local SetSignUpInfo = require(Modules.Luobu.Actions.SetSignUpInfo)
local SetBackNavigationDisabled = require(Modules.LuaApp.Actions.SetBackNavigationDisabled)
local FFlagUseBackDisableSignalStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseBackDisableSignalStore
local vector2 = Vector2.new(540, 1080)
local uDim2 = UDim2.new(0, 36, 0, 36)
local v47 = Images["icons/navigation/close"]
local v48 = Roact.PureComponent:extend("LuobuSignUpPage")

v48.validateProps = t.strictInterface({
	formFactor = t.string,
	isSignUpInProgress = t.boolean,
	prefilledDisplayName = t.string,
	voucher = t.string,
	authMethod = t.string,
	channelId = t.number,
	agreedUserAgreements = t.array(t.strictInterface({
		id = t.string,
		agreementType = t.string,
		clientType = t.string,
		displayUrl = t.string,
		regulationType = t.string
	})),
	setSignUpInProgress = t.callback,
	resetSignUpInfo = t.callback,
	navigateBack = t.callback,
	setBackNavigationDisabled = t.callback,
	requestSignUp = t.callback,
	networking = t.callback,
	authEventAnalytics = t.table,
	analytics = t.table,
	appPolicy = t.table
})

local function formatGenderForEndpoint(p1) -- line: 105
	-- upvalues: UserGender (copy)
	return ({
		[UserGender.Unknown] = 1,
		[UserGender.Male] = 2,
		[UserGender.Female] = 3
	})[p1]
end

function v48.init(p2) -- line: 115
	-- upvalues: UserGender (copy), InputValidity (copy), ArgCheck (copy), Birthday (copy), EventStreamConstants (copy)
	p2.state = {
		birthday = nil,
		displayName = "",
		onScreenKeyboardHeight = 0,
		gender = UserGender.Unknown,
		displayNameValid = InputValidity.Unvalidated
	}
	p2.isMounted = false

	function p2.onBirthdaySelected(p3) -- line: 126
		-- upvalues: ArgCheck (copy), Birthday (copy), p2 (copy)
		ArgCheck.assert(Birthday.is(p3), "CentralOverlayForSignUpBirthdayPicker should pass back a Birthday when closing.")
		p2:setState({
			birthday = p3
		})
	end
	function p2.onDisplayNameTextChanged(p4, p5) -- line: 137
		-- upvalues: p2 (copy)
		p2:setState({
			displayName = p4,
			displayNameValid = p5
		})
	end
	function p2.onDisplayNameTextBoxFocused() -- line: 144
		-- upvalues: p2 (copy), EventStreamConstants (copy)
		p2.props.authEventAnalytics.reportDisplayNameFocus(EventStreamConstants.Context.LuobuSignUpPage)
	end
	function p2.onGenderChanged(p6) -- line: 148
		-- upvalues: p2 (copy)
		if p2.isMounted then
			p2:setState({
				gender = p6
			})
		end
	end
	function p2.onSignUpClick() -- line: 156
		-- upvalues: p2 (copy), EventStreamConstants (copy), UserGender (copy)
		local setSignUpInProgress = p2.props.setSignUpInProgress
		local setBackNavigationDisabled = p2.props.setBackNavigationDisabled

		setSignUpInProgress(true)
		setBackNavigationDisabled(true)

		local requestSignUp = p2.props.requestSignUp
		local networking = p2.props.networking
		local analytics = p2.props.analytics
		local appPolicy = p2.props.appPolicy

		p2.props.authEventAnalytics.reportSignUpButtonClicked(EventStreamConstants.Context.LuobuSignUpPage)

		local birthday = p2.state.birthday
		local displayName = p2.state.displayName
		local gender = p2.state.gender
		local authMethod = p2.props.authMethod
		local voucher = p2.props.voucher
		local channelId = p2.props.channelId
		local agreedUserAgreements = p2.props.agreedUserAgreements
		local v91, _ = requestSignUp(networking, analytics, appPolicy, authMethod, {
			birthday = birthday:FormatForEndpoint(),
			displayName = displayName,
			gender = ({
				[UserGender.Unknown] = 1,
				[UserGender.Male] = 2,
				[UserGender.Female] = 3
			})[gender],
			voucher = voucher,
			channelId = channelId,
			agreementIds = agreedUserAgreements
		}):await()

		setBackNavigationDisabled(false)

		if not v91 then
			setSignUpInProgress(false)
		end
	end
end
function v48.didMount(p7) -- line: 196
	-- upvalues: UserInputService (copy)
	p7.isMounted = true
	p7.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 200
		-- upvalues: UserInputService (copy), p7 (copy)
		local v93 = UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		p7:setState({
			onScreenKeyboardHeight = v93
		})
	end)
end
function v48.willUnmount(p8) -- line: 210
	p8.props.resetSignUpInfo()
	p8.props.setSignUpInProgress(false)
	p8.isMounted = false

	if p8.keyboardVisibleChanged then
		p8.keyboardVisibleChanged:disconnect()
		p8.keyboardVisibleChanged = nil
	end
end
function v48.render(p9) -- line: 221
	-- upvalues: FormFactor (copy), InputValidity (copy), withStyle (copy), withLocalization (copy), Roact (copy), FullscreenPageWithSafeArea (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), BackgroundFill (copy), ImageSetLabel (copy), GetImageData (copy), vector2 (copy), ImageSetButton (copy), uDim2 (copy), v47 (copy), AuthBirthdayBar (copy), CollapsingTextInputValidator (copy), DisplayNameValidator (copy), SignUpGenderSelector (copy), Button (copy), ButtonType (copy)
	local n1 = 0
	local n2 = 0
	local v59 = p9.props.formFactor == FormFactor.WIDE
	local v60 = p9.state.onScreenKeyboardHeight > 0

	if v59 then
		if v60 then
			n1 = p9.state.onScreenKeyboardHeight + 10
		else
			n1 = 48
			n2 = 24
		end
	end

	local isSignUpInProgress = p9.props.isSignUpInProgress
	local birthday = p9.state.birthday
	local gender = p9.state.gender
	local displayName = p9.state.displayName
	local displayNameValid = p9.state.displayNameValid
	local v66 = birthday and (displayName and displayNameValid == InputValidity.Valid)
	local s1 = "Authentication.SignUp.Label.ErrorsWithUsername"

	if not birthday then
		s1 = "Authentication.SignUp.Response.BirthdayMustBeSetFirst"
	end

	local prefilledDisplayName = p9.props.prefilledDisplayName

	return withStyle(function(t1: {[any]: any}) -- line: 253
		-- upvalues: withLocalization (copy), Roact (copy), FullscreenPageWithSafeArea (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), v59 (copy), BackgroundFill (copy), isSignUpInProgress (copy), ImageSetLabel (copy), n1 (ref), n2 (ref), GetImageData (copy), vector2 (copy), ImageSetButton (copy), uDim2 (copy), v47 (copy), p9 (copy), AuthBirthdayBar (copy), CollapsingTextInputValidator (copy), s1 (ref), birthday (copy), DisplayNameValidator (copy), prefilledDisplayName (copy), SignUpGenderSelector (copy), gender (copy), Button (copy), ButtonType (copy), v66 (copy)
		return withLocalization({
			signUpText = "Authentication.SignUp.Action.CreateAccount"
		})(function(p10) -- line: 256
			-- upvalues: Roact (copy), FullscreenPageWithSafeArea (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), v59 (copy), t1 (copy), BackgroundFill (copy), isSignUpInProgress (copy), ImageSetLabel (copy), n1 (ref), n2 (ref), GetImageData (copy), vector2 (copy), ImageSetButton (copy), uDim2 (copy), v47 (copy), p9 (copy), AuthBirthdayBar (copy), CollapsingTextInputValidator (copy), s1 (ref), birthday (copy), DisplayNameValidator (copy), prefilledDisplayName (copy), SignUpGenderSelector (copy), gender (copy), Button (copy), ButtonType (copy), v66 (copy)
			return Roact.createElement(FullscreenPageWithSafeArea, {
				BackgroundTransparency = 1,
				includeStatusBar = true,
				renderFullscreenBackground = function() -- line: 260
					-- upvalues: Roact (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), v59 (copy), t1 (copy), BackgroundFill (copy)
					return Roact.createElement(AuthBackgroundGate, {
						renderTreatment = function() -- line: 262
							-- upvalues: Roact (copy), AuthBackgroundContainer (copy), v59 (copy), t1 (copy)
							return Roact.createElement(AuthBackgroundContainer, {
								showImage = v59,
								fallbackBackgroundColor = t1.Theme.BackgroundUIDefault.Color
							})
						end,
						renderLegacy = function() -- line: 268
							-- upvalues: Roact (copy), v59 (copy), t1 (copy), BackgroundFill (copy)
							return Roact.createElement("Frame", {
								Size = UDim2.new(1, 0, 1, 0),
								BackgroundTransparency = not v59 and 0 or 1,
								BackgroundColor3 = t1.Theme.BackgroundUIDefault.Color
							}, {
								Background = v59 and Roact.createElement(BackgroundFill, {
									Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg"
								}),
								Mask = v59 and Roact.createElement("ImageLabel", {
									ZIndex = 2,
									BackgroundTransparency = 0.5,
									Size = UDim2.new(1, 0, 1, 0),
									BackgroundColor3 = Color3.new(0, 0, 0)
								})
							})
						end
					})
				end
			}, {
				UserInputSink = isSignUpInProgress and Roact.createElement("ImageButton", {
					ZIndex = 2,
					BackgroundTransparency = 1,
					Image = "",
					Size = UDim2.new(1, 0, 1, 0)
				}),
				Container = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 1, -n1),
					Position = UDim2.new(0.5, 0, 0, n2),
					AnchorPoint = Vector2.new(0.5, 0),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
					ImageColor3 = t1.Theme.BackgroundUIDefault.Color
				}, {
					SizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = vector2
					}),
					HeaderFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 48),
						Position = UDim2.new(0.5, 0, 0, 0),
						AnchorPoint = Vector2.new(0.5, 0)
					}, {
						BackButton = Roact.createElement(ImageSetButton, {
							Size = uDim2,
							AutoButtonColor = false,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 12, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							ScaleType = Enum.ScaleType.Fit,
							Image = v47,
							ImageColor3 = t1.Theme.UIEmphasis.Color,
							ImageTransparency = t1.Theme.BackgroundUIDefault.Transparency,
							[Roact.Event.Activated] = p9.props.navigateBack
						}),
						Title = p10.signUpText and Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							TextWrapped = true,
							Position = UDim2.new(0, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Text = p10.signUpText or "",
							Font = t1.Font.CaptionHeader.Font,
							TextSize = t1.Font.BaseSize * t1.Font.Header1.RelativeSize,
							TextColor3 = t1.Theme.TextEmphasis.Color,
							TextTransparency = t1.Theme.TextEmphasis.Transparency,
							TextXAlignment = Enum.TextXAlignment.Center
						})
					}),
					Divider = Roact.createElement("Frame", {
						BackgroundTransparency = 0,
						Size = UDim2.new(1, 0, 0, 1),
						Position = UDim2.new(0.5, 0, 0, 48),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundColor3 = t1.Theme.UIEmphasis.Color
					}),
					ContentFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 1, -49),
						Position = UDim2.new(0.5, 0, 0, 49),
						AnchorPoint = Vector2.new(0.5, 0),
						AutomaticSize = Enum.AutomaticSize.XY
					}, {
						ContentPadding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 24),
							PaddingRight = UDim.new(0, 24),
							PaddingTop = UDim.new(0, not v59 and 48 or 25)
						}),
						ListLayout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 5)
						}),
						BirthdayBar = Roact.createElement(AuthBirthdayBar, {
							layoutOrder = 1,
							autoFocusOnMount = false,
							onBirthdaySelected = p9.onBirthdaySelected
						}),
						DisplayNameValidator = Roact.createElement(CollapsingTextInputValidator, {
							layoutOrder = 2,
							titleTextKey = "Authentication.Login.Label.Username",
							summaryErrorTextKey = s1,
							prerequisiteMet = not not birthday,
							onInputTextChanged = p9.onDisplayNameTextChanged,
							onInputTextValidated = p9.onDisplayNameTextChanged,
							validator = DisplayNameValidator,
							validatorAdditionalProps = {
								birthday = birthday and birthday:FormatForEndpoint() or ""
							},
							returnKeyType = Enum.ReturnKeyType.Next,
							prefilledText = prefilledDisplayName
						}),
						GenderSelector = Roact.createElement(SignUpGenderSelector, {
							layoutOrder = 3,
							gender = gender,
							onGenderChanged = p9.onGenderChanged
						}),
						Spacing = Roact.createElement("Frame", {
							LayoutOrder = 4,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 38)
						}),
						SignUpButton = Roact.createElement(Button, {
							layoutOrder = 5,
							buttonType = ButtonType.PrimaryContextual,
							size = UDim2.new(1, 0, 0, 36),
							text = p10.signUpText,
							isDisabled = not v66,
							isLoading = isSignUpInProgress,
							onActivated = p9.onSignUpClick
						})
					})
				})
			})
		end)
	end)
end

local v50 = RoactRodux.connect(function(p11, _) -- line: 414
	return {
		formFactor = p11.FormFactor,
		isSignUpInProgress = p11.Luobu.SignUp.signUpInProgress,
		prefilledDisplayName = p11.Luobu.SignUp.prefilledDisplayName,
		voucher = p11.Luobu.SignUp.signUpVoucher,
		authMethod = p11.Luobu.SignUp.authMethod,
		channelId = p11.Luobu.SignUp.channelId,
		agreedUserAgreements = p11.Luobu.SignUp.agreedUserAgreements
	}
end, function(p13) -- line: 424
	-- upvalues: SetSignUpInProgress (copy), SetSignUpInfo (copy), FFlagSignalsNavP3Dispatch (copy), v38 (copy), NavigateBack (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), SetBackNavigationDisabled (copy), RequestSignUp (copy)
	return {
		setSignUpInProgress = function(p14) -- line: 426
			-- upvalues: p13 (copy), SetSignUpInProgress (copy)
			return p13(SetSignUpInProgress(p14))
		end,
		resetSignUpInfo = function() -- line: 429
			-- upvalues: p13 (copy), SetSignUpInfo (copy)
			return p13(SetSignUpInfo("", "", "", ""))
		end,
		navigateBack = function() -- line: 432
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v38 (copy), p13 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v38.back()
			end

			return p13(NavigateBack())
		end,
		setBackNavigationDisabled = function(p15) -- line: 439
			-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), p13 (copy), SetBackNavigationDisabled (copy)
			if FFlagUseBackDisableSignalStore then
				return (BackDisableStore.setDisabled(p15))
			end

			return (p13(SetBackNavigationDisabled(p15)))
		end,
		requestSignUp = function(p16, p17, p18, p19, p20) -- line: 444
			-- upvalues: p13 (copy), RequestSignUp (copy)
			return p13(RequestSignUp(p16, p17, p18, p19, p20))
		end
	}
end)(v48)
local v51 = RoactServices.connect({
	networking = RoactNetworking,
	authEventAnalytics = RoactAnalyticsAuthEvents,
	analytics = RoactAnalytics
})(v50)

return (RoactAppPolicy.connect(function(p21, _) -- line: 456
	return {
		appPolicy = p21
	}
end)(v51))
