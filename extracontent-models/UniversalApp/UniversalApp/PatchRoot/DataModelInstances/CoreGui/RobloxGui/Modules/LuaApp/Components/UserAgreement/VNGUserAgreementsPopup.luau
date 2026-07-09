local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local ToCPopupOccurance = require(Modules.LuaApp.Analytics.RobloxTelemetryConfigs.ToCPopupOccurance)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Checkbox = require(CorePackages.Packages.Foundation).Checkbox
local t = require(CorePackages.Packages.t)
local CloseVNGUserAgreementsPopup = require(Modules.LuaApp.Thunks.CloseVNGUserAgreementsPopup)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local withStyle = UIBlox.Core.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local AgreeUpdatedUserAgreements = require(Modules.LuaApp.Http.Requests.AgreeUpdatedUserAgreements)
local UserAgreementErrorCodes = require(CorePackages.Workspace.Packages.UserAgreements).UserAgreementErrorCodes
local LogoutFromAllSessionsAndReauthenticate = require(CorePackages.Workspace.Packages.AuthCommon).Thunks.LogoutFromAllSessionsAndReauthenticate
local FitFrame = require(CorePackages.Packages.FitFrame)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local VNGBalanceTransferPrompt = require(Modules.LuaApp.Components.UserAgreement.VNGBalanceTransferPrompt)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local UserAgreementsList = require(CorePackages.Workspace.Packages.UserAgreements).UserAgreementsList
local FFlagVngLogoutGlobalAppSessionsOnConversion = require(CorePackages.Workspace.Packages.SharedFlags).FFlagVngLogoutGlobalAppSessionsOnConversion
local GetFFlagVngTOSRevisedEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagVngTOSRevisedEnabled
local FFlagAddReasonToEveryLogout = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddReasonToEveryLogout
local rect = Rect.new(8, 8, 9, 9)
local v35 = not GetFFlagVngTOSRevisedEnabled() and 48 or 16
local v36 = not GetFFlagVngTOSRevisedEnabled() and 48 or 24
local v37 = Roact.PureComponent:extend("VNGUserAgreementsPopup")

v37.validateProps = t.strictInterface({
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

function v37.init(p1) -- line: 116
	-- upvalues: Roact (copy), FFlagVngLogoutGlobalAppSessionsOnConversion (copy), LogoutFromAllSessionsAndReauthenticate (copy), AgreeUpdatedUserAgreements (copy), UserAgreementErrorCodes (copy)
	local v40, v41 = Roact.createBinding(false)

	p1.buttonPressed = v40
	p1.updateButtonPressed = v41
	p1.state = {
		agreementsChecked = false,
		acceptingAgreements = false,
		showBalanceTransferAlert = false,
		showError = false
	}

	function p1.SetAgreementsCheckBox(p2) -- line: 125
		-- upvalues: p1 (copy)
		p1:setState({
			agreementsChecked = p2
		})
	end
	function p1.SetAgreementsCheckBoxByTextButton() -- line: 130
		-- upvalues: p1 (copy)
		p1:setState({
			agreementsChecked = not p1.state.agreementsChecked
		})
	end
	function p1.xClose() -- line: 137
		-- upvalues: p1 (copy)
		if p1.props.isSignup then
			p1.props.closePopup()

			if p1.props.agreementDeclined then
				p1.props.agreementDeclined()

				return
			end
		else
			p1.props.logout(p1.props.networking, p1.props.guiService)
			p1.props.closePopup()
		end
	end
	function p1.tryAgree() -- line: 150
		-- upvalues: p1 (copy), FFlagVngLogoutGlobalAppSessionsOnConversion (copy), LogoutFromAllSessionsAndReauthenticate (copy), AgreeUpdatedUserAgreements (copy), UserAgreementErrorCodes (copy)
		if not p1.state.agreementsChecked then
			return
		end

		p1:setState({
			showError = false,
			acceptingAgreements = true
		})

		local closePopup = p1.props.closePopup
		local agreements = p1.props.agreements

		if p1.props.isSignup then
			closePopup()

			if p1.props.agreementAccepted then
				p1.props.agreementAccepted(agreements)

				return
			end
		else
			local networking = p1.props.networking

			if FFlagVngLogoutGlobalAppSessionsOnConversion then
				local v68, _ = LogoutFromAllSessionsAndReauthenticate(networking):await()

				if not v68 then
					p1:setState({
						acceptingAgreements = false,
						showError = true
					})

					return
				end
			end

			AgreeUpdatedUserAgreements(networking, agreements, function(p3) -- line: 187
				-- upvalues: UserAgreementErrorCodes (copy), p1 (copy), closePopup (copy), agreements (copy)
				if p3 == UserAgreementErrorCodes.InvalidState then
					p1:setState({
						showBalanceTransferAlert = true
					})
				elseif p3 == UserAgreementErrorCodes.NoError then
					closePopup()

					if p1.props.agreementAccepted then
						p1.props.agreementAccepted(agreements)
					end
				else
					p1:setState({
						showError = true
					})
				end

				p1:setState({
					acceptingAgreements = false
				})
			end)
		end
	end
end
function v37.getLayoutInfo(_, p5, p6) -- line: 213
	-- upvalues: DEPRECATED_ImageSetLabel (copy), rect (copy)
	if p5 then
		return DEPRECATED_ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = "LuaApp/buttons/buttonFill",
			BorderSizePixel = 0,
			Size = UDim2.new(0, 540, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = p6.BackgroundUIDefault.Color,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect,
			AutomaticSize = Enum.AutomaticSize.Y
		}
	end

	return "Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = p6.BackgroundUIDefault.Color
	}
end
function v37.renderBalanceTransferPrompt(p7, _) -- line: 240
	-- upvalues: Roact (copy), VNGBalanceTransferPrompt (copy)
	return Roact.createElement(VNGBalanceTransferPrompt, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = p7.props.screenSize,
		doneActivated = function() -- line: 245
			-- upvalues: p7 (copy)
			p7:setState({
				showBalanceTransferAlert = false
			})
		end
	})
end
function v37.renderWithProviders(p9, p10, p11) -- line: 253
	-- upvalues: FormFactor (copy), LoggingProtocol (copy), ToCPopupOccurance (copy), Roact (copy), FitFrame (copy), IconButton (copy), Images (copy), StyledTextLabel (copy), v35 (copy), v36 (copy), Checkbox (copy), UserAgreementsList (copy), GetFFlagVngTOSRevisedEnabled (copy), Button (copy), ButtonType (copy)
	local p11Font = p11.Font
	local Theme = p11.Theme
	local screenSize = p9.props.screenSize
	local v53 = p9.props.formFactor == FormFactor.WIDE
	local v54, v55 = p9:getLayoutInfo(v53, Theme)
	local title = p10.title
	local message = p10.message
	local agreeButton = p10.agreeButton
	local checkbox = p10.checkbox
	local errorMessage = p10.errorMessage

	LoggingProtocol.default:logRobloxTelemetryEvent(ToCPopupOccurance)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, screenSize.Y)
	}, {
		Layout = Roact.createElement(v54, v55, {
			ListLayout = v53 and Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, not v53 and 60 or 0),
				PaddingBottom = UDim.new(0, not v53 and 48 or 24)
			}),
			Content = Roact.createElement(FitFrame.FitFrameVertical, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				width = UDim.new(1, 0)
			}, {
				Title = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 48)
				}, {
					Roact.createElement(IconButton, {
						anchorPoint = Vector2.new(0, 0.5),
						size = UDim2.new(0, 36, 0, 36),
						position = UDim2.new(0, 8, 0.5, 0),
						icon = Images["icons/navigation/close"],
						onActivated = p9.xClose
					}),
					TitleText = Roact.createElement(StyledTextLabel, {
						size = UDim2.new(1, 0, 0, 36),
						text = title,
						fontStyle = p11Font.Header1,
						colorStyle = Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Center,
						textYAlignment = Enum.TextYAlignment.Bottom,
						textTruncate = Enum.TextTruncate.AtEnd
					}),
					Divider = Roact.createElement("Frame", {
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 1),
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = Theme.Divider.Color,
						BackgroundTransparency = Theme.Divider.Transparency
					})
				}),
				Message = Roact.createElement("Frame", {
					LayoutOrder = 2,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, if not v53 then v35 else 24),
						PaddingRight = UDim.new(0, 24),
						PaddingBottom = UDim.new(0, if not v53 then v36 else 12),
						PaddingLeft = UDim.new(0, 24)
					}),
					MessageText = Roact.createElement(StyledTextLabel, {
						size = UDim2.new(1, 0, 0, 0),
						text = message,
						fontStyle = p11Font.Body,
						colorStyle = Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Top,
						textTruncate = Enum.TextTruncate.None,
						automaticSize = Enum.AutomaticSize.Y
					})
				}),
				AgreementsContainer = Roact.createElement("Frame", {
					LayoutOrder = 3,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 0),
						PaddingRight = UDim.new(0, 24),
						PaddingBottom = UDim.new(0, 20),
						PaddingLeft = UDim.new(0, 24)
					}),
					CheckBox = Roact.createElement(Checkbox, {
						label = "",
						isChecked = p9.state.agreementsChecked,
						onActivated = p9.SetAgreementsCheckBox
					}),
					MessageButton = Roact.createElement("TextButton", {
						Size = UDim2.new(1, -34, 1, 0),
						Position = UDim2.new(0, 34, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Text = checkbox,
						Font = p11Font.Body.Font,
						TextSize = p11Font.BaseSize * p11Font.Body.RelativeSize,
						TextColor3 = Theme.TextEmphasis.Color,
						TextTransparency = Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						[Roact.Event.Activated] = p9.SetAgreementsCheckBoxByTextButton
					})
				}),
				SecondDivider = Roact.createElement("Frame", {
					LayoutOrder = 4,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 0),
						PaddingRight = UDim.new(0, 24),
						PaddingBottom = UDim.new(0, 0),
						PaddingLeft = UDim.new(0, 24)
					}),
					Divider = Roact.createElement("Frame", {
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 1),
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = Theme.Divider.Color,
						BackgroundTransparency = Theme.Divider.Transparency
					})
				}),
				AgreementsList = Roact.createElement(UserAgreementsList, {
					LayoutOrder = 5,
					agreements = p9.props.agreements,
					margin = FitFrame.Rect.quad(0, 24, 24, 24),
					verticalSpaceOffset = if not GetFFlagVngTOSRevisedEnabled() or v53 then nil else 80,
					useScrollableFrame = GetFFlagVngTOSRevisedEnabled() and not v53 or nil
				})
			}),
			AgreeZone = Roact.createElement("Frame", {
				LayoutOrder = 2,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ZIndex = 99,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 1, -10),
				AnchorPoint = Vector2.new(0.5, 1)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 0),
					PaddingRight = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 24)
				}),
				Roact.createElement(FitFrame.FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0)
				}, {
					ErrorLabel = p9.state.showError and Roact.createElement("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Text = errorMessage,
						Font = p11Font.Body.Font,
						TextSize = p11Font.BaseSize * p11Font.Body.RelativeSize * 0.8,
						TextColor3 = Theme.Alert.Color,
						TextTransparency = Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left
					}) or nil,
					AgreeButton = Roact.createElement(Button, {
						layoutOrder = 2,
						buttonType = ButtonType.PrimarySystem,
						size = UDim2.new(1, 0, 0, 48),
						anchorPoint = Vector2.new(0, 0),
						isDisabled = p9.state.acceptingAgreements or not p9.state.agreementsChecked,
						text = agreeButton,
						fontStyle = p11Font.SubHeader1,
						onActivated = p9.tryAgree
					})
				})
			})
		})
	})
end
function v37.render(p12) -- line: 469
	-- upvalues: withLocalization (copy), GetFFlagVngTOSRevisedEnabled (copy), withStyle (copy)
	return withLocalization({
		title = "CommonUI.UserAgreements.Popup.Agreement.TermsOfService",
		agreeButton = "CommonUI.UserAgreements.Popup.Agree2",
		errorMessage = "CommonUI.UserAgreements.Popup.FailAndRetryMessage",
		message = not p12.props.isSignup and "CommonUI.UserAgreements.Popup.ConvertToVNMessage" or (not GetFFlagVngTOSRevisedEnabled() and "CommonUI.UserAgreements.Popup.SignupMessage" or "CommonUI.UserAgreements.Popup.VNSignupMessage"),
		checkbox = not GetFFlagVngTOSRevisedEnabled() and "CommonUI.UserAgreements.Popup.CheckboxMessage" or (not p12.props.isSignup and "CommonUI.UserAgreements.Popup.ConvertToVNCheckboxMessage" or "CommonUI.UserAgreements.Popup.VNSignupCheckboxMessage")
	})(function(p13) -- line: 484
		-- upvalues: withStyle (copy), p12 (copy)
		return withStyle(function(p14) -- line: 485
			-- upvalues: p12 (copy), p13 (copy)
			if p12.state.showBalanceTransferAlert then
				return (p12:renderBalanceTransferPrompt(p13))
			end

			return (p12:renderWithProviders(p13, p14))
		end)
	end)
end

local v38 = RoactRodux.connect(function(p15) -- line: 493
	return {
		screenSize = p15.ScreenSize,
		formFactor = p15.FormFactor
	}
end, function(p16) -- line: 498
	-- upvalues: CloseVNGUserAgreementsPopup (copy), FFlagAddReasonToEveryLogout (copy), Logout (copy), luaLogoutReasonNames (copy)
	return {
		closePopup = function() -- line: 500
			-- upvalues: p16 (copy), CloseVNGUserAgreementsPopup (copy)
			p16(CloseVNGUserAgreementsPopup())
		end,
		logout = function(p17, p18) -- line: 503
			-- upvalues: FFlagAddReasonToEveryLogout (copy), p16 (copy), Logout (copy), luaLogoutReasonNames (copy)
			if FFlagAddReasonToEveryLogout then
				p16(Logout(p17, p18, luaLogoutReasonNames.VngUserAgreement))

				return
			end

			p16(Logout(p17, p18))
		end
	}
end)(v37)

return (RoactServices.connect({
	networking = RoactNetworking,
	guiService = AppGuiService
})(v38))
