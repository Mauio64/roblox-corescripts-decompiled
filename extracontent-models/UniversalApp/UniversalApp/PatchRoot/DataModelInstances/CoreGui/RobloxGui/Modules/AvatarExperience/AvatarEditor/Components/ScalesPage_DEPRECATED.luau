local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactFitComponents = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local FFlagAXFixBodyScaleReduxUpdates = require(Modules.AvatarExperience.Flags.FFlagAXFixBodyScaleReduxUpdates)
local BodyTypeRadar = require(Modules.AvatarExperience.AvatarEditor.Components.BodyTypeRadar)
local BodySizeRadar = require(Modules.AvatarExperience.AvatarEditor.Components.BodySizeRadar)
local v14 = if not FFlagAXFixBodyScaleReduxUpdates then require(Modules.AvatarExperience.AvatarEditor.Components.HeadSlider_DEPRECATED) else require(Modules.AvatarExperience.AvatarEditor.Components.HeadSlider)
local AvatarTypeSwitch = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarTypeSwitch)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling
local v19 = Roact.PureComponent:extend("ScalesPage")

function v19.init(p1) -- line: 36
	-- upvalues: Roact (copy)
	local v23, v24 = Roact.createBinding(UDim2.new(0, 0, 1, 0))

	p1.canvasSizeBinding = v23
	p1.updateCanvasSizeBinding = v24

	function p1.onContentSizeChanged(p2) -- line: 39
		-- upvalues: p1 (copy)
		local v33 = p2.AbsoluteContentSize.Y + 20

		p1.updateCanvasSizeBinding(UDim2.new(0, 0, 0, v33))
	end

	p1.bodyTypeRadarRef = Roact.createRef()
	p1.bodySizeRadarRef = Roact.createRef()
	p1.headSizeSliderRef = Roact.createRef()
	p1.avatarTypeSwitchRef = Roact.createRef()
end
function v19.render(p3) -- line: 51
	-- upvalues: withStyle (copy), withLocalization (copy), Constants (copy), Roact (copy), FitFrameVertical (copy), BodyTypeRadar (copy), BodySizeRadar (copy), RoactFitComponents (copy), v14 (copy), AvatarTypeSwitch (copy)
	local v26 = p3.props.adaptiveScrolling or {}
	local v27 = not v26.scrollingEnabledBinding or v26.scrollingEnabledBinding:map(function(p4) -- line: 55
		return p4
	end)

	return withStyle(function(p5) -- line: 60
		-- upvalues: withLocalization (copy), p3 (copy), Constants (copy), Roact (copy), v27 (copy), v26 (copy), FitFrameVertical (copy), BodyTypeRadar (copy), BodySizeRadar (copy), RoactFitComponents (copy), v14 (copy), AvatarTypeSwitch (copy)
		return withLocalization({
			headSize = "Feature.Avatar.Label.HeadSize",
			r6R15 = "Feature.Avatar.Label.R6R15"
		})(function(p6) -- line: 64
			-- upvalues: p3 (copy), Constants (copy), p5 (copy), Roact (copy), v27 (copy), v26 (copy), FitFrameVertical (copy), BodyTypeRadar (copy), BodySizeRadar (copy), RoactFitComponents (copy), v14 (copy), AvatarTypeSwitch (copy)
			local lockNavigationCallback = p3.props.lockNavigationCallback
			local unlockNavigationCallback = p3.props.unlockNavigationCallback
			local enableNavigation = p3.props.enableNavigation
			local v40 = p3.props.avatarType == Constants.AvatarType.R6
			local p5Font = p5.Font
			local Theme = p5.Theme
			local Header2Font = p5Font.Header2.Font
			local v44 = p5Font.BaseSize * p5Font.Header2.RelativeSize
			local forwardRef = p3.props.forwardRef

			return Roact.createElement("ScrollingFrame", {
				CanvasSize = p3.canvasSizeBinding,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollingEnabled = enableNavigation and v27,
				[Roact.Ref] = forwardRef,
				[Roact.Change.CanvasPosition] = v26.onCanvasPositionChanged
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
					[Roact.Change.AbsoluteContentSize] = p3.onContentSizeChanged
				}),
				BodyWrappers = Roact.createElement(FitFrameVertical, {
					SelectionGroup = true,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}, {
					BodyTypeWrapper = Roact.createElement(BodyTypeRadar, {
						lockNavigationCallback = p3.props.lockNavigationCallback,
						unlockNavigationCallback = p3.props.unlockNavigationCallback,
						enableNavigation = p3.props.enableNavigation,
						layoutOrder = 1,
						isDisabled = v40,
						[Roact.Ref] = p3.bodyTypeRadarRef
					}),
					BodySizeWrapper = Roact.createElement(BodySizeRadar, {
						lockNavigationCallback = p3.props.lockNavigationCallback,
						unlockNavigationCallback = p3.props.unlockNavigationCallback,
						enableNavigation = p3.props.enableNavigation,
						layoutOrder = 2,
						isDisabled = v40,
						[Roact.Ref] = p3.bodySizeRadarRef
					})
				}),
				HeadSizeWrapper = Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					width = UDim.new(1, 0),
					contentPadding = UDim.new(0, 11),
					margin = RoactFitComponents.Rect.quad(0, 0, 24, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}, {
					HeadSizeLabel = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, v44),
						Text = p6.headSize,
						TextSize = v44,
						TextColor3 = Theme.TextDefault.Color,
						TextTransparency = Theme.TextDefault.TextTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						Font = Header2Font
					}),
					HeadSize = Roact.createElement(v14, {
						LayoutOrder = 2,
						lockNavigationCallback = lockNavigationCallback,
						unlockNavigationCallback = unlockNavigationCallback,
						isDisabled = v40,
						[Roact.Ref] = p3.headSizeSliderRef
					})
				}),
				R6R15Wrapper = Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					width = UDim.new(1, 0),
					contentPadding = UDim.new(0, 11),
					margin = RoactFitComponents.Rect.quad(0, 0, 24, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}, {
					R6R15Label = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, v44),
						Text = p6.r6R15,
						TextSize = v44,
						TextColor3 = Theme.TextDefault.Color,
						TextTransparency = Theme.TextDefault.TextTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						Font = Header2Font
					}),
					AvatarTypeSwitch = Roact.createElement(AvatarTypeSwitch, {
						LayoutOrder = 2,
						[Roact.Ref] = p3.avatarTypeSwitchRef
					})
				})
			})
		end)
	end)
end

local function mapStateToProps(p7, _) -- line: 194
	return {
		avatarType = p7.AvatarExperience.AvatarEditor.Character.AvatarType
	}
end

local u21 = withAdaptiveScrolling((RoactRodux.connect(mapStateToProps)(v19)))

return Roact.forwardRef(function(p9, p10) -- line: 204
	-- upvalues: Roact (copy), u21 (ref), Cryo (copy)
	return Roact.createElement(u21, Cryo.Dictionary.join(p9, {
		forwardRef = p10
	}))
end)
