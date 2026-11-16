local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/eda")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module3 = require("@luauforge/deferred/hLp")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local module4 = require("@luauforge/deferred/hLq")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local withStyle = UIBlox.Core.Style.withStyle
local module5 = require("@luauforge/bundled/edC")
local module6 = require("@luauforge/deferred/hLr")
local module7 = require("@luauforge/deferred/hLs")

local FitFrame = require(CorePackages.Packages.FitFrame)
local module8 = require("@luauforge/bundled/edi")

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType

local userAgreementsList = require("@luauforge/bundled/fOd").UserAgreementsList

local module9 = require("@luauforge/deferred/hLt")

local defineFastFlag = game:DefineFastFlag("UserAgreementsDefaultSelection", false)

local defineFastFlag2 = game:DefineFastFlag("UserAgreementsUpdatedPopupFoundation", false)

local defineFastFlag3 = game:DefineFastFlag("UserAgreementsDynamicBodyText", false)

local module10 = require("@luauforge/deferred/hLu")

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

		local createElement4 = Roact.createElement
		local v17 = {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 48),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local createElement5 = Roact.createElement
		local v19 = {
			Size = UDim2.new(1, 0, 0, 28),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Text = title,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextWrapped = true
		}

		local v20 = if not foundationFontFaceMigration then font.Header1.Font else nil
		v19.Font = v20

		local v21 = if foundationFontFaceMigration then normalizeFontFace(props3.Tokens.Typography.HeadingSmall.Font) else nil
		v19.FontFace = v21

		v19.TextSize = font.BaseSize * font.Header1.RelativeSize
		v19.TextColor3 = theme.TextEmphasis.Color
		v19.TextXAlignment = Enum.TextXAlignment.Center
		local children2 = {
			Title = createElement4("Frame", v17, {
				TitleText = createElement5("TextLabel", v19),
				Divider = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = theme.Divider.Color,
					BackgroundTransparency = theme.Divider.Transparency,
					BorderSizePixel = 0
				})
			}),
			Message = 0,
			SecondDivider = 0,
			AgreementsList = 0,
			PromotionalEmailsContainer = 0
		}

		local createElement6 = Roact.createElement
		local v23 = {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		}

		local v24 = {
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v8 and 24 or 48),
				PaddingRight = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, v8 and 12 or 48),
				PaddingLeft = UDim.new(0, 24)
			}),
			MessageText = 0
		}

		local createElement7 = Roact.createElement
		local v26 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = v10,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextWrapped = true
		}

		local v27 = if not foundationFontFaceMigration then font.Body.Font else nil
		v26.Font = v27

		local v28 = if foundationFontFaceMigration then normalizeFontFace(props3.Tokens.Typography.BodyLarge.Font) else nil
		v26.FontFace = v28

		v26.TextSize = font.BaseSize * font.Body.RelativeSize
		v26.TextColor3 = theme.TextEmphasis.Color
		v26.TextTransparency = theme.TextEmphasis.Transparency
		v26.TextXAlignment = Enum.TextXAlignment.Center
		v24.MessageText = createElement7("TextLabel", v26)
		children2.Message = createElement6("Frame", v23, v24)

		children2.SecondDivider = Roact.createElement("Frame", {
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
		})

		children2.AgreementsList = Roact.createElement(userAgreementsList, {
			LayoutOrder = 4,
			agreements = agreements,
			margin = FitFrame.Rect.quad(0, 24, 24, 24)
		})
		local v29

		if module10() and self.state.promoEmailsDisplayed then
			local createElement8 = Roact.createElement
			local v31 = {
				LayoutOrder = 5,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}

			local v32 = {
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
				MessageButton = 0
			}

			local createElement9 = Roact.createElement
			local setPromoEmailsCheckboxByTextButtonsByActivated = {}
			setPromoEmailsCheckboxByTextButtonsByActivated.Size = UDim2.new(1, -34, 1, 0)
			setPromoEmailsCheckboxByTextButtonsByActivated.Position = UDim2.new(0, 34, 0, 0)
			setPromoEmailsCheckboxByTextButtonsByActivated.AutomaticSize = Enum.AutomaticSize.Y
			setPromoEmailsCheckboxByTextButtonsByActivated.BackgroundTransparency = 1
			setPromoEmailsCheckboxByTextButtonsByActivated.Text = checkbox2
			local v34 = if not foundationFontFaceMigration then font.Body.Font else nil
			setPromoEmailsCheckboxByTextButtonsByActivated.Font = v34

			local v35 = if foundationFontFaceMigration then normalizeFontFace(props3.Tokens.Typography.BodyLarge.Font) else nil
			setPromoEmailsCheckboxByTextButtonsByActivated.FontFace = v35

			setPromoEmailsCheckboxByTextButtonsByActivated.TextSize = font.BaseSize * font.Body.RelativeSize
			setPromoEmailsCheckboxByTextButtonsByActivated.TextColor3 = theme.TextEmphasis.Color
			setPromoEmailsCheckboxByTextButtonsByActivated.TextTransparency = theme.TextEmphasis.Transparency
			setPromoEmailsCheckboxByTextButtonsByActivated.TextXAlignment = Enum.TextXAlignment.Left
			setPromoEmailsCheckboxByTextButtonsByActivated.TextWrapped = true
			setPromoEmailsCheckboxByTextButtonsByActivated[Roact.Event.Activated] = self.SetPromoEmailsCheckboxByTextButton
			v32.MessageButton = createElement9("TextButton", setPromoEmailsCheckboxByTextButtonsByActivated)
			v29 = createElement8("Frame", v31, v32)
		end

		children2.PromotionalEmailsContainer = v29
		children.Content = createElement3(fitFrameVertical, v15, children2)

		local createElement8 = Roact.createElement
		local v31 = {
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
		local v32 = if defineFastFlag then self.props.defaultFocusRef else nil
		v31[ref2] = v32
		children.AgreeButton = createElement8(button, v31)
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
