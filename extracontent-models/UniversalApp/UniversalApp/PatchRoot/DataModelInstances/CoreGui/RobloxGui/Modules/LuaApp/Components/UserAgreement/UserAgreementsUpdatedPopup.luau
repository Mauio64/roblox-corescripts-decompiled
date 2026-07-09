local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local ToCPopupOccurance = require(Modules.LuaApp.Analytics.RobloxTelemetryConfigs.ToCPopupOccurance)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Checkbox = require(CorePackages.Packages.Foundation).Checkbox
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local CloseUserAgreementsUpdatedPopup = require(Modules.LuaApp.Thunks.CloseUserAgreementsUpdatedPopup)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local withStyle = UIBlox.Core.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local AgreeUpdatedUserAgreements = require(Modules.LuaApp.Http.Requests.AgreeUpdatedUserAgreements)
local PromotionalEmailsPreference = require(Modules.LuaApp.Http.Requests.PromotionalEmailsPreference)
local FitFrame = require(CorePackages.Packages.FitFrame)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local UserAgreementsList = require(CorePackages.Workspace.Packages.UserAgreements).UserAgreementsList
local v26 = game:DefineFastFlag("UserAgreementsDefaultSelection", false)
local GetFFlagLuaAppPromotionalEmailsCheckboxEnabled = require(Modules.LuaApp.Flags.GetFFlagLuaAppPromotionalEmailsCheckboxEnabled)
local rect = Rect.new(8, 8, 9, 9)
local v29 = Roact.PureComponent:extend("UserAgreementsUpdatedPopup")

v29.validateProps = t.strictInterface({
	agreements = t.array(t.strictInterface({
		id = t.string,
		agreementType = t.string,
		clientType = t.string,
		displayUrl = t.string,
		regulationType = t.string
	})),
	formFactor = t.string,
	screenSize = t.Vector2,
	networking = t.callback,
	closePopup = t.callback,
	defaultChildRef = t.optional(t.any),
	focusController = t.optional(t.any),
	containerWidth = t.optional(t.integer),
	closeCentralOverlayThunk = t.optional(t.callback),
	checkboxEnabled = t.optional(t.boolean),
	optInByDefault = t.optional(t.boolean),
	defaultFocusRef = if not v26 then nil else t.callback,
	containerRef = if not v26 then nil else t.callback
})

function v29.init(p1) -- line: 112
	-- upvalues: GetFFlagLuaAppPromotionalEmailsCheckboxEnabled (copy), AgreeUpdatedUserAgreements (copy), PromotionalEmailsPreference (copy)
	if GetFFlagLuaAppPromotionalEmailsCheckboxEnabled() then
		p1.state = {
			promoEmailsDisplayed = p1.props.checkboxEnabled,
			promoEmailsChecked = p1.props.optInByDefault
		}

		function p1.SetPromoEmailsCheckbox(p2) -- line: 118
			-- upvalues: p1 (copy)
			p1:setState({
				promoEmailsChecked = p2
			})
		end
		function p1.SetPromoEmailsCheckboxByTextButton() -- line: 123
			-- upvalues: p1 (copy)
			p1:setState({
				promoEmailsChecked = not p1.state.promoEmailsChecked
			})
		end
	end

	function p1.agreeAndClosePopup() -- line: 129
		-- upvalues: p1 (copy), AgreeUpdatedUserAgreements (copy), GetFFlagLuaAppPromotionalEmailsCheckboxEnabled (copy), PromotionalEmailsPreference (copy)
		local networking = p1.props.networking
		local agreements = p1.props.agreements
		local closePopup = p1.props.closePopup

		AgreeUpdatedUserAgreements(networking, agreements, function(_) -- line: 133
		end)

		if GetFFlagLuaAppPromotionalEmailsCheckboxEnabled() then
			local promoEmailsChecked = p1.state.promoEmailsChecked

			PromotionalEmailsPreference(networking, promoEmailsChecked)
		end

		closePopup()
	end
end
function v29.getLayoutInfo(_, p5, p6) -- line: 144
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
function v29.renderWithProviders(p7, p8, p9) -- line: 171
	-- upvalues: FormFactor (copy), GetFFlagLuaAppPromotionalEmailsCheckboxEnabled (copy), LoggingProtocol (copy), ToCPopupOccurance (copy), Roact (copy), v26 (copy), FitFrame (copy), UserAgreementsList (copy), Checkbox (copy), Button (copy), ButtonType (copy)
	local p9Font = p9.Font
	local Theme = p9.Theme
	local screenSize = p7.props.screenSize
	local formFactor = p7.props.formFactor
	local agreements = p7.props.agreements
	local v44 = formFactor == FormFactor.WIDE
	local v45, v46 = p7:getLayoutInfo(v44, Theme)
	local title = p8.title
	local message = p8.message
	local agreeButton = p8.agreeButton
	local v50 = if not GetFFlagLuaAppPromotionalEmailsCheckboxEnabled() then nil else p8.checkbox

	LoggingProtocol.default:logRobloxTelemetryEvent(ToCPopupOccurance)

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, screenSize.Y),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[Roact.Ref] = if not v26 then nil else p7.props.containerRef
	}, {
		Layout = Roact.createElement(v45, v46, {
			ListLayout = v44 and Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, not v44 and 60 or 0),
				PaddingBottom = UDim.new(0, not v44 and 48 or 24)
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
					TitleText = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 28),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Text = title,
						Font = p9Font.Header1.Font,
						TextSize = p9Font.BaseSize * p9Font.Header1.RelativeSize,
						TextColor3 = Theme.TextEmphasis.Color,
						TextXAlignment = Enum.TextXAlignment.Center
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
						PaddingTop = UDim.new(0, not v44 and 48 or 24),
						PaddingRight = UDim.new(0, 24),
						PaddingBottom = UDim.new(0, not v44 and 48 or 12),
						PaddingLeft = UDim.new(0, 24)
					}),
					MessageText = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Text = message,
						Font = p9Font.Body.Font,
						TextSize = p9Font.BaseSize * p9Font.Body.RelativeSize,
						TextColor3 = Theme.TextEmphasis.Color,
						TextTransparency = Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Center
					})
				}),
				SecondDivider = Roact.createElement("Frame", {
					LayoutOrder = 3,
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
					LayoutOrder = 4,
					agreements = agreements,
					margin = FitFrame.Rect.quad(0, 24, 24, 24)
				}),
				PromotionalEmailsContainer = if not GetFFlagLuaAppPromotionalEmailsCheckboxEnabled() or not p7.state.promoEmailsDisplayed then nil else Roact.createElement("Frame", {
					LayoutOrder = 5,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 0),
						PaddingRight = UDim.new(0, 24),
						PaddingBottom = UDim.new(0, 48),
						PaddingLeft = UDim.new(0, 24)
					}),
					CheckBox = Roact.createElement(Checkbox, {
						label = "",
						isChecked = p7.state.promoEmailsChecked,
						onActivated = p7.SetPromoEmailsCheckbox
					}),
					MessageButton = Roact.createElement("TextButton", {
						Size = UDim2.new(1, -34, 1, 0),
						Position = UDim2.new(0, 34, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Text = v50,
						Font = p9Font.Body.Font,
						TextSize = p9Font.BaseSize * p9Font.Body.RelativeSize,
						TextColor3 = Theme.TextEmphasis.Color,
						TextTransparency = Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						[Roact.Event.Activated] = p7.SetPromoEmailsCheckboxByTextButton
					})
				})
			}),
			AgreeButton = Roact.createElement(Button, {
				buttonType = ButtonType.PrimarySystem,
				size = UDim2.new(1, -48, 0, 48),
				position = UDim2.new(0.5, 0, 1, -10),
				anchorPoint = Vector2.new(0.5, 1),
				layoutOrder = 2,
				text = agreeButton,
				fontStyle = p9Font.SubHeader1,
				onActivated = p7.agreeAndClosePopup,
				[Roact.Ref] = if not v26 then nil else p7.props.defaultFocusRef
			})
		})
	})
end
function v29.render(p10) -- line: 347
	-- upvalues: withLocalization (copy), GetFFlagLuaAppPromotionalEmailsCheckboxEnabled (copy), withStyle (copy)
	return withLocalization({
		title = "CommonUI.UserAgreements.Popup.Title",
		message = "CommonUI.UserAgreements.Popup.Message",
		agreeButton = "CommonUI.UserAgreements.Popup.Agree",
		checkbox = if not GetFFlagLuaAppPromotionalEmailsCheckboxEnabled() then nil else "CommonUI.UserAgreements.Popup.PromotionalEmailsCheckbox"
	})(function(p11) -- line: 355
		-- upvalues: withStyle (copy), p10 (copy)
		return withStyle(function(p12) -- line: 356
			-- upvalues: p10 (copy), p11 (copy)
			return p10:renderWithProviders(p11, p12)
		end)
	end)
end

local v30 = RoactRodux.connect(function(p13) -- line: 362
	return {
		screenSize = p13.ScreenSize,
		formFactor = p13.FormFactor
	}
end, function(p14) -- line: 367
	-- upvalues: CloseUserAgreementsUpdatedPopup (copy)
	return {
		closePopup = function() -- line: 369
			-- upvalues: p14 (copy), CloseUserAgreementsUpdatedPopup (copy)
			p14(CloseUserAgreementsUpdatedPopup())
		end
	}
end)(v29)

if GetFFlagLuaAppPromotionalEmailsCheckboxEnabled() then
	v30 = RoactAppPolicy.connect(function(p15, _) -- line: 376
		return {
			checkboxEnabled = p15.getPromotionalEmailsCheckboxEnabled(),
			optInByDefault = p15.getPromotionalEmailsOptInByDefault()
		}
	end)(v30)
end

local u31 = RoactServices.connect({
	networking = RoactNetworking
})(v30)

if v26 then
	return function(p17) -- line: 389
		-- upvalues: ReactFocusNavigation (copy), Roact (copy), u31 (ref), Cryo (copy)
		local v57, v58 = ReactFocusNavigation.useDefaultFocusBehavior()

		return Roact.createElement(u31, Cryo.Dictionary.join(p17, {
			defaultFocusRef = v57,
			containerRef = v58
		}))
	end
end

return u31
