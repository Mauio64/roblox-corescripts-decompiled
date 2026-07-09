local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local isStringEmail = require(Modules.LuaApp.Util.isStringEmail)
local isStringPhone = AuthCommon.Utils.isStringPhone
local debounce = require(Modules.LuaApp.Util.debounce)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local TextBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper
local GenericTextBox = AuthCommon.Components.GenericTextBox
local PhoneNumberTextBox = AuthCommon.Components.PhoneNumberTextBox
local CredentialType = require(Modules.LuaApp.Enum.CredentialType)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local v22 = Images["icons/navigation/pushRight"]
local v23 = Images["icons/actions/accept_small"]
local uDim2 = UDim2.new(0, 18, 0, 18)
local v25 = Roact.Component:extend("ContactInfoField")

v25.defaultProps = {
	TextBoxHeight = 36
}

function v25.init(p1) -- line: 43
	-- upvalues: UserInputService (copy), CredentialType (copy), EventStreamConstants (copy), debounce (copy), isStringEmail (copy), isStringPhone (copy)
	local Platform = UserInputService:GetPlatform()
	local v28 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android

	p1:setState({
		LinkHover = false,
		EmailInput = "",
		EmailValid = false,
		PhoneInput = "",
		PhoneValid = false,
		Type = v28 and CredentialType.PhoneNumber or CredentialType.Email,
		CountryCode = {
			code = "US",
			name = "United States",
			prefix = "1"
		}
	})

	function p1.MouseEnterLink() -- line: 60
		-- upvalues: p1 (copy)
		p1:setState({
			LinkHover = true
		})
	end
	function p1.MouseLeaveLink() -- line: 66
		-- upvalues: p1 (copy)
		p1:setState({
			LinkHover = false
		})
	end
	function p1.LinkActivated() -- line: 72
		-- upvalues: p1 (copy), CredentialType (copy), EventStreamConstants (copy)
		p1:setState({
			Focused = false,
			Type = p1.state.Type == CredentialType.Email and CredentialType.PhoneNumber or CredentialType.Email
		})

		local UseEmail = nil

		if p1.state.Type == CredentialType.Email then
			UseEmail = EventStreamConstants.Field.UseEmail
		elseif p1.state.Type == CredentialType.PhoneNumber then
			UseEmail = EventStreamConstants.Field.UsePhone
		end

		p1.props.authAnalytics.reportInteractWithAction(EventStreamConstants.Context.SinglePageSignUpScreen, UseEmail, EventStreamConstants.ActionType.Click, "", "")
	end
	function p1.UpdateEmailInput(p2, p3) -- line: 93
		-- upvalues: p1 (copy)
		p1:setState({
			EmailInput = p2,
			EmailValid = p3
		})

		if p1.props.SetEmail then
			p1.props.SetEmail(p2, p3)
		end
	end
	function p1.UpdatePhoneInput(p4, p5) -- line: 103
		-- upvalues: p1 (copy)
		p1:setState({
			PhoneInput = p4,
			PhoneValid = p5
		})

		if p1.props.SetPhoneNumber then
			p1.props.SetPhoneNumber(p1.state.CountryCode, p4, p5)
		end
	end
	function p1.InputFocused(_) -- line: 113
		-- upvalues: p1 (copy), CredentialType (copy), EventStreamConstants (copy)
		p1:setState({
			Focused = true
		})

		local Email = nil

		if p1.state.Type == CredentialType.Email then
			Email = EventStreamConstants.Field.Email
		elseif p1.state.Type == CredentialType.PhoneNumber then
			Email = EventStreamConstants.Field.Phone
		end

		p1.props.authAnalytics.reportInteractWithAction(EventStreamConstants.Context.SinglePageSignUpScreen, Email, EventStreamConstants.ActionType.Focus, "", "")
	end

	p1.EmailInputChanged = debounce(function(p7) -- line: 133
		-- upvalues: p1 (copy), isStringEmail (copy)
		p1.UpdateEmailInput(p7.Text, isStringEmail(p7.Text))
	end, 1.5)

	function p1.EmailInputFocusLost(p8) -- line: 137
		-- upvalues: p1 (copy), isStringEmail (copy)
		p1:setState({
			Focused = false
		})
		p1.UpdateEmailInput(p8.Text, isStringEmail(p8.Text))
	end

	p1.PhoneInputChanged = debounce(function(p9) -- line: 144
		-- upvalues: p1 (copy), isStringPhone (copy)
		p1.UpdatePhoneInput(p9.Text, isStringPhone(p9.Text))
	end, 1.5)

	function p1.PhoneInputFocusLost(p10) -- line: 148
		-- upvalues: p1 (copy), isStringPhone (copy)
		p1:setState({
			Focused = false
		})
		p1.UpdatePhoneInput(p10.Text, isStringPhone(p10.Text))
	end
	function p1.SetCountryCode(p11) -- line: 155
		-- upvalues: p1 (copy)
		p1:setState({
			CountryCode = p11
		})

		if p1.props.SetPhoneNumber then
			p1.props.SetPhoneNumber(p11, p1.state.PhoneInput, p1.state.PhoneValid)
		end
	end
end
function v25.didMount(p12) -- line: 165
	p12.mounted = true

	if p12.props.SetContactMethod then
		p12.props.SetContactMethod(p12.state.Type)
	end
end
function v25.didUpdate(p13, p14, p15) -- line: 172
	local contactMethod = p13.props.contactMethod

	if contactMethod and (contactMethod ~= p14.contactMethod and contactMethod ~= p13.state.Type) then
		p13:setState({
			Type = contactMethod
		})
	end

	if p13.state.Type ~= p15.Type and p13.props.SetContactMethod then
		p13.props.SetContactMethod(p13.state.Type)
	end
end
function v25.willUnmount(p16) -- line: 187
	p16.mounted = false
end
function v25.getDerivedStateFromProps(p17, p18) -- line: 191
	-- upvalues: CredentialType (copy)
	if p17.Under13 and p18.Type ~= CredentialType.Email then
		return {
			Type = CredentialType.Email
		}
	end

	return nil
end
function v25.render(p19) -- line: 201
	-- upvalues: CredentialType (copy), withLocalization (copy), withStyle (copy), Text (copy), Roact (copy), TextBoxStateWrapper (copy), GenericTextBox (copy), PhoneNumberTextBox (copy), v23 (copy), uDim2 (copy), ImageSetLabel (copy), v22 (copy)
	local v38 = p19.state.Type == CredentialType.Email
	local v39 = not v38 and "Authentication.SignUp.Label.PhoneNumber" or "Authentication.SignUp.Label.EmailAddress"
	local v40 = not v38 and "Authentication.SignUp.Response.InvalidPhoneNumber" or "Authentication.SignUp.Response.InvalidEmail"
	local v41 = not v38 and "Authentication.SignUp.Action.UseEmail" or "Authentication.SignUp.Action.UsePhoneNumber"
	local v42 = v38 and (not p19.state.EmailValid and (not p19.state.Focused and p19.state.EmailInput ~= "")) or not v38 and (not p19.state.PhoneValid and (not p19.state.Focused and p19.state.PhoneInput ~= ""))

	return withLocalization({
		Title = if not p19.props.Under13 then v39 else "Authentication.SignUp.Label.ParentEmailAddress",
		Placeholder = v39,
		Error = v42 and v40 or nil,
		LinkText = v41
	})(function(p20) -- line: 222
		-- upvalues: withStyle (copy), Text (copy), p19 (copy), Roact (copy), TextBoxStateWrapper (copy), v38 (copy), GenericTextBox (copy), PhoneNumberTextBox (copy), v42 (copy), v23 (copy), uDim2 (copy), ImageSetLabel (copy), v22 (copy)
		return withStyle(function(p21) -- line: 223
			-- upvalues: Text (copy), p20 (copy), p19 (copy), Roact (copy), TextBoxStateWrapper (copy), v38 (copy), GenericTextBox (copy), PhoneNumberTextBox (copy), v42 (copy), v23 (copy), uDim2 (copy), ImageSetLabel (copy), v22 (copy)
			local BodyFont = p21.Font.Body.Font
			local v58 = p21.Font.BaseSize * p21.Font.Body.RelativeSize
			local TextDefaultColor = p21.Theme.TextDefault.Color
			local TextDefaultTransparency = p21.Theme.TextDefault.Transparency
			local BackgroundUIContrastColor = p21.Theme.BackgroundUIContrast.Color
			local BackgroundUIContrastTransparency = p21.Theme.BackgroundUIContrast.Transparency
			local UIDefaultColor = p21.Theme.UIDefault.Color
			local v64 = p21.Font.BaseSize * p21.Font.CaptionBody.RelativeSize
			local v65 = math.max(1, Text.GetTextWidth(" ", BodyFont, v64))
			local v66 = p20.LinkText .. string.rep(" ", math.ceil(v64 / v65) + 1)
			local v67 = Text.GetTextWidth(v66, BodyFont, v64)
			local v68 = not p19.props.Under13

			if p19.state.LinkHover then
				v66 = "<u>" .. v66 .. "</u>"
			end

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = p19.props.layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
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
					BackgroundTransparency = 1,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Text = p20.Title,
					Font = p21.Font.CaptionHeader.Font,
					TextSize = p21.Font.BaseSize * p21.Font.CaptionHeader.RelativeSize,
					TextColor3 = p21.Theme.TextEmphasis.Color,
					TextTransparency = p21.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Spacer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(0, 0, 0, 5)
				}),
				CValue = Roact.createElement(TextBoxStateWrapper, {
					LayoutOrder = 2,
					ChildClass = v38 and GenericTextBox or PhoneNumberTextBox,
					ErrorState = v42,
					Icon = (v38 and p19.state.EmailValid or not v38 and p19.state.PhoneValid) and v23,
					IconSize = uDim2,
					Size = UDim2.new(1, 0, 0, p19.props.TextBoxHeight),
					ChildProps = {
						ClearTextOnFocus = false,
						PaddingX = 12,
						CountryCode = not v38 and p19.state.CountryCode or nil,
						SetCountryCode = not v38 and p19.SetCountryCode or nil,
						Text = v38 and p19.state.EmailInput or p19.state.PhoneInput,
						PlaceholderText = p20.Placeholder,
						Font = BodyFont,
						TextSize = v58,
						TextXAlignment = Enum.TextXAlignment.Left,
						Color = BackgroundUIContrastColor,
						Transparency = BackgroundUIContrastTransparency,
						TextColor = TextDefaultColor,
						PlaceholderColor = UIDefaultColor,
						TextTransparency = TextDefaultTransparency,
						onChangeText = v38 and p19.EmailInputChanged or p19.PhoneInputChanged,
						onFocused = p19.InputFocused,
						onFocusLost = v38 and p19.EmailInputFocusLost or p19.PhoneInputFocusLost,
						phoneCountryCodeSelectorCallback = p19.props.phoneCountryCodeSelectorCallback
					}
				}),
				Footer = Roact.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v64 + 10)
				}, {
					ErrorText = v42 and Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, -12 - v67, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Text = p20.Error,
						Font = BodyFont,
						TextSize = v64,
						TextColor3 = p21.Theme.Alert.Color,
						TextTransparency = p19.issueSummaryTextTransparency,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Arrow = v68 and Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, v64, 0, v64),
						Position = UDim2.new(1, 0, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						Image = v22,
						ImageColor3 = p21.Theme.IconEmphasis.Color,
						ImageTransparency = p21.Theme.IconEmphasis.Transparency
					}),
					Link = v68 and Roact.createElement("TextButton", {
						Text = v66,
						Size = UDim2.new(0, v67, 1, 0),
						TextSize = v64,
						Position = UDim2.new(1, 0, 0, 0),
						AnchorPoint = Vector2.new(1, 0),
						RichText = true,
						BackgroundTransparency = 1,
						TextColor3 = TextDefaultColor,
						Font = BodyFont,
						[Roact.Event.MouseEnter] = p19.MouseEnterLink,
						[Roact.Event.MouseLeave] = p19.MouseLeaveLink,
						[Roact.Event.Activated] = p19.LinkActivated
					})
				})
			})
		end)
	end)
end

return (RoactServices.connect({
	authAnalytics = RoactAnalyticsAuthEvents
})(v25))
