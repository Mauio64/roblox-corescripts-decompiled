local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module3 = require("@luauforge/deferred/hVX")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local t = require(CorePackages.Packages.t)

local module4 = require("@luauforge/deferred/hWe")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local withStyle = UIBlox.Core.Style.withStyle
local module5 = require("@luauforge/bundled/egZ")
local module6 = require("@luauforge/deferred/hVZ")
local userAgreementErrorCodes = require("@luauforge/bundled/gsy").UserAgreementErrorCodes

local logoutFromAllSessionsAndReauthenticate = require("@game/CorePackages/Workspace/Packages/AuthCommon").Thunks.LogoutFromAllSessionsAndReauthenticate

local FitFrame = require(CorePackages.Packages.FitFrame)
local module7 = require("@luauforge/bundled/egF")
local module8 = require("@luauforge/deferred/hWf")

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType

local iconButton = UIBlox.App.Button.IconButton
local images = UIBlox.App.ImageSet.Images
local styledTextLabel = UIBlox.App.Text.StyledTextLabel

local module9 = require("@luauforge/bundled/ggi")
local module10 = require("@luauforge/bundled/ggp")

local userAgreementsList = require("@luauforge/bundled/gsy").UserAgreementsList

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
		Content = Roact.createElement(
			FitFrame.FitFrameVertical,
			{ width = UDim.new(1, 0), BackgroundTransparency = 1, LayoutOrder = 1 },
			{
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
				AgreementsContainer = Roact.createElement("Frame", {
					LayoutOrder = 3,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1
				}, {
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
						[Roact.Event.Activated] = self.SetAgreementsCheckBoxByTextButton
					})
				}),
				SecondDivider = Roact.createElement("Frame", {
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
				}),
				AgreementsList = Roact.createElement(userAgreementsList, {
					LayoutOrder = 5,
					agreements = self.props.agreements,
					margin = FitFrame.Rect.quad(0, 24, 24, 24),
					verticalSpaceOffset = getFFlagVngTOSRevisedEnabled() and not v7 and 80 or nil,
					useScrollableFrame = getFFlagVngTOSRevisedEnabled() and not v7 and true or nil
				})
			}
		),
		AgreeZone = 0
	}

	local createElement6 = Roact.createElement
	local v16 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 1, -10),
		AnchorPoint = Vector2.new(0.5, 1),
		ZIndex = 99
	}

	local v17 = {
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
	local v18 = { width = UDim.new(1, 0), BackgroundTransparency = 1 }

	local v20 = if self.state.showError then Roact.createElement("TextLabel", {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text = errorMessage,
		FontFace = normalizeFontFace(props3.Tokens.Typography.BodyLarge.Font),
		TextSize = font.BaseSize * font.Body.RelativeSize * 0.8,
		TextColor3 = theme.Alert.Color,
		TextTransparency = theme.TextEmphasis.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true
	}) or nil else nil
	-- [TOVEK] unclear table creation
	-- Inserting from loop instead
	do
		local _values = table.pack(createElement7(fitFrameVertical2, v18, {
			ErrorLabel = v20,
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
			v17[_k] = _values[_k]
		end
	end
	children.AgreeZone = createElement6("Frame", v16, v17)
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
