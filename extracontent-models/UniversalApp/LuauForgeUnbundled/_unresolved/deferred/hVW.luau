local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module3 = require("@luauforge/deferred/hVX")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local module4 = require("@luauforge/deferred/hVY")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local withStyle = UIBlox.Core.Style.withStyle
local module5 = require("@luauforge/bundled/egZ")
local module6 = require("@luauforge/deferred/hVZ")
local module7 = require("@luauforge/deferred/hWa")

local FitFrame = require(CorePackages.Packages.FitFrame)
local module8 = require("@luauforge/bundled/egF")

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType

local userAgreementsList = require("@luauforge/bundled/gsy").UserAgreementsList

local module9 = require("@luauforge/deferred/hWb")

local defineFastFlag = game:DefineFastFlag("UserAgreementsDefaultSelection", false)

local defineFastFlag2 = game:DefineFastFlag("UserAgreementsUpdatedPopupFoundation", false)

local defineFastFlag3 = game:DefineFastFlag("UserAgreementsDynamicBodyText", false)

local module10 = require("@luauforge/deferred/hWc")

local rect = Rect.new(8, 8, 9, 9)

local function findAgreementBodyText(agreements)
	for i, item in ipairs(agreements) do
		if item.agreementBodyText ~= nil and item.agreementBodyText ~= "" then
			return item.agreementBodyText
		end
	end

	return nil
end

local extended = Roact.PureComponent:extend("UserAgreementsUpdatedPopup")

local strictInterface = t.strictInterface
local v5 = {
	agreements = t.array(t.strictInterface({
		id = t.string,
		agreementType = t.string,
		clientType = t.string,
		displayUrl = t.string,
		regulationType = t.string,
		agreementBodyText = t.optional(t.string)
	})),
	formFactor = t.string,
	screenSize = t.Vector2,
	networking = t.callback,
	closePopup = t.callback,
	defaultChildRef = t.optional(t.any),
	focusController = t.optional(t.any),
	containerWidth = t.optional(t.integer),
	closeCentralOverlayThunk = t.optional(t.callback),
	agreementAccepted = t.optional(t.callback),
	checkboxEnabled = t.optional(t.boolean),
	optInByDefault = t.optional(t.boolean),
	defaultFocusRef = 0,
	containerRef = 0
}

local v6 = if defineFastFlag then t.callback else nil
v5.defaultFocusRef = v6
local v7 = if defineFastFlag then t.callback else nil
v5.containerRef = v7
extended.validateProps = strictInterface(v5)

function extended:init()
	if module10() then
		self.state = {
			promoEmailsDisplayed = self.props.checkboxEnabled,
			promoEmailsChecked = self.props.optInByDefault
		}

		function self.SetPromoEmailsCheckbox(p2)
			self:setState({ promoEmailsChecked = p2 })
		end
		function self.SetPromoEmailsCheckboxByTextButton()
			self:setState({
				promoEmailsChecked = not self.state.promoEmailsChecked
			})
		end
	end

	function self.agreeAndClosePopup()
		local networking = self.props.networking
		local agreements = self.props.agreements
		local closePopup = self.props.closePopup
		module6(networking, agreements, function(p2) end)

		if module10() then
			module7(networking, self.state.promoEmailsChecked)
		end

		closePopup()

		if self.props.agreementAccepted then
			self.props.agreementAccepted()
		end
	end
end

function extended:getLayoutInfo(p3, p4)
	if p3 then
		return module8, {
			Size = UDim2.new(0, 540, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "LuaApp/buttons/buttonFill",
			ImageColor3 = p4.BackgroundUIDefault.Color,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect,
			AutomaticSize = Enum.AutomaticSize.Y
		}
	end

	return "Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		BackgroundColor3 = p4.BackgroundUIDefault.Color
	}
end

function extended:renderWithProviders(props2, props3)
	local font = props3.Font
	local theme = props3.Theme

	local screenSize = self.props.screenSize
	local formFactor2 = self.props.formFactor
	local agreements = self.props.agreements
	local v8 = formFactor2 == formFactor.WIDE
	local layoutInfo, v9 = self:getLayoutInfo(v8, theme)

	local title = props2.title
	local v10 = props2.message

	if defineFastFlag3 then
		v10 = findAgreementBodyText(agreements) or props2.message
	end

	local agreeButton = props2.agreeButton
	local checkbox2 = if module10() then props2.checkbox else nil

	LoggingProtocol.default:logRobloxTelemetryEvent(module3)

	if defineFastFlag2 then
		local createElement = Roact.createElement
		local v12 = {
			agreements = agreements,
			titleText = title,
			messageText = v10,
			agreeButtonText = agreeButton,
			onAgree = self.agreeAndClosePopup,
			isWideView = v8,
			isPromotionalEmailsShown = module10() and self.state.promoEmailsDisplayed,
			promotionalEmailsText = checkbox2,
			isPromotionalEmailsChecked = 0,
			onPromotionalEmailsChanged = 0,
			containerRef = 0,
			agreeButtonRef = 0
		}

		local v13 = if module10() then self.state.promoEmailsChecked else nil
		v12.isPromotionalEmailsChecked = v13

		local v14 = if module10() then self.SetPromoEmailsCheckbox else nil
		v12.onPromotionalEmailsChanged = v14

		local v15 = if defineFastFlag then self.props.containerRef else nil
		v12.containerRef = v15
		local v16 = if defineFastFlag then self.props.defaultFocusRef else nil
		v12.agreeButtonRef = v16
		return createElement(module9, v12)
	else
		local createElement = Roact.createElement
		local v12 = {
			["Size"] = UDim2.new(1, 0, 0, screenSize.Y),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local ref = Roact.Ref
		local v13 = if defineFastFlag then self.props.containerRef else nil
		v12[ref] = v13

		local createElement2 = Roact.createElement
		local children = {
			ListLayout = v8 and Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v8 and 0 or 60),
				PaddingBottom = UDim.new(0, v8 and 24 or 48)
			}),
			Content = 0,
			AgreeButton = 0
		}

		local createElement3 = Roact.createElement
		local fitFrameVertical = FitFrame.FitFrameVertical
		local v15 = {
			width = UDim.new(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v16 = {
			Title = Roact.createElement(
				"Frame",
				{
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 48),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				},
				{
					TitleText = Roact.createElement("TextLabel", {
						Size = UDim2.new(1, 0, 0, 28),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Text = title,
						FontFace = normalizeFontFace(props3.Tokens.Typography.HeadingSmall.Font),
						TextSize = font.BaseSize * font.Header1.RelativeSize,
						TextColor3 = theme.TextEmphasis.Color,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextWrapped = true
					}),
					Divider = Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 1),
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = theme.Divider.Color,
						BackgroundTransparency = theme.Divider.Transparency,
						BorderSizePixel = 0
					})
				}
			),
			Message = Roact.createElement("Frame", {
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v8 and 24 or 48),
					PaddingRight = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, v8 and 12 or 48),
					PaddingLeft = UDim.new(0, 24)
				}),
				MessageText = Roact.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Text = v10,
					FontFace = normalizeFontFace(props3.Tokens.Typography.BodyLarge.Font),
					TextSize = font.BaseSize * font.Body.RelativeSize,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextWrapped = true
				})
			}),
			SecondDivider = Roact.createElement("Frame", {
				LayoutOrder = 3,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 0),
					PaddingRight = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 0),
					PaddingLeft = UDim.new(0, 24)
				}),
				Divider = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = theme.Divider.Color,
					BackgroundTransparency = theme.Divider.Transparency,
					BorderSizePixel = 0
				})
			}),
			AgreementsList = Roact.createElement(userAgreementsList, {
				LayoutOrder = 4,
				agreements = agreements,
				margin = FitFrame.Rect.quad(0, 24, 24, 24)
			}),
			PromotionalEmailsContainer = 0
		}
		local v17

		if module10() and self.state.promoEmailsDisplayed then
			v17 = Roact.createElement("Frame", {
				LayoutOrder = 5,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 0),
					PaddingRight = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 48),
					PaddingLeft = UDim.new(0, 24)
				}),
				CheckBox = Roact.createElement(checkbox, {
					label = "",
					isChecked = self.state.promoEmailsChecked,
					onActivated = self.SetPromoEmailsCheckbox
				}),
				MessageButton = Roact.createElement("TextButton", {
					Size = UDim2.new(1, -34, 1, 0),
					Position = UDim2.new(0, 34, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Text = checkbox2,
					FontFace = normalizeFontFace(props3.Tokens.Typography.BodyLarge.Font),
					TextSize = font.BaseSize * font.Body.RelativeSize,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					[Roact.Event.Activated] = self.SetPromoEmailsCheckboxByTextButton
				})
			})
		end

		v16.PromotionalEmailsContainer = v17
		children.Content = createElement3(fitFrameVertical, v15, v16)

		local createElement4 = Roact.createElement
		local v19 = {
			["buttonType"] = nil,
			buttonType = buttonType.PrimarySystem,
			size = UDim2.new(1, -48, 0, 48),
			position = UDim2.new(0.5, 0, 1, -10),
			anchorPoint = Vector2.new(0.5, 1),
			layoutOrder = 2,
			text = agreeButton,
			fontStyle = font.SubHeader1,
			onActivated = self.agreeAndClosePopup
		}
		local ref2 = Roact.Ref
		local v20 = if defineFastFlag then self.props.defaultFocusRef else nil
		v19[ref2] = v20
		children.AgreeButton = createElement4(button, v19)
		return createElement("Frame", v12, {
			Layout = createElement2(layoutInfo, v9, children)
		})
	end
end

function extended:render()
	return module5({
		title = "CommonUI.UserAgreements.Popup.Title",
		message = "CommonUI.UserAgreements.Popup.Message",
		agreeButton = "CommonUI.UserAgreements.Popup.Agree",
		checkbox = module10() and "CommonUI.UserAgreements.Popup.PromotionalEmailsCheckbox" or nil
	})(function(p2)
		return withStyle(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

local v8 = RoactRodux.connect(function(p2)
	return { screenSize = p2.ScreenSize, formFactor = p2.FormFactor }
end, function(callback)
	return {
		closePopup = function()
			callback(module4())
		end
	}
end)(extended)

if module10() then
	v8 = roactAppPolicy.connect(function(p2, p3)
		return {
			checkboxEnabled = p2.getPromotionalEmailsCheckboxEnabled(),
			optInByDefault = p2.getPromotionalEmailsOptInByDefault()
		}
	end)(v8)
end

local v9 = roactServices.connect({ networking = module })(v8)

if defineFastFlag then
	return function(p2)
		local v10, v11 = ReactFocusNavigation.useDefaultFocusBehavior()
		return Roact.createElement(
			v9,
			Cryo.Dictionary.join(p2, { defaultFocusRef = v10, containerRef = v11 })
		)
	end
end

return v9
