local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local CrossExperienceVoice = require(SquadsParent.CrossExperienceVoice)
local UIBlox = require(SquadsParent.UIBlox)
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local dependencies = require(Squads.dependencies)
local Foundation = dependencies.Foundation
local React = dependencies.React
local GameSettings = UserSettings().GameSettings
local EngineFeature = game:GetEngineFeature("PartyVoiceVolume")
local Cryo = require(SquadsParent.Cryo)
local Flags = Squads.Flags
local SharedFlags = require(SquadsParent.SharedFlags)
local ContextualSlider = UIBlox.App.Slider.ContextualSlider
local CrossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useEnableAudioFocusToggle = CrossExperienceVoice.Hooks.useEnableAudioFocusToggle
local useIsVoiceFocused = CrossExperienceVoice.Hooks.useIsVoiceFocused
local useSelector = dependencies.Hooks.useSelector
local useTokens = Foundation.Hooks.useTokens
local useLocalization = dependencies.Hooks.useLocalization
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local useCurrentSquadParentChannelId = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadParentChannelId
local FFlagSquadVoiceMenuFoundationRefactor = require(Flags.FFlagSquadVoiceMenuFoundationRefactor)
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local v28 = Images["component_assets/circle_24_stroke_1"]
local v29 = Images["component_assets/circle_16"]
local t1 = {
	forceEnableAudioFocusToggle = false,
	forceShowVoiceChangerSection = false,
	openSquadVoiceChangers = function() -- line: 56
	end
}

local function v31(t2: {[any]: any}) -- line: 66
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), FFlagSquadVoiceMenuFoundationRefactor (copy), ContextualSlider (copy)
	local v34 = useTokens()

	return React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		padding = {
			top = UDim.new(0, v34.Padding.Small),
			bottom = UDim.new(0, v34.Padding.Small)
		},
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v34.Gap.Small)
		},
		LayoutOrder = t2.LayoutOrder
	} else {
		tag = "size-full-0 auto-y padding-y-small col gap-small",
		LayoutOrder = t2.LayoutOrder
	}, {
		Label = React.createElement(Foundation.Text, if not FFlagSquadVoiceMenuFoundationRefactor then {
			TextWrapped = false,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			fontStyle = v34.Typography.LabelMedium,
			textStyle = v34.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = t2.labelText
		} else {
			tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left text-label-medium content-emphasis",
			LayoutOrder = 1,
			Text = t2.labelText
		}),
		SliderWrapper = React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		} else {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			Slider = React.createElement(ContextualSlider, {
				stepInterval = 0.1,
				min = 0,
				max = 1,
				width = UDim.new(1, 0),
				value = t2.sliderValue,
				onValueChanged = t2.onValueChanged
			})
		})
	})
end
local function v32(t3: {[any]: any}) -- line: 145
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), FFlagSquadVoiceMenuFoundationRefactor (copy), ImageSetLabel (copy), v28 (copy), v29 (copy)
	local v36 = useTokens()
	local EmphasisColor3 = v36.Color.Content.Emphasis.Color3
	local EmphasisTransparency = v36.Color.Content.Emphasis.Transparency

	return React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		padding = Vector2.new(v36.Padding.Large, v36.Padding.XSmall),
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v36.Gap.Large)
		},
		LayoutOrder = t3.LayoutOrder,
		onActivated = t3.onActivated
	} else {
		tag = "size-full-0 auto-y padding-x-large padding-y-xsmall row align-x-left align-y-center gap-large",
		LayoutOrder = t3.LayoutOrder,
		onActivated = t3.onActivated
	}, {
		Icon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(24, 24),
			Image = t3.icon,
			ImageColor3 = EmphasisColor3,
			ImageTransparency = EmphasisTransparency
		}),
		Label = React.createElement(Foundation.Text, if not FFlagSquadVoiceMenuFoundationRefactor then {
			TextWrapped = false,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.XY,
			flexItem = {
				FlexMode = Enum.UIFlexMode.Fill
			},
			fontStyle = v36.Typography.LabelMedium,
			textStyle = v36.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = t3.labelText
		} else {
			tag = "auto-xy fill text-truncate-end text-no-wrap text-align-x-left text-label-medium content-emphasis",
			LayoutOrder = 2,
			Text = t3.labelText
		}),
		RadioButtonContainer = React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
			LayoutOrder = 3,
			Size = UDim2.new(0, 0, 0, 40),
			AutomaticSize = Enum.AutomaticSize.X,
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}
		} else {
			tag = "auto-x row align-x-right align-y-center",
			LayoutOrder = 3,
			Size = UDim2.new(0, 0, 0, 40)
		}, {
			DefaultIcon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = v28,
				Size = UDim2.new(0, 24, 0, 24),
				ImageColor3 = EmphasisColor3,
				ImageTransparency = EmphasisTransparency,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}, {
				SelectedIcon = t3.isSelected and React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = v29,
					Size = UDim2.new(0, 16, 0, 16),
					ImageColor3 = EmphasisColor3,
					ImageTransparency = EmphasisTransparency,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})
			})
		})
	})
end

return function(t4: {[any]: any}) -- line: 248
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), useLocalUserId (copy), useIsVoiceFocused (copy), useEnableAudioFocusToggle (copy), React (copy), SquadExternalContractContext (copy), useSelector (copy), PresenceType (copy), useCurrentSquadParentChannelId (copy), CrossExperienceVoiceManager (copy), EngineFeature (copy), GameSettings (copy), useLocalization (copy), Foundation (copy), FFlagSquadVoiceMenuFoundationRefactor (copy), v31 (copy), v32 (copy), Images (copy), FFlagEnablePartyVoiceChangersInLua (copy)
	local v40 = Cryo.Dictionary.join(t1, t4)
	local v41 = useTokens()
	local v42 = useLocalUserId()
	local v43 = useIsVoiceFocused()
	local v44 = useEnableAudioFocusToggle()
	local v45 = React.useContext(SquadExternalContractContext)
	local v46 = React.useCallback(function(p1) -- line: 256
		-- upvalues: v42 (copy)
		return p1.Squad.Presence.byUserId[tostring(v42)]
	end, { v42 })
	local v47 = useSelector(v46)
	local v48 = React.useMemo(function() -- line: 261
		-- upvalues: v47 (copy), PresenceType (copy)
		return v47 and v47.userPresenceType == PresenceType.InGame
	end, { v47 })
	local v49 = React.useMemo(function() -- line: 265
		-- upvalues: v47 (copy), v48 (copy)
		if v47 and v48 then
			return v47.lastLocation
		end

		return nil
	end, {
		v47,
		v48
	})
	local v50 = useCurrentSquadParentChannelId()
	local v51 = v45.useParentChannelTitleSelector(v50 or "")
	local v52 = React.useCallback(function() -- line: 273
		-- upvalues: CrossExperienceVoiceManager (copy)
		CrossExperienceVoiceManager.default:toggleAudioFocus()
	end, {})
	local v53 = EngineFeature
	local v54 = v48 or not v53
	local v55 = v53 and v54
	local v56 = v48 and (v44 or v40.forceEnableAudioFocusToggle)
	local v57, v58 = React.useState(not EngineFeature and 0 or GameSettings.PartyVoiceVolume)
	local v59, v60 = React.useState(GameSettings.MasterVolume)
	local v61 = useLocalization({
		volumeLabelText = "Feature.Squads.Label.Volume",
		partyVolumeLabelText = "Feature.Squads.Label.PartyVolume",
		experienceLabelText = "Feature.Squads.Label.Experience",
		voiceChatsLabelText = "Feature.Squads.Label.VoiceChats",
		partyLabelText = "Feature.Squads.Label.Party"
	})
	local v62 = if not v55 then v61.partyVolumeLabelText else v61.partyLabelText
	local v63 = if not v53 then v61.volumeLabelText else v61.experienceLabelText
	local v64 = React.useCallback(function() -- line: 301
		-- upvalues: v43 (copy), v52 (copy)
		if not v43 then
			v52()
		end
	end, {
		v43,
		v52
	})
	local v65 = React.useCallback(function() -- line: 307
		-- upvalues: v43 (copy), v52 (copy)
		if v43 then
			v52()
		end
	end, {
		v43,
		v52
	})
	local v66 = React.useCallback(function() -- line: 314
		-- upvalues: v40 (copy)
		if v40.openSquadVoiceChangers then
			v40.openSquadVoiceChangers()
		end
	end, { v40.openSquadVoiceChangers })

	return React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		padding = Vector2.new(0, v41.Padding.Small),
		cornerRadius = UDim.new(0, v41.Radius.Medium),
		backgroundStyle = v41.Color.Surface.Surface_300,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	} else {
		tag = "size-full-0 auto-y padding-y-small radius-medium bg-surface-300 col"
	}, {
		VolumeSection = React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = Vector2.new(v41.Padding.Large, 0),
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		} else {
			tag = "size-full-0 auto-y padding-x-large col",
			LayoutOrder = 1
		}, {
			VolumeLabel = v55 and React.createElement(Foundation.Text, if not FFlagSquadVoiceMenuFoundationRefactor then {
				TextWrapped = false,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				fontStyle = v41.Typography.TitleSmall,
				textStyle = v41.Color.Content.Muted,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				padding = Vector2.new(0, v41.Padding.XSmall),
				Text = v61.volumeLabelText
			} else {
				tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left padding-y-xsmall text-title-small content-muted",
				LayoutOrder = 1,
				Text = v61.volumeLabelText
			}),
			PartySliderGroup = v53 and React.createElement(v31, {
				LayoutOrder = 2,
				labelText = v62,
				sliderValue = v57,
				onValueChanged = function(n1: number) -- line: 381
					-- upvalues: GameSettings (copy), v58 (copy)
					GameSettings.PartyVoiceVolume = n1
					v58(n1)
				end
			}),
			ExperienceSliderGroup = v54 and React.createElement(v31, {
				LayoutOrder = 3,
				labelText = v63,
				sliderValue = v59,
				onValueChanged = function(n2: number) -- line: 390
					-- upvalues: GameSettings (copy), v60 (copy)
					GameSettings.MasterVolume = n2
					v60(n2)
				end
			})
		}),
		Divider = v56 and React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = Vector2.new(0, v41.Padding.Small)
		} else {
			tag = "size-full-0 auto-y padding-y-small",
			LayoutOrder = 2
		}, {
			Divider = React.createElement(Foundation.View, {
				Size = UDim2.new(1, 0, 0, 1),
				backgroundStyle = v41.Color.Stroke.Default
			})
		}),
		VoiceChatSection = v56 and React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		} else {
			tag = "size-full-0 auto-y col",
			LayoutOrder = 3
		}, {
			VoiceChatLabel = React.createElement(Foundation.Text, if not FFlagSquadVoiceMenuFoundationRefactor then {
				TextWrapped = false,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				fontStyle = v41.Typography.TitleSmall,
				textStyle = v41.Color.Content.Muted,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				padding = Vector2.new(v41.Padding.Large, v41.Padding.XSmall),
				Text = v61.voiceChatsLabelText
			} else {
				tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left padding-x-large padding-y-xsmall text-title-small content-muted",
				LayoutOrder = 1,
				Text = v61.voiceChatsLabelText
			}),
			PartySelector = React.createElement(v32, {
				LayoutOrder = 2,
				icon = Images["icons/menu/platformChatOff"],
				labelText = v51 or "",
				isSelected = v43,
				onActivated = v64
			}),
			ExperienceSelector = React.createElement(v32, {
				LayoutOrder = 3,
				icon = Images["icons/menu/publicChatOff"],
				labelText = v49 or "",
				isSelected = not v43,
				onActivated = v65
			})
		}),
		VoiceChangerSection = if not FFlagEnablePartyVoiceChangersInLua and not v40.forceShowVoiceChangerSection then nil else React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y col",
			LayoutOrder = 4
		}, {
			VoiceChangerSectionLabel = React.createElement(Foundation.Text, {
				tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left padding-x-large padding-y-xsmall text-title-small content-muted",
				LayoutOrder = 1,
				Text = "Voice changers"
			}),
			OpenVoiceChangerModal = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y row align-x-left align-y-center gap-large padding-x-large padding-y-xsmall",
				LayoutOrder = 2,
				onActivated = v66
			}, {
				ChooseVoicePackLabel = React.createElement(Foundation.Text, {
					tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left fill text-label-medium content-emphasis",
					LayoutOrder = 1,
					Text = "Choose voice pack",
					Size = UDim2.new(1, 0, 0, 40)
				}),
				OpenIcon = React.createElement(Foundation.Icon, {
					LayoutOrder = 2,
					name = "chevron-large-right"
				})
			})
		})
	})
end
