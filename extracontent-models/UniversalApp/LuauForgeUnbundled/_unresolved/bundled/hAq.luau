local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)

local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")

local text = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Text
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle
local module2 = require("@luauforge/bundled/edC")
local module3 = require("@luauforge/bundled/fUh")
local isStringPhone = AuthCommon.Utils.isStringPhone
local module4 = require("@luauforge/bundled/ede")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local textBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper
local genericTextBox = AuthCommon.Components.GenericTextBox
local phoneNumberTextBox = AuthCommon.Components.PhoneNumberTextBox

local module5 = require("@luauforge/bundled/hAr")

local module6 = require("@luauforge/bundled/fMG")
local module7 = require("@luauforge/bundled/fsy")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local iconsnavigationpushRight = images["icons/navigation/pushRight"]
local iconsactionsaccept_small = images["icons/actions/accept_small"]
local udim = UDim2.new(0, 18, 0, 18)

local extended = Roact.Component:extend("ContactInfoField")

extended.defaultProps = { TextBoxHeight = 36 }

function extended:init()
	local platform = UserInputService:GetPlatform()
	self:setState({
		Type = (platform == Enum.Platform.IOS or platform == Enum.Platform.Android) and module5.PhoneNumber or module5.Email,
		LinkHover = false,
		EmailInput = "",
		EmailValid = false,
		CountryCode = { code = "US", name = "United States", prefix = "1" },
		PhoneInput = "",
		PhoneValid = false
	})

	function self.MouseEnterLink()
		self:setState({ LinkHover = true })
	end

	function self.MouseLeaveLink()
		self:setState({ LinkHover = false })
	end

	function self.LinkActivated()
		self:setState({
			Type = self.state.Type == module5.Email and module5.PhoneNumber or module5.Email,
			Focused = false
		})

		local v5 = nil

		if self.state.Type == module5.Email then
			v5 = module7.Field.UseEmail
		elseif self.state.Type == module5.PhoneNumber then
			v5 = module7.Field.UsePhone
		end

		self.props.authAnalytics.reportInteractWithAction(
			module7.Context.SinglePageSignUpScreen,
			v5,
			module7.ActionType.Click,
			"",
			""
		)
	end

	function self.UpdateEmailInput(p2, p3)
		self:setState({ EmailInput = p2, EmailValid = p3 })

		if self.props.SetEmail then
			self.props.SetEmail(p2, p3)
		end
	end

	function self.UpdatePhoneInput(p2, p3)
		self:setState({ PhoneInput = p2, PhoneValid = p3 })

		if self.props.SetPhoneNumber then
			self.props.SetPhoneNumber(self.state.CountryCode, p2, p3)
		end
	end

	function self.InputFocused(p2)
		self:setState({ Focused = true })

		local v5 = nil

		if self.state.Type == module5.Email then
			v5 = module7.Field.Email
		elseif self.state.Type == module5.PhoneNumber then
			v5 = module7.Field.Phone
		end

		self.props.authAnalytics.reportInteractWithAction(
			module7.Context.SinglePageSignUpScreen,
			v5,
			module7.ActionType.Focus,
			"",
			""
		)
	end

	self.EmailInputChanged = module4(function(p2)
		self.UpdateEmailInput(p2.Text, module3(p2.Text))
	end, 1.5)

	function self.EmailInputFocusLost(p2)
		self:setState({ Focused = false })

		self.UpdateEmailInput(p2.Text, module3(p2.Text))
	end

	self.PhoneInputChanged = module4(function(p2)
		self.UpdatePhoneInput(p2.Text, isStringPhone(p2.Text))
	end, 1.5)

	function self.PhoneInputFocusLost(p2)
		self:setState({ Focused = false })

		self.UpdatePhoneInput(p2.Text, isStringPhone(p2.Text))
	end

	function self.SetCountryCode(p2)
		self:setState({ CountryCode = p2 })

		if self.props.SetPhoneNumber then
			self.props.SetPhoneNumber(p2, self.state.PhoneInput, self.state.PhoneValid)
		end
	end
end

function extended:didMount()
	self.mounted = true

	if self.props.SetContactMethod then
		self.props.SetContactMethod(self.state.Type)
	end
end

function extended.didUpdate(object, p2, p3)
	local contactMethod = object.props.contactMethod

	if contactMethod and contactMethod ~= p2.contactMethod and contactMethod ~= object.state.Type then
		object:setState({ Type = contactMethod })
	end

	if object.state.Type ~= p3.Type and object.props.SetContactMethod then
		object.props.SetContactMethod(object.state.Type)
	end
end

function extended:willUnmount()
	self.mounted = false
end

function extended.getDerivedStateFromProps(p2, p3)
	if p2.Under13 and p3.Type ~= module5.Email then
		return { Type = module5.Email }
	end

	return nil
end

function extended.render(data)
	local v5 = data.state.Type == module5.Email
	local v6 = v5 and "Authentication.SignUp.Label.EmailAddress"
		or "Authentication.SignUp.Label.PhoneNumber"
	local v7 = v5
		and not data.state.EmailValid
		and not data.state.Focused
		and data.state.EmailInput ~= ""
		and true
		or not (v5 or data.state.PhoneValid) and not data.state.Focused and data.state.PhoneInput ~= ""

	return module2({
		Title = data.props.Under13 and "Authentication.SignUp.Label.ParentEmailAddress" or v6,
		Placeholder = v6,
		Error = v7 and (v5 and "Authentication.SignUp.Response.InvalidEmail" or "Authentication.SignUp.Response.InvalidPhoneNumber") or nil,
		LinkText = v5 and "Authentication.SignUp.Action.UsePhoneNumber" or "Authentication.SignUp.Action.UseEmail"
	})(function(data2)
		return withStyle(function(props)
			local font = props.Font.Body.Font
			local v8 = props.Font.BaseSize * props.Font.Body.RelativeSize
			local color = props.Theme.TextDefault.Color
			local transparency = props.Theme.TextDefault.Transparency
			local color2 = props.Theme.BackgroundUIContrast.Color
			local transparency2 = props.Theme.BackgroundUIContrast.Transparency
			local color3 = props.Theme.UIDefault.Color

			local v9 = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize
			local v11

			if foundationFontFaceMigration then
				v11 = getTextSize(
					" ",
					v9,
					props.Tokens.Typography.BodyLarge.Font,
					Vector2.new(10000, 10000)
				).X
			else
				v11 = text.GetTextWidth(" ", font, v9)
			end

			local v12 = math.max(1, v11)

			local v13 = data2.LinkText .. string.rep(" ", math.ceil(v9 / v12) + 1)
			local v14

			if foundationFontFaceMigration then
				v14 = getTextSize(
					v13,
					v9,
					props.Tokens.Typography.BodyLarge.Font,
					Vector2.new(10000, 10000)
				).X
			else
				v14 = text.GetTextWidth(v13, font, v9)
			end

			local v15 = not data.props.Under13

			if data.state.LinkHover then
				v13 = "<u>" .. v13 .. "</u>"
			end

			local createElement = Roact.createElement
			local v17 = {
				LayoutOrder = data.props.layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			}

			local children = {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0)
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 5)
				}),
				Title = 0,
				Spacer = 0,
				CValue = 0,
				Footer = 0
			}

			local createElement2 = Roact.createElement
			local v19 = {
				LayoutOrder = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = data2.Title,
				TextWrapped = true,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextXAlignment = 0
			}

			local v20 = if not foundationFontFaceMigration then props.Font.CaptionHeader.Font else nil
			v19.Font = v20

			local v21 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font) else nil
			v19.FontFace = v21

			v19.TextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize
			v19.TextColor3 = props.Theme.TextEmphasis.Color
			v19.TextTransparency = props.Theme.TextEmphasis.Transparency
			v19.TextXAlignment = Enum.TextXAlignment.Left
			children.Title = createElement2("TextLabel", v19)

			children.Spacer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 5),
				LayoutOrder = 1
			})

			local createElement3 = Roact.createElement
			local v23 = {
				ChildClass = v5 and genericTextBox or phoneNumberTextBox,
				ErrorState = v7,
				Icon = (v5 and data.state.EmailValid or not v5 and data.state.PhoneValid) and iconsactionsaccept_small,
				IconSize = udim,
				Size = UDim2.new(1, 0, 0, data.props.TextBoxHeight),
				LayoutOrder = 2,
				ChildProps = 0
			}

			local v25 = if not v5 then data.state.CountryCode or nil else nil
			local v26 = if not v5 then data.SetCountryCode or nil else nil
			v23.ChildProps = {
				CountryCode = v25,
				SetCountryCode = v26,
				Text = v5 and data.state.EmailInput or data.state.PhoneInput,
				PlaceholderText = data2.Placeholder,
				Font = font,
				TextSize = v8,
				TextXAlignment = Enum.TextXAlignment.Left,
				Color = color2,
				Transparency = transparency2,
				TextColor = color,
				PlaceholderColor = color3,
				TextTransparency = transparency,
				ClearTextOnFocus = false,
				PaddingX = 12,
				onChangeText = v5 and data.EmailInputChanged or data.PhoneInputChanged,
				onFocused = data.InputFocused,
				onFocusLost = v5 and data.EmailInputFocusLost or data.PhoneInputFocusLost,
				phoneCountryCodeSelectorCallback = data.props.phoneCountryCodeSelectorCallback
			}
			children.CValue = createElement3(textBoxStateWrapper, v23)

			local createElement4 = Roact.createElement
			local v28 = {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v9 + 10),
				BackgroundTransparency = 1
			}

			local v30 = v7

			if v30 then
				local createElement5 = Roact.createElement
				local v32 = {
					Size = UDim2.new(1, -12 - v14, 1, 0),
					Position = UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Text = data2.Error,
					TextWrapped = true,
					Font = if not foundationFontFaceMigration then font else nil,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextXAlignment = 0
				}

				local v34 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
				v32.FontFace = v34

				v32.TextSize = v9
				v32.TextColor3 = props.Theme.Alert.Color
				v32.TextTransparency = data.issueSummaryTextTransparency
				v32.TextXAlignment = Enum.TextXAlignment.Left
				v30 = createElement5("TextLabel", v32)
			end

			local v29 = {
				ErrorText = v30,
				Arrow = v15 and Roact.createElement(imageSetLabel, {
					Size = UDim2.new(0, v9, 0, v9),
					Position = UDim2.new(1, 0, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundTransparency = 1,
					Image = iconsnavigationpushRight,
					ImageColor3 = props.Theme.IconEmphasis.Color,
					ImageTransparency = props.Theme.IconEmphasis.Transparency
				}),
				Link = 0
			}

			if v15 then
				local createElement5 = Roact.createElement
				local v32 = {}
				v32.Text = v13
				v32.Size = UDim2.new(0, v14, 1, 0)
				v32.TextSize = v9
				v32.Position = UDim2.new(1, 0, 0, 0)
				v32.AnchorPoint = Vector2.new(1, 0)
				v32.RichText = true
				v32.BackgroundTransparency = 1
				v32.TextColor3 = color

				if foundationFontFaceMigration then
					font = nil
				end

				v32.Font = font

				local v33 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
				v32.FontFace = v33

				local tag = React.Tag
				local v34 = if fFlagLuaAppAddTestIdsForArrow then getTestId("auth-signup-contact-info-toggle") else nil
				v32[tag] = v34

				v32[Roact.Event.MouseEnter] = data.MouseEnterLink
				v32[Roact.Event.MouseLeave] = data.MouseLeaveLink
				v32[Roact.Event.Activated] = data.LinkActivated
				v15 = createElement5("TextButton", v32)
			end

			v29.Link = v15
			children.Footer = createElement4("Frame", v28, v29)
			return createElement("Frame", v17, children)
		end)
	end)
end

return (roactServices.connect({ authAnalytics = module6 })(extended))
