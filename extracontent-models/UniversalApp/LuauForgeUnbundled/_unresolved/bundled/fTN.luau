local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/bundled/fMG")
local module2 = require("@luauforge/bundled/dYT")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/eda")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local module4 = require("@luauforge/bundled/dwM")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Style.withStyle
local module5 = require("@luauforge/bundled/edC")

local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local userGender = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.UserGender
local inputValidity = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.InputValidity

local module6 = require("@luauforge/bundled/dYW")
local authBackgroundContainer = require("@game/CorePackages/Workspace/Packages/AuthCommon").Components.AuthBackgroundContainer
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageData
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local images = UIBlox.App.ImageSet.Images
local module7 = require("@luauforge/bundled/fTO")
local module8 = require("@luauforge/bundled/fTR")
local module9 = require("@luauforge/bundled/fTS")
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local module10 = require("@luauforge/bundled/fsy")

local birthday = require("@game/CorePackages/Workspace/Packages/AuthCommon").Models.Birthday
local module11 = require("@luauforge/bundled/fuu")

local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local module13 = require("@luauforge/bundled/fTU")
local module14 = require("@luauforge/bundled/fTW")

local module15 = require("@luauforge/bundled/fTZ")
local module16 = require("@luauforge/bundled/fOR")

local vector2 = Vector2.new(540, 1080)

local udim = UDim2.new(0, 36, 0, 36)

local iconsnavigationclose = images["icons/navigation/close"]

local extended = Roact.PureComponent:extend("LuobuSignUpPage")

extended.validateProps = t.strictInterface({
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

local function formatGenderForEndpoint(p2)
	return ({ [userGender.Unknown] = 1, [userGender.Male] = 2, [userGender.Female] = 3 })[p2]
end

function extended:init()
	self.state = {
		birthday = nil,
		displayName = "",
		gender = userGender.Unknown,
		onScreenKeyboardHeight = 0,
		displayNameValid = inputValidity.Unvalidated
	}

	self.isMounted = false

	function self.onBirthdaySelected(p2)
		module4.assert(
			birthday.is(p2),
			"CentralOverlayForSignUpBirthdayPicker should pass back a Birthday when closing."
		)

		self:setState({ birthday = p2 })
	end

	function self.onDisplayNameTextChanged(p2, p3)
		self:setState({ displayName = p2, displayNameValid = p3 })
	end

	function self.onDisplayNameTextBoxFocused()
		self.props.authEventAnalytics.reportDisplayNameFocus(module10.Context.LuobuSignUpPage)
	end

	function self.onGenderChanged(p2)
		if self.isMounted then
			self:setState({ gender = p2 })
		end
	end

	function self.onSignUpClick()
		local setSignUpInProgress = self.props.setSignUpInProgress
		local setBackNavigationDisabled = self.props.setBackNavigationDisabled

		setSignUpInProgress(true)
		setBackNavigationDisabled(true)

		local requestSignUp = self.props.requestSignUp
		local networking = self.props.networking
		local analytics = self.props.analytics
		local appPolicy = self.props.appPolicy

		self.props.authEventAnalytics.reportSignUpButtonClicked(module10.Context.LuobuSignUpPage)

		local birthday2 = self.state.birthday
		local displayName = self.state.displayName
		local gender = self.state.gender

		local authMethod = self.props.authMethod
		local voucher = self.props.voucher
		local channelId = self.props.channelId
		local agreedUserAgreements = self.props.agreedUserAgreements
		local v7, v8 = requestSignUp(networking, analytics, appPolicy, authMethod, {
			birthday = birthday2:FormatForEndpoint(),
			displayName = displayName,
			gender = ({
				[userGender.Unknown] = 1,
				[userGender.Male] = 2,
				[userGender.Female] = 3
			})[gender],
			voucher = voucher,
			channelId = channelId,
			agreementIds = agreedUserAgreements
		}):await()
		setBackNavigationDisabled(false)

		if not v7 then
			setSignUpInProgress(false)
		end
	end
end

function extended:didMount()
	self.isMounted = true

	self.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
		local y = UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		self:setState({ onScreenKeyboardHeight = y })
	end)
end

function extended:willUnmount()
	self.props.resetSignUpInfo()
	self.props.setSignUpInProgress(false)
	self.isMounted = false

	if self.keyboardVisibleChanged then
		self.keyboardVisibleChanged:disconnect()
		self.keyboardVisibleChanged = nil
	end
end

function extended.render(data)
	local v5 = 0

	local v6 = data.props.formFactor == formFactor.WIDE
	local v7 = data.state.onScreenKeyboardHeight > 0
	local v8

	if v6 then
		if v7 then
			v8 = data.state.onScreenKeyboardHeight + 10
		else
			v8 = 48
			v5 = 24
		end
	else
		v8 = 0
	end

	local isSignUpInProgress = data.props.isSignUpInProgress

	local birthday2 = data.state.birthday
	local gender = data.state.gender
	local displayName = data.state.displayName
	local displayNameValid = data.state.displayNameValid
	local v9 = birthday2 and displayName and displayNameValid == inputValidity.Valid
	local v10 = birthday2 and "Authentication.SignUp.Label.ErrorsWithUsername"
		or "Authentication.SignUp.Response.BirthdayMustBeSetFirst"
	local prefilledDisplayName = data.props.prefilledDisplayName

	return withStyle(function(data2)
		return module5({ signUpText = "Authentication.SignUp.Action.CreateAccount" })(function(p2)
			local createElement = Roact.createElement

			local v13 = {
				UserInputSink = isSignUpInProgress and Roact.createElement("ImageButton", {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Image = ""
				}),
				Container = 0
			}

			local createElement2 = Roact.createElement
			local v15 = {
				Size = UDim2.new(1, 0, 1, -v8),
				Position = UDim2.new(0.5, 0, 0, v5),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(9, 9, 9, 9),
				Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = data2.Theme.BackgroundUIDefault.Color,
				ClipsDescendants = true
			}

			local children = {
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = vector2
				}),
				HeaderFrame = 0,
				Divider = 0,
				ContentFrame = 0
			}

			local createElement3 = Roact.createElement
			local v17 = {
				Size = UDim2.new(1, 0, 0, 48),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1
			}

			local v18 = {
				BackButton = Roact.createElement(imageSetButton, {
					Size = udim,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					ScaleType = Enum.ScaleType.Fit,
					Image = iconsnavigationclose,
					ImageColor3 = data2.Theme.UIEmphasis.Color,
					ImageTransparency = data2.Theme.BackgroundUIDefault.Transparency,
					[Roact.Event.Activated] = data.props.navigateBack
				}),
				Title = 0
			}

			local v20 = p2.signUpText

			if v20 then
				local createElement5 = Roact.createElement
				local v22 = {
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Text = p2.signUpText or "",
					TextWrapped = true,
					Font = 0,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextXAlignment = 0
				}

				local v23 = if not foundationFontFaceMigration then data2.Font.CaptionHeader.Font else nil
				v22.Font = v23

				local v24 = if foundationFontFaceMigration then normalizeFontFace(data2.Tokens.Typography.CaptionLarge.Font) else nil
				v22.FontFace = v24

				v22.TextSize = data2.Font.BaseSize * data2.Font.Header1.RelativeSize
				v22.TextColor3 = data2.Theme.TextEmphasis.Color
				v22.TextTransparency = data2.Theme.TextEmphasis.Transparency
				v22.TextXAlignment = Enum.TextXAlignment.Center
				v20 = createElement5("TextLabel", v22)
			end

			v18.Title = v20
			children.HeaderFrame = createElement3("Frame", v17, v18)

			children.Divider = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0.5, 0, 0, 48),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 0,
				BackgroundColor3 = data2.Theme.UIEmphasis.Color
			})

			children.ContentFrame = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, -49),
				Position = UDim2.new(0.5, 0, 0, 49),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				ContentPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24),
					PaddingTop = UDim.new(0, v6 and 25 or 48)
				}),
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 5)
				}),
				BirthdayBar = Roact.createElement(module7, {
					layoutOrder = 1,
					onBirthdaySelected = data.onBirthdaySelected,
					autoFocusOnMount = false
				}),
				DisplayNameValidator = Roact.createElement(module8, {
					layoutOrder = 2,
					titleTextKey = "Authentication.Login.Label.Username",
					summaryErrorTextKey = v10,
					prerequisiteMet = birthday2 and true or false,
					onInputTextChanged = data.onDisplayNameTextChanged,
					onInputTextValidated = data.onDisplayNameTextChanged,
					validator = module13,
					validatorAdditionalProps = {
						birthday = birthday2 and birthday2:FormatForEndpoint() or ""
					},
					returnKeyType = Enum.ReturnKeyType.Next,
					prefilledText = prefilledDisplayName
				}),
				GenderSelector = Roact.createElement(module9, {
					layoutOrder = 3,
					gender = gender,
					onGenderChanged = data.onGenderChanged
				}),
				Spacing = Roact.createElement("Frame", {
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 38)
				}),
				SignUpButton = Roact.createElement(button, {
					buttonType = buttonType.PrimaryContextual,
					layoutOrder = 5,
					size = UDim2.new(1, 0, 0, 36),
					text = p2.signUpText,
					isDisabled = not v9,
					isLoading = isSignUpInProgress,
					onActivated = data.onSignUpClick
				})
			})
			v13.Container = createElement2(imageSetLabel, v15, children)
			return createElement(module6, {
				BackgroundTransparency = 1,
				includeStatusBar = true,
				renderFullscreenBackground = function()
					return Roact.createElement(authBackgroundContainer, {
						showImage = v6,
						fallbackBackgroundColor = data2.Theme.BackgroundUIDefault.Color
					})
				end
			}, v13)
		end)
	end)
end

local v5 = RoactRodux.connect(function(p2, p3)
	return {
		formFactor = p2.FormFactor,
		isSignUpInProgress = p2.Luobu.SignUp.signUpInProgress,
		prefilledDisplayName = p2.Luobu.SignUp.prefilledDisplayName,
		voucher = p2.Luobu.SignUp.signUpVoucher,
		authMethod = p2.Luobu.SignUp.authMethod,
		channelId = p2.Luobu.SignUp.channelId,
		agreedUserAgreements = p2.Luobu.SignUp.agreedUserAgreements
	}
end, function(callback)
	return {
		setSignUpInProgress = function(p2)
			return callback(module15(p2))
		end,
		resetSignUpInfo = function()
			return callback(module16("", "", "", ""))
		end,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end,
		setBackNavigationDisabled = function(p2)
			return module11.setDisabled(p2)
		end,
		requestSignUp = function(p2, p3, p4, p5, p6)
			return callback(module14(p2, p3, p4, p5, p6))
		end
	}
end)(extended)

local v6 = roactServices.connect({
	networking = module3,
	authEventAnalytics = module,
	analytics = module2
})(v5)

return (roactAppPolicy.connect(function(p2, p3)
	return { appPolicy = p2 }
end)(v6))
