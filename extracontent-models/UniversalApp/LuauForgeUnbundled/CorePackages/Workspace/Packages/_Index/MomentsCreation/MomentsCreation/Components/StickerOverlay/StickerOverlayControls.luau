local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local button = Foundation.Button
local knob = Foundation.Knob
local scrollView = Foundation.ScrollView
local slider = Foundation.Slider
local view = Foundation.View

local useCallback = React.useCallback
local useMemo = React.useMemo
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local formFactor = MomentsCommon.Enums.FormFactor
local reactionType = MomentsCommon.Enums.ReactionType
local reactionAssets = MomentsCommon.Components.ReactionAssets

local eventNames = MomentsCommon.Analytics.EventNames
local sessionManager = MomentsCommon.Analytics.SessionManager
local funnelEventNames = MomentsCommon.Analytics.FunnelEventNames

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
local StickerPickerItem = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/StickerOverlay/StickerPickerItem")
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local makeDefaultStickerOverlayEdit = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makeDefaultStickerOverlayEdit")
local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local function StickerOverlayControls(p2)
	local controller = p2.controller
	local v5 = useDeviceInsets()
	local v6 = useTokens()
	local v7 = useCreationFlowStrings()

	local v9 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p3)
			local activeSession = controller.getActiveSession(p3)
			local v9 = if activeSession ~= nil then activeSession.getDraft(p3) else nil
			local v10 = v9 and v9[1]

			if v10 == nil then
				return Constants.StickerOverlay.DefaultStickerSize
			end

			return v10.stickerSize
		end)
	end, { controller })))

	local v10 = useCallback(function(p3)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v11 = draft and draft[1]

		if v11 == nil then
			return
		end

		activeSession.update({ Dash.joinDeep(v11, { stickerSize = p3 }) })
	end, { controller })

	local v11 = useCallback(function()
		controller.discardActiveTool()
	end, { controller })

	local v12 = useCallback(function()
		controller.commitActiveTool()
	end, { controller })

	local v13 = useCallback(function(p3)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v14 = draft and draft[1]

		if v14 ~= nil and v14.stickerURI == p3 then
			activeSession.update({ Dash.join(v14, { stickerURI = Dash.None }) })
			return
		end

		local v15 = v14 or makeDefaultStickerOverlayEdit()
		activeSession.update({ Dash.join(v15, { stickerURI = p3 }) })

		local v16 = { stickerURI = p3 }

		for k, v17 in makeCreationEventFields.makeToolFieldFromKind("sticker") do
			v16[k] = v17
		end

		local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)

		for k, v17 in makeCreationEventFields.makeCreationBaseFields(sessionId) do
			v16[k] = v17
		end

		fireAnalyticsEvent(eventNames.EditingFlowStickerSelected, v16)
	end, { controller })

	local v14 = useFormFactor() == formFactor.Wide

	local v15 = useMemo(function()
		local count = 0
		local children = {}

		for k, v16 in reactionType do
			local stickerImageUri = reactionAssets.getStickerImageUri(v16)

			if stickerImageUri == nil then
				continue
			end

			count += 1
			table.insert(
				children,
				React.createElement(StickerPickerItem, {
					key = v16,
					layoutOrder = count,
					stickerURI = stickerImageUri,
					onStickerSelected = v13
				})
			)
		end

		return children
	end, { v13 })

	local createElement = React.createElement
	local v17 = {
		LayoutOrder = p2.layoutOrder,
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v6.Padding.Small),
			bottom = UDim.new(0, (math.max(v5.bottom, v6.Padding.Small))),
			left = UDim.new(0, (math.max(v5.left, v6.Padding.XLarge))),
			right = UDim.new(0, (math.max(v5.right, v6.Padding.XLarge)))
		}
	}

	local v18 = {
		StickerSizeSlider = React.createElement(slider, {
			knob = React.createElement(knob, { size = Foundation.Enums.InputSize.Large }),
			knobVisibility = Foundation.Enums.Visibility.Always,
			LayoutOrder = 1,
			onValueChanged = v10,
			size = Foundation.Enums.InputSize.XSmall,
			range = NumberRange.new(
				Constants.StickerOverlay.MinStickerSize,
				Constants.StickerOverlay.MaxStickerSize
			),
			value = math.clamp(
				v9 or Constants.StickerOverlay.DefaultStickerSize,
				Constants.StickerOverlay.MinStickerSize,
				Constants.StickerOverlay.MaxStickerSize
			),
			variant = Foundation.Enums.SliderVariant.Standard
		}),
		Nav = 0
	}

	local createElement2 = React.createElement

	local children = {
		BackButton = React.createElement(button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fit,
			LayoutOrder = 1,
			text = v7.GeneralCtaBack,
			variant = Foundation.Enums.ButtonVariant.Text,
			onActivated = v11,
			size = Foundation.Enums.InputSize.Medium
		}),
		StickerRow = 0,
		DoneButton = 0
	}

	local createElement3 = React.createElement
	local v22 = {
		LayoutOrder = 2,
		flexItem = { FlexMode = Enum.UIFlexMode.Fill },
		Size = UDim2.fromOffset(0, v6.Size.Size_1000),
		layout = 0,
		scroll = 0
	}
	local v23 = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = 0,
		VerticalAlignment = 0,
		Padding = 0,
		SortOrder = 0
	}

	local v24 = if v14 then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Left
	v23.HorizontalAlignment = v24

	v23.VerticalAlignment = Enum.VerticalAlignment.Center
	v23.Padding = UDim.new(0, v6.Padding.Small)
	v23.SortOrder = Enum.SortOrder.LayoutOrder
	v22.layout = v23

	local v25 = {
		ScrollingDirection = Enum.ScrollingDirection.X,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.fromOffset(0, 0),
		scrollBarVisibility = 0
	}

	local v26 = if v14 then Foundation.Enums.Visibility.None else Foundation.Enums.Visibility.Auto
	v25.scrollBarVisibility = v26
	v22.scroll = v25
	children.StickerRow = createElement3(scrollView, v22, v15)

	children.DoneButton = React.createElement(button, {
		fillBehavior = Foundation.Enums.FillBehavior.Fit,
		LayoutOrder = 3,
		text = v7.GeneralCtaDone,
		variant = Foundation.Enums.ButtonVariant.Text,
		onActivated = v12,
		size = Foundation.Enums.InputSize.Medium
	})
	v18.Nav = createElement2(
		view,
		{
			LayoutOrder = 2,
			tag = "row flex-x-between align-x-center align-y-center gap-medium size-full-0 auto-y"
		},
		children
	)
	return createElement(view, v17, v18)
end

return StickerOverlayControls
