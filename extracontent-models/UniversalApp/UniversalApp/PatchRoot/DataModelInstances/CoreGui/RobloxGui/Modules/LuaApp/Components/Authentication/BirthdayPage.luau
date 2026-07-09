local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local useDefaultFocusBehavior = require(CorePackages.Packages.ReactFocusNavigation).useDefaultFocusBehavior
local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local NavigateSideways = require(Modules.LuaApp.Thunks.NavigateSideways)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v18 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local FitChildren = require(Modules.LuaApp.FitChildren)
local BirthdayPicker = require(CorePackages.Workspace.Packages.AuthSignup).Components.BirthdayPicker
local SignUpLayout = require(Modules.LuaApp.Components.Authentication.SignUpLayout)
local AuthBackAndNextButton = require(Modules.LuaApp.Components.Authentication.AuthBackAndNextButton)
local DateHelper = require(CorePackages.Workspace.Packages.Time).DateHelper
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local MultiPageSignupText = require(Modules.LuaApp.Components.Authentication.MultiPageSignupText)
local Birthday = require(CorePackages.Workspace.Packages.AuthCommon).Models.Birthday
local SetSignUpBirthday = require(Modules.LuaApp.Actions.Authentication.SetSignUpBirthday)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local GetFFlagEnableMultiPageSignupExperiment = require(Modules.LuaApp.Flags.GetFFlagEnableMultiPageSignupExperiment)
local uDim2 = UDim2.new(0, 36, 0, 36)
local v36 = Images["icons/navigation/close"]
local vector2 = Vector2.new(540, 1080)
local v38 = Roact.PureComponent:extend("BirthdayPage")

function v38.init(p1) -- line: 64
	-- upvalues: Roact (copy), Birthday (copy), EventStreamConstants (copy), DateHelper (copy)
	p1.state = {
		month = 0,
		day = 0,
		year = 0,
		continueButtonEnabled = false
	}
	p1.isMounted = false
	p1.closeButtonRef = p1.props.defaultRef
	p1.confirmButtonRef = Roact.createRef()

	function p1.onContinueButtonActivated() -- line: 76
		-- upvalues: p1 (copy), Birthday (copy), EventStreamConstants (copy)
		local authAnalytics = p1.props.authAnalytics
		local setSignUpBirthday = p1.props.setSignUpBirthday
		local month = p1.state.month
		local day = p1.state.day
		local year = p1.state.year

		if p1.state.continueButtonEnabled then
			local v54 = Birthday.new({
				Month = month,
				Day = day,
				Year = year
			})

			authAnalytics.reportBirthdaySelection(EventStreamConstants.Context.BirthdayScreen)
			setSignUpBirthday(v54)
			authAnalytics.reportContinueButtonClicked(EventStreamConstants.Context.BirthdayScreen)
			authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.BirthdayScreen, EventStreamConstants.Button.Continue, (tostring(year)))
			p1.props.navigateToSinglePageSignUp(v54)
		end
	end
	function p1.onCloseButtonClicked() -- line: 105
		-- upvalues: p1 (copy), EventStreamConstants (copy)
		p1.props.authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.BirthdayScreen, EventStreamConstants.Button.Close)
		p1.props.navigateBack()
	end
	function p1.updateBirthday(p2, p3, p4) -- line: 113
		-- upvalues: DateHelper (copy), p1 (copy)
		local v58 = DateHelper:isValidDate(p2, p3, p4)

		spawn(function() -- line: 116
			-- upvalues: p1 (copy), p2 (copy), p3 (copy), p4 (copy), v58 (copy)
			if p1.isMounted then
				p1:setState({
					month = p2,
					day = p3,
					year = p4,
					continueButtonEnabled = v58
				})
			end
		end)
	end
	function p1.renderCharacter() -- line: 128
		-- upvalues: Roact (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Character = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/builderman.png",
				ZIndex = 2,
				Size = UDim2.new(0.9, 0, 0.9, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0)
			}),
			Shadow = Roact.createElement("ImageLabel", {
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/CharacterShadow.png",
				BackgroundTransparency = 1,
				BorderSizePixel = 1,
				Size = UDim2.new(1, 0, 0.25, 0),
				Position = UDim2.new(0.5, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 1)
			})
		})
	end

	p1.props.authAnalytics.reportScreenLoaded(EventStreamConstants.Context.BirthdayScreen)
end
function v38.didMount(p5) -- line: 155
	-- upvalues: EventStreamConstants (copy)
	p5.isMounted = true
	p5.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.BirthdayScreen)
end
function v38.willUnmount(p6) -- line: 161
	p6.isMounted = false
end
function v38.render(p7) -- line: 165
	-- upvalues: GetFFlagEnableMultiPageSignupExperiment (copy), withStyle (copy), withLocalization (copy), Roact (copy), FullscreenPageWithSafeArea (copy), ImageSetLabel (copy), GetImageData (copy), vector2 (copy), ImageSetButton (copy), uDim2 (copy), v36 (copy), MultiPageSignupText (copy), BirthdayPicker (copy), Button (copy), ButtonType (copy), SignUpLayout (copy), FormFactor (copy), FitChildren (copy), AuthBackAndNextButton (copy)
	if GetFFlagEnableMultiPageSignupExperiment() then
		return withStyle(function(t1: {[any]: any}) -- line: 167
			-- upvalues: withLocalization (copy), Roact (copy), FullscreenPageWithSafeArea (copy), ImageSetLabel (copy), GetImageData (copy), p7 (copy), vector2 (copy), ImageSetButton (copy), uDim2 (copy), v36 (copy), MultiPageSignupText (copy), BirthdayPicker (copy), Button (copy), ButtonType (copy)
			return withLocalization({
				continueText = "Authentication.SignUp.Label.Continue",
				signUpText = "Authentication.SignUp.Action.CreateAccount",
				helpText = "Authentication.SignUp.Description.BirthdayHelp",
				headerText = "Authentication.SignUp.Heading.WhatsYourBirthday"
			})(function(p8) -- line: 173
				-- upvalues: Roact (copy), FullscreenPageWithSafeArea (copy), t1 (copy), ImageSetLabel (copy), GetImageData (copy), p7 (copy), vector2 (copy), ImageSetButton (copy), uDim2 (copy), v36 (copy), MultiPageSignupText (copy), BirthdayPicker (copy), Button (copy), ButtonType (copy)
				return Roact.createElement(FullscreenPageWithSafeArea, {
					BackgroundTransparency = 1,
					includeStatusBar = true,
					renderFullscreenBackground = function() -- line: 177
						-- upvalues: Roact (copy), t1 (copy)
						return Roact.createElement("Frame", {
							BackgroundTransparency = 0,
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundColor3 = t1.Theme.BackgroundUIDefault.Color
						})
					end
				}, {
					Container = Roact.createElement(ImageSetLabel, {
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0.5, 0, 0, 0),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(9, 9, 9, 9),
						Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
						ImageColor3 = t1.Theme.BackgroundUIDefault.Color,
						ClipsDescendants = true,
						[Roact.Ref] = p7.props.containerRef
					}, {
						SizeConstraint = Roact.createElement("UISizeConstraint", {
							MaxSize = vector2
						}),
						HeaderFrame = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 48),
							Position = UDim2.new(0.5, 0, 0, 0),
							AnchorPoint = Vector2.new(0.5, 0)
						}, {
							CloseButton = Roact.createElement(ImageSetButton, {
								Size = uDim2,
								AutoButtonColor = false,
								BorderSizePixel = 0,
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 12, 0.5, 0),
								AnchorPoint = Vector2.new(0, 0.5),
								ScaleType = Enum.ScaleType.Fit,
								Image = v36,
								ImageColor3 = t1.Theme.UIEmphasis.Color,
								ImageTransparency = 0,
								[Roact.Ref] = p7.closeButtonRef,
								[Roact.Event.Activated] = p7.onCloseButtonClicked
							}),
							Title = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextWrapped = true,
								Position = UDim2.new(0, 0, 0.5, 0),
								Size = UDim2.new(1, 0, 0, 0),
								AnchorPoint = Vector2.new(0, 0.5),
								AutomaticSize = Enum.AutomaticSize.Y,
								Text = p8.signUpText or "",
								Font = t1.Font.CaptionHeader.Font,
								TextSize = t1.Font.BaseSize * t1.Font.Header1.RelativeSize,
								TextColor3 = t1.Theme.TextEmphasis.Color,
								TextTransparency = t1.Theme.TextEmphasis.Transparency,
								TextXAlignment = Enum.TextXAlignment.Center
							})
						}),
						Divider = Roact.createElement("Frame", {
							BackgroundTransparency = 0,
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0.5, 0, 0, 48),
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundColor3 = t1.Theme.UIEmphasis.Color
						}),
						ContentFrame = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, -49),
							Position = UDim2.new(0.5, 0, 0, 49),
							AnchorPoint = Vector2.new(0.5, 0)
						}, {
							Padding = Roact.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, 24),
								PaddingRight = UDim.new(0, 24),
								PaddingTop = UDim.new(0, 24)
							}),
							ListLayout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 8)
							}),
							MultiPageSignupText = Roact.createElement(MultiPageSignupText, {
								layoutOrder = 1,
								titleText = p8.headerText,
								helpText = p8.helpText
							}),
							PickerFrame = Roact.createElement("Frame", {
								BackgroundTransparency = 1,
								LayoutOrder = 2,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							}, {
								BirthdayPadding = Roact.createElement("UIPadding", {
									PaddingTop = UDim.new(0, 20),
									PaddingBottom = UDim.new(0, 20)
								}),
								BirthdayPicker = Roact.createElement(BirthdayPicker, {
									updateBirthday = p7.updateBirthday,
									NextSelectionUp = p7.closeButtonRef,
									NextSelectionDown = p7.confirmButtonRef
								})
							}),
							ButtonPadding = Roact.createElement("Frame", {
								BackgroundTransparency = 1,
								LayoutOrder = 3,
								Size = UDim2.new(1, 0, 0, 10)
							}),
							ConfirmBirthdayButton = Roact.createElement(Button, {
								layoutOrder = 4,
								buttonType = ButtonType.PrimaryContextual,
								isDisabled = not p7.state.continueButtonEnabled,
								size = UDim2.new(1, 0, 0, 36),
								text = p8.continueText,
								onActivated = p7.onContinueButtonActivated,
								[Roact.Ref] = p7.confirmButtonRef
							})
						})
					})
				})
			end)
		end)
	end

	return Roact.createElement(SignUpLayout, {
		titleTextKey = "Authentication.SignUp.Label.WhensYourBirthday",
		widgetHeightIsDrivenByLayout = false,
		showDisclaimerLinks = true,
		renderWidget = function(p9) -- line: 302
			-- upvalues: p7 (copy), withStyle (copy), withLocalization (copy), FormFactor (copy), Roact (copy), FitChildren (copy), BirthdayPicker (copy), AuthBackAndNextButton (copy)
			local formFactor = p9.formFactor
			local continueButtonEnabled = p7.state.continueButtonEnabled

			return withStyle(function(p10) -- line: 306
				-- upvalues: withLocalization (copy), formFactor (copy), FormFactor (copy), Roact (copy), FitChildren (copy), p7 (copy), BirthdayPicker (copy), AuthBackAndNextButton (copy), continueButtonEnabled (copy)
				return withLocalization({
					continueText = "Authentication.SignUp.Label.Continue"
				})(function(p11) -- line: 309
					-- upvalues: formFactor (copy), FormFactor (copy), p10 (copy), Roact (copy), FitChildren (copy), p7 (copy), BirthdayPicker (copy), AuthBackAndNextButton (copy), continueButtonEnabled (copy)
					local n1 = 1

					if formFactor == FormFactor.COMPACT then
						n1 = p10.Theme.BackgroundDefault.Transparency
					end

					return Roact.createElement(FitChildren.FitImageLabel, {
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						BackgroundColor3 = p10.Theme.BackgroundDefault.Color,
						BackgroundTransparency = n1,
						BorderSizePixel = 0,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(9, 9, 9, 9),
						ClipsDescendants = true,
						Image = "LuaApp/buttons/buttonFill",
						ImageColor3 = p10.Theme.BackgroundDefault.Color,
						ImageTransparency = p10.Theme.BackgroundDefault.Transparency,
						[Roact.Ref] = p7.props.containerRef
					}, {
						ListLayout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 20),
							PaddingRight = UDim.new(0, 20),
							PaddingTop = UDim.new(0, 20),
							PaddingBottom = UDim.new(0, 20)
						}),
						BirthdayPicker = Roact.createElement(BirthdayPicker, {
							layoutOrder = 1,
							updateBirthday = p7.updateBirthday,
							NextSelectionUp = p7.closeButtonRef,
							NextSelectionDown = p7.confirmButtonRef
						}),
						AuthBackAndNextButton = Roact.createElement(AuthBackAndNextButton, {
							layoutOrder = 2,
							size = UDim2.new(1, 0, 0, 36),
							nextButtonText = p11.continueText,
							nextButtonIsDisabled = not continueButtonEnabled,
							nextButtonOnActivated = p7.onContinueButtonActivated,
							[Roact.Ref] = p7.confirmButtonRef
						})
					})
				end)
			end)
		end,
		renderCharacter = p7.renderCharacter
	})
end

local v39 = RoactRodux.connect(nil, function(p12) -- line: 364
	-- upvalues: SetSignUpBirthday (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), NavigateSideways (copy), NavigateBack (copy)
	return {
		setSignUpBirthday = function(p13) -- line: 366
			-- upvalues: p12 (copy), SetSignUpBirthday (copy)
			return p12(SetSignUpBirthday(p13))
		end,
		navigateToSinglePageSignUp = function(p14) -- line: 369
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), p12 (copy), NavigateSideways (copy)
			local t2 = {
				name = AppPage.SinglePageSignUp,
				extraProps = {
					birthday = p14
				}
			}

			if FFlagSignalsNavP3Dispatch then
				return v18.sideways(v18.fromLegacyPage(t2))
			end

			return p12(NavigateSideways(t2))
		end,
		navigateBack = function() -- line: 377
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v18 (copy), p12 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v18.back()
			end

			return p12(NavigateBack())
		end
	}
end)(v38)
local u40 = RoactServices.connect({
	authAnalytics = RoactAnalyticsAuthEvents
})(v39)

return function(p15) -- line: 391
	-- upvalues: useDefaultFocusBehavior (copy), Roact (copy), u40 (ref), Cryo (copy)
	local v47, v48 = useDefaultFocusBehavior()

	return Roact.createElement(u40, Cryo.Dictionary.join(p15, {
		defaultRef = v47,
		containerRef = v48
	}))
end
