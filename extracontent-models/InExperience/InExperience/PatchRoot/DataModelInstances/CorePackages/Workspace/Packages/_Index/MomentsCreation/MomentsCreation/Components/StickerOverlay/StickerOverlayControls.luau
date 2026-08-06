local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Dash = require(MomentsCreationParent.Dash)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local SignalsReact = require(MomentsCreationParent.SignalsReact)
local Button = Foundation.Button
local Knob = Foundation.Knob
local Slider = Foundation.Slider
local View = Foundation.View
local useCallback = React.useCallback
local useMemo = React.useMemo
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
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
require(MomentsCreationParent.MomentsTypes)

local function StickerOverlayControls(t1: {[any]: any}) -- line: 54
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), useMemo (copy), Signals (copy), Constants (copy), useSignalState (copy), useCallback (copy), Dash (copy), makeDefaultStickerOverlayEdit (copy), makeCreationEventFields (copy), SessionManager (copy), FunnelEventNames (copy), fireAnalyticsEvent (copy), EventNames (copy), ReactionType (copy), ReactionAssets (copy), React (copy), StickerPickerItem (copy), View (copy), Slider (copy), Knob (copy), Foundation (copy), Button (copy)
	local controller = t1.controller
	local v32 = useDeviceInsets()
	local v33 = useTokens()
	local v34 = useCreationFlowStrings()
	local v35 = useMemo(function() -- line: 61
		-- upvalues: Signals (copy), controller (copy), Constants (copy)
		return Signals.createComputed(function(p1) -- line: 62
			-- upvalues: controller (copy), Constants (copy)
			local v62 = controller.getActiveSession(p1)
			local v63 = if v62 == nil then nil else v62.getDraft(p1)
			local v64 = v63 and v63[1]

			if v64 ~= nil then
				return v64.stickerSize
			end

			return Constants.StickerOverlay.DefaultStickerSize
		end)
	end, { controller })
	local v36 = useSignalState(v35)
	local v37 = useCallback(function(n1: number) -- line: 71
		-- upvalues: controller (copy), Dash (copy)
		local v43 = controller.getActiveSession(false)

		if v43 == nil then
			return
		end

		local v44 = v43.getDraft(false)
		local v45 = v44 and v44[1]

		if v45 == nil then
			return
		end

		v43.update({ Dash.joinDeep(v45, {
			stickerSize = n1
		}) })
	end, { controller })
	local v38 = useCallback(function() -- line: 84
		-- upvalues: controller (copy)
		controller.discardActiveTool()
	end, { controller })
	local v39 = useCallback(function() -- line: 88
		-- upvalues: controller (copy)
		controller.commitActiveTool()
	end, { controller })
	local v40 = useCallback(function(s1: string) -- line: 92
		-- upvalues: controller (copy), makeDefaultStickerOverlayEdit (copy), Dash (copy), makeCreationEventFields (copy), SessionManager (copy), FunnelEventNames (copy), fireAnalyticsEvent (copy), EventNames (copy)
		local v47 = controller.getActiveSession(false)

		if v47 == nil then
			return
		end

		local v48 = v47.getDraft(false)
		local v49 = v48 and v48[1] or makeDefaultStickerOverlayEdit()

		v47.update({ Dash.join(v49, {
			stickerURI = s1
		}) })

		local t2 = {
			stickerURI = s1
		}

		for v51, v52 in makeCreationEventFields.makeToolFieldFromKind("sticker") do
			t2[v51] = v52
		end

		local v53 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		for v54, v55 in makeCreationEventFields.makeCreationBaseFields(v53) do
			t2[v54] = v55
		end

		fireAnalyticsEvent(EventNames.EditingFlowStickerSelected, t2)
	end, { controller })
	local v41 = useMemo(function() -- line: 119
		-- upvalues: ReactionType (copy), ReactionAssets (copy), React (copy), StickerPickerItem (copy), v40 (copy)
		local t3 = {}
		local n2 = 0

		for _, v59 in ReactionType do
			local v60 = ReactionAssets.getStickerImageUri(v59)

			if v60 ~= nil then
				n2 += 1
				table.insert(t3, React.createElement(StickerPickerItem, {
					key = v59,
					layoutOrder = n2,
					stickerURI = v60,
					onStickerSelected = v40
				}))
			end
		end

		return t3
	end, { v40 })

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		padding = {
			top = UDim.new(0, v33.Padding.Small),
			bottom = UDim.new(0, (math.max(v32.bottom, v33.Padding.Small))),
			left = UDim.new(0, (math.max(v32.left, v33.Padding.XLarge))),
			right = UDim.new(0, (math.max(v32.right, v33.Padding.XLarge)))
		}
	}, {
		StickerSizeSlider = React.createElement(Slider, {
			LayoutOrder = 1,
			knob = React.createElement(Knob, {
				size = Foundation.Enums.InputSize.Large
			}),
			knobVisibility = Foundation.Enums.Visibility.Always,
			onValueChanged = v37,
			size = Foundation.Enums.InputSize.XSmall,
			range = NumberRange.new(Constants.StickerOverlay.MinStickerSize, Constants.StickerOverlay.MaxStickerSize),
			value = math.clamp(v36 or Constants.StickerOverlay.DefaultStickerSize, Constants.StickerOverlay.MinStickerSize, Constants.StickerOverlay.MaxStickerSize),
			variant = Foundation.Enums.SliderVariant.Standard
		}),
		Nav = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
		}, {
			BackButton = React.createElement(Button, {
				LayoutOrder = 1,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v34.GeneralCtaBack,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v38,
				size = Foundation.Enums.InputSize.Medium
			}),
			StickerRow = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row flex-x-between align-x-center align-y-center gap-small auto-xy"
			}, v41),
			DoneButton = React.createElement(Button, {
				LayoutOrder = 3,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v34.GeneralCtaDone,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v39,
				size = Foundation.Enums.InputSize.Medium
			})
		})
	})
end

return StickerOverlayControls
