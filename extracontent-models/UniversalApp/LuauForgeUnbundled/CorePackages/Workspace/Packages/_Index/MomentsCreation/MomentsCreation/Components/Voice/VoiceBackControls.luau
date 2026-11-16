local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local icon = Foundation.Icon
local menu = Foundation.Menu
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useToggleState = MomentsCommon.Hooks.useToggleState

local useCreationController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/CreationController").useCreationController
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")

local eventNames = MomentsCommon.Analytics.EventNames

local function VoiceBackControls()
	local v5 = useCreationController()
	local v6 = useTokens()
	local v7 = useDeviceInsets()
	local v8 = useToggleState(false)

	local v9 = useLocalization({
		discard = "Feature.Moments.Action.DiscardChange",
		keep = "Feature.Moments.Action.KeepEditing"
	})

	local v10 = {
		{ id = "discard", text = v9.discard },
		{ id = "keep", text = v9.keep }
	}

	local function fireContinueEditing()
		fireAnalyticsEvent(eventNames.EditingFlowVoiceContinueEditingPressed, makeCreationEventFields.makeVoiceEventFields())
	end

	return React.createElement(view, {
		padding = {
			top = UDim.new(0, v7.top + v6.Padding.Medium),
			left = UDim.new(0, v7.left + v6.Padding.Medium)
		},
		tag = "position-top-left anchor-top-left auto-xy",
		ZIndex = 10
	}, {
		DiscardMenu = React.createElement(menu, {
			isOpen = v8.enabled,
			side = Foundation.Enums.PopoverSide.Bottom,
			align = Foundation.Enums.PopoverAlign.Start,
			onPressedOutside = function()
				if not v8.enabled then
					return
				end

				v8.disable()
				fireAnalyticsEvent(eventNames.EditingFlowVoiceContinueEditingPressed, makeCreationEventFields.makeVoiceEventFields())
			end,
			onActivated = function(p2)
				v8.disable()

				if p2 == "discard" then
					v5.discardActiveTool()
				elseif p2 == "keep" then
					fireAnalyticsEvent(
						eventNames.EditingFlowVoiceContinueEditingPressed,
						makeCreationEventFields.makeVoiceEventFields()
					)
				end
			end,
			items = v10
		}, {
			BackButton = React.createElement(view, {
				onActivated = function()
					fireAnalyticsEvent(eventNames.EditingFlowVoiceBackButtonPressed, makeCreationEventFields.makeVoiceEventFields())

					local activeSession = v5.getActiveSession(false)
					local v11 = not (activeSession == nil) and activeSession.getIsDirty(false)

					if v11 then
						v8.toggle()
					else
						v5.commitActiveTool()
					end
				end,
				stateLayer = {
					affordance = Foundation.Enums.StateLayerAffordance.Background
				},
				tag = "auto-xy padding-small radius-circle"
			}, {
				BackIcon = React.createElement(icon, {
					name = BuilderIcons.Icon.ChevronLargeLeft,
					size = Foundation.Enums.IconSize.Large,
					style = v6.Color.Content.Emphasis
				})
			})
		})
	})
end

return VoiceBackControls
