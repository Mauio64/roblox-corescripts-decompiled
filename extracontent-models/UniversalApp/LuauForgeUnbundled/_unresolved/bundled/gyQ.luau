local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/egZ")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local getImageData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageData
local module3 = require("@luauforge/bundled/egM")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local preAuthDeepLinkUrlStore = AuthCommon.Stores.PreAuthDeepLinkUrlStore
local userGender = AuthCommon.Enums.UserGender
local module5 = require("@luauforge/bundled/fzS")
local module6 = require("@luauforge/bundled/grb")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local module7 = require("@luauforge/bundled/gyR")

local module8 = require("@luauforge/bundled/gxX")
local registerAuditContent = AuthCommon.Components.RegisterAuditContent
local signUpGenderChips = require("@luauforge/bundled/grL").Components.SignUpGenderChips

local getFFlagEnableAuditForSinglePageSignUp = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuditForSinglePageSignUp

local defineFastFlag = game:DefineFastFlag("FixGenderSelectorIconLightTheme", false)

local udim = UDim2.new(8 / 9, 0, 8 / 9, 0)

local extended = Roact.PureComponent:extend("SignUpGenderSelector")

extended.defaultProps = { size = UDim2.new(1, 0, 0, 48) }

function extended:init()
	self.state = { gender = userGender.Unknown, hoverRight = false, hoverLeft = false }

	self.isMounted = false

	function self.onGenderSelected(p2)
		spawn(function()
			local v5 = if p2 == userGender.Male then module5.Button.GenderMale else module5.Button.GenderFemale
			self.props.analytics.reportButtonClicked(module5.Context.SinglePageSignUpScreen, v5)

			if module8 and self.props.useFoundationChips then
				local v6 = if self.props.getIsAltAttempt then self.props.getIsAltAttempt() else nil
				self.props.analytics.reportAuthButtonClick(
					module5.Context.SinglePageSignUpScreen,
					v5,
					preAuthDeepLinkUrlStore.getUrl() or "foundationSignup",
					nil,
					v6,
					"foundationSignup"
				)
			end

			if self.isMounted then
				if self.state.gender == p2 then
					p2 = userGender.Unknown
				end

				self:setState({ gender = p2 })

				if self.props.onGenderChanged then
					self.props.onGenderChanged(p2)
				end
			end
		end)
	end

	function self.isSelectedGenderMale(): boolean
		return self.state.gender == userGender.Male
	end

	function self.isSelectedGenderFemale(): boolean
		return self.state.gender == userGender.Female
	end

	function self.onMouseEnterRight()
		if self.isMounted then
			self:setState({ hoverRight = true })
		end
	end

	function self.onMouseLeaveRight()
		if self.isMounted then
			self:setState({ hoverRight = false })
		end
	end

	function self.onMouseEnterLeft()
		if self.isMounted then
			self:setState({ hoverLeft = true })
		end
	end

	function self.onMouseLeaveLeft()
		if self.isMounted then
			self:setState({ hoverLeft = false })
		end
	end
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(data)
	local layoutOrder = data.props.layoutOrder
	local size = data.props.size

	local v5 = data.props.boldFoundationLabel and "Authentication.SignUp.Label.Gender"
		or module7() == 1 and "Authentication.SignUp.Label.OptionalGender"
		or "Authentication.SignUp.Label.Gender"

	return withStyle(function(data2)
		return module({
			titleText = v5,
			femaleText = data.props.useFoundationChips and "Authentication.SignUp.Label.GenderFemale" or nil,
			maleText = data.props.useFoundationChips and "Authentication.SignUp.Label.GenderMale" or nil
		})(function(props)
			local v6

			if
				getFFlagEnableAuditForSinglePageSignUp()
				and data.props.enableAuditContentCapture
				and props.titleText
			then
				v6 = Roact.createElement(registerAuditContent, {
					translationKey = v5,
					translatedSourceString = props.titleText
				})
			end

			if data.props.useFoundationChips then
				return Roact.createFragment({
					GenderChips = Roact.createElement(signUpGenderChips, {
						LayoutOrder = layoutOrder,
						label = props.titleText,
						isLabelBold = data.props.boldFoundationLabel,
						femaleText = props.femaleText,
						maleText = props.maleText,
						gender = data.state.gender,
						onGenderSelected = data.onGenderSelected
					}),
					RegisterTitleAuditContent = v6
				})
			end

			local createElement = Roact.createElement
			local fitFrame = FitChildren.FitFrame
			local v7 = {
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1
			}

			local v8 = {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5)
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5)
				}),
				Title = props.titleText and Roact.createElement(fitTextLabel, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					width = UDim.new(1, 0),
					BackgroundTransparency = 1,
					Text = props.titleText or "",
					TextWrapped = true,
					Font = normalizeFontFace(data2.Tokens.Typography.CaptionLarge.Font),
					TextSize = data2.Font.BaseSize * data2.Font.CaptionHeader.RelativeSize,
					TextColor3 = data2.Theme.TextEmphasis.Color,
					TextTransparency = data2.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				RegisterTitleAuditContent = v6,
				Frame = 0
			}

			local createElement2 = Roact.createElement

			local v11 = {
				Boundary = Roact.createElement(imageSetLabel, {
					ZIndex = 3,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = getImageData("LuaApp/buttons/buttonStroke") or "LuaApp/buttons/buttonStroke",
					ImageColor3 = data2.Theme.SecondaryDefault.Color
				}),
				BackgroundImage = 0
			}

			local createElement3 = Roact.createElement
			local v13 = {
				ZIndex = 1,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(9, 9, 9, 9),
				Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = data2.Theme.SecondaryDefault.Color
			}
			local children = {
				UIListLayout2 = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 1)
				}),
				Left = 0,
				Right = 0
			}

			local createElement4 = Roact.createElement
			local v15 = {
				LayoutOrder = 1,
				Size = UDim2.new(0.5, 0, 1, 0),
				AutoButtonColor = false,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(7, 8, 7, 8),
				ClipsDescendants = true,
				Image = "LuaApp/buttons/buttonLeftFill",
				ImageColor3 = data2.Theme.BackgroundContrast.Color,
				ImageTransparency = 0,
				[Roact.Event.Activated] = function()
					data.onGenderSelected(userGender.Female)
				end,
				[Roact.Event.MouseEnter] = data.onMouseEnterLeft,
				[Roact.Event.MouseLeave] = data.onMouseLeaveLeft
			}

			local createElement5 = Roact.createElement
			local v18 = {
				LayoutOrder = 1,
				Size = udim,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Fit,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ClipsDescendants = true,
				Image = 0,
				ImageColor3 = 0,
				ImageTransparency = 0,
				BackgroundTransparency = 1
			}

			local v19 = if data.isSelectedGenderFemale() then images["icons/common/gender_female_selected"] else images["icons/common/gender_female"]
			v18.Image = v19

			local v20 = if defineFastFlag then data2.Theme.IconEmphasis.Color else nil
			v18.ImageColor3 = v20

			local v21 = if defineFastFlag then data2.Theme.IconEmphasis.Transparency else data2.Theme.BackgroundUIDefault.Transparency
			v18.ImageTransparency = v21
			children.Left = createElement4(module3, v15, {
				LeftIcon = createElement5(imageSetLabel, v18)
			})

			local createElement6 = Roact.createElement
			local v23 = {
				LayoutOrder = 2,
				Size = UDim2.new(0.5, -1, 1, 0),
				AutoButtonColor = false,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(1, 8, 1, 8),
				ClipsDescendants = true,
				Image = "LuaApp/buttons/buttonRightFill",
				ImageColor3 = data2.Theme.BackgroundContrast.Color,
				ImageTransparency = 0,
				[Roact.Event.Activated] = function()
					data.onGenderSelected(userGender.Male)
				end,
				[Roact.Event.MouseEnter] = data.onMouseEnterRight,
				[Roact.Event.MouseLeave] = data.onMouseLeaveRight
			}

			local createElement7 = Roact.createElement
			local v26 = {
				LayoutOrder = 1,
				Size = udim,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Fit,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ClipsDescendants = true,
				Image = 0,
				ImageColor3 = 0,
				ImageTransparency = 0,
				BackgroundTransparency = 1
			}

			local v27 = if data.isSelectedGenderMale() then images["icons/common/gender_male_selected"] else images["icons/common/gender_male"]
			v26.Image = v27

			local v28 = if defineFastFlag then data2.Theme.IconEmphasis.Color else nil
			v26.ImageColor3 = v28

			local v29 = if defineFastFlag then data2.Theme.IconEmphasis.Transparency else data2.Theme.BackgroundUIDefault.Transparency
			v26.ImageTransparency = v29
			children.Right = createElement6(module3, v23, {
				RightIcon = createElement7(imageSetLabel, v26)
			})
			v11.BackgroundImage = createElement3(imageSetLabel, v13, children)
			v8.Frame = createElement2(
				"Frame",
				{ LayoutOrder = 3, Size = size, BackgroundTransparency = 1 },
				v11
			)
			return createElement(fitFrame, v7, v8)
		end)
	end)
end

return (roactServices.connect({ analytics = module6 })(extended))
