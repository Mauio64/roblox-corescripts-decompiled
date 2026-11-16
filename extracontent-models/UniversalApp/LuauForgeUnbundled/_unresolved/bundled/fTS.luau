local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/edC")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local getImageData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageData
local module3 = require("@luauforge/bundled/edp")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local preAuthDeepLinkUrlStore = AuthCommon.Stores.PreAuthDeepLinkUrlStore
local userGender = AuthCommon.Enums.UserGender
local module5 = require("@luauforge/bundled/fsy")
local module6 = require("@luauforge/bundled/fMG")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local module7 = require("@luauforge/bundled/fTT")

local module8 = require("@luauforge/bundled/fTt")
local registerAuditContent = AuthCommon.Components.RegisterAuditContent
local signUpGenderChips = require("@luauforge/bundled/fNq").Components.SignUpGenderChips

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
			local v6 = if p2 == userGender.Male then module5.Button.GenderMale else module5.Button.GenderFemale
			self.props.analytics.reportButtonClicked(module5.Context.SinglePageSignUpScreen, v6)

			if module8 and self.props.useFoundationChips then
				local v7 = if self.props.getIsAltAttempt then self.props.getIsAltAttempt() else nil
				self.props.analytics.reportAuthButtonClick(
					module5.Context.SinglePageSignUpScreen,
					v6,
					preAuthDeepLinkUrlStore.getUrl() or "foundationSignup",
					nil,
					v7,
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

	local v6 = data.props.boldFoundationLabel and "Authentication.SignUp.Label.Gender"
		or module7() == 1 and "Authentication.SignUp.Label.OptionalGender"
		or "Authentication.SignUp.Label.Gender"

	return withStyle(function(data2)
		return module({
			titleText = v6,
			femaleText = data.props.useFoundationChips and "Authentication.SignUp.Label.GenderFemale" or nil,
			maleText = data.props.useFoundationChips and "Authentication.SignUp.Label.GenderMale" or nil
		})(function(props)
			local v7

			if
				getFFlagEnableAuditForSinglePageSignUp()
				and data.props.enableAuditContentCapture
				and props.titleText
			then
				v7 = Roact.createElement(registerAuditContent, {
					translationKey = v6,
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
					RegisterTitleAuditContent = v7
				})
			end

			local createElement = Roact.createElement
			local fitFrame = FitChildren.FitFrame
			local v8 = {
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1
			}

			local v9 = {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5)
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5)
				}),
				Title = 0,
				RegisterTitleAuditContent = 0,
				Frame = 0
			}

			local v10 = props.titleText

			if v10 then
				local createElement2 = Roact.createElement
				local v12 = {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = 0,
					width = 0,
					BackgroundTransparency = 1,
					Text = 0,
					TextWrapped = true,
					Font = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextXAlignment = 0
				}
				local v13 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
				v12.fitAxis = v13
				local v14 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
				v12.width = v14

				v12.Text = props.titleText or ""

				local v15 = if foundationFontFaceMigration then normalizeFontFace(data2.Tokens.Typography.CaptionLarge.Font) else data2.Font.CaptionHeader.Font
				v12.Font = v15

				v12.TextSize = data2.Font.BaseSize * data2.Font.CaptionHeader.RelativeSize
				v12.TextColor3 = data2.Theme.TextEmphasis.Color
				v12.TextTransparency = data2.Theme.TextEmphasis.Transparency
				v12.TextXAlignment = Enum.TextXAlignment.Left
				v10 = createElement2(v5, v12)
			end

			v9.Title = v10

			v9.RegisterTitleAuditContent = v7
			local createElement2 = Roact.createElement

			local v13 = {
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
			local v15 = {
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
			local v17 = {
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
			local v20 = {
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

			local v21 = if data.isSelectedGenderFemale() then images["icons/common/gender_female_selected"] else images["icons/common/gender_female"]
			v20.Image = v21

			local v22 = if defineFastFlag then data2.Theme.IconEmphasis.Color else nil
			v20.ImageColor3 = v22

			local v23 = if defineFastFlag then data2.Theme.IconEmphasis.Transparency else data2.Theme.BackgroundUIDefault.Transparency
			v20.ImageTransparency = v23
			children.Left = createElement4(module3, v17, {
				LeftIcon = createElement5(imageSetLabel, v20)
			})

			local createElement6 = Roact.createElement
			local v25 = {
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
			local v28 = {
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

			local v29 = if data.isSelectedGenderMale() then images["icons/common/gender_male_selected"] else images["icons/common/gender_male"]
			v28.Image = v29

			local v30 = if defineFastFlag then data2.Theme.IconEmphasis.Color else nil
			v28.ImageColor3 = v30

			local v31 = if defineFastFlag then data2.Theme.IconEmphasis.Transparency else data2.Theme.BackgroundUIDefault.Transparency
			v28.ImageTransparency = v31
			children.Right = createElement6(module3, v25, {
				RightIcon = createElement7(imageSetLabel, v28)
			})
			v13.BackgroundImage = createElement3(imageSetLabel, v15, children)
			v9.Frame = createElement2(
				"Frame",
				{ LayoutOrder = 3, Size = size, BackgroundTransparency = 1 },
				v13
			)
			return createElement(fitFrame, v8, v9)
		end)
	end)
end

return (roactServices.connect({ analytics = module6 })(extended))
