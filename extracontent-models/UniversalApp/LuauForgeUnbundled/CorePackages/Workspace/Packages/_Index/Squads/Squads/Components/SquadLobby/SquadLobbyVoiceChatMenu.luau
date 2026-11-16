local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UIBlox")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local foundation = dependencies.Foundation
local react = dependencies.React
local gameSettings = UserSettings().GameSettings
local engineFeature = game:GetEngineFeature("PartyVoiceVolume")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Cryo")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SharedFlags")

local contextualSlider = UIBlox.App.Slider.ContextualSlider
local crossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager
local presenceType = dependencies.RoduxPresence.Enums.PresenceType
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local useEnableAudioFocusToggle = CrossExperienceVoice.Hooks.useEnableAudioFocusToggle
local useIsVoiceFocused = CrossExperienceVoice.Hooks.useIsVoiceFocused
local useSelector = dependencies.Hooks.useSelector
local useTokens = foundation.Hooks.useTokens
local useLocalization = dependencies.Hooks.useLocalization

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadParentChannelId

local FFlagSquadVoiceMenuFoundationRefactor = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadVoiceMenuFoundationRefactor")
local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")
local fFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua

local fFlagSquadsPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").FFlagSquadsPresenceStoreMigration
local useGetPresenceByUserId

if fFlagSquadsPresenceStoreMigration then
	useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FriendsCommon").Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local presenceType2

if fFlagSquadsPresenceStoreMigration then
	presenceType2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/DataHydration").Presence.PresenceEnums.PresenceType
else
	presenceType2 = nil
end

local component_assetscircle_24_stroke_1 = images["component_assets/circle_24_stroke_1"]
local component_assetscircle_16 = images["component_assets/circle_16"]

local v5 = {
	forceEnableAudioFocusToggle = false,
	forceShowVoiceChangerSection = false,
	openSquadVoiceChangers = function() end
}

local function fn(props)
	local v6 = useTokens()

	local createElement = react.createElement
	local view = foundation.View
	local v7

	if FFlagSquadVoiceMenuFoundationRefactor then
		v7 = {
			tag = "size-full-0 auto-y padding-y-small col gap-small",
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		}
	else
		v7 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = {
				top = UDim.new(0, v6.Padding.Small),
				bottom = UDim.new(0, v6.Padding.Small)
			},
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v6.Gap.Small)
			},
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		}
	end

	local createElement2 = react.createElement
	local text = foundation.Text
	local v8

	if FFlagSquadVoiceMenuFoundationRefactor then
		v8 = {
			tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left text-label-medium content-emphasis",
			LayoutOrder = 1,
			Text = props.labelText,
			testId = 0
		}
	else
		v8 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			fontStyle = v6.Typography.LabelMedium,
			textStyle = v6.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1,
			Text = props.labelText,
			testId = 0
		}
	end

	local v9 = if FFlagSquadsEnableFoundationTestIds then `{props.testId}--label` else nil
	v8.testId = v9
	return createElement(view, v7, {
		Label = createElement2(text, v8),
		SliderWrapper = react.createElement(
			foundation.View,
			FFlagSquadVoiceMenuFoundationRefactor and { tag = "size-full-0 auto-y", LayoutOrder = 2 } or {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2
			},
			{
				Slider = react.createElement(contextualSlider, {
					width = UDim.new(1, 0),
					stepInterval = 0.1,
					min = 0,
					max = 1,
					value = props.sliderValue,
					onValueChanged = props.onValueChanged
				})
			}
		)
	})
end

local function fn2(props)
	local v6 = useTokens()

	local color3 = v6.Color.Content.Emphasis.Color3
	local transparency = v6.Color.Content.Emphasis.Transparency

	local createElement = react.createElement
	local view = foundation.View
	local v7

	if FFlagSquadVoiceMenuFoundationRefactor then
		v7 = {
			tag = "size-full-0 auto-y padding-x-large padding-y-xsmall row align-x-left align-y-center gap-large",
			LayoutOrder = props.LayoutOrder,
			onActivated = props.onActivated,
			testId = props.testId
		}
	else
		v7 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = Vector2.new(v6.Padding.Large, v6.Padding.XSmall),
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v6.Gap.Large)
			},
			LayoutOrder = props.LayoutOrder,
			onActivated = props.onActivated,
			testId = props.testId
		}
	end

	local children = {
		Icon = react.createElement(imageSetLabel, {
			Size = UDim2.fromOffset(24, 24),
			BackgroundTransparency = 1,
			Image = props.icon,
			ImageColor3 = color3,
			ImageTransparency = transparency,
			LayoutOrder = 1
		}),
		Label = 0,
		RadioButtonContainer = 0
	}

	local createElement2 = react.createElement
	local text = foundation.Text
	local v8

	if FFlagSquadVoiceMenuFoundationRefactor then
		v8 = {
			tag = "auto-xy fill text-truncate-end text-no-wrap text-align-x-left text-label-medium content-emphasis",
			LayoutOrder = 2,
			Text = props.labelText,
			testId = 0
		}
	else
		v8 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			fontStyle = v6.Typography.LabelMedium,
			textStyle = v6.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2,
			Text = props.labelText,
			testId = 0
		}
	end

	local v9 = if FFlagSquadsEnableFoundationTestIds then `{props.testId}--label` else nil
	v8.testId = v9
	children.Label = createElement2(text, v8)

	local createElement3 = react.createElement
	local view2 = foundation.View
	local v10

	if FFlagSquadVoiceMenuFoundationRefactor then
		v10 = {
			tag = "auto-x row align-x-right align-y-center",
			Size = UDim2.new(0, 0, 0, 40),
			LayoutOrder = 3
		}
	else
		v10 = {
			Size = UDim2.new(0, 0, 0, 40),
			AutomaticSize = Enum.AutomaticSize.X,
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			},
			LayoutOrder = 3
		}
	end

	children.RadioButtonContainer = createElement3(view2, v10, {
		DefaultIcon = react.createElement(imageSetLabel, {
			BackgroundTransparency = 1,
			Image = component_assetscircle_24_stroke_1,
			Size = UDim2.new(0, 24, 0, 24),
			ImageColor3 = color3,
			ImageTransparency = transparency,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}, {
			SelectedIcon = props.isSelected and react.createElement(imageSetLabel, {
				BackgroundTransparency = 1,
				Image = component_assetscircle_16,
				Size = UDim2.new(0, 16, 0, 16),
				ImageColor3 = color3,
				ImageTransparency = transparency,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
		})
	})
	return createElement(view, v7, children)
end

return function(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useTokens()
	local v7 = useLocalUserId()
	local v8 = useIsVoiceFocused()
	local v9 = useEnableAudioFocusToggle()
	local v10 = react.useContext(squadExternalContractContext)

	local v11 = react.useCallback(function(p3)
		return p3.Squad.Presence.byUserId[tostring(v7)]
	end, { v7 })
	local v12

	if fFlagSquadsPresenceStoreMigration then
		v12 = useGetPresenceByUserId((tostring(v7)))
	else
		v12 = useSelector(v11)
	end

	local v13 = react.useMemo(function()
		local v14 = v12

		if not v14 then
			return v14
		end

		local userPresenceType = v12.userPresenceType
		local v15 = if fFlagSquadsPresenceStoreMigration then presenceType2.InGame else presenceType.InGame
		v14 = userPresenceType == v15
		return v14
	end, { v12 })

	local v14 = react.useMemo(function()
		if v12 and v13 then
			return v12.lastLocation
		end

		return nil
	end, { v12, v13 })

	local v15 = useCurrentSquadParentChannelId()

	local v16 = v10.useParentChannelTitleSelector(v15 or "")

	local v17 = react.useCallback(function()
		crossExperienceVoiceManager.default:toggleAudioFocus()
	end, {})

	local v18 = engineFeature
	local v19 = v13 or not v18
	local v20 = v18 and v19
	local v21 = v13 and (v9 or joined.forceEnableAudioFocusToggle)

	local state, setState = react.useState(not engineFeature and 0 or gameSettings.PartyVoiceVolume)
	local state2, setState2 = react.useState(gameSettings.MasterVolume)

	local v22 = useLocalization({
		volumeLabelText = "Feature.Squads.Label.Volume",
		partyVolumeLabelText = "Feature.Squads.Label.PartyVolume",
		experienceLabelText = "Feature.Squads.Label.Experience",
		voiceChatsLabelText = "Feature.Squads.Label.VoiceChats",
		partyLabelText = "Feature.Squads.Label.Party"
	})

	local v23 = if v20 then v22.partyLabelText else v22.partyVolumeLabelText

	local v24 = if v18 then v22.experienceLabelText else v22.volumeLabelText

	local v25 = react.useCallback(function()
		if not v8 then
			v17()
		end
	end, { v8, v17 })

	local v26 = react.useCallback(function()
		if v8 then
			v17()
		end
	end, { v8, v17 })

	local v27 = react.useCallback(function()
		if joined.openSquadVoiceChangers then
			joined.openSquadVoiceChangers()
		end
	end, { joined.openSquadVoiceChangers })

	local createElement = react.createElement
	local view = foundation.View
	local v28

	if FFlagSquadVoiceMenuFoundationRefactor then
		v28 = {
			tag = "size-full-0 auto-y padding-y-small radius-medium bg-surface-300 col",
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu" or nil
		}
	else
		v28 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = Vector2.new(0, v6.Padding.Small),
			cornerRadius = UDim.new(0, v6.Radius.Medium),
			backgroundStyle = v6.Color.Surface.Surface_300,
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			},
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu" or nil
		}
	end

	local createElement2 = react.createElement
	local view2 = foundation.View

	local v30 = FFlagSquadVoiceMenuFoundationRefactor and {
		tag = "size-full-0 auto-y padding-x-large col",
		LayoutOrder = 1
	} or {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		padding = Vector2.new(v6.Padding.Large, 0),
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		LayoutOrder = 1
	}

	if v20 then
		local createElement3 = react.createElement
		local text = foundation.Text
		local v32

		if FFlagSquadVoiceMenuFoundationRefactor then
			v32 = {
				tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left padding-y-xsmall text-title-small content-muted",
				LayoutOrder = 1,
				Text = v22.volumeLabelText,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--volume-label" or nil
			}
		else
			v32 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				fontStyle = v6.Typography.TitleSmall,
				textStyle = v6.Color.Content.Muted,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				padding = Vector2.new(0, v6.Padding.XSmall),
				Text = v22.volumeLabelText,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--volume-label" or nil
			}
		end

		v20 = createElement3(text, v32)
	end

	local v29 = {
		VolumeSection = createElement2(view2, v30, {
			VolumeLabel = v20,
			PartySliderGroup = v18 and react.createElement(fn, {
				LayoutOrder = 2,
				labelText = v23,
				sliderValue = state,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--party-volume" or nil,
				onValueChanged = function(partyVoiceVolume)
					gameSettings.PartyVoiceVolume = partyVoiceVolume
					setState(partyVoiceVolume)
				end
			}),
			ExperienceSliderGroup = v19 and react.createElement(fn, {
				LayoutOrder = 3,
				labelText = v24,
				sliderValue = state2,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--experience-volume" or nil,
				onValueChanged = function(masterVolume)
					gameSettings.MasterVolume = masterVolume
					setState2(masterVolume)
				end
			})
		}),
		Divider = v21 and react.createElement(
			foundation.View,
			FFlagSquadVoiceMenuFoundationRefactor and { tag = "size-full-0 auto-y padding-y-small", LayoutOrder = 2 } or {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2,
				padding = Vector2.new(0, v6.Padding.Small)
			},
			{
				Divider = react.createElement(foundation.View, {
					Size = UDim2.new(1, 0, 0, 1),
					backgroundStyle = v6.Color.Stroke.Default
				})
			}
		),
		VoiceChatSection = 0,
		VoiceChangerSection = 0
	}

	if v21 then
		local createElement3 = react.createElement
		local view3 = foundation.View

		local v32 = FFlagSquadVoiceMenuFoundationRefactor and { tag = "size-full-0 auto-y col", LayoutOrder = 3 } or {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			},
			LayoutOrder = 3
		}

		local createElement4 = react.createElement
		local text = foundation.Text
		local v33

		if FFlagSquadVoiceMenuFoundationRefactor then
			v33 = {
				tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left padding-x-large padding-y-xsmall text-title-small content-muted",
				LayoutOrder = 1,
				Text = v22.voiceChatsLabelText,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--voice-chats-label" or nil
			}
		else
			v33 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				fontStyle = v6.Typography.TitleSmall,
				textStyle = v6.Color.Content.Muted,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				padding = Vector2.new(v6.Padding.Large, v6.Padding.XSmall),
				Text = v22.voiceChatsLabelText,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--voice-chats-label" or nil
			}
		end

		v21 = createElement3(view3, v32, {
			VoiceChatLabel = createElement4(text, v33),
			PartySelector = react.createElement(fn2, {
				icon = images["icons/menu/platformChatOff"],
				LayoutOrder = 2,
				labelText = v16 or "",
				isSelected = v8,
				onActivated = v25,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--party-voice-selector" or nil
			}),
			ExperienceSelector = react.createElement(fn2, {
				icon = images["icons/menu/publicChatOff"],
				LayoutOrder = 3,
				labelText = v14 or "",
				isSelected = not v8,
				onActivated = v26,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--experience-voice-selector" or nil
			})
		})
	end

	v29.VoiceChatSection = v21

	local v32 = if fFlagEnablePartyVoiceChangersInLua or joined.forceShowVoiceChangerSection then react.createElement(
		foundation.View,
		{ tag = "size-full-0 auto-y col", LayoutOrder = 4 },
		{
			VoiceChangerSectionLabel = react.createElement(foundation.Text, {
				tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left padding-x-large padding-y-xsmall text-title-small content-muted",
				LayoutOrder = 1,
				Text = "Voice changers",
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--voice-changers-label" or nil
			}),
			OpenVoiceChangerModal = react.createElement(foundation.View, {
				tag = "size-full-0 auto-y row align-x-left align-y-center gap-large padding-x-large padding-y-xsmall",
				LayoutOrder = 2,
				onActivated = v27,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--choose-voice-pack-button" or nil
			}, {
				ChooseVoicePackLabel = react.createElement(foundation.Text, {
					tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left fill text-label-medium content-emphasis",
					Size = UDim2.new(1, 0, 0, 40),
					LayoutOrder = 1,
					Text = "Choose voice pack",
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--choose-voice-pack-button--label" or nil
				}),
				OpenIcon = react.createElement(foundation.Icon, {
					LayoutOrder = 2,
					name = "chevron-large-right"
				})
			})
		}
	) else nil
	v29.VoiceChangerSection = v32
	return createElement(view, v28, v29)
end
