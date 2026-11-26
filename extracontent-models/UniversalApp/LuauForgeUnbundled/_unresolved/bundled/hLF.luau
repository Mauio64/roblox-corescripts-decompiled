local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)

local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle
local module2 = require("@luauforge/bundled/egZ")
local module3 = require("@luauforge/bundled/gzf")
local isStringPhone = AuthCommon.Utils.isStringPhone
local module4 = require("@luauforge/bundled/egB")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local textBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper
local genericTextBox = AuthCommon.Components.GenericTextBox
local phoneNumberTextBox = AuthCommon.Components.PhoneNumberTextBox

local module5 = require("@luauforge/bundled/hLG")

local module6 = require("@luauforge/bundled/grb")
local module7 = require("@luauforge/bundled/fzS")
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
			local v10 = math.max(
				1,
				getTextSize(" ", v9, props.Tokens.Typography.BodyLarge.Font, Vector2.new(10000, 10000)).X
			)

			local v11 = data2.LinkText .. string.rep(" ", math.ceil(v9 / v10) + 1)
			local x = getTextSize(
				v11,
				v9,
				props.Tokens.Typography.BodyLarge.Font,
				Vector2.new(10000, 10000)
			).X
			local v12 = not data.props.Under13

			if data.state.LinkHover then
				v11 = "<u>" .. v11 .. "</u>"
			end

			local createElement = Roact.createElement
			local v14 = {
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
				Title = Roact.createElement("TextLabel", {
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Text = data2.Title,
					TextWrapped = true,
					FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
					TextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize,
					TextColor3 = props.Theme.TextEmphasis.Color,
					TextTransparency = props.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Spacer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 5),
					LayoutOrder = 1
				}),
				CValue = 0,
				Footer = 0
			}

			local createElement2 = Roact.createElement
			local v16 = {
				ChildClass = v5 and genericTextBox or phoneNumberTextBox,
				ErrorState = v7,
				Icon = (v5 and data.state.EmailValid or not v5 and data.state.PhoneValid) and iconsactionsaccept_small,
				IconSize = udim,
				Size = UDim2.new(1, 0, 0, data.props.TextBoxHeight),
				LayoutOrder = 2,
				ChildProps = 0
			}

			local v18 = if not v5 then data.state.CountryCode or nil else nil
			local v19 = if not v5 then data.SetCountryCode or nil else nil
			v16.ChildProps = {
				CountryCode = v18,
				SetCountryCode = v19,
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
			children.CValue = createElement2(textBoxStateWrapper, v16)

			local createElement3 = Roact.createElement
			local v21 = {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v9 + 10),
				BackgroundTransparency = 1
			}

			local v22 = {
				ErrorText = v7 and Roact.createElement("TextLabel", {
					Size = UDim2.new(1, -12 - x, 1, 0),
					Position = UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Text = data2.Error,
					TextWrapped = true,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					TextSize = v9,
					TextColor3 = props.Theme.Alert.Color,
					TextTransparency = data.issueSummaryTextTransparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Arrow = v12 and Roact.createElement(imageSetLabel, {
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

			if v12 then
				local createElement4 = Roact.createElement
				local v24 = {
					["Text"] = v11,
					Size = UDim2.new(0, x, 1, 0),
					TextSize = v9,
					Position = UDim2.new(1, 0, 0, 0),
					AnchorPoint = Vector2.new(1, 0),
					RichText = true,
					BackgroundTransparency = 1,
					TextColor3 = color,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
				}
				local tag = React.Tag
				local v25 = if fFlagLuaAppAddTestIdsForArrow then getTestId("auth-signup-contact-info-toggle") else nil
				v24[tag] = v25

				v24[Roact.Event.MouseEnter] = data.MouseEnterLink
				v24[Roact.Event.MouseLeave] = data.MouseLeaveLink
				v24[Roact.Event.Activated] = data.LinkActivated
				v12 = createElement4("TextButton", v24)
			end

			v22.Link = v12
			children.Footer = createElement3("Frame", v21, v22)
			return createElement("Frame", v14, children)
		end)
	end)
end

return (roactServices.connect({ authAnalytics = module6 })(extended))
