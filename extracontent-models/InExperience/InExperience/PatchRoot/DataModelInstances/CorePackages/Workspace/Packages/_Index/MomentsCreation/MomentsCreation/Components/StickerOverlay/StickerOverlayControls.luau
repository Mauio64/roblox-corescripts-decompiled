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
local FoundationImage = Foundation.Image
local useCallback = React.useCallback
local useMemo = React.useMemo
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
local ReactionType = MomentsCommon.Enums.ReactionType
local ReactionSize = MomentsCommon.Enums.ReactionSize
local ReactionAssets = MomentsCommon.Components.ReactionAssets
local Constants = require(MomentsCreation.Constants)
local makeDefaultStickerOverlayEdit = require(MomentsCreation.Utils.makeDefaultStickerOverlayEdit)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

require(MomentsCreation.Types.CreationFlowTypes)
require(MomentsCreationParent.MomentsTypes)

local function StickerOverlayControls(t1: {[any]: any}) -- line: 49
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), useMemo (copy), Signals (copy), Constants (copy), useSignalState (copy), useCallback (copy), Dash (copy), ReactionType (copy), ReactionAssets (copy), ReactionSize (copy), React (copy), FoundationImage (copy), makeDefaultStickerOverlayEdit (copy), View (copy), Slider (copy), Knob (copy), Foundation (copy), Button (copy)
	local controller = t1.controller
	local v28 = useDeviceInsets()
	local v29 = useTokens()
	local v30 = useCreationFlowStrings()
	local v31 = useMemo(function() -- line: 56
		-- upvalues: Signals (copy), controller (copy), Constants (copy)
		return Signals.createComputed(function(p1) -- line: 57
			-- upvalues: controller (copy), Constants (copy)
			local v47 = controller.getActiveSession(p1)
			local v48 = if v47 == nil then nil else v47.getDraft(p1)
			local v49 = v48 and v48[1]

			if v49 ~= nil then
				return v49.stickerSize
			end

			return Constants.StickerOverlay.DefaultStickerSize
		end)
	end, { controller })
	local v32 = useSignalState(v31)
	local v33 = useCallback(function(n1: number) -- line: 66
		-- upvalues: controller (copy), Dash (copy)
		local v38 = controller.getActiveSession(false)

		if v38 == nil then
			return
		end

		local v39 = v38.getDraft(false)
		local v40 = v39 and v39[1]

		if v40 == nil then
			return
		end

		v38.update({ Dash.joinDeep(v40, {
			stickerSize = n1
		}) })
	end, { controller })
	local v34 = useCallback(function() -- line: 79
		-- upvalues: controller (copy)
		controller.discardActiveTool()
	end, { controller })
	local v35 = useCallback(function() -- line: 83
		-- upvalues: controller (copy)
		controller.commitActiveTool()
	end, { controller })
	local v36 = useMemo(function() -- line: 88
		-- upvalues: ReactionType (copy), ReactionAssets (copy), ReactionSize (copy), React (copy), FoundationImage (copy), controller (copy), makeDefaultStickerOverlayEdit (copy), Dash (copy)
		local t2 = {}
		local n2 = 0

		for _, v44 in ReactionType do
			n2 += 1

			local v45 = ReactionAssets.getStaticImageUri(v44, ReactionSize.Large)

			table.insert(t2, React.createElement(FoundationImage, {
				BackgroundTransparency = 1,
				tag = "size-1000-1000 radius-medium",
				key = v44,
				LayoutOrder = n2,
				onActivated = function() -- line: 99
					-- upvalues: controller (copy), makeDefaultStickerOverlayEdit (copy), Dash (copy), v45 (copy)
					local v50 = controller.getActiveSession(false)

					if v50 == nil then
						return
					end

					local v51 = v50.getDraft(false)
					local v52 = v51 and v51[1] or makeDefaultStickerOverlayEdit()

					v50.update({ Dash.join(v52, {
						stickerURI = v45
					}) })
				end,
				Image = v45,
				ScaleType = Enum.ScaleType.Fit
			}))
		end

		return t2
	end, { controller })

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		padding = {
			top = UDim.new(0, v29.Padding.Small),
			bottom = UDim.new(0, (math.max(v28.bottom, v29.Padding.Small))),
			left = UDim.new(0, (math.max(v28.left, v29.Padding.XLarge))),
			right = UDim.new(0, (math.max(v28.right, v29.Padding.XLarge)))
		}
	}, {
		StickerSizeSlider = React.createElement(Slider, {
			LayoutOrder = 1,
			knob = React.createElement(Knob, {
				size = Foundation.Enums.InputSize.Large
			}),
			knobVisibility = Foundation.Enums.Visibility.Always,
			onValueChanged = v33,
			size = Foundation.Enums.InputSize.XSmall,
			range = NumberRange.new(Constants.StickerOverlay.MinStickerSize, Constants.StickerOverlay.MaxStickerSize),
			value = math.clamp(v32 or Constants.StickerOverlay.DefaultStickerSize, Constants.StickerOverlay.MinStickerSize, Constants.StickerOverlay.MaxStickerSize),
			variant = Foundation.Enums.SliderVariant.Standard
		}),
		Nav = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
		}, {
			BackButton = React.createElement(Button, {
				LayoutOrder = 1,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v30.GeneralCtaBack,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v34,
				size = Foundation.Enums.InputSize.Medium
			}),
			StickerRow = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row flex-x-between align-x-center align-y-center gap-small auto-xy"
			}, v36),
			DoneButton = React.createElement(Button, {
				LayoutOrder = 3,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v30.GeneralCtaDone,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v35,
				size = Foundation.Enums.InputSize.Medium
			})
		})
	})
end

return StickerOverlayControls
