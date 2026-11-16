local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Button = Foundation.Button
local Knob = Foundation.Knob
local ScrollView = Foundation.ScrollView
local Slider = Foundation.Slider
local View = Foundation.View

local useCallback = React.useCallback
local useMemo = React.useMemo
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local FormFactor = MomentsCommon.Enums.FormFactor
local ReactionType = MomentsCommon.Enums.ReactionType
local ReactionAssets = MomentsCommon.Components.ReactionAssets

local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames

local Constants = require(MomentsCreation.Constants)
local StickerPickerItem = require(MomentsCreation.Components.StickerOverlay.StickerPickerItem)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local makeDefaultStickerOverlayEdit = require(MomentsCreation.Utils.makeDefaultStickerOverlayEdit)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
require(MomentsCreation.Types.CreationFlowTypes)
require(parent.MomentsTypes)

local function StickerOverlayControls(p)
	local controller = p.controller
	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = useCreationFlowStrings()

	local v4 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p2)
			local activeSession = controller.getActiveSession(p2)
			local v4

			if activeSession ~= nil then
				v4 = activeSession.getDraft(p2)
			end

			local v5 = v4 and v4[1]

			if v5 == nil then
				return Constants.StickerOverlay.DefaultStickerSize
			end

			return v5.stickerSize
		end)
	end, { controller })))

	local onValueChanged = useCallback(function(stickerSize: number)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v5 = draft and draft[1]

		if v5 == nil then
			return
		end

		activeSession.update({ Dash.joinDeep(v5, { stickerSize = stickerSize }) })
	end, { controller })

	local onActivated = useCallback(function()
		controller.discardActiveTool()
	end, { controller })

	local onActivated2 = useCallback(function()
		controller.commitActiveTool()
	end, { controller })

	local onStickerSelected = useCallback(function(stickerURI: string)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v5 = draft and draft[1]

		if v5 ~= nil and v5.stickerURI == stickerURI then
			activeSession.update({ Dash.join(v5, { stickerURI = Dash.None }) })
			return
		end

		local v6 = v5 or makeDefaultStickerOverlayEdit()
		activeSession.update({ Dash.join(v6, { stickerURI = stickerURI }) })

		local v7 = { stickerURI = stickerURI }

		for k, v8 in makeCreationEventFields.makeToolFieldFromKind("sticker") do
			v7[k] = v8
		end

		local sessionId = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		for k, v8 in makeCreationEventFields.makeCreationBaseFields(sessionId) do
			v7[k] = v8
		end

		fireAnalyticsEvent(EventNames.EditingFlowStickerSelected, v7)
	end, { controller })

	local v5 = useFormFactor() == FormFactor.Wide

	local v6 = useMemo(function()
		local count = 0
		local children = {}

		for _, v6 in ReactionType do
			local stickerImageUri = ReactionAssets.getStickerImageUri(v6)

			if stickerImageUri == nil then
				continue
			end

			count += 1
			table.insert(
				children,
				React.createElement(StickerPickerItem, {
					key = v6,
					layoutOrder = count,
					stickerURI = stickerImageUri,
					onStickerSelected = onStickerSelected
				})
			)
		end

		return children
	end, { onStickerSelected })

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = p.layoutOrder,
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v2.Padding.Small),
			bottom = UDim.new(0, (math.max(v.bottom, v2.Padding.Small))),
			left = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
			right = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
		}
	}

	local v8 = {
		StickerSizeSlider = React.createElement(Slider, {
			knob = React.createElement(Knob, { size = Foundation.Enums.InputSize.Large }),
			knobVisibility = Foundation.Enums.Visibility.Always,
			LayoutOrder = 1,
			onValueChanged = onValueChanged,
			size = Foundation.Enums.InputSize.XSmall,
			range = NumberRange.new(Constants.StickerOverlay.MinStickerSize, Constants.StickerOverlay.MaxStickerSize),
			value = math.clamp(
				v4 or Constants.StickerOverlay.DefaultStickerSize,
				Constants.StickerOverlay.MinStickerSize,
				Constants.StickerOverlay.MaxStickerSize
			),
			variant = Foundation.Enums.SliderVariant.Standard
		}),
		Nav = 0
	}

	local createElement2 = React.createElement

	local children = {
		BackButton = React.createElement(Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fit,
			LayoutOrder = 1,
			text = v3.GeneralCtaBack,
			variant = Foundation.Enums.ButtonVariant.Text,
			onActivated = onActivated,
			size = Foundation.Enums.InputSize.Medium
		}),
		StickerRow = 0,
		DoneButton = 0
	}

	local createElement3 = React.createElement
	local v9 = {
		LayoutOrder = 2,
		flexItem = { FlexMode = Enum.UIFlexMode.Fill },
		Size = UDim2.fromOffset(0, v2.Size.Size_1000),
		layout = 0,
		scroll = 0
	}
	local layout = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = 0,
		VerticalAlignment = 0,
		Padding = 0,
		SortOrder = 0
	}
	local horizontalAlignment

	if v5 then
		horizontalAlignment = Enum.HorizontalAlignment.Center
	else
		horizontalAlignment = Enum.HorizontalAlignment.Left
	end

	layout.HorizontalAlignment = horizontalAlignment

	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, v2.Padding.Small)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	v9.layout = layout

	local scroll = {
		ScrollingDirection = Enum.ScrollingDirection.X,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.fromOffset(0, 0),
		scrollBarVisibility = 0
	}
	local scrollBarVisibility

	if v5 then
		scrollBarVisibility = Foundation.Enums.Visibility.None
	else
		scrollBarVisibility = Foundation.Enums.Visibility.Auto
	end

	scroll.scrollBarVisibility = scrollBarVisibility
	v9.scroll = scroll
	children.StickerRow = createElement3(ScrollView, v9, v6)

	children.DoneButton = React.createElement(Button, {
		fillBehavior = Foundation.Enums.FillBehavior.Fit,
		LayoutOrder = 3,
		text = v3.GeneralCtaDone,
		variant = Foundation.Enums.ButtonVariant.Text,
		onActivated = onActivated2,
		size = Foundation.Enums.InputSize.Medium
	})
	v8.Nav = createElement2(
		View,
		{
			LayoutOrder = 2,
			tag = "row flex-x-between align-x-center align-y-center gap-medium size-full-0 auto-y"
		},
		children
	)
	return createElement(View, v7, v8)
end

return StickerOverlayControls
