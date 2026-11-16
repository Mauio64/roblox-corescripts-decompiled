local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/eda")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module3 = require("@luauforge/deferred/hLp")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local t = require(CorePackages.Packages.t)

local module4 = require("@luauforge/deferred/hLw")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local withStyle = UIBlox.Core.Style.withStyle
local module5 = require("@luauforge/bundled/edC")
local module6 = require("@luauforge/deferred/hLr")
local userAgreementErrorCodes = require("@luauforge/bundled/fOd").UserAgreementErrorCodes

local logoutFromAllSessionsAndReauthenticate = require("@game/CorePackages/Workspace/Packages/AuthCommon").Thunks.LogoutFromAllSessionsAndReauthenticate

local FitFrame = require(CorePackages.Packages.FitFrame)
local module7 = require("@luauforge/bundled/edi")
local module8 = require("@luauforge/deferred/hLx")

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType

local iconButton = UIBlox.App.Button.IconButton
local images = UIBlox.App.ImageSet.Images
local styledTextLabel = UIBlox.App.Text.StyledTextLabel

local module9 = require("@luauforge/bundled/fBP")
local module10 = require("@luauforge/bundled/fBW")

local userAgreementsList = require("@luauforge/bundled/fOd").UserAgreementsList

local fFlagVngLogoutGlobalAppSessionsOnConversion = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagVngLogoutGlobalAppSessionsOnConversion

local getFFlagVngTOSRevisedEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagVngTOSRevisedEnabled
local fFlagAddReasonToEveryLogout = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddReasonToEveryLogout

local rect = Rect.new(8, 8, 9, 9)

local v5 = getFFlagVngTOSRevisedEnabled() and 16 or 48
local v6 = getFFlagVngTOSRevisedEnabled() and 24 or 48

local extended = Roact.PureComponent:extend("VNGUserAgreementsPopup")

extended.validateProps = t.strictInterface({
	agreements = t.array(t.strictInterface({
		id = t.string,
		agreementType = t.string,
		clientType = t.string,
		displayUrl = t.string,
		regulationType = t.string,
		action = t.optional(t.string)
	})),
	isSignup = t.boolean,
	formFactor = t.string,
	screenSize = t.Vector2,
	networking = t.callback,
	guiService = t.union(t.Instance, t.table),
	closePopup = t.callback,
	logout = t.callback,
	defaultChildRef = t.optional(t.any),
	focusController = t.optional(t.any),
	containerWidth = t.optional(t.integer),
	closeCentralOverlayThunk = t.optional(t.callback),
	agreementAccepted = t.optional(t.callback),
	agreementDeclined = t.optional(t.callback)
})

function extended:init()
	local binding, v7 = Roact.createBinding(false)
	self.buttonPressed = binding
	self.updateButtonPressed = v7
	self.state = {
		agreementsChecked = false,
		acceptingAgreements = false,
		showBalanceTransferAlert = false,
		showError = false
	}

	function self.SetAgreementsCheckBox(p2)
		self:setState({ agreementsChecked = p2 })
	end
	function self.SetAgreementsCheckBoxByTextButton()
		self:setState({
			agreementsChecked = not self.state.agreementsChecked
		})
	end

	function self.xClose()
		if self.props.isSignup then
			self.props.closePopup()

			if self.props.agreementDeclined then
				self.props.agreementDeclined()
			end
		else
			self.props.logout(self.props.networking, self.props.guiService)
			self.props.closePopup()
		end
	end

	function self.tryAgree()
		if not self.state.agreementsChecked then
			return
		end

		self:setState({ showError = false, acceptingAgreements = true })

		local closePopup = self.props.closePopup

		local agreements = self.props.agreements

		if self.props.isSignup then
			closePopup()

			if self.props.agreementAccepted then
				self.props.agreementAccepted(agreements)
			end
		else
			local networking = self.props.networking

			if fFlagVngLogoutGlobalAppSessionsOnConversion then
				local v8, v9 = logoutFromAllSessionsAndReauthenticate(networking):await()

				if not v8 then
					self:setState({ acceptingAgreements = false, showError = true })

					return
				end
			end

			module6(networking, agreements, function(p2)
				if p2 == userAgreementErrorCodes.InvalidState then
					self:setState({ showBalanceTransferAlert = true })
				elseif p2 == userAgreementErrorCodes.NoError then
					closePopup()

					if self.props.agreementAccepted then
						self.props.agreementAccepted(agreements)
					end
				else
					self:setState({ showError = true })
				end

				self:setState({ acceptingAgreements = false })
			end)
		end
	end
end

function extended:getLayoutInfo(p3, p4)
	if p3 then
		return module7, {
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

function extended:renderBalanceTransferPrompt(p2)
	return Roact.createElement(module8, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = self.props.screenSize,
		doneActivated = function()
			self:setState({ showBalanceTransferAlert = false })
		end
	})
end

function extended:renderWithProviders(props2, props3)
	local font = props3.Font
	local theme = props3.Theme

	local screenSize = self.props.screenSize
	local v7 = self.props.formFactor == formFactor.WIDE
	local layoutInfo, v8 = self:getLayoutInfo(v7, theme)

	local title = props2.title

	local message = props2.message
	local agreeButton = props2.agreeButton
	local checkbox2 = props2.checkbox
	local errorMessage = props2.errorMessage

	LoggingProtocol.default:logRobloxTelemetryEvent(module3)
	local createElement = Roact.createElement
	local v10 = {
		Size = UDim2.new(1, 0, 0, screenSize.Y),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v11 = { Layout = 0 }
	local createElement2 = Roact.createElement
	local children = {
		ListLayout = v7 and Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v7 and 0 or 60),
			PaddingBottom = UDim.new(0, v7 and 24 or 48)
		}),
		Content = 0,
		AgreeZone = 0
	}

	local createElement3 = Roact.createElement
	local fitFrameVertical = FitFrame.FitFrameVertical
	local v12 = { width = UDim.new(1, 0), BackgroundTransparency = 1, LayoutOrder = 1 }

	local children2 = {
		Title = Roact.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 48),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			{
				Roact.createElement(iconButton, {
					anchorPoint = Vector2.new(0, 0.5),
					size = UDim2.new(0, 36, 0, 36),
					position = UDim2.new(0, 8, 0.5, 0),
					icon = images["icons/navigation/close"],
					onActivated = self.xClose
				}),
				TitleText = Roact.createElement(styledTextLabel, {
					size = UDim2.new(1, 0, 0, 36),
					text = title,
					fontStyle = font.Header1,
					colorStyle = theme.TextEmphasis,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Bottom,
					textTruncate = Enum.TextTruncate.AtEnd
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
				PaddingTop = UDim.new(0, v7 and 24 or v5),
				PaddingRight = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, v7 and 12 or v6),
				PaddingLeft = UDim.new(0, 24)
			}),
			MessageText = Roact.createElement(styledTextLabel, {
				size = UDim2.new(1, 0, 0, 0),
				text = message,
				fontStyle = font.Body,
				colorStyle = theme.TextDefault,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Top,
				textTruncate = Enum.TextTruncate.None,
				automaticSize = Enum.AutomaticSize.Y
			})
		}),
		AgreementsContainer = 0,
		SecondDivider = 0,
		AgreementsList = 0
	}

	local createElement4 = Roact.createElement
	local v14 = {
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local v15 = {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 20),
			PaddingLeft = UDim.new(0, 24)
		}),
		CheckBox = Roact.createElement(checkbox, {
			label = "",
			isChecked = self.state.agreementsChecked,
			onActivated = self.SetAgreementsCheckBox
		}),
		MessageButton = 0
	}

	local createElement5 = Roact.createElement
	local setAgreementsCheckBoxByTextButtonsByActivated = {}
	setAgreementsCheckBoxByTextButtonsByActivated.Size = UDim2.new(1, -34, 1, 0)
	setAgreementsCheckBoxByTextButtonsByActivated.Position = UDim2.new(0, 34, 0, 0)
	setAgreementsCheckBoxByTextButtonsByActivated.AutomaticSize = Enum.AutomaticSize.Y
	setAgreementsCheckBoxByTextButtonsByActivated.BackgroundTransparency = 1
	setAgreementsCheckBoxByTextButtonsByActivated.Text = checkbox2
	local v17 = if not foundationFontFaceMigration then font.Body.Font else nil
	setAgreementsCheckBoxByTextButtonsByActivated.Font = v17

	local v18 = if foundationFontFaceMigration then normalizeFontFace(props3.Tokens.Typography.BodyLarge.Font) else nil
	setAgreementsCheckBoxByTextButtonsByActivated.FontFace = v18

	setAgreementsCheckBoxByTextButtonsByActivated.TextSize = font.BaseSize * font.Body.RelativeSize
	setAgreementsCheckBoxByTextButtonsByActivated.TextColor3 = theme.TextEmphasis.Color
	setAgreementsCheckBoxByTextButtonsByActivated.TextTransparency = theme.TextEmphasis.Transparency
	setAgreementsCheckBoxByTextButtonsByActivated.TextXAlignment = Enum.TextXAlignment.Left
	setAgreementsCheckBoxByTextButtonsByActivated.TextWrapped = true
	setAgreementsCheckBoxByTextButtonsByActivated[Roact.Event.Activated] = self.SetAgreementsCheckBoxByTextButton
	v15.MessageButton = createElement5("TextButton", setAgreementsCheckBoxByTextButtonsByActivated)
	children2.AgreementsContainer = createElement4("Frame", v14, v15)

	children2.SecondDivider = Roact.createElement("Frame", {
		LayoutOrder = 4,
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
		LayoutOrder = 5,
		agreements = self.props.agreements,
		margin = FitFrame.Rect.quad(0, 24, 24, 24),
		verticalSpaceOffset = getFFlagVngTOSRevisedEnabled() and not v7 and 80 or nil,
		useScrollableFrame = getFFlagVngTOSRevisedEnabled() and not v7 and true or nil
	})
	children.Content = createElement3(fitFrameVertical, v12, children2)

	local createElement6 = Roact.createElement
	local v20 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 1, -10),
		AnchorPoint = Vector2.new(0.5, 1),
		ZIndex = 99
	}

	local v21 = {
		nil,
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 24)
		})
	}

	local createElement7 = Roact.createElement
	local fitFrameVertical2 = FitFrame.FitFrameVertical
	local v22 = { width = UDim.new(1, 0), BackgroundTransparency = 1 }
	local v24

	if self.state.showError then
		local createElement8 = Roact.createElement
		local v26 = {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = errorMessage,
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

		v26.TextSize = font.BaseSize * font.Body.RelativeSize * 0.8
		v26.TextColor3 = theme.Alert.Color
		v26.TextTransparency = theme.TextEmphasis.Transparency
		v26.TextXAlignment = Enum.TextXAlignment.Left
		v24 = createElement8("TextLabel", v26) or nil
	end

	-- [TOVEK] unclear table creation
	-- Inserting from loop instead
	do
		local _values = table.pack(createElement7(fitFrameVertical2, v22, {
			ErrorLabel = v24,
			AgreeButton = Roact.createElement(button, {
				buttonType = buttonType.PrimarySystem,
				size = UDim2.new(1, 0, 0, 48),
				anchorPoint = Vector2.new(0, 0),
				isDisabled = self.state.acceptingAgreements or not self.state.agreementsChecked,
				layoutOrder = 2,
				text = agreeButton,
				fontStyle = font.SubHeader1,
				onActivated = self.tryAgree
			})
		}))
		for _k = 1, _values.n do
			v21[_k] = _values[_k]
		end
	end
	children.AgreeZone = createElement6("Frame", v20, v21)
	v11.Layout = createElement2(layoutInfo, v8, children)
	return createElement("Frame", v10, v11)
end

function extended:render()
	return module5({
		title = "CommonUI.UserAgreements.Popup.Agreement.TermsOfService",
		message = self.props.isSignup and (getFFlagVngTOSRevisedEnabled() and "CommonUI.UserAgreements.Popup.VNSignupMessage" or "CommonUI.UserAgreements.Popup.SignupMessage") or "CommonUI.UserAgreements.Popup.ConvertToVNMessage",
		agreeButton = "CommonUI.UserAgreements.Popup.Agree2",
		checkbox = getFFlagVngTOSRevisedEnabled() and (self.props.isSignup and "CommonUI.UserAgreements.Popup.VNSignupCheckboxMessage" or "CommonUI.UserAgreements.Popup.ConvertToVNCheckboxMessage") or "CommonUI.UserAgreements.Popup.CheckboxMessage",
		errorMessage = "CommonUI.UserAgreements.Popup.FailAndRetryMessage"
	})(function(p2)
		return withStyle(function(p3)
			if self.state.showBalanceTransferAlert then
				return (self:renderBalanceTransferPrompt(p2))
			end

			return (self:renderWithProviders(p2, p3))
		end)
	end)
end

local v7 = RoactRodux.connect(function(p2)
	return { screenSize = p2.ScreenSize, formFactor = p2.FormFactor }
end, function(callback)
	return {
		closePopup = function()
			callback(module4())
		end,
		logout = function(p2, p3)
			if fFlagAddReasonToEveryLogout then
				callback(module9(p2, p3, module10.VngUserAgreement))
			else
				callback(module9(p2, p3))
			end
		end
	}
end)(extended)

return (roactServices.connect({ networking = module, guiService = appGuiService })(v7))
