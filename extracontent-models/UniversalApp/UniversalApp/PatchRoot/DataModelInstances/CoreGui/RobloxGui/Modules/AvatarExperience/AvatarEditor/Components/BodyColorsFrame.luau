local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXColorAdjustmentButtonShouldAccountForTryOns = AvatarExperienceFlags.FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local v9 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then require(Modules.AvatarExperience.Common.Selectors.selectAvatarPreviewColors) else AvatarExperienceCommon.State.Selectors.selectAvatarPreviewColors
local BodyColorButton = require(Modules.AvatarExperience.AvatarEditor.Components.BodyColorButton)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local GridMetrics = UIBlox.App.Grid.GridMetrics
local RadioButtonList = UIBlox.App.InputButton.RadioButtonList
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local BodyColorsSliderFrame = require(Modules.AvatarExperience.AvatarEditor.Components.BodyColorsSliderFrame)
local SetBodyColorViewSetting = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyColorViewSetting)
local SetBodyPartRangeIds = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyPartRangeIds)
local SetSelectedBodyPartIndex = require(Modules.AvatarExperience.AvatarEditor.Actions.SetSelectedBodyPartIndex)
local selectRangeIdForSelectedBodyParts = require(Modules.AvatarExperience.AvatarEditor.Selectors.selectRangeIdForSelectedBodyParts)
local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling
local FFlagAXFixColorAdjustmentGamepadSupport = require(Modules.AvatarExperience.Flags.FFlagAXFixColorAdjustmentGamepadSupport)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXAdaptiveScrollingFixForward = AvatarExperienceFlags.FFlagAXAdaptiveScrollingFixForward
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local v35 = Roact.PureComponent:extend("BodyColorsFrame")
local ShimmerColorCardsToDisplay = Constants.ShimmerColorCardsToDisplay
local t1 = table.create(ShimmerColorCardsToDisplay, {})
local t2 = {
	minimumItemsPerRow = 5,
	minimumItemWidth = 60
}

v35.validateProps = t.strictInterface({
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
	onContentScroll = if not GetFFlagAXEnableSlotBasedEditor() then nil else t.optional(t.any),
	LayoutOrder = t.optional(t.number),
	PaddingBottom = t.optional(t.UDim),
	PaddingTop = t.optional(t.UDim),
	PaddingLeft = t.optional(t.UDim),
	PaddingRight = t.optional(t.UDim),
	ref = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else t.optional(t.table)
})

function v35.init(p1) -- line: 99
	-- upvalues: Roact (copy), BodyColorButton (copy), Constants (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	p1:setState({
		bodyColorsFrameHeight = 0,
		bodyPartsListHeight = 0
	})

	function p1.renderItem(p2) -- line: 105
		-- upvalues: Roact (copy), BodyColorButton (copy), p1 (copy)
		if p2.rangeId then
			return Roact.createElement(BodyColorButton, {
				rangeId = p2.rangeId
			})
		end

		return p1:getShimmerPanel()
	end
	function p1.onScroll(p3) -- line: 115
		-- upvalues: p1 (copy)
		if p1.props.adaptiveScrolling then
			p1.props.adaptiveScrolling.onCanvasPositionChanged(p3)
		end

		if p1.props.onContentScroll then
			p1.props.onContentScroll(p3)
		end
	end

	local v40, v41 = Roact.createBinding(UDim2.new(0, 0, 1, 0))

	p1.canvasSizeBinding = v40
	p1.updateCanvasSizeBinding = v41

	local v42, v43 = Roact.createBinding(0)

	p1.bodyPartsListHeightBinding = v42
	p1.updateBodyPartsListHeightBinding = v43

	local v44, v45 = Roact.createBinding(0)

	p1.bodyColorsFrameHeightBinding = v44
	p1.updateBodyColorsFrameHeightBinding = v45

	function p1.onUIListLayoutContentSizeChanged(p4) -- line: 128
		-- upvalues: Constants (copy), p1 (copy)
		local v95 = Constants.SkinColorGridPadding * 2
		local v96 = p4.AbsoluteContentSize.Y + v95

		p1.updateCanvasSizeBinding(UDim2.new(0, 0, 0, v96))
	end
	function p1.onBodyPartsListAbsoluteSizeChanged(p5) -- line: 134
		-- upvalues: p1 (copy)
		p1.updateBodyPartsListHeightBinding(p5.AbsoluteSize.Y)
	end
	function p1.onBodyColorsFrameAbsoluteSizeChanged(p6) -- line: 138
		-- upvalues: p1 (copy)
		p1.updateBodyColorsFrameHeightBinding(p6.AbsoluteSize.Y)
	end

	p1.toggleViewButtonRef = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createRef() else nil
	p1.bodyColorButtonsRef = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createRef() else nil
	p1.bodyPartButtonsRef = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createRef() else nil
	p1.sliderRef = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createRef() else nil
	p1:setSelectedBodyPartIndex(1)
end
function v35.setSelectedBodyPartIndex(t3: {[any]: any}, n1: number) -- line: 151
	t3.props.setSelectedBodyPartIndex(n1)
end
function v35.getShimmerPanel(_) -- line: 155
	-- upvalues: Roact (copy), Skeleton (copy)
	return Roact.createElement(Skeleton, {
		Size = UDim2.new(1, 0, 1, 0)
	})
end
function v35.getItems(p8) -- line: 161
	-- upvalues: t1 (copy)
	local defaultBodyColorRanges = p8.props.defaultBodyColorRanges

	return defaultBodyColorRanges and #defaultBodyColorRanges > 0 and defaultBodyColorRanges or t1
end
function v35.getBodyPartsListHeight(p9) -- line: 167
	-- upvalues: Constants (copy)
	if p9.props.viewSetting == Constants.ColorPickerViewSettings.AdvancedView then
		return p9.state.bodyPartsListHeight
	end

	return 0
end
function v35.getGridAndSidebarFrameSize(p10) -- line: 175
	-- upvalues: Roact (copy), Constants (copy), Utils2 (copy)
	if p10:shouldRenderSliderBar() then
		return Roact.joinBindings({
			p10.canvasSizeBinding,
			p10.bodyPartsListHeightBinding,
			p10.bodyColorsFrameHeightBinding
		}):map(function(t4: {[any]: any}) -- line: 181
			-- upvalues: p10 (copy), Constants (copy), Utils2 (copy)
			local YOffset = t4[1].Y.Offset
			local v101 = t4[2]
			local v102 = t4[3]

			if p10.props.viewSetting ~= Constants.ColorPickerViewSettings.AdvancedView then
				v101 = 0
			end

			local v103 = Utils2.getBodyColorsSliderFrameHeight(Constants.BodyColorsSliderFrameHeight, YOffset, v102, v101)

			return UDim2.new(1, 0, 1, -v103)
		end)
	end

	return p10.props.Size
end
function v35.renderBodyColorButtons(p11, p12, p13) -- line: 203
	-- upvalues: Roact (copy), DefaultMetricsGridView (copy), Utils (copy), Constants2 (copy), GridMetrics (copy), t2 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	return Roact.createElement(DefaultMetricsGridView, {
		renderItem = p11.renderItem,
		getItemHeight = Utils.GridItemHeightGetter(Constants2.ItemTileType.BodyColorButton),
		getItemMetrics = GridMetrics.makeCustomMetricsGetter(t2),
		itemPadding = Vector2.new(10, 10),
		items = p12,
		maxHeight = 1e999,
		defaultChildIndex = 1,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then p11.toggleViewButtonRef else nil,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p11.props.NextSelectionUp else nil,
		NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then p13 else nil,
		[Roact.Ref] = if not FFlagAXMigrateAXToGlobalAutofocus then p11.bodyColorButtonsRef else nil
	})
end
function v35.renderToggleButton(p14, p15, p16, p17, p18) -- line: 219
	-- upvalues: Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), CursorKind (copy)
	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.TextButton else "TextButton", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, 100, 0, 30),
		Text = p15,
		Font = p16.Font.Header2.Font,
		AutomaticSize = Enum.AutomaticSize.X,
		TextSize = p16.Font.BaseSize * p16.Font.Header2.RelativeSize,
		TextColor3 = p16.Theme.TextEmphasis.Color,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p14.bodyColorButtonsRef else nil,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then p14.sliderRef else nil,
		SelectionImageObject = p17(CursorKind.RoundedRect),
		[Roact.Ref] = if not FFlagAXMigrateAXToGlobalAutofocus then p14.toggleViewButtonRef else nil,
		[Roact.Event.Activated] = p18
	})
end
function v35.renderUIListLayout(p19) -- line: 240
	-- upvalues: Roact (copy)
	return Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 20),
		[Roact.Change.AbsoluteContentSize] = p19.onUIListLayoutContentSizeChanged
	})
end
function v35.renderUIPadding(p20) -- line: 250
	-- upvalues: Roact (copy), Constants (copy)
	return Roact.createElement("UIPadding", {
		PaddingTop = if not p20.props.PaddingTop then UDim.new(0, Constants.SkinColorGridPadding) else p20.props.PaddingTop,
		PaddingBottom = if not p20.props.PaddingBottom then UDim.new(0, Constants.SkinColorGridPadding) else p20.props.PaddingBottom,
		PaddingLeft = if not p20.props.PaddingLeft then UDim.new(0, Constants.SkinColorGridPadding) else p20.props.PaddingLeft,
		PaddingRight = if not p20.props.PaddingRight then UDim.new(0, Constants.SkinColorGridPadding) else p20.props.PaddingRight
	})
end
function v35.renderBodyPartsList(p21, p22) -- line: 267
	-- upvalues: Constants (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), RadioButtonList (copy)
	local t5 = {}

	for i = 1, #Constants.BodyPartButtonData do
		table.insert(t5, {
			label = p22["bodyPart" .. i]
		})
	end

	local selectedBodyPartIndex = p21.props.selectedBodyPartIndex

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromOffset(150, 0),
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = p21.onBodyPartsListAbsoluteSizeChanged
	}, {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = if not p21.props.PaddingTop then UDim.new(0, Constants.SkinColorGridPadding) else p21.props.PaddingTop,
			PaddingBottom = if not p21.props.PaddingBottom then UDim.new(0, Constants.SkinColorGridPadding) else p21.props.PaddingBottom
		}),
		BodyPartRadioButtons = Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable[RadioButtonList] else RadioButtonList, {
			radioButtons = t5,
			onActivated = function(p23) -- line: 293
				-- upvalues: p21 (copy)
				p21:setSelectedBodyPartIndex(p23)
			end,
			initialValue = selectedBodyPartIndex,
			elementSize = UDim2.new(1, -10, 0, 25),
			automaticSize = true,
			padding = UDim.new(0, 10),
			NextSelectionRight = if not FFlagAXMigrateAXToGlobalAutofocus then p21.bodyColorButtonsRef else nil,
			NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p21.props.NextSelectionUp else nil,
			[Roact.Ref] = if not FFlagAXMigrateAXToGlobalAutofocus then p21.bodyPartButtonsRef else nil
		})
	})
end
function v35.renderStandardView(p24) -- line: 311
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), withLocalization (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), FFlagAXAdaptiveScrollingFixForward (copy), GetFFlagAXEnableSlotBasedEditor (copy), Constants (copy)
	local v69 = p24.props.adaptiveScrolling or {}

	return withStyle(function(p25) -- line: 313
		-- upvalues: withSelectionCursorProvider (copy), withLocalization (copy), p24 (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), v69 (copy), FFlagAXAdaptiveScrollingFixForward (copy), GetFFlagAXEnableSlotBasedEditor (copy), Constants (copy)
		return withSelectionCursorProvider(function(p26) -- line: 314
			-- upvalues: withLocalization (copy), p24 (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), v69 (copy), FFlagAXAdaptiveScrollingFixForward (copy), GetFFlagAXEnableSlotBasedEditor (copy), p25 (copy), Constants (copy)
			return withLocalization({
				buttonText = "Feature.Avatar.Label.BodyColorAdvancedView"
			})(function(p27) -- line: 317
				-- upvalues: p24 (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), v69 (copy), FFlagAXAdaptiveScrollingFixForward (copy), GetFFlagAXEnableSlotBasedEditor (copy), p25 (copy), p26 (copy), Constants (copy)
				local v116 = p24:getItems()
				local setViewSetting = p24.props.setViewSetting

				return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.ScrollingFrame else "ScrollingFrame", {
					BackgroundTransparency = 1,
					CanvasSize = p24.canvasSizeBinding,
					ScrollBarThickness = 0,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					Size = p24:getGridAndSidebarFrameSize(),
					NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p24.props.NextSelectionUp else nil,
					defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then p24.bodyColorButtonsRef else nil,
					ScrollingEnabled = if not v69.scrollingEnabledBinding then FFlagAXAdaptiveScrollingFixForward and true or v69.scrollingEnabled else v69.scrollingEnabledBinding:map(function(p28) -- line: 333
						return p28
					end),
					Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil,
					[Roact.Change.CanvasPosition] = if not GetFFlagAXEnableSlotBasedEditor() then v69.onCanvasPositionChanged else p24.onScroll
				}, {
					UIListLayout = p24:renderUIListLayout(),
					UIPadding = p24:renderUIPadding(),
					BodyColorButtons = p24:renderBodyColorButtons(v116),
					AdvancedViewButton = p24:renderToggleButton(p27.buttonText, p25, p26, function() -- line: 352
						-- upvalues: setViewSetting (copy), Constants (copy)
						setViewSetting(Constants.ColorPickerViewSettings.AdvancedView)
					end)
				})
			end)
		end)
	end)
end
function v35.renderAdvancedView(p29) -- line: 367
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), Constants (copy), withLocalization (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), FFlagAXAdaptiveScrollingFixForward (copy), GetFFlagAXEnableSlotBasedEditor (copy)
	local v71 = p29.props.adaptiveScrolling or {}

	return withStyle(function(p30) -- line: 369
		-- upvalues: withSelectionCursorProvider (copy), Constants (copy), withLocalization (copy), p29 (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), v71 (copy), FFlagAXAdaptiveScrollingFixForward (copy), GetFFlagAXEnableSlotBasedEditor (copy)
		return withSelectionCursorProvider(function(p31) -- line: 370
			-- upvalues: Constants (copy), withLocalization (copy), p29 (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), v71 (copy), FFlagAXAdaptiveScrollingFixForward (copy), GetFFlagAXEnableSlotBasedEditor (copy), p30 (copy)
			local t6 = {
				standardButtonText = "Feature.Avatar.Label.BodyColorStandardView"
			}

			for v113, _ in Constants.BodyPartButtonData do
				t6["bodyPart" .. v113] = Constants.BodyPartButtonData[v113].textKey
			end

			return withLocalization(t6)(function(p32) -- line: 377
				-- upvalues: p29 (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), v71 (copy), FFlagAXAdaptiveScrollingFixForward (copy), GetFFlagAXEnableSlotBasedEditor (copy), p30 (copy), p31 (copy), Constants (copy)
				local v119 = p29:getItems()
				local v120 = p29:getGridAndSidebarFrameSize()
				local setViewSetting = p29.props.setViewSetting

				return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.ScrollingFrame else "ScrollingFrame", {
					BackgroundTransparency = 1,
					Size = v120,
					CanvasSize = p29.canvasSizeBinding,
					ScrollBarThickness = 0,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					Position = UDim2.fromScale(0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then p29.bodyColorButtonsRef else nil,
					Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil,
					ScrollingEnabled = if not v71.scrollingEnabledBinding then FFlagAXAdaptiveScrollingFixForward and true or v71.scrollingEnabled else v71.scrollingEnabledBinding:map(function(p33) -- line: 395
						return p33
					end),
					[Roact.Change.CanvasPosition] = if not GetFFlagAXEnableSlotBasedEditor() then v71.onCanvasPositionChanged else p29.onScroll
				}, {
					BodyPartsList = p29:renderBodyPartsList(p32),
					BodyColorsGrid = Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 150, 0, 0),
						Size = UDim2.new(1, -150, 1, 0),
						defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then p29.bodyColorButtonsRef else nil
					}, {
						UIPadding = p29:renderUIPadding(),
						UIListLayout = p29:renderUIListLayout(),
						BodyColorButtons = p29:renderBodyColorButtons(v119, if not FFlagAXMigrateAXToGlobalAutofocus then p29.bodyPartButtonsRef else nil),
						StandardViewButton = p29:renderToggleButton(p32.standardButtonText, p30, p31, function() -- line: 428
							-- upvalues: p29 (copy), setViewSetting (copy), Constants (copy)
							p29:setSelectedBodyPartIndex(1)
							setViewSetting(Constants.ColorPickerViewSettings.StandardView)
						end)
					})
				})
			end)
		end)
	end)
end
function v35.shouldRenderSliderBar(p34) -- line: 442
	if not p34.props.rangeIdForSelectedBodyParts then
		return false
	end

	return true
end
function v35.render(p35) -- line: 451
	-- upvalues: Constants (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), FFlagAXFixColorAdjustmentGamepadSupport (copy), BodyColorsSliderFrame (copy)
	local v74 = if p35.props.viewSetting ~= Constants.ColorPickerViewSettings.AdvancedView then p35:renderStandardView() else p35:renderAdvancedView()
	local v75 = p35:shouldRenderSliderBar()

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		[Roact.Ref] = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else p35.props.ref,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = p35.props.Size,
		Position = UDim2.fromOffset(0, 0),
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then p35.bodyColorButtonsRef else nil,
		Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil,
		[Roact.Change.AbsoluteSize] = p35.onBodyColorsFrameAbsoluteSizeChanged,
		LayoutOrder = p35.props.LayoutOrder
	}, {
		BodyColorsView = v74,
		BodyColorsSliderFrame = if not v75 then nil else Roact.createElement(BodyColorsSliderFrame, {
			sliderRef = if not FFlagAXMigrateAXToGlobalAutofocus then p35.sliderRef else nil,
			NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p35.toggleViewButtonRef else nil,
			gridAndSidebarFrameSizeBinding = p35:getGridAndSidebarFrameSize(),
			rangeIdForSelectedBodyParts = p35.props.rangeIdForSelectedBodyParts,
			defaultBodyColorRanges = p35.props.defaultBodyColorRanges
		})
	})
end
function v35.didMount(p36) -- line: 487
	-- upvalues: Utils2 (copy)
	local bodyColor3s = p36.props.bodyColor3s
	local bodyPartRangeIds = p36.props.bodyPartRangeIds
	local t7 = {}
	local v80 = false

	for v81, v82 in bodyColor3s do
		if bodyPartRangeIds[v81] == nil then
			v80 = true

			local v83, _ = Utils2.findRangeAndSliderValueForColor3(v82, p36.props.defaultBodyColorRanges)

			t7[v81] = v83
		else
			t7[v81] = bodyPartRangeIds[v81]
		end
	end

	if v80 then
		p36.props.setBodyPartRangeIds(t7)
	end
end

return (withAdaptiveScrolling((RoactRodux.connect(function(p37, _) -- line: 509
	-- upvalues: selectRangeIdForSelectedBodyParts (copy), v9 (copy)
	local DefaultBodyColorRanges = p37.AvatarExperience.AvatarEditor.DefaultBodyColorRanges
	local BodyPartRangeIds = p37.AvatarExperience.AvatarEditor.Character.BodyPartRangeIds
	local selectedBodyPartIndex = p37.AvatarExperience.AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex
	local v90 = selectRangeIdForSelectedBodyParts(p37)

	return {
		viewSetting = p37.AvatarExperience.AvatarEditor.BodyColorPickerSettings.viewSetting,
		rangeIdForSelectedBodyParts = v90,
		defaultBodyColorRanges = DefaultBodyColorRanges,
		bodyColor3s = v9(p37),
		bodyPartRangeIds = BodyPartRangeIds,
		selectedBodyPartIndex = selectedBodyPartIndex
	}
end, function(p39) -- line: 525
	-- upvalues: SetBodyColorViewSetting (copy), SetBodyPartRangeIds (copy), SetSelectedBodyPartIndex (copy)
	return {
		setViewSetting = function(p40) -- line: 527
			-- upvalues: p39 (copy), SetBodyColorViewSetting (copy)
			p39(SetBodyColorViewSetting(p40))
		end,
		setBodyPartRangeIds = function(p41) -- line: 530
			-- upvalues: p39 (copy), SetBodyPartRangeIds (copy)
			p39(SetBodyPartRangeIds(p41))
		end,
		setSelectedBodyPartIndex = function(p42) -- line: 533
			-- upvalues: p39 (copy), SetSelectedBodyPartIndex (copy)
			p39(SetSelectedBodyPartIndex(p42))
		end
	}
end)(v35))))
