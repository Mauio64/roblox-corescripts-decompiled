local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical

local withStyle = UIBlox.Style.withStyle
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module = require("@luauforge/deferred/heu")
local module2 = require("@luauforge/deferred/hex")
local module3 = require("@luauforge/deferred/hez")
local module4 = require("@luauforge/deferred/heA")
require("@luauforge/bundled/dKT")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module6 = require("@luauforge/bundled/dRg")
local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling

local extended = Roact.PureComponent:extend("ScalesPage")

function extended:init()
	local binding, v5 = Roact.createBinding(UDim2.new(0, 0, 1, 0))
	self.canvasSizeBinding = binding
	self.updateCanvasSizeBinding = v5

	function self.onContentSizeChanged(p3)
		local v6 = p3.AbsoluteContentSize.Y + 20
		self.updateCanvasSizeBinding(UDim2.new(0, 0, 0, v6))
	end

	self.bodyTypeRadarRef = Roact.createRef()
	self.bodySizeRadarRef = Roact.createRef()
	self.headSizeSliderRef = Roact.createRef()
	self.avatarTypeSwitchRef = Roact.createRef()
end

function extended.render(data)
	local adaptiveScrolling = data.props.adaptiveScrolling or {}

	local v5 = not adaptiveScrolling.scrollingEnabledBinding
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
			local v6 = data.props.avatarType == module6.AvatarType.R6

			local font = data2.Font
			local theme = data2.Theme
			local v7 = font.BaseSize * font.Header2.RelativeSize

			local forwardRef = data.props.forwardRef

			return Roact.createElement("ScrollingFrame", {
				CanvasSize = data.canvasSizeBinding,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollingEnabled = enableNavigation and v5,
				[Roact.Ref] = forwardRef,
				[Roact.Change.CanvasPosition] = adaptiveScrolling.onCanvasPositionChanged
			}, {
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
					BodyTypeWrapper = Roact.createElement(module, {
						lockNavigationCallback = data.props.lockNavigationCallback,
						unlockNavigationCallback = data.props.unlockNavigationCallback,
						enableNavigation = data.props.enableNavigation,
						layoutOrder = 1,
						isDisabled = v6,
						[Roact.Ref] = data.bodyTypeRadarRef
					}),
					BodySizeWrapper = Roact.createElement(module2, {
						lockNavigationCallback = data.props.lockNavigationCallback,
						unlockNavigationCallback = data.props.unlockNavigationCallback,
						enableNavigation = data.props.enableNavigation,
						layoutOrder = 2,
						isDisabled = v6,
						[Roact.Ref] = data.bodySizeRadarRef
					})
				}),
				HeadSizeWrapper = Roact.createElement(fitFrameVertical, {
					width = UDim.new(1, 0),
					contentPadding = UDim.new(0, 11),
					margin = roactFitComponents.Rect.quad(0, 0, 24, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					BackgroundTransparency = 1,
					LayoutOrder = 3
				}, {
					HeadSizeLabel = Roact.createElement("TextLabel", {
						Size = UDim2.new(1, 0, 0, v7),
						BackgroundTransparency = 1,
						Text = p2.headSize,
						TextSize = v7,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.TextTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						LayoutOrder = 1,
						FontFace = normalizeFontFace(data2.Tokens.Typography.TitleLarge.Font)
					}),
					HeadSize = Roact.createElement(module3, {
						LayoutOrder = 2,
						lockNavigationCallback = lockNavigationCallback,
						unlockNavigationCallback = unlockNavigationCallback,
						isDisabled = v6,
						[Roact.Ref] = data.headSizeSliderRef
					})
				}),
				R6R15Wrapper = Roact.createElement(fitFrameVertical, {
					width = UDim.new(1, 0),
					contentPadding = UDim.new(0, 11),
					margin = roactFitComponents.Rect.quad(0, 0, 24, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					BackgroundTransparency = 1,
					LayoutOrder = 4
				}, {
					R6R15Label = Roact.createElement("TextLabel", {
						Size = UDim2.new(1, 0, 0, v7),
						BackgroundTransparency = 1,
						Text = p2.r6R15,
						TextSize = v7,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.TextTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						LayoutOrder = 1,
						FontFace = normalizeFontFace(data2.Tokens.Typography.TitleLarge.Font)
					}),
					AvatarTypeSwitch = Roact.createElement(module4, {
						LayoutOrder = 2,
						[Roact.Ref] = data.avatarTypeSwitchRef
					})
				})
			})
		end)
	end)
end

local function mapStateToProps(p2, p3)
	return { avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType }
end

local v5 = withAdaptiveScrolling((RoactRodux.connect(mapStateToProps)(extended)))

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v5, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
