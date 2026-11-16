local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Icon = Foundation.Icon
local Menu = Foundation.Menu
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useToggleState = MomentsCommon.Hooks.useToggleState

local CreationController = require(MomentsCreation.CreationController)
local useCreationController = CreationController.useCreationController
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)

local EventNames = MomentsCommon.Analytics.EventNames

local function VoiceBackControls()
	local v = useCreationController()
	local v2 = useTokens()
	local v3 = useDeviceInsets()
	local v4 = useToggleState(false)

	local v5 = useLocalization({
		discard = "Feature.Moments.Action.DiscardChange",
		keep = "Feature.Moments.Action.KeepEditing"
	})

	local items = {
		{ id = "discard", text = v5.discard },
		{ id = "keep", text = v5.keep }
	}

	local function fireContinueEditing() -- 2 equivalent calls inferred from this helper
		fireAnalyticsEvent(
			EventNames.EditingFlowVoiceContinueEditingPressed,
			makeCreationEventFields.makeVoiceEventFields()
		)
	end

	return React.createElement(View, {
		padding = {
			top = UDim.new(0, v3.top + v2.Padding.Medium),
			left = UDim.new(0, v3.left + v2.Padding.Medium)
		},
		tag = "position-top-left anchor-top-left auto-xy",
		ZIndex = 10
	}, {
		DiscardMenu = React.createElement(Menu, {
			isOpen = v4.enabled,
			side = Foundation.Enums.PopoverSide.Bottom,
			align = Foundation.Enums.PopoverAlign.Start,
			onPressedOutside = function()
				if not v4.enabled then
					return
				end

				v4.disable()
				fireContinueEditing() -- inferred equivalent call
			end,
			onActivated = function(p)
				v4.disable()

				if p == "discard" then
					v.discardActiveTool()
				elseif p == "keep" then
					fireContinueEditing() -- inferred equivalent call
				end
			end,
			items = items
		}, {
			BackButton = React.createElement(View, {
				onActivated = function()
					fireAnalyticsEvent(
						EventNames.EditingFlowVoiceBackButtonPressed,
						makeCreationEventFields.makeVoiceEventFields()
					)

					local activeSession = v.getActiveSession(false)
					local v6

					if activeSession == nil then
						v6 = false
					else
						v6 = activeSession.getIsDirty(false)
					end

					if v6 then
						v4.toggle()
					else
						v.commitActiveTool()
					end
				end,
				stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.Background },
				tag = "auto-xy padding-small radius-circle"
			}, {
				BackIcon = React.createElement(Icon, {
					name = BuilderIcons.Icon.ChevronLargeLeft,
					size = Foundation.Enums.IconSize.Large,
					style = v2.Color.Content.Emphasis
				})
			})
		})
	})
end

return VoiceBackControls
