local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/fMG")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType

local withStyle = UIBlox.Style.withStyle
local module2 = require("@luauforge/bundled/edC")

local module3 = require("@luauforge/bundled/dCp")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module5 = require("@luauforge/deferred/fTH")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local birthdayPicker = require("@luauforge/bundled/fNq").Components.BirthdayPicker
local module7 = require("@luauforge/deferred/fTI")
local module8 = require("@luauforge/deferred/fTL")
local dateHelper = require("@luauforge/bundled/fAu").DateHelper

local module9 = require("@luauforge/bundled/dYW")
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageData
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local images = UIBlox.App.ImageSet.Images
local module10 = require("@luauforge/deferred/fTM")

local birthday = require("@game/CorePackages/Workspace/Packages/AuthCommon").Models.Birthday

local module11 = require("@luauforge/bundled/dxN")

local fFlagRemoveUnusedSignUpInfoRoduxSlice = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveUnusedSignUpInfoRoduxSlice

local module12 = require("@luauforge/bundled/fsy")
local module13 = require("@luauforge/bundled/fDz")

local udim = UDim2.new(0, 36, 0, 36)

local iconsnavigationclose = images["icons/navigation/close"]

local vector2 = Vector2.new(540, 1080)

local extended = Roact.PureComponent:extend("BirthdayPage")

function extended:init()
	self.state = { month = 0, day = 0, year = 0, continueButtonEnabled = false }

	self.isMounted = false
	self.closeButtonRef = self.props.defaultRef
	self.confirmButtonRef = Roact.createRef()

	function self.onContinueButtonActivated()
		local authAnalytics = self.props.authAnalytics
		local setSignUpBirthday = self.props.setSignUpBirthday

		local month = self.state.month
		local day = self.state.day
		local year = self.state.year

		if self.state.continueButtonEnabled then
			local v5 = birthday.new({ Month = month, Day = day, Year = year })

			authAnalytics.reportBirthdaySelection(module12.Context.BirthdayScreen)
			setSignUpBirthday(v5)

			authAnalytics.reportContinueButtonClicked(module12.Context.BirthdayScreen)
			authAnalytics.reportAuthButtonClick(
				module12.Context.BirthdayScreen,
				module12.Button.Continue,
				(tostring(year))
			)

			self.props.navigateToSinglePageSignUp(v5)
		end
	end

	function self.onCloseButtonClicked()
		self.props.authAnalytics.reportAuthButtonClick(
			module12.Context.BirthdayScreen,
			module12.Button.Close
		)

		self.props.navigateBack()
	end

	function self.updateBirthday(p2, p3, p4)
		local validDate = dateHelper:isValidDate(p2, p3, p4)

		spawn(function()
			if self.isMounted then
				self:setState({
					month = p2,
					day = p3,
					year = p4,
					continueButtonEnabled = validDate
				})
			end
		end)
	end

	function self.renderCharacter()
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			Character = Roact.createElement("ImageLabel", {
				Size = UDim2.new(0.9, 0, 0.9, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/builderman.png",
				ZIndex = 2
			}),
			Shadow = Roact.createElement("ImageLabel", {
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/CharacterShadow.png",
				Size = UDim2.new(1, 0, 0.25, 0),
				Position = UDim2.new(0.5, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 1
			})
		})
	end

	self.props.authAnalytics.reportScreenLoaded(module12.Context.BirthdayScreen)
end

function extended:didMount()
	self.isMounted = true

	self.props.authAnalytics.reportAuthPageload(module12.Context.BirthdayScreen)
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(props)
	if module13() then
		return withStyle(function(data)
			return module2({
				continueText = "Authentication.SignUp.Label.Continue",
				signUpText = "Authentication.SignUp.Action.CreateAccount",
				helpText = "Authentication.SignUp.Description.BirthdayHelp",
				headerText = "Authentication.SignUp.Heading.WhatsYourBirthday"
			})(function(props2)
				local createElement = Roact.createElement

				local createElement2 = Roact.createElement
				local containerRefsByRef = {
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
					ImageColor3 = data.Theme.BackgroundUIDefault.Color,
					ClipsDescendants = true,
					[Roact.Ref] = props.props.containerRef
				}
				local children = {
					SizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = vector2
					}),
					HeaderFrame = 0,
					Divider = 0,
					ContentFrame = 0
				}

				local createElement3 = Roact.createElement
				local v10 = {
					Size = UDim2.new(1, 0, 0, 48),
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1
				}

				local children2 = {
					CloseButton = Roact.createElement(imageSetButton, {
						Size = udim,
						AutoButtonColor = false,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 12, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						ScaleType = Enum.ScaleType.Fit,
						Image = iconsnavigationclose,
						ImageColor3 = data.Theme.UIEmphasis.Color,
						ImageTransparency = 0,
						[Roact.Ref] = props.closeButtonRef,
						[Roact.Event.Activated] = props.onCloseButtonClicked
					}),
					Title = 0
				}

				local createElement5 = Roact.createElement
				local v14 = {
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Text = props2.signUpText or "",
					TextWrapped = true,
					Font = 0,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextXAlignment = 0
				}

				local v15 = if not foundationFontFaceMigration then data.Font.CaptionHeader.Font else nil
				v14.Font = v15

				local v16 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.CaptionLarge.Font) else nil
				v14.FontFace = v16

				v14.TextSize = data.Font.BaseSize * data.Font.Header1.RelativeSize
				v14.TextColor3 = data.Theme.TextEmphasis.Color
				v14.TextTransparency = data.Theme.TextEmphasis.Transparency
				v14.TextXAlignment = Enum.TextXAlignment.Center
				children2.Title = createElement5("TextLabel", v14)
				children.HeaderFrame = createElement3("Frame", v10, children2)

				children.Divider = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0.5, 0, 0, 48),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 0,
					BackgroundColor3 = data.Theme.UIEmphasis.Color
				})

				children.ContentFrame = Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 1, -49),
						Position = UDim2.new(0.5, 0, 0, 49),
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0)
					},
					{
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 24),
							PaddingRight = UDim.new(0, 24),
							PaddingTop = UDim.new(0, 24)
						}),
						ListLayout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 8)
						}),
						MultiPageSignupText = Roact.createElement(module10, {
							layoutOrder = 1,
							titleText = props2.headerText,
							helpText = props2.helpText
						}),
						PickerFrame = Roact.createElement(
							"Frame",
							{
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								LayoutOrder = 2
							},
							{
								BirthdayPadding = Roact.createElement("UIPadding", {
									PaddingTop = UDim.new(0, 20),
									PaddingBottom = UDim.new(0, 20)
								}),
								BirthdayPicker = Roact.createElement(birthdayPicker, {
									updateBirthday = props.updateBirthday,
									NextSelectionUp = props.closeButtonRef,
									NextSelectionDown = props.confirmButtonRef
								})
							}
						),
						ButtonPadding = Roact.createElement("Frame", {
							Size = UDim2.new(1, 0, 0, 10),
							BackgroundTransparency = 1,
							LayoutOrder = 3
						}),
						ConfirmBirthdayButton = Roact.createElement(button, {
							layoutOrder = 4,
							buttonType = buttonType.PrimaryContextual,
							isDisabled = not props.state.continueButtonEnabled,
							size = UDim2.new(1, 0, 0, 36),
							text = props2.continueText,
							onActivated = props.onContinueButtonActivated,
							[Roact.Ref] = props.confirmButtonRef
						})
					}
				)
				return createElement(module9, {
					BackgroundTransparency = 1,
					includeStatusBar = true,
					renderFullscreenBackground = function()
						return Roact.createElement("Frame", {
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 0,
							BackgroundColor3 = data.Theme.BackgroundUIDefault.Color
						})
					end
				}, {
					Container = createElement2(imageSetLabel, containerRefsByRef, children)
				})
			end)
		end)
	end

	return Roact.createElement(module7, {
		titleTextKey = "Authentication.SignUp.Label.WhensYourBirthday",
		renderWidget = function(p2)
			local formFactor2 = p2.formFactor
			local continueButtonEnabled = props.state.continueButtonEnabled

			return withStyle(function(p3)
				return module2({ continueText = "Authentication.SignUp.Label.Continue" })(function(p4)
					local v5 = formFactor2 ~= formFactor.COMPACT and 1
						or p3.Theme.BackgroundDefault.Transparency

					return Roact.createElement(FitChildren.FitImageLabel, {
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
						BackgroundTransparency = v5,
						BorderSizePixel = 0,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(9, 9, 9, 9),
						ClipsDescendants = true,
						Image = "LuaApp/buttons/buttonFill",
						ImageColor3 = p3.Theme.BackgroundDefault.Color,
						ImageTransparency = p3.Theme.BackgroundDefault.Transparency,
						[Roact.Ref] = props.props.containerRef
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
						BirthdayPicker = Roact.createElement(birthdayPicker, {
							layoutOrder = 1,
							updateBirthday = props.updateBirthday,
							NextSelectionUp = props.closeButtonRef,
							NextSelectionDown = props.confirmButtonRef
						}),
						AuthBackAndNextButton = Roact.createElement(module8, {
							layoutOrder = 2,
							size = UDim2.new(1, 0, 0, 36),
							nextButtonText = p4.continueText,
							nextButtonIsDisabled = not continueButtonEnabled,
							nextButtonOnActivated = props.onContinueButtonActivated,
							[Roact.Ref] = props.confirmButtonRef
						})
					})
				end)
			end)
		end,
		renderCharacter = props.renderCharacter,
		widgetHeightIsDrivenByLayout = false,
		showDisclaimerLinks = true
	})
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		setSignUpBirthday = function(p2)
			if fFlagRemoveUnusedSignUpInfoRoduxSlice then
				return nil
			end

			return callback(module11(p2))
		end,
		navigateToSinglePageSignUp = function(p2)
			local v6 = {
				name = module3.SinglePageSignUp,
				extraProps = { birthday = p2 }
			}

			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.sideways(navigationCommands.fromLegacyPage(v6))
			end

			return callback(module5(v6))
		end,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end
	}
end)(extended)

local v6 = roactServices.connect({ authAnalytics = module })(v5)

return function(p2)
	local v7, v8 = useDefaultFocusBehavior()
	return Roact.createElement(v6, Cryo.Dictionary.join(p2, {
		defaultRef = v7,
		containerRef = v8
	}))
end
