local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SignalsExperimental = require(CorePackages.Packages.SignalsExperimental)
require("@luauforge/bundled/dHK")

require("@luauforge/bundled/dMc")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXColorAdjustmentButtonShouldAccountForTryOns = AvatarExperienceFlags.FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local fFlagAXUseSignalsForBodyColorPickerSettings = AvatarExperienceFlags.FFlagAXUseSignalsForBodyColorPickerSettings
local fFlagAXFixBodyColorButtonStaleRanges = AvatarExperienceFlags.FFlagAXFixBodyColorButtonStaleRanges
local v5

if fFlagAXUseSignalsForBodyColorPickerSettings then
	v5 = require("@luauforge/bundled/gOv")
else
	v5 = nil
end

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local v6

if fFlagAXColorAdjustmentButtonShouldAccountForTryOns then
	v6 = AvatarExperienceCommon.State.Selectors.selectAvatarPreviewColors
else
	v6 = require("@luauforge/bundled/gOy")
end

local module3 = require("@luauforge/deferred/gOA")
local module4 = require("@luauforge/bundled/dNQ")
local module5 = require("@luauforge/bundled/dMx")
local module6 = require("@luauforge/bundled/fuD")
local module7 = require("@luauforge/bundled/fvh")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local gridMetrics = UIBlox.App.Grid.GridMetrics
local radioButtonList = UIBlox.App.InputButton.RadioButtonList
local defaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local module8 = require("@luauforge/deferred/gOH")
local module9 = require("@luauforge/bundled/dPn")
local module10 = require("@luauforge/bundled/dNU")
local module11 = require("@luauforge/bundled/dPq")

local module12 = require("@luauforge/deferred/gOD")

local module13 = require("@luauforge/deferred/gOE")
local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling

local module14 = require("@luauforge/deferred/gOK")
local fFlagAXAdaptiveScrollingFixForward = AvatarExperienceFlags.FFlagAXAdaptiveScrollingFixForward
local module15 = require("@luauforge/bundled/dOc")

local extended = Roact.PureComponent:extend("BodyColorsFrame")

local shimmerColorCardsToDisplay = module4.ShimmerColorCardsToDisplay
local v7 = table.create(shimmerColorCardsToDisplay, {})

local v8 = { minimumItemsPerRow = 5, minimumItemWidth = 60 }

local strictInterface = t.strictInterface
local v9 = {
	Size = t.UDim2,
	NextSelectionUp = t.optional(t.table),
	viewSetting = t.string,
	rangeIdForSelectedBodyParts = t.optional(t.string),
	defaultBodyColorRanges = t.table,
	bodyColor3s = t.table,
	bodyPartRangeIds = t.table,
	selectedBodyPartIndex = t.number,
	setViewSetting = t.callback,
	setBodyPartRangeIds = t.callback,
	setSelectedBodyPartIndex = t.callback,
	adaptiveScrolling = t.optional(t.any),
	onContentScroll = 0,
	LayoutOrder = 0,
	PaddingBottom = 0,
	PaddingTop = 0,
	PaddingLeft = 0,
	PaddingRight = 0,
	ref = 0
}
local v10 = if module15() then t.optional(t.any) else nil
v9.onContentScroll = v10
v9.LayoutOrder = t.optional(t.number)
v9.PaddingBottom = t.optional(t.UDim)
v9.PaddingTop = t.optional(t.UDim)
v9.PaddingLeft = t.optional(t.UDim)
v9.PaddingRight = t.optional(t.UDim)
local v11 = if module14 then t.optional(t.table) else nil
v9.ref = v11
extended.validateProps = strictInterface(v9)

function extended:init()
	self:setState({ bodyColorsFrameHeight = 0, bodyPartsListHeight = 0 })

	function self.renderItem(p2)
		if not p2.rangeId then
			return self:getShimmerPanel()
		end

		local createElement = Roact.createElement
		local v13 = { rangeId = p2.rangeId, defaultBodyColorRanges = 0 }

		local v14 = if fFlagAXUseSignalsForBodyColorPickerSettings and fFlagAXFixBodyColorButtonStaleRanges then self.props.defaultBodyColorRanges else nil
		v13.defaultBodyColorRanges = v14
		return createElement(module3, v13)
	end

	function self.onScroll(p2)
		if self.props.adaptiveScrolling then
			self.props.adaptiveScrolling.onCanvasPositionChanged(p2)
		end

		if self.props.onContentScroll then
			self.props.onContentScroll(p2)
		end
	end

	local binding, v12 = Roact.createBinding(UDim2.new(0, 0, 1, 0))
	self.canvasSizeBinding = binding
	self.updateCanvasSizeBinding = v12
	local binding2, v13 = Roact.createBinding(0)
	self.bodyPartsListHeightBinding = binding2
	self.updateBodyPartsListHeightBinding = v13
	local binding3, v14 = Roact.createBinding(0)
	self.bodyColorsFrameHeightBinding = binding3
	self.updateBodyColorsFrameHeightBinding = v14

	function self.onUIListLayoutContentSizeChanged(p2)
		local v15 = module4.SkinColorGridPadding * 2
		local v16 = p2.AbsoluteContentSize.Y + v15
		self.updateCanvasSizeBinding(UDim2.new(0, 0, 0, v16))
	end

	function self.onBodyPartsListAbsoluteSizeChanged(p2)
		self.updateBodyPartsListHeightBinding(p2.AbsoluteSize.Y)
	end

	function self.onBodyColorsFrameAbsoluteSizeChanged(p2)
		self.updateBodyColorsFrameHeightBinding(p2.AbsoluteSize.Y)
	end

	self:setSelectedBodyPartIndex(1)
end

function extended.setSelectedBodyPartIndex(p2, p3)
	p2.props.setSelectedBodyPartIndex(p3)
end

function extended:getShimmerPanel()
	return Roact.createElement(skeleton, { Size = UDim2.new(1, 0, 1, 0) })
end

function extended:getItems()
	local defaultBodyColorRanges = self.props.defaultBodyColorRanges
	return defaultBodyColorRanges and #defaultBodyColorRanges > 0 and defaultBodyColorRanges or v7
end

function extended.getBodyPartsListHeight(p2)
	if p2.props.viewSetting == module4.ColorPickerViewSettings.AdvancedView then
		return p2.state.bodyPartsListHeight
	end

	return 0
end

function extended:getGridAndSidebarFrameSize()
	if self:shouldRenderSliderBar() then
		return Roact.joinBindings({
			self.canvasSizeBinding,
			self.bodyPartsListHeightBinding,
			self.bodyColorsFrameHeightBinding
		}):map(function(list)
			local offset = list[1].Y.Offset
			local item = list[2]
			local item2 = list[3]

			local v12 = self.props.viewSetting ~= module4.ColorPickerViewSettings.AdvancedView and 0 or item

			local bodyColorsSliderFrameHeight = module7.getBodyColorsSliderFrameHeight(
				module4.BodyColorsSliderFrameHeight,
				offset,
				item2,
				v12
			)

			return UDim2.new(1, 0, 1, -bodyColorsSliderFrameHeight)
		end)
	end

	return self.props.Size
end

function extended:renderBodyColorButtons(p3, p4)
	return Roact.createElement(defaultMetricsGridView, {
		renderItem = self.renderItem,
		getItemHeight = module6.GridItemHeightGetter(module5.ItemTileType.BodyColorButton),
		getItemMetrics = gridMetrics.makeCustomMetricsGetter(v8),
		itemPadding = Vector2.new(10, 10),
		items = p3,
		maxHeight = 1e999,
		defaultChildIndex = 1
	})
end

function extended:renderToggleButton(p3, props, callback, p4)
	local createElement = Roact.createElement
	local v13 = {}
	v13.AnchorPoint = Vector2.new(1, 0)
	v13.BackgroundTransparency = 1
	v13.LayoutOrder = 2
	v13.Position = UDim2.fromScale(1, 0)
	v13.Size = UDim2.new(0, 100, 0, 30)
	v13.Text = p3
	local v14 = if not foundationFontFaceMigration then props.Font.Header2.Font else nil
	v13.Font = v14

	local v15 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.TitleLarge.Font) else nil
	v13.FontFace = v15

	v13.AutomaticSize = Enum.AutomaticSize.X
	v13.TextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize
	v13.TextColor3 = props.Theme.TextEmphasis.Color
	v13.SelectionImageObject = callback(cursorKind.RoundedRect)
	v13[Roact.Event.Activated] = p4
	return createElement("TextButton", v13)
end

function extended:renderUIListLayout()
	return Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 20),
		[Roact.Change.AbsoluteContentSize] = self.onUIListLayoutContentSizeChanged
	})
end

function extended:renderUIPadding()
	local createElement = Roact.createElement
	local v14 = if self.props.PaddingTop then self.props.PaddingTop else UDim.new(0, module4.SkinColorGridPadding)
	local v15 = if self.props.PaddingBottom then self.props.PaddingBottom else UDim.new(0, module4.SkinColorGridPadding)
	local v16 = if self.props.PaddingLeft then self.props.PaddingLeft else UDim.new(0, module4.SkinColorGridPadding)
	local v17 = if self.props.PaddingRight then self.props.PaddingRight else UDim.new(0, module4.SkinColorGridPadding)
	return createElement("UIPadding", {
		PaddingTop = v14,
		PaddingBottom = v15,
		PaddingLeft = v16,
		PaddingRight = v17
	})
end

function extended:renderBodyPartsList(p2)
	local v12 = {}

	for i = 1, #module4.BodyPartButtonData do
		table.insert(v12, {
			label = p2["bodyPart" .. i]
		})
	end

	local selectedBodyPartIndex = self.props.selectedBodyPartIndex

	local createElement = Roact.createElement
	local onBodyPartsListAbsoluteSizeChangedsByAbsoluteSize = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromOffset(150, 0),
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = self.onBodyPartsListAbsoluteSizeChanged
	}

	local createElement2 = Roact.createElement
	local v16 = if self.props.PaddingTop then self.props.PaddingTop else UDim.new(0, module4.SkinColorGridPadding)
	local v17 = if self.props.PaddingBottom then self.props.PaddingBottom else UDim.new(0, module4.SkinColorGridPadding)
	return createElement("Frame", onBodyPartsListAbsoluteSizeChangedsByAbsoluteSize, {
		UIPadding = createElement2("UIPadding", {
			PaddingTop = v16,
			PaddingBottom = v17
		}),
		BodyPartRadioButtons = Roact.createElement(radioButtonList, {
			radioButtons = v12,
			onActivated = function(p3)
				self:setSelectedBodyPartIndex(p3)
			end,
			initialValue = selectedBodyPartIndex,
			elementSize = UDim2.new(1, -10, 0, 25),
			automaticSize = true,
			padding = UDim.new(0, 10)
		})
	})
end

function extended:renderStandardView()
	local adaptiveScrolling = self.props.adaptiveScrolling or {}
	return withStyle(function(p2)
		return withSelectionCursorProvider(function(p3)
			return withLocalization({
				buttonText = "Feature.Avatar.Label.BodyColorAdvancedView"
			})(function(p4)
				local items = self:getItems()

				local setViewSetting = self.props.setViewSetting

				local createElement = Roact.createElement
				local v13 = {
					BackgroundTransparency = 1,
					["CanvasSize"] = self.canvasSizeBinding,
					ScrollBarThickness = 0,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					Size = self:getGridAndSidebarFrameSize()
				}
				local v14

				if adaptiveScrolling.scrollingEnabledBinding then
					v14 = adaptiveScrolling.scrollingEnabledBinding:map(function(p5)
						return p5
					end)
				else
					v14 = fFlagAXAdaptiveScrollingFixForward and true or adaptiveScrolling.scrollingEnabled
				end

				v13.ScrollingEnabled = v14

				v13.Selectable = false
				local canvasPosition = Roact.Change.CanvasPosition
				local v15 = if module15() then self.onScroll else adaptiveScrolling.onCanvasPositionChanged
				v13[canvasPosition] = v15
				return createElement("ScrollingFrame", v13, {
					UIListLayout = self:renderUIListLayout(),
					UIPadding = self:renderUIPadding(),
					BodyColorButtons = self:renderBodyColorButtons(items),
					AdvancedViewButton = self:renderToggleButton(p4.buttonText, p2, p3, function()
						setViewSetting(module4.ColorPickerViewSettings.AdvancedView)
					end)
				})
			end)
		end)
	end)
end

function extended:renderAdvancedView()
	local adaptiveScrolling = self.props.adaptiveScrolling or {}
	return withStyle(function(p2)
		return withSelectionCursorProvider(function(p3)
			local textKeys = {
				standardButtonText = "Feature.Avatar.Label.BodyColorStandardView"
			}

			for k, v12 in module4.BodyPartButtonData do
				textKeys["bodyPart" .. k] = module4.BodyPartButtonData[k].textKey
			end

			return withLocalization(textKeys)(function(p4)
				local items = self:getItems()
				local gridAndSidebarFrameSize = self:getGridAndSidebarFrameSize()
				local setViewSetting = self.props.setViewSetting

				local createElement = Roact.createElement
				local v13 = {}
				v13.BackgroundTransparency = 1
				v13.Size = gridAndSidebarFrameSize
				v13.CanvasSize = self.canvasSizeBinding
				v13.ScrollBarThickness = 0
				v13.ScrollingDirection = Enum.ScrollingDirection.Y
				v13.Position = UDim2.fromScale(0, 0)
				v13.AutomaticCanvasSize = Enum.AutomaticSize.Y
				v13.Selectable = false
				local v14

				if adaptiveScrolling.scrollingEnabledBinding then
					v14 = adaptiveScrolling.scrollingEnabledBinding:map(function(p5)
						return p5
					end)
				else
					v14 = fFlagAXAdaptiveScrollingFixForward and true or adaptiveScrolling.scrollingEnabled
				end

				v13.ScrollingEnabled = v14

				local canvasPosition = Roact.Change.CanvasPosition
				local v15 = if module15() then self.onScroll else adaptiveScrolling.onCanvasPositionChanged
				v13[canvasPosition] = v15
				return createElement("ScrollingFrame", v13, {
					BodyPartsList = self:renderBodyPartsList(p4),
					BodyColorsGrid = Roact.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 150, 0, 0),
							Size = UDim2.new(1, -150, 1, 0)
						},
						{
							UIPadding = self:renderUIPadding(),
							UIListLayout = self:renderUIListLayout(),
							BodyColorButtons = self:renderBodyColorButtons(items),
							StandardViewButton = self:renderToggleButton(
								p4.standardButtonText,
								p2,
								p3,
								function()
									if fFlagAXUseSignalsForBodyColorPickerSettings then
										SignalsExperimental.batch(function()
											self:setSelectedBodyPartIndex(1)
											setViewSetting(module4.ColorPickerViewSettings.StandardView)
										end)
										return
									end

									self:setSelectedBodyPartIndex(1)
									setViewSetting(module4.ColorPickerViewSettings.StandardView)
								end
							)
						}
					)
				})
			end)
		end)
	end)
end

function extended:shouldRenderSliderBar(): boolean
	if self.props.rangeIdForSelectedBodyParts then
		return true
	end

	return false
end

function extended:render()
	local v12

	if self.props.viewSetting == module4.ColorPickerViewSettings.AdvancedView then
		v12 = self:renderAdvancedView()
	else
		v12 = self:renderStandardView()
	end

	local shouldRenderSliderBar = self:shouldRenderSliderBar()
	local createElement = Roact.createElement
	local ref = Roact.Ref
	local v15 = if module14 then self.props.ref else nil
	local v14 = {
		[ref] = v15,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = self.props.Size,
		Position = UDim2.fromOffset(0, 0),
		Selectable = false,
		[Roact.Change.AbsoluteSize] = self.onBodyColorsFrameAbsoluteSizeChanged,
		LayoutOrder = self.props.LayoutOrder
	}

	local v17 = if shouldRenderSliderBar then Roact.createElement(module8, {
		gridAndSidebarFrameSizeBinding = self:getGridAndSidebarFrameSize(),
		rangeIdForSelectedBodyParts = self.props.rangeIdForSelectedBodyParts,
		defaultBodyColorRanges = self.props.defaultBodyColorRanges
	}) else nil
	return createElement("Frame", v14, {
		BodyColorsView = v12,
		BodyColorsSliderFrame = v17
	})
end

function extended.didMount(p2)
	local bodyColor3s = p2.props.bodyColor3s
	local bodyPartRangeIds = p2.props.bodyPartRangeIds
	local v12 = {}
	local flag = false

	for k, bodyColor3 in bodyColor3s do
		if bodyPartRangeIds[k] == nil then
			local rangeAndSliderValueForColor3, v13 = module7.findRangeAndSliderValueForColor3(
				bodyColor3,
				p2.props.defaultBodyColorRanges
			)
			v12[k] = rangeAndSliderValueForColor3
			flag = true
		else
			v12[k] = bodyPartRangeIds[k]
		end
	end

	if flag then
		p2.props.setBodyPartRangeIds(v12)
	end
end

local v12 = RoactRodux.connect(function(p2, p3)
	local defaultBodyColorRanges = p2.AvatarExperience.AvatarEditor.DefaultBodyColorRanges
	local bodyPartRangeIds = p2.AvatarExperience.AvatarEditor.Character.BodyPartRangeIds
	local selectedBodyPartIndex

	if not fFlagAXUseSignalsForBodyColorPickerSettings then
		selectedBodyPartIndex = p2.AvatarExperience.AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex
	end

	local v13

	if fFlagAXUseSignalsForBodyColorPickerSettings then
		v13 = module13(p2, p3.selectedBodyPartIndex)
	else
		v13 = module12(p2)
	end

	local v15 = if not fFlagAXUseSignalsForBodyColorPickerSettings then p2.AvatarExperience.AvatarEditor.BodyColorPickerSettings.viewSetting else nil
	return {
		viewSetting = v15,
		rangeIdForSelectedBodyParts = v13,
		defaultBodyColorRanges = defaultBodyColorRanges,
		bodyColor3s = v6(p2),
		bodyPartRangeIds = bodyPartRangeIds,
		selectedBodyPartIndex = selectedBodyPartIndex
	}
end, function(callback)
	return {
		setViewSetting = function(p2)
			if fFlagAXUseSignalsForBodyColorPickerSettings then
				v5(false).setBodyColorViewSetting(p2)
			else
				callback(module9(p2))
			end
		end,
		setBodyPartRangeIds = function(p2)
			callback(module10(p2))
		end,
		setSelectedBodyPartIndex = function(p2)
			if fFlagAXUseSignalsForBodyColorPickerSettings then
				v5(false).setSelectedBodyPartIndex(p2)
			else
				callback(module11(p2))
			end
		end
	}
end)(extended)

local function BodyColorsFrameWithSignals(p2)
	local v13 = v5(false)
	local v14 = useSignalState(v13.getViewSetting)
	local v15 = useSignalState(v13.getSelectedBodyPartIndex)
	return React.createElement(
		v12,
		Cryo.Dictionary.union(p2, { viewSetting = v14, selectedBodyPartIndex = v15 })
	)
end

local v13

if fFlagAXUseSignalsForBodyColorPickerSettings then
	v13 = React.memo(BodyColorsFrameWithSignals)
else
	v13 = v12
end

return (withAdaptiveScrolling(v13))
