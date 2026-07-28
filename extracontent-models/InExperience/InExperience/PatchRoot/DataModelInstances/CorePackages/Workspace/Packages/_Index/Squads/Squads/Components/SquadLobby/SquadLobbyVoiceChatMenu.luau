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
local FFlagSquadsPresenceStoreMigration = require(SquadsParent.SquadsCore.Flags).FFlagSquadsPresenceStoreMigration
local v29 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsParent.FriendsCommon).Hooks.useGetPresenceByUserId
local v30 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsParent.DataHydration).Presence.PresenceEnums.PresenceType
local v31 = Images["component_assets/circle_24_stroke_1"]
local v32 = Images["component_assets/circle_16"]
local t1 = {
	forceEnableAudioFocusToggle = false,
	forceShowVoiceChangerSection = false,
	openSquadVoiceChangers = function() -- line: 64
	end
}

local function v34(t2: {[any]: any}) -- line: 74
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), FFlagSquadVoiceMenuFoundationRefactor (copy), ContextualSlider (copy)
	local v37 = useTokens()

	return React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		padding = {
			top = UDim.new(0, v37.Padding.Small),
			bottom = UDim.new(0, v37.Padding.Small)
		},
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v37.Gap.Small)
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
			fontStyle = v37.Typography.LabelMedium,
			textStyle = v37.Color.Content.Emphasis,
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
local function v35(t3: {[any]: any}) -- line: 153
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), FFlagSquadVoiceMenuFoundationRefactor (copy), ImageSetLabel (copy), v31 (copy), v32 (copy)
	local v39 = useTokens()
	local EmphasisColor3 = v39.Color.Content.Emphasis.Color3
	local EmphasisTransparency = v39.Color.Content.Emphasis.Transparency

	return React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		padding = Vector2.new(v39.Padding.Large, v39.Padding.XSmall),
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v39.Gap.Large)
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
			fontStyle = v39.Typography.LabelMedium,
			textStyle = v39.Color.Content.Emphasis,
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
				Image = v31,
				Size = UDim2.new(0, 24, 0, 24),
				ImageColor3 = EmphasisColor3,
				ImageTransparency = EmphasisTransparency,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}, {
				SelectedIcon = t3.isSelected and React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = v32,
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

return function(t4: {[any]: any}) -- line: 256
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), useLocalUserId (copy), useIsVoiceFocused (copy), useEnableAudioFocusToggle (copy), React (copy), SquadExternalContractContext (copy), FFlagSquadsPresenceStoreMigration (copy), v29 (copy), useSelector (copy), v30 (copy), PresenceType (copy), useCurrentSquadParentChannelId (copy), CrossExperienceVoiceManager (copy), EngineFeature (copy), GameSettings (copy), useLocalization (copy), Foundation (copy), FFlagSquadVoiceMenuFoundationRefactor (copy), v34 (copy), v35 (copy), Images (copy), FFlagEnablePartyVoiceChangersInLua (copy)
	local v43 = Cryo.Dictionary.join(t1, t4)
	local v44 = useTokens()
	local v45 = useLocalUserId()
	local v46 = useIsVoiceFocused()
	local v47 = useEnableAudioFocusToggle()
	local v48 = React.useContext(SquadExternalContractContext)
	local v49 = React.useCallback(function(p1) -- line: 264
		-- upvalues: v45 (copy)
		return p1.Squad.Presence.byUserId[tostring(v45)]
	end, { v45 })
	local v50 = if not FFlagSquadsPresenceStoreMigration then useSelector(v49) else v29((tostring(v45)))
	local v51 = React.useMemo(function() -- line: 272
		-- upvalues: v50 (copy), FFlagSquadsPresenceStoreMigration (copy), v30 (copy), PresenceType (copy)
		return v50 and v50.userPresenceType == if not FFlagSquadsPresenceStoreMigration then PresenceType.InGame else v30.InGame
	end, { v50 })
	local v52 = React.useMemo(function() -- line: 278
		-- upvalues: v50 (copy), v51 (copy)
		if v50 and v51 then
			return v50.lastLocation
		end

		return nil
	end, {
		v50,
		v51
	})
	local v53 = useCurrentSquadParentChannelId()
	local v54 = v48.useParentChannelTitleSelector(v53 or "")
	local v55 = React.useCallback(function() -- line: 286
		-- upvalues: CrossExperienceVoiceManager (copy)
		CrossExperienceVoiceManager.default:toggleAudioFocus()
	end, {})
	local v56 = EngineFeature
	local v57 = v51 or not v56
	local v58 = v56 and v57
	local v59 = v51 and (v47 or v43.forceEnableAudioFocusToggle)
	local v60, v61 = React.useState(not EngineFeature and 0 or GameSettings.PartyVoiceVolume)
	local v62, v63 = React.useState(GameSettings.MasterVolume)
	local v64 = useLocalization({
		volumeLabelText = "Feature.Squads.Label.Volume",
		partyVolumeLabelText = "Feature.Squads.Label.PartyVolume",
		experienceLabelText = "Feature.Squads.Label.Experience",
		voiceChatsLabelText = "Feature.Squads.Label.VoiceChats",
		partyLabelText = "Feature.Squads.Label.Party"
	})
	local v65 = if not v58 then v64.partyVolumeLabelText else v64.partyLabelText
	local v66 = if not v56 then v64.volumeLabelText else v64.experienceLabelText
	local v67 = React.useCallback(function() -- line: 314
		-- upvalues: v46 (copy), v55 (copy)
		if not v46 then
			v55()
		end
	end, {
		v46,
		v55
	})
	local v68 = React.useCallback(function() -- line: 320
		-- upvalues: v46 (copy), v55 (copy)
		if v46 then
			v55()
		end
	end, {
		v46,
		v55
	})
	local v69 = React.useCallback(function() -- line: 327
		-- upvalues: v43 (copy)
		if v43.openSquadVoiceChangers then
			v43.openSquadVoiceChangers()
		end
	end, { v43.openSquadVoiceChangers })

	return React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		padding = Vector2.new(0, v44.Padding.Small),
		cornerRadius = UDim.new(0, v44.Radius.Medium),
		backgroundStyle = v44.Color.Surface.Surface_300,
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
			padding = Vector2.new(v44.Padding.Large, 0),
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		} else {
			tag = "size-full-0 auto-y padding-x-large col",
			LayoutOrder = 1
		}, {
			VolumeLabel = v58 and React.createElement(Foundation.Text, if not FFlagSquadVoiceMenuFoundationRefactor then {
				TextWrapped = false,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				fontStyle = v44.Typography.TitleSmall,
				textStyle = v44.Color.Content.Muted,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				padding = Vector2.new(0, v44.Padding.XSmall),
				Text = v64.volumeLabelText
			} else {
				tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left padding-y-xsmall text-title-small content-muted",
				LayoutOrder = 1,
				Text = v64.volumeLabelText
			}),
			PartySliderGroup = v56 and React.createElement(v34, {
				LayoutOrder = 2,
				labelText = v65,
				sliderValue = v60,
				onValueChanged = function(n1: number) -- line: 394
					-- upvalues: GameSettings (copy), v61 (copy)
					GameSettings.PartyVoiceVolume = n1
					v61(n1)
				end
			}),
			ExperienceSliderGroup = v57 and React.createElement(v34, {
				LayoutOrder = 3,
				labelText = v66,
				sliderValue = v62,
				onValueChanged = function(n2: number) -- line: 403
					-- upvalues: GameSettings (copy), v63 (copy)
					GameSettings.MasterVolume = n2
					v63(n2)
				end
			})
		}),
		Divider = v59 and React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = Vector2.new(0, v44.Padding.Small)
		} else {
			tag = "size-full-0 auto-y padding-y-small",
			LayoutOrder = 2
		}, {
			Divider = React.createElement(Foundation.View, {
				Size = UDim2.new(1, 0, 0, 1),
				backgroundStyle = v44.Color.Stroke.Default
			})
		}),
		VoiceChatSection = v59 and React.createElement(Foundation.View, if not FFlagSquadVoiceMenuFoundationRefactor then {
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
				fontStyle = v44.Typography.TitleSmall,
				textStyle = v44.Color.Content.Muted,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				padding = Vector2.new(v44.Padding.Large, v44.Padding.XSmall),
				Text = v64.voiceChatsLabelText
			} else {
				tag = "auto-xy text-truncate-end text-no-wrap text-align-x-left padding-x-large padding-y-xsmall text-title-small content-muted",
				LayoutOrder = 1,
				Text = v64.voiceChatsLabelText
			}),
			PartySelector = React.createElement(v35, {
				LayoutOrder = 2,
				icon = Images["icons/menu/platformChatOff"],
				labelText = v54 or "",
				isSelected = v46,
				onActivated = v67
			}),
			ExperienceSelector = React.createElement(v35, {
				LayoutOrder = 3,
				icon = Images["icons/menu/publicChatOff"],
				labelText = v52 or "",
				isSelected = not v46,
				onActivated = v68
			})
		}),
		VoiceChangerSection = if not FFlagEnablePartyVoiceChangersInLua and not v43.forceShowVoiceChangerSection then nil else React.createElement(Foundation.View, {
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
				onActivated = v69
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
