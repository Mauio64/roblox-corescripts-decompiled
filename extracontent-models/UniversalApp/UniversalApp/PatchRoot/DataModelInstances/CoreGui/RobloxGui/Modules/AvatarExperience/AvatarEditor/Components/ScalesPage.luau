local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local RoactFitComponents = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local useTokens = Foundation.Hooks.useTokens
local useSlotItemCardBreakpoints = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Hooks.useSlotItemCardBreakpoints
local FFlagAXFixBodyScaleReduxUpdates = require(Modules.AvatarExperience.Flags.FFlagAXFixBodyScaleReduxUpdates)
local BodyTypeRadar = require(Modules.AvatarExperience.AvatarEditor.Components.BodyTypeRadar)
local BodySizeRadar = require(Modules.AvatarExperience.AvatarEditor.Components.BodySizeRadar)
local v16 = if not FFlagAXFixBodyScaleReduxUpdates then require(Modules.AvatarExperience.AvatarEditor.Components.HeadSlider_DEPRECATED) else require(Modules.AvatarExperience.AvatarEditor.Components.HeadSlider)
local AvatarTypeSwitch = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarTypeSwitch)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling

local function selectAvatarType(p1) -- line: 36
	return p1.AvatarExperience.AvatarEditor.Character.AvatarType
end
local function ScalesPage(t1: {[any]: any}, p2) -- line: 52
	-- upvalues: useTokens (copy), useAdaptiveScrolling (copy), useIsSpatial (copy), useSlotItemCardBreakpoints (copy), React (copy), useLocalization (copy), useSelector (copy), selectAvatarType (copy), Constants (copy), FitFrameVertical (copy), BodyTypeRadar (copy), BodySizeRadar (copy), RoactFitComponents (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v16 (copy), AvatarTypeSwitch (copy)
	local v26 = useTokens()
	local v27 = useAdaptiveScrolling()
	local v28 = useIsSpatial()
	local v29 = useSlotItemCardBreakpoints()
	local v30, v31 = React.useBinding(UDim2.new(0, 0, 1, 0))
	local v32 = React.useRef(nil)
	local v33 = React.useRef(nil)
	local v34 = React.useRef(nil)
	local v35 = React.useRef(nil)
	local v36 = useLocalization({
		headSize = "Feature.Avatar.Label.HeadSize",
		r6R15 = "Feature.Avatar.Label.R6R15"
	})
	local v37 = useSelector(selectAvatarType) == Constants.AvatarType.R6
	local Size_250 = v26.Size.Size_250
	local TitleLarge = v26.Typography.TitleLarge
	local v40 = not v27 or (not v27.scrollingEnabledBinding or v27.scrollingEnabledBinding)
	local v41 = React.useCallback(function(p3) -- line: 82
		-- upvalues: v28 (copy), v29 (copy), Size_250 (copy), v31 (copy)
		local v44 = not v28 and 0 or v29.slotCardTotalHeight
		local v45 = Size_250 * 2
		local v46 = p3.AbsoluteContentSize.Y + v45 + v44

		v31(UDim2.new(0, 0, 0, v46))
	end, {
		v31,
		Size_250,
		v28,
		v29
	})

	local function onScrollingFrameCanvasPositionChanged(p4) -- line: 97
		-- upvalues: t1 (copy), v27 (copy)
		if t1.onCanvasPositionChanged then
			t1.onCanvasPositionChanged(p4)
		end

		if v27 and v27.onCanvasPositionChanged then
			v27.onCanvasPositionChanged(p4)
		end
	end

	return React.createElement("ScrollingFrame", {
		CanvasSize = v30,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = not not t1.enableNavigation and v40,
		ref = p2,
		[React.Change.CanvasPosition] = onScrollingFrameCanvasPositionChanged
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, Size_250 * 2),
			PaddingLeft = UDim.new(0, v26.Size.Size_600),
			PaddingRight = UDim.new(0, v26.Size.Size_600)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, Size_250),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			[React.Change.AbsoluteContentSize] = v41
		}),
		BodyWrappers = React.createElement(FitFrameVertical, {
			SelectionGroup = true,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			width = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}, {
			BodyTypeWrapper = React.createElement(BodyTypeRadar, {
				layoutOrder = 1,
				lockNavigationCallback = t1.lockNavigationCallback,
				unlockNavigationCallback = t1.unlockNavigationCallback,
				enableNavigation = t1.enableNavigation,
				isDisabled = v37,
				ref = v32
			}),
			BodySizeWrapper = React.createElement(BodySizeRadar, {
				layoutOrder = 2,
				lockNavigationCallback = t1.lockNavigationCallback,
				unlockNavigationCallback = t1.unlockNavigationCallback,
				enableNavigation = t1.enableNavigation,
				isDisabled = v37,
				ref = v33
			})
		}),
		HeadSizeWrapper = React.createElement(FitFrameVertical, {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, v26.Size.Size_300),
			margin = RoactFitComponents.Rect.quad(0, 0, v26.Size.Size_600, 0),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}, {
			HeadSizeLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, TitleLarge.FontSize),
				Text = v36.headSize,
				TextSize = TitleLarge.FontSize,
				TextColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v26.Semantic.Color.Text.Default else v26.Color.Content.Default)).Color3,
				TextTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v26.Semantic.Color.Text.Default else v26.Color.Content.Default)).Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = TitleLarge.Font
			}),
			HeadSize = React.createElement(v16, {
				LayoutOrder = 2,
				lockNavigationCallback = t1.lockNavigationCallback,
				unlockNavigationCallback = t1.unlockNavigationCallback,
				isDisabled = v37,
				ref = v34
			})
		}),
		R6R15Wrapper = React.createElement(FitFrameVertical, {
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, v26.Size.Size_300),
			margin = RoactFitComponents.Rect.quad(0, 0, v26.Size.Size_600, 0),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}, {
			R6R15Label = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, TitleLarge.FontSize),
				Text = v36.r6R15,
				TextSize = TitleLarge.FontSize,
				TextColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v26.Semantic.Color.Text.Default else v26.Color.Content.Default)).Color3,
				TextTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v26.Semantic.Color.Text.Default else v26.Color.Content.Default)).Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = TitleLarge.Font
			}),
			AvatarTypeSwitch = React.createElement(AvatarTypeSwitch, {
				LayoutOrder = 2,
				ref = v35
			})
		})
	})
end

return React.memo(React.forwardRef(ScalesPage))
