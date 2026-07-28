local Parent = script:FindFirstAncestor("GameJoinCard").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local Icon = Foundation.Icon
local Button = Foundation.Button
local Skeleton = Foundation.Skeleton
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local EnumsRadius = Foundation.Enums.Radius
local getBuilderIconForCurrentPlatform = Foundation.Utility.getBuilderIconForCurrentPlatform
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local ControlState = Foundation.Enums.ControlState
local AnalyticsConstants = require(script.Parent.Parent.Parent.Analytics.AnalyticsConstants)
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local SharedFlags = require(Parent.SharedFlags)
local FFlagEnableConsoleGameJoinCard = SharedFlags.FFlagEnableConsoleGameJoinCard
local FFlagJoinCardAgeCheckUpsell = SharedFlags.FFlagJoinCardAgeCheckUpsell
local FFlagBlockEDPClickthrough = SharedFlags.FFlagBlockEDPClickthrough
local FFlagDesktopGameJoinCardUIImprovements = SharedFlags.FFlagDesktopGameJoinCardUIImprovements
local AgeCheckUpsellCTA = require(script.Parent.Parent.AgeCheckUpsellCTA)

local function DesktopGameJoinCard(t1: {[any]: any}) -- line: 63
	-- upvalues: useTokens (copy), useScaledValue (copy), useLocalization (copy), React (copy), getBuilderIconForCurrentPlatform (copy), viewEDPsourceValues (copy), viewProfileSourceValues (copy), FFlagDesktopGameJoinCardUIImprovements (copy), ControlState (copy), FFlagJoinCardAgeCheckUpsell (copy), View (copy), FFlagEnableConsoleGameJoinCard (copy), FoundationImage (copy), FFlagBlockEDPClickthrough (copy), StateLayerAffordance (copy), Skeleton (copy), EnumsRadius (copy), FoundationText (copy), Icon (copy), IconSize (copy), AgeCheckUpsellCTA (copy), Button (copy), ButtonVariant (copy), InputSize (copy), Foundation (copy)
	local v31 = useTokens()
	local v32 = useScaledValue(260)
	local v33 = useLocalization({
		isPlaying = "Feature.Friends.Text.IsPlaying",
		joinButton = "Feature.Profile.Action.JoinGame",
		chat = "Feature.Profile.Action.Chat",
		viewProfile = "Feature.Profile.Action.ViewProfile"
	})
	local layoutOrder = t1.layoutOrder
	local playerName = t1.playerName
	local experienceName = t1.experienceName
	local gameIconUrl = t1.gameIconUrl
	local isLoading = t1.isLoading
	local v39 = if not t1.isConsole then v31.Size.Size_1000 else v31.Size.Size_1500
	local v40 = React.useMemo(function() -- line: 79
		-- upvalues: getBuilderIconForCurrentPlatform (copy)
		return getBuilderIconForCurrentPlatform()
	end, {})
	local v41 = React.useCallback(function() -- line: 83
		-- upvalues: t1 (copy), viewEDPsourceValues (copy)
		t1.onViewExperienceDetails(viewEDPsourceValues.Thumbnail)
	end, { t1 })
	local v42 = React.useCallback(function() -- line: 87
		-- upvalues: t1 (copy), viewEDPsourceValues (copy)
		t1.onViewExperienceDetails(viewEDPsourceValues.Title)
	end, { t1 })
	local v43 = React.useCallback(function() -- line: 91
		-- upvalues: t1 (copy), viewProfileSourceValues (copy)
		if t1.onViewProfile then
			t1.onViewProfile(viewProfileSourceValues.ViewProfileButton)
		end
	end, { t1 })
	local v44 = nil
	local u45 = nil
	local v46 = nil

	if FFlagDesktopGameJoinCardUIImprovements then
		local v47

		v44, v47 = React.useState(false)
		u45 = v47
		v46 = React.useCallback(function(p1) -- line: 101
			-- upvalues: u45 (ref), ControlState (copy)
			u45(p1 == ControlState.Hover)
		end, {})
	end

	local v48 = if not FFlagDesktopGameJoinCardUIImprovements or not v44 then v33.viewProfile else `<u>{ v33.viewProfile }</u>`
	local v49 = FFlagJoinCardAgeCheckUpsell and t1.ageCheckRequired == true
	local v50 = React.createElement(View, {
		tag = "col gap-medium padding-large radius-medium stroke-thin stroke-muted",
		Size = UDim2.fromOffset(v32, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = layoutOrder,
		backgroundStyle = v31.Color.OverMedia.OverMedia_300,
		ref = if not FFlagEnableConsoleGameJoinCard then nil else t1.focusRootRef
	}, {
		GameInfoRow = React.createElement(View, {
			tag = "row gap-small items-center size-full-0 auto-y align-x-left",
			LayoutOrder = 1
		}, {
			GameIcon = if isLoading then React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v39, v39),
				radius = EnumsRadius.Small
			}) else React.createElement(View, {
				LayoutOrder = 1,
				ClipsDescendants = true,
				Size = UDim2.fromOffset(v39, v39)
			}, {
				Thumbnail = React.createElement(FoundationImage, {
					tag = "radius-small",
					Image = gameIconUrl,
					Size = UDim2.fromScale(1, 1),
					ScaleType = Enum.ScaleType.Fit,
					onActivated = if not FFlagBlockEDPClickthrough then v41 else nil,
					stateLayer = if FFlagBlockEDPClickthrough or not t1.onViewExperienceDetails then nil else {
						affordance = StateLayerAffordance.None
					}
				})
			}),
			TextContainer = React.createElement(View, {
				tag = "col size-full-0 auto-y gap-xxsmall shrink align-x-left items-start",
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				GameInfo = React.createElement(View, {
					tag = "col size-full-0 auto-y shrink align-x-left items-start",
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					GameTitle = if isLoading then React.createElement(Skeleton, {
						LayoutOrder = 1,
						Size = UDim2.new(0.7, 0, 0, v31.Typography.BodyMedium.FontSize),
						radius = EnumsRadius.Small
					}) else React.createElement(View, {
						tag = "row auto-y gap-xxsmall size-full-0 align-x-left align-y-center text-body-medium content-default text-align-x-left",
						LayoutOrder = 1
					}, {
						PlayerName = React.createElement(FoundationText, {
							tag = "shrink auto-xy text-body-medium content-default text-no-wrap text-truncate-end text-align-x-left",
							LayoutOrder = 1,
							Text = playerName
						}),
						IsPlaying = React.createElement(FoundationText, {
							tag = "shrink-0 auto-xy text-body-medium content-default text-align-x-left",
							LayoutOrder = 2,
							Text = v33.isPlaying
						})
					}),
					GameName = if isLoading then React.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.new(0.5, 0, 0, v31.Typography.TitleMedium.FontSize),
						radius = EnumsRadius.Small
					}) else React.createElement(View, {
						tag = "size-full-0 auto-y",
						LayoutOrder = 2,
						onActivated = if not FFlagBlockEDPClickthrough then v42 else nil,
						stateLayer = if not FFlagBlockEDPClickthrough then {
							affordance = StateLayerAffordance.None
						} else nil
					}, {
						Label = React.createElement(FoundationText, {
							Text = experienceName,
							tag = {
								["size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left content-emphasis"] = true,
								["text-truncate-split"] = FFlagDesktopGameJoinCardUIImprovements,
								["text-truncate-end"] = not FFlagDesktopGameJoinCardUIImprovements
							}
						})
					})
				}),
				PlatformName = if not t1.isConsole then nil else if isLoading then React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.6, 0, 0, v31.Typography.BodySmall.FontSize),
					radius = EnumsRadius.Small
				}) else React.createElement(View, {
					LayoutOrder = 2,
					tag = "row align-x-left items-center gap-small size-full-0 auto-y",
					onActivated = if not FFlagEnableConsoleGameJoinCard then nil else t1.onPlatformProfilePressed,
					selection = if not FFlagEnableConsoleGameJoinCard or not t1.onPlatformProfilePressed then nil else {
						Selectable = true
					},
					stateLayer = if not FFlagEnableConsoleGameJoinCard or not t1.onPlatformProfilePressed then nil else {
						affordance = StateLayerAffordance.Background
					}
				}, {
					PlatformLogo = React.createElement(View, {
						tag = "auto-xy shrink",
						LayoutOrder = 1
					}, {
						LogoImage = React.createElement(Icon, {
							name = v40,
							size = IconSize.XSmall
						})
					}),
					PlatformNameLabel = React.createElement(FoundationText, {
						tag = "fill shrink auto-y text-body-small content-default text-no-wrap text-truncate-end text-align-x-left",
						LayoutOrder = 2,
						Text = t1.consolePlatformLabel
					})
				})
			})
		}),
		Actions = if t1.isConsole then nil else React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			JoinButton = if not v49 then React.createElement(Button, {
				tag = "align-x-center fill size-full-0",
				LayoutOrder = 1,
				text = v33.joinButton,
				onActivated = t1.onJoin,
				isLoading = isLoading,
				variant = ButtonVariant.Emphasis,
				size = InputSize.Medium,
				width = UDim.new(1, 0)
			}) else React.createElement(AgeCheckUpsellCTA, {
				LayoutOrder = 1,
				onUnlockPressed = t1.onAgeCheckPressed or function() -- line: 260
				end
			}),
			ChatButton = if t1.onChat == nil then nil else React.createElement(Button, {
				tag = "align-x-center fill size-full-0",
				LayoutOrder = 2,
				text = v33.chat,
				onActivated = t1.onChat,
				variant = ButtonVariant.Standard,
				size = InputSize.Medium,
				width = UDim.new(1, 0)
			}),
			ViewProfileButton = if t1.onViewProfile == nil then nil else React.createElement(View, {
				tag = "row align-x-center align-y-center",
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v31.Size.Size_600),
				onActivated = v43,
				onStateChanged = if not FFlagDesktopGameJoinCardUIImprovements then nil else v46,
				stateLayer = {
					affordance = StateLayerAffordance.None
				}
			}, {
				Label = React.createElement(FoundationText, {
					tag = "auto-xy text-title-medium text-align-x-center content-emphasis",
					Text = v48,
					RichText = FFlagDesktopGameJoinCardUIImprovements
				})
			})
		})
	})

	return React.createElement(Foundation.Popover.Root, {
		isOpen = t1.isOpen
	}, {
		Anchor = React.createElement(Foundation.Popover.Anchor, {
			anchorRef = t1.anchorRef
		}),
		Content = React.createElement(Foundation.Popover.Content, {
			hasArrow = false,
			align = Foundation.Enums.PopoverAlign.Center,
			side = if not FFlagEnableConsoleGameJoinCard or not t1.isConsole then Foundation.Enums.PopoverSide.Bottom else {
				position = Foundation.Enums.PopoverSide.Bottom,
				offset = v31.Padding.Small
			},
			radius = Foundation.Enums.Radius.Medium,
			backgroundStyle = v31.Color.None,
			onPressedOutside = t1.onClose
		}, {
			GameJoinCard = v50
		})
	})
end

return DesktopGameJoinCard
