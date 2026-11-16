local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical

local withStyle = UIBlox.Style.withStyle
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module = require("@luauforge/bundled/gSi")

local module2 = require("@luauforge/deferred/gSj")
local module3 = require("@luauforge/deferred/gSn")

local v5 = if module then require("@luauforge/deferred/gSq") else require("@luauforge/deferred/gSr")
local module4 = require("@luauforge/deferred/gSs")
require("@luauforge/bundled/dHK")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module6 = require("@luauforge/bundled/dNQ")
local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling

local extended = Roact.PureComponent:extend("ScalesPage")

function extended:init()
	local binding, v6 = Roact.createBinding(UDim2.new(0, 0, 1, 0))
	self.canvasSizeBinding = binding
	self.updateCanvasSizeBinding = v6

	function self.onContentSizeChanged(p3)
		local v7 = p3.AbsoluteContentSize.Y + 20
		self.updateCanvasSizeBinding(UDim2.new(0, 0, 0, v7))
	end

	self.bodyTypeRadarRef = Roact.createRef()
	self.bodySizeRadarRef = Roact.createRef()
	self.headSizeSliderRef = Roact.createRef()
	self.avatarTypeSwitchRef = Roact.createRef()
end

function extended.render(data)
	local adaptiveScrolling = data.props.adaptiveScrolling or {}

	local v6 = not adaptiveScrolling.scrollingEnabledBinding
		or adaptiveScrolling.scrollingEnabledBinding:map(function(p2)
			return p2
		end)

	return withStyle(function(data2)
		return withLocalization({
			headSize = "Feature.Avatar.Label.HeadSize",
			r6R15 = "Feature.Avatar.Label.R6R15"
		})(function(p2)
			local lockNavigationCallback = data.props.lockNavigationCallback
			local unlockNavigationCallback = data.props.unlockNavigationCallback
			local enableNavigation = data.props.enableNavigation
			local v7 = data.props.avatarType == module6.AvatarType.R6

			local font = data2.Font
			local theme = data2.Theme
			local font2 = font.Header2.Font
			local v8 = font.BaseSize * font.Header2.RelativeSize

			local forwardRef = data.props.forwardRef

			local createElement = Roact.createElement
			local v10 = {
				CanvasSize = data.canvasSizeBinding,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollingEnabled = enableNavigation and v6,
				[Roact.Ref] = forwardRef,
				[Roact.Change.CanvasPosition] = adaptiveScrolling.onCanvasPositionChanged
			}
			local children = {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 20),
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				UIListLayout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 10),
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					[Roact.Change.AbsoluteContentSize] = data.onContentSizeChanged
				}),
				BodyWrappers = Roact.createElement(fitFrameVertical, {
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SelectionGroup = true,
					BackgroundTransparency = 1,
					LayoutOrder = 1
				}, {
					BodyTypeWrapper = Roact.createElement(module2, {
						lockNavigationCallback = data.props.lockNavigationCallback,
						unlockNavigationCallback = data.props.unlockNavigationCallback,
						enableNavigation = data.props.enableNavigation,
						layoutOrder = 1,
						isDisabled = v7,
						[Roact.Ref] = data.bodyTypeRadarRef
					}),
					BodySizeWrapper = Roact.createElement(module3, {
						lockNavigationCallback = data.props.lockNavigationCallback,
						unlockNavigationCallback = data.props.unlockNavigationCallback,
						enableNavigation = data.props.enableNavigation,
						layoutOrder = 2,
						isDisabled = v7,
						[Roact.Ref] = data.bodySizeRadarRef
					})
				}),
				HeadSizeWrapper = 0,
				R6R15Wrapper = 0
			}

			local createElement6 = Roact.createElement
			local v16 = {
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 11),
				margin = roactFitComponents.Rect.quad(0, 0, 24, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				BackgroundTransparency = 1,
				LayoutOrder = 3
			}

			local createElement7 = Roact.createElement
			local v18 = {
				Size = UDim2.new(1, 0, 0, v8),
				BackgroundTransparency = 1,
				Text = p2.headSize,
				TextSize = v8,
				TextColor3 = theme.TextDefault.Color,
				TextTransparency = theme.TextDefault.TextTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				Font = if not foundationFontFaceMigration then font2 else nil,
				FontFace = 0
			}

			local v20 = if foundationFontFaceMigration then normalizeFontFace(data2.Tokens.Typography.TitleLarge.Font) else nil
			v18.FontFace = v20
			children.HeadSizeWrapper = createElement6(fitFrameVertical, v16, {
				HeadSizeLabel = createElement7("TextLabel", v18),
				HeadSize = Roact.createElement(v5, {
					LayoutOrder = 2,
					lockNavigationCallback = lockNavigationCallback,
					unlockNavigationCallback = unlockNavigationCallback,
					isDisabled = v7,
					[Roact.Ref] = data.headSizeSliderRef
				})
			})

			local createElement9 = Roact.createElement
			local v23 = {
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 11),
				margin = roactFitComponents.Rect.quad(0, 0, 24, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				BackgroundTransparency = 1,
				LayoutOrder = 4
			}

			local createElement10 = Roact.createElement
			local v25 = {
				Size = UDim2.new(1, 0, 0, v8),
				BackgroundTransparency = 1,
				Text = p2.r6R15,
				TextSize = v8,
				TextColor3 = theme.TextDefault.Color,
				TextTransparency = theme.TextDefault.TextTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				Font = 0,
				FontFace = 0
			}

			if foundationFontFaceMigration then
				font2 = nil
			end

			v25.Font = font2

			local v26 = if foundationFontFaceMigration then normalizeFontFace(data2.Tokens.Typography.TitleLarge.Font) else nil
			v25.FontFace = v26
			children.R6R15Wrapper = createElement9(fitFrameVertical, v23, {
				R6R15Label = createElement10("TextLabel", v25),
				AvatarTypeSwitch = Roact.createElement(module4, {
					LayoutOrder = 2,
					[Roact.Ref] = data.avatarTypeSwitchRef
				})
			})
			return createElement("ScrollingFrame", v10, children)
		end)
	end)
end

local function mapStateToProps(p2, p3)
	return { avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType }
end

local v6 = withAdaptiveScrolling((RoactRodux.connect(mapStateToProps)(extended)))

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v6, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
