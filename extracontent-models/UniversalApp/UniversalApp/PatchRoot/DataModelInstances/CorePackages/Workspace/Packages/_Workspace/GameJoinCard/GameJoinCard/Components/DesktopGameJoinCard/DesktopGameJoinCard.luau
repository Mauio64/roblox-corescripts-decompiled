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
local AnalyticsConstants = require(script.Parent.Parent.Parent.Analytics.AnalyticsConstants)
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local SharedFlags = require(Parent.SharedFlags)
local FFlagEnableConsoleGameJoinCard = SharedFlags.FFlagEnableConsoleGameJoinCard
local FFlagJoinCardAgeCheckUpsell = SharedFlags.FFlagJoinCardAgeCheckUpsell
local FFlagBlockEDPClickthrough = SharedFlags.FFlagBlockEDPClickthrough
local AgeCheckUpsellCTA = require(script.Parent.Parent.AgeCheckUpsellCTA)

local function DesktopGameJoinCard(t1: {[any]: any}) -- line: 61
	-- upvalues: useTokens (copy), useScaledValue (copy), useLocalization (copy), React (copy), getBuilderIconForCurrentPlatform (copy), viewEDPsourceValues (copy), viewProfileSourceValues (copy), FFlagJoinCardAgeCheckUpsell (copy), View (copy), FFlagEnableConsoleGameJoinCard (copy), FoundationImage (copy), FFlagBlockEDPClickthrough (copy), StateLayerAffordance (copy), Skeleton (copy), EnumsRadius (copy), FoundationText (copy), Icon (copy), IconSize (copy), AgeCheckUpsellCTA (copy), Button (copy), ButtonVariant (copy), InputSize (copy), Foundation (copy)
	local v29 = useTokens()
	local v30 = useScaledValue(260)
	local v31 = useLocalization({
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
	local v37 = if not t1.isConsole then v29.Size.Size_1000 else v29.Size.Size_1500
	local v38 = React.useMemo(function() -- line: 77
		-- upvalues: getBuilderIconForCurrentPlatform (copy)
		return getBuilderIconForCurrentPlatform()
	end, {})
	local v39 = React.useCallback(function() -- line: 81
		-- upvalues: t1 (copy), viewEDPsourceValues (copy)
		t1.onViewExperienceDetails(viewEDPsourceValues.Thumbnail)
	end, { t1 })
	local v40 = React.useCallback(function() -- line: 85
		-- upvalues: t1 (copy), viewEDPsourceValues (copy)
		t1.onViewExperienceDetails(viewEDPsourceValues.Title)
	end, { t1 })
	local v41 = React.useCallback(function() -- line: 89
		-- upvalues: t1 (copy), viewProfileSourceValues (copy)
		if t1.onViewProfile then
			t1.onViewProfile(viewProfileSourceValues.ViewProfileButton)
		end
	end, { t1 })
	local v42 = FFlagJoinCardAgeCheckUpsell and t1.ageCheckRequired == true
	local v43 = React.createElement(View, {
		tag = "col gap-medium padding-large radius-medium stroke-thin stroke-muted",
		Size = UDim2.fromOffset(v30, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = layoutOrder,
		backgroundStyle = v29.Color.OverMedia.OverMedia_300,
		ref = if not FFlagEnableConsoleGameJoinCard then nil else t1.focusRootRef
	}, {
		GameInfoRow = React.createElement(View, {
			tag = "row gap-small items-center size-full-0 auto-y align-x-left",
			LayoutOrder = 1
		}, {
			GameIcon = if isLoading then React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v37, v37),
				radius = EnumsRadius.Small
			}) else React.createElement(View, {
				LayoutOrder = 1,
				ClipsDescendants = true,
				Size = UDim2.fromOffset(v37, v37)
			}, {
				Thumbnail = React.createElement(FoundationImage, {
					tag = "radius-small",
					Image = gameIconUrl,
					Size = UDim2.fromScale(1, 1),
					ScaleType = Enum.ScaleType.Fit,
					onActivated = if not FFlagBlockEDPClickthrough then v39 else nil,
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
						Size = UDim2.new(0.7, 0, 0, v29.Typography.BodyMedium.FontSize),
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
							Text = v31.isPlaying
						})
					}),
					GameName = if isLoading then React.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.new(0.5, 0, 0, v29.Typography.TitleMedium.FontSize),
						radius = EnumsRadius.Small
					}) else React.createElement(View, {
						tag = "size-full-0 auto-y",
						LayoutOrder = 2,
						onActivated = if not FFlagBlockEDPClickthrough then v40 else nil,
						stateLayer = if not FFlagBlockEDPClickthrough then {
							affordance = StateLayerAffordance.None
						} else nil
					}, {
						Label = React.createElement(FoundationText, {
							tag = "size-full-0 auto-y text-title-medium content-emphasis text-no-wrap text-truncate-end text-align-x-left",
							Text = experienceName
						})
					})
				}),
				PlatformName = if not t1.isConsole then nil else if isLoading then React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.6, 0, 0, v29.Typography.BodySmall.FontSize),
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
							name = v38,
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
			JoinButton = if not v42 then React.createElement(Button, {
				tag = "align-x-center fill size-full-0",
				LayoutOrder = 1,
				text = v31.joinButton,
				onActivated = t1.onJoin,
				isLoading = isLoading,
				variant = ButtonVariant.Emphasis,
				size = InputSize.Medium,
				width = UDim.new(1, 0)
			}) else React.createElement(AgeCheckUpsellCTA, {
				LayoutOrder = 1,
				onUnlockPressed = t1.onAgeCheckPressed or function() -- line: 242
				end
			}),
			ChatButton = if t1.onChat == nil then nil else React.createElement(Button, {
				tag = "align-x-center fill size-full-0",
				LayoutOrder = 2,
				text = v31.chat,
				onActivated = t1.onChat,
				variant = ButtonVariant.Standard,
				size = InputSize.Medium,
				width = UDim.new(1, 0)
			}),
			ViewProfileButton = if t1.onViewProfile == nil then nil else React.createElement(View, {
				tag = "row align-x-center align-y-center",
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v29.Size.Size_600),
				onActivated = v41,
				stateLayer = {
					affordance = StateLayerAffordance.None
				}
			}, {
				Label = React.createElement(FoundationText, {
					tag = "auto-xy text-title-medium text-align-x-center content-emphasis",
					Text = v31.viewProfile
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
				offset = v29.Padding.Small
			},
			radius = Foundation.Enums.Radius.Medium,
			backgroundStyle = v29.Color.None,
			onPressedOutside = t1.onClose
		}, {
			GameJoinCard = v43
		})
	})
end

return DesktopGameJoinCard
