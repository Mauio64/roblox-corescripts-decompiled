local Squads = script:FindFirstAncestor("Squads")

local parent = Squads.Parent
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local UIBlox = require(parent.UIBlox)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local dependencies = require(Squads.dependencies)

local foundation = dependencies.Foundation
local react = dependencies.React
local gameSettings = UserSettings().GameSettings
local engineFeature = game:GetEngineFeature("PartyVoiceVolume")
local Cryo = require(parent.Cryo)

local Flags = Squads.Flags
local SharedFlags = require(parent.SharedFlags)

local ContextualSlider = UIBlox.App.Slider.ContextualSlider
local CrossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager
local presenceType = dependencies.RoduxPresence.Enums.PresenceType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useEnableAudioFocusToggle = CrossExperienceVoice.Hooks.useEnableAudioFocusToggle
local useIsVoiceFocused = CrossExperienceVoice.Hooks.useIsVoiceFocused
local useSelector = dependencies.Hooks.useSelector
local useTokens = foundation.Hooks.useTokens
local useLocalization = dependencies.Hooks.useLocalization

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId

local FFlagSquadVoiceMenuFoundationRefactor = require(Flags.FFlagSquadVoiceMenuFoundationRefactor)
local FFlagSquadsEnableFoundationTestIds = require(Flags.FFlagSquadsEnableFoundationTestIds)
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua

local Flags2 = require(parent.SquadsCore.Flags)
local FFlagSquadsPresenceStoreMigration = Flags2.FFlagSquadsPresenceStoreMigration
local useGetPresenceByUserId

if FFlagSquadsPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local presenceType2

if FFlagSquadsPresenceStoreMigration then
	local DataHydration = require(parent.DataHydration)
	presenceType2 = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType2 = nil
end

local component_assetscircle_24_stroke_1 = Images["component_assets/circle_24_stroke_1"]
local component_assetscircle_16 = Images["component_assets/circle_16"]

local v = {
	forceEnableAudioFocusToggle = false,
	forceShowVoiceChangerSection = false,
	openSquadVoiceChangers = function() end
}

local function fn(props)
	local v2 = useTokens()

	local createElement = react.createElement
	local view = foundation.View
	local v3

	if FFlagSquadVoiceMenuFoundationRefactor then
		v3 = {
			tag = "size-full-0 auto-y padding-y-small col gap-small",
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		}
	else
		v3 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = {
				top = UDim.new(0, v2.Padding.Small),
				bottom = UDim.new(0, v2.Padding.Small)
			},
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v2.Gap.Small)
			},
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		}
	end

	local createElement2 = react.createElement
	local text = foundation.Text
	local v4

	if FFlagSquadVoiceMenuFoundationRefactor then
		v4 = {
			tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left text-label-medium content-emphasis",
			LayoutOrder = 1,
			Text = props.labelText,
			testId = 0
		}
	else
		v4 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			fontStyle = v2.Typography.LabelMedium,
			textStyle = v2.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1,
			Text = props.labelText,
			testId = 0
		}
	end

	local testId

	if FFlagSquadsEnableFoundationTestIds then
		testId = `{props.testId}--label`
	end

	v4.testId = testId
	return createElement(view, v3, {
		Label = createElement2(text, v4),
		SliderWrapper = react.createElement(
			foundation.View,
			FFlagSquadVoiceMenuFoundationRefactor and {
				tag = "size-full-0 auto-y",
				LayoutOrder = 2
			} or {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2
			},
			{
				Slider = react.createElement(ContextualSlider, {
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
	local v2 = useTokens()

	local color3 = v2.Color.Content.Emphasis.Color3
	local transparency = v2.Color.Content.Emphasis.Transparency

	local createElement = react.createElement
	local view = foundation.View
	local v3

	if FFlagSquadVoiceMenuFoundationRefactor then
		v3 = {
			tag = "size-full-0 auto-y padding-x-large padding-y-xsmall row align-x-left align-y-center gap-large",
			LayoutOrder = props.LayoutOrder,
			onActivated = props.onActivated,
			testId = props.testId
		}
	else
		v3 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = Vector2.new(v2.Padding.Large, v2.Padding.XSmall),
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v2.Gap.Large)
			},
			LayoutOrder = props.LayoutOrder,
			onActivated = props.onActivated,
			testId = props.testId
		}
	end

	local children = {
		Icon = react.createElement(ImageSetLabel, {
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
	local v4

	if FFlagSquadVoiceMenuFoundationRefactor then
		v4 = {
			tag = "auto-xy fill text-truncate-end text-no-wrap text-align-x-left text-label-medium content-emphasis",
			LayoutOrder = 2,
			Text = props.labelText,
			testId = 0
		}
	else
		v4 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			fontStyle = v2.Typography.LabelMedium,
			textStyle = v2.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2,
			Text = props.labelText,
			testId = 0
		}
	end

	local testId

	if FFlagSquadsEnableFoundationTestIds then
		testId = `{props.testId}--label`
	end

	v4.testId = testId
	children.Label = createElement2(text, v4)

	local createElement3 = react.createElement
	local view2 = foundation.View
	local v5

	if FFlagSquadVoiceMenuFoundationRefactor then
		v5 = {
			tag = "auto-x row align-x-right align-y-center",
			Size = UDim2.new(0, 0, 0, 40),
			LayoutOrder = 3
		}
	else
		v5 = {
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

	children.RadioButtonContainer = createElement3(view2, v5, {
		DefaultIcon = react.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = component_assetscircle_24_stroke_1,
			Size = UDim2.new(0, 24, 0, 24),
			ImageColor3 = color3,
			ImageTransparency = transparency,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}, {
			SelectedIcon = props.isSelected and react.createElement(ImageSetLabel, {
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
	return createElement(view, v3, children)
end

return function(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useTokens()
	local v3 = useLocalUserId()
	local isSelected = useIsVoiceFocused()
	local v4 = useEnableAudioFocusToggle()
	local v5 = react.useContext(SquadExternalContractContext)

	local v6 = react.useCallback(function(p2)
		return p2.Squad.Presence.byUserId[tostring(v3)]
	end, { v3 })
	local v7

	if FFlagSquadsPresenceStoreMigration then
		v7 = useGetPresenceByUserId((tostring(v3)))
	else
		v7 = useSelector(v6)
	end

	local v8 = react.useMemo(function()
		local v8 = v7

		if not v8 then
			return v8
		end

		local userPresenceType = v7.userPresenceType
		local v9

		if FFlagSquadsPresenceStoreMigration then
			v9 = presenceType2.InGame
		else
			v9 = presenceType.InGame
		end

		return userPresenceType == v9
	end, { v7 })

	local v9 = react.useMemo(function()
		return if v7 and v8 then v7.lastLocation else nil
	end, { v7, v8 })

	local v10 = useCurrentSquadParentChannelId()

	local v11 = v5.useParentChannelTitleSelector(v10 or "")

	local v12 = react.useCallback(function()
		CrossExperienceVoiceManager.default:toggleAudioFocus()
	end, {})

	local v13 = engineFeature
	local v14 = v8 or not v13
	local volumeLabel = v13 and v14
	local voiceChatSection = v8 and (v4 or joined.forceEnableAudioFocusToggle)

	local state, setState = react.useState(not engineFeature and 0 or gameSettings.PartyVoiceVolume)
	local state2, setState2 = react.useState(gameSettings.MasterVolume)

	local v15 = useLocalization({
		volumeLabelText = "Feature.Squads.Label.Volume",
		partyVolumeLabelText = "Feature.Squads.Label.PartyVolume",
		experienceLabelText = "Feature.Squads.Label.Experience",
		voiceChatsLabelText = "Feature.Squads.Label.VoiceChats",
		partyLabelText = "Feature.Squads.Label.Party"
	})
	local labelText

	if volumeLabel then
		labelText = v15.partyLabelText
	else
		labelText = v15.partyVolumeLabelText
	end

	local labelText2

	if v13 then
		labelText2 = v15.experienceLabelText
	else
		labelText2 = v15.volumeLabelText
	end

	local onActivated = react.useCallback(function()
		if not isSelected then
			v12()
		end
	end, { isSelected, v12 })

	local onActivated2 = react.useCallback(function()
		if isSelected then
			v12()
		end
	end, { isSelected, v12 })

	local onActivated3 = react.useCallback(function()
		if joined.openSquadVoiceChangers then
			joined.openSquadVoiceChangers()
		end
	end, { joined.openSquadVoiceChangers })

	local createElement = react.createElement
	local view = foundation.View
	local v16

	if FFlagSquadVoiceMenuFoundationRefactor then
		v16 = {
			tag = "size-full-0 auto-y padding-y-small radius-medium bg-surface-300 col",
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu" or nil
		}
	else
		v16 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = Vector2.new(0, v2.Padding.Small),
			cornerRadius = UDim.new(0, v2.Radius.Medium),
			backgroundStyle = v2.Color.Surface.Surface_300,
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			},
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu" or nil
		}
	end

	local createElement2 = react.createElement
	local view2 = foundation.View

	local v17 = FFlagSquadVoiceMenuFoundationRefactor
		and { tag = "size-full-0 auto-y padding-x-large col", LayoutOrder = 1 }
		or {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = Vector2.new(v2.Padding.Large, 0),
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			},
			LayoutOrder = 1
		}

	if volumeLabel then
		local createElement3 = react.createElement
		local text = foundation.Text
		local v18

		if FFlagSquadVoiceMenuFoundationRefactor then
			v18 = {
				tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left padding-y-xsmall text-title-small content-muted",
				LayoutOrder = 1,
				Text = v15.volumeLabelText,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--volume-label" or nil
			}
		else
			v18 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				fontStyle = v2.Typography.TitleSmall,
				textStyle = v2.Color.Content.Muted,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				padding = Vector2.new(0, v2.Padding.XSmall),
				Text = v15.volumeLabelText,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--volume-label" or nil
			}
		end

		volumeLabel = createElement3(text, v18)
	end

	local v18 = {
		VolumeSection = createElement2(view2, v17, {
			VolumeLabel = volumeLabel,
			PartySliderGroup = v13 and react.createElement(fn, {
				LayoutOrder = 2,
				labelText = labelText,
				sliderValue = state,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--party-volume" or nil,
				onValueChanged = function(partyVoiceVolume: number)
					gameSettings.PartyVoiceVolume = partyVoiceVolume
					setState(partyVoiceVolume)
				end
			}),
			ExperienceSliderGroup = v14 and react.createElement(fn, {
				LayoutOrder = 3,
				labelText = labelText2,
				sliderValue = state2,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--experience-volume" or nil,
				onValueChanged = function(masterVolume: number)
					gameSettings.MasterVolume = masterVolume
					setState2(masterVolume)
				end
			})
		}),
		Divider = voiceChatSection and react.createElement(
			foundation.View,
			FFlagSquadVoiceMenuFoundationRefactor and {
				tag = "size-full-0 auto-y padding-y-small",
				LayoutOrder = 2
			} or {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2,
				padding = Vector2.new(0, v2.Padding.Small)
			},
			{
				Divider = react.createElement(foundation.View, {
					Size = UDim2.new(1, 0, 0, 1),
					backgroundStyle = v2.Color.Stroke.Default
				})
			}
		),
		VoiceChatSection = 0,
		VoiceChangerSection = 0
	}

	if voiceChatSection then
		local createElement3 = react.createElement
		local view3 = foundation.View

		local v19 = FFlagSquadVoiceMenuFoundationRefactor and {
			tag = "size-full-0 auto-y col",
			LayoutOrder = 3
		} or {
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
		local v20

		if FFlagSquadVoiceMenuFoundationRefactor then
			v20 = {
				tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left padding-x-large padding-y-xsmall text-title-small content-muted",
				LayoutOrder = 1,
				Text = v15.voiceChatsLabelText,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--voice-chats-label" or nil
			}
		else
			v20 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				fontStyle = v2.Typography.TitleSmall,
				textStyle = v2.Color.Content.Muted,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				padding = Vector2.new(v2.Padding.Large, v2.Padding.XSmall),
				Text = v15.voiceChatsLabelText,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--voice-chats-label" or nil
			}
		end

		voiceChatSection = createElement3(view3, v19, {
			VoiceChatLabel = createElement4(text, v20),
			PartySelector = react.createElement(fn2, {
				icon = Images["icons/menu/platformChatOff"],
				LayoutOrder = 2,
				labelText = v11 or "",
				isSelected = isSelected,
				onActivated = onActivated,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--party-voice-selector" or nil
			}),
			ExperienceSelector = react.createElement(fn2, {
				icon = Images["icons/menu/publicChatOff"],
				LayoutOrder = 3,
				labelText = v9 or "",
				isSelected = not isSelected,
				onActivated = onActivated2,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-chat-menu--experience-voice-selector" or nil
			})
		})
	end

	v18.VoiceChatSection = voiceChatSection
	local voiceChangerSection

	if FFlagEnablePartyVoiceChangersInLua or joined.forceShowVoiceChangerSection then
		voiceChangerSection = react.createElement(
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
					onActivated = onActivated3,
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
		)
	end

	v18.VoiceChangerSection = voiceChangerSection
	return createElement(view, v16, v18)
end
