local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useComposedRef = ReactUtils.useComposedRef
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Icon = Foundation.Icon
local Button = Foundation.Button
local Skeleton = Foundation.Skeleton
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Radius = Foundation.Enums.Radius
local getBuilderIconForCurrentPlatform = Foundation.Utility.getBuilderIconForCurrentPlatform
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local ControlState = Foundation.Enums.ControlState

local AnalyticsConstants = require(script.Parent.Parent.Parent.Analytics.AnalyticsConstants)
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues

local SharedFlags = require(parent.SharedFlags)
local FFlagBlockEDPClickthrough = SharedFlags.FFlagBlockEDPClickthrough
local FFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor
local FFlagJoinabilityCTAContextCopy = SharedFlags.FFlagJoinabilityCTAContextCopy
local FFlagDesktopGameJoinCardGamepadSupport = SharedFlags.FFlagDesktopGameJoinCardGamepadSupport
local FFlagConsoleOpenGameJoinCard = SharedFlags.FFlagConsoleOpenGameJoinCard
local FFlagGameJoinCardContent = SharedFlags.FFlagGameJoinCardContent
local useGameJoinCardGamepadNavigation, assignPrimaryFocusRef

if FFlagDesktopGameJoinCardGamepadSupport or FFlagConsoleOpenGameJoinCard then
	local useGameJoinCardGamepadNavigation2 = require(GameJoinCard.Hooks.useGameJoinCardGamepadNavigation)
	useGameJoinCardGamepadNavigation = useGameJoinCardGamepadNavigation2.useGameJoinCardGamepadNavigation
	assignPrimaryFocusRef = useGameJoinCardGamepadNavigation2.assignPrimaryFocusRef
else
	useGameJoinCardGamepadNavigation = nil
	assignPrimaryFocusRef = nil
end

local AgeCheckUpsellCTA = require(script.Parent.Parent.AgeCheckUpsellCTA)
require(GameJoinCard.Components.Actions.Types)
local buildJoinCardActionsComponent = require(GameJoinCard.Components.Actions.buildJoinCardActionsComponent)

local function DesktopGameJoinCard(props)
	local v = useTokens()
	local v2 = useScaledValue(260)
	local v3 = useLocalization({
		isPlaying = "Feature.Friends.Text.IsPlaying",
		joinButton = "Feature.Profile.Action.JoinGame",
		chat = "Feature.Profile.Action.Chat",
		viewProfile = "Feature.Profile.Action.ViewProfile",
		playTogether = "Feature.GameJoin.Label.PlayTogether",
		playTogetherSoon = "Feature.GameJoin.Label.PlayTogetherSoon",
		differentServer = "Feature.GameJoin.Description.DifferentServer"
	})

	local layoutOrder = props.layoutOrder
	local playerName = props.playerName
	local experienceName = props.experienceName
	local gameIconUrl = props.gameIconUrl
	local isLoading = props.isLoading
	local v4

	if props.isConsole then
		v4 = v.Size.Size_1500
	else
		v4 = v.Size.Size_1000
	end

	local name = React.useMemo(function()
		return getBuilderIconForCurrentPlatform()
	end, {})

	local onActivated = React.useCallback(function()
		props.onViewExperienceDetails(viewEDPsourceValues.Thumbnail)
	end, { props })

	local onActivated2 = React.useCallback(function()
		props.onViewExperienceDetails(viewEDPsourceValues.Title)
	end, { props })

	local onActivated3 = React.useCallback(function()
		if props.onViewProfile then
			props.onViewProfile(viewProfileSourceValues.ViewProfileButton)
		end
	end, { props })

	local state, setState = React.useState(false)
	local onStateChanged = React.useCallback(function(p)
		setState(p == ControlState.Hover)
	end, {})
	local text

	if state then
		text = `<u>{v3.viewProfile}</u>`
	else
		text = v3.viewProfile
	end

	local isConsole = FFlagConsoleOpenGameJoinCard and props.isConsole
	local v5

	if FFlagDesktopGameJoinCardGamepadSupport or FFlagConsoleOpenGameJoinCard then
		v5 = useGameJoinCardGamepadNavigation(props.onClose, props.isOpen ~= false)
	end

	local primaryButtonFocusRef

	if not (v5 == nil or not FFlagDesktopGameJoinCardGamepadSupport or props.isConsole) then
		primaryButtonFocusRef = v5.primaryButtonFocusRef
	end

	local rootRef

	if v5 ~= nil then
		local v6

		if props.isConsole then
			v6 = isConsole
		else
			v6 = FFlagDesktopGameJoinCardGamepadSupport
		end

		if v6 then
			rootRef = v5.rootRef
		end
	end

	local ref

	if FFlagDesktopGameJoinCardGamepadSupport or FFlagConsoleOpenGameJoinCard then
		ref = useComposedRef(rootRef, props.focusRootRef)
	end

	local ageCheckRequired = props.ageCheckRequired == true
	local v6 = {}
	local v7 = nil

	if FFlagJoinabilityCTARefactor or FFlagGameJoinCardContent and props.content ~= nil then
		if props.areActionsLoading then
			v6.ActionsLoading = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v.Size.Size_600),
				radius = Radius.Medium,
				LayoutOrder = 1
			})
		else
			local v8

			if primaryButtonFocusRef then
				v8 = assignPrimaryFocusRef(props.actions, primaryButtonFocusRef) or props.actions
			else
				v8 = props.actions
			end

			v6, v7 = buildJoinCardActionsComponent(
				v8,
				{
					playTogether = v3.playTogether,
					playTogetherSoon = v3.playTogetherSoon,
					differentServer = v3.differentServer
				},
				props.onClose,
				function(props2, layoutOrder2)
					return React.createElement(Button, {
						ref = props2.focusRef,
						text = props2.text,
						onActivated = function()
							props2.onActivated()
						end,
						isLoading = props2.isLoading,
						isDisabled = props2.isDisabled,
						variant = props2.variant,
						size = props2.inputSize,
						width = props2.width,
						tag = "align-x-center fill size-full-0",
						LayoutOrder = layoutOrder2
					})
				end
			)
		end
	end

	local v8 = FFlagJoinabilityCTAContextCopy and not props.isConsole

	local createElement = React.createElement
	local v9 = {
		Size = UDim2.fromOffset(v2, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = layoutOrder,
		backgroundStyle = v.Color.OverMedia.OverMedia_300,
		tag = "col gap-medium padding-large radius-medium stroke-thin stroke-muted",
		ref = 0,
		selectionGroup = 0
	}

	if rootRef == nil then
		ref = props.focusRootRef
	end

	v9.ref = ref
	v9.selectionGroup = isConsole
		and {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
		or nil

	local createElement2 = React.createElement
	local gameIcon

	if isLoading then
		gameIcon = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v4, v4),
			radius = Radius.Small
		})
	else
		local createElement3 = React.createElement
		local v10 = { Size = UDim2.fromOffset(v4, v4), LayoutOrder = 1, ClipsDescendants = true }
		local media

		if FFlagGameJoinCardContent and props.content then
			media = props.content.media
		end

		local createElement4 = React.createElement
		local v11 = {
			Image = gameIconUrl,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Fit,
			tag = "radius-small",
			onActivated = 0,
			stateLayer = 0
		}

		if FFlagBlockEDPClickthrough or FFlagGameJoinCardContent and props.content ~= nil then
			onActivated = nil
		end

		v11.onActivated = onActivated

		v11.stateLayer = not FFlagBlockEDPClickthrough
			and (not FFlagGameJoinCardContent or props.content == nil)
			and props.onViewExperienceDetails
			and { affordance = StateLayerAffordance.None }
			or nil
		gameIcon = createElement3(View, v10, {
			Media = media,
			Thumbnail = createElement4(Image, v11)
		})
	end

	local createElement3 = React.createElement
	local v10 = {
		tag = "col size-full-0 auto-y gap-xxsmall shrink align-x-left items-start",
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local createElement4 = React.createElement
	local v11 = {
		tag = "col size-full-0 auto-y shrink align-x-left items-start",
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local gameTitle

	if isLoading then
		gameTitle = React.createElement(Skeleton, {
			Size = UDim2.new(0.7, 0, 0, v.Typography.BodyMedium.FontSize),
			radius = Radius.Small,
			LayoutOrder = 1
		})
	else
		local createElement5 = React.createElement

		local v12 = {
			PlayerName = React.createElement(Text, {
				Text = playerName,
				tag = "shrink auto-xy text-body-medium content-default text-no-wrap text-truncate-end text-align-x-left",
				LayoutOrder = 1
			}),
			IsPlaying = 0
		}

		local createElement6 = React.createElement
		local text2

		if FFlagGameJoinCardContent and props.content then
			text2 = props.content.activityText
		else
			text2 = v3.isPlaying
		end

		v12.IsPlaying = createElement6(Text, {
			Text = text2,
			tag = "shrink-0 auto-xy text-body-medium content-default text-align-x-left",
			LayoutOrder = 2
		})
		gameTitle = createElement5(
			View,
			{
				tag = "row auto-y gap-xxsmall size-full-0 align-x-left align-y-center text-body-medium content-default text-align-x-left",
				LayoutOrder = 1
			},
			v12
		)
	end

	local gameName

	if isLoading then
		gameName = React.createElement(Skeleton, {
			Size = UDim2.new(0.5, 0, 0, v.Typography.TitleMedium.FontSize),
			radius = Radius.Small,
			LayoutOrder = 2
		})
	else
		local createElement5 = React.createElement

		if FFlagBlockEDPClickthrough or FFlagGameJoinCardContent and props.content ~= nil then
			onActivated2 = nil
		end

		gameName = createElement5(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2,
			onActivated = onActivated2,
			stateLayer = not FFlagBlockEDPClickthrough and (not FFlagGameJoinCardContent or props.content == nil) and {
				affordance = StateLayerAffordance.None
			} or nil
		}, {
			Label = React.createElement(Text, {
				Text = experienceName,
				tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-split content-emphasis"
			})
		})
	end

	local v12 = {
		GameInfo = createElement4(View, v11, { GameTitle = gameTitle, GameName = gameName }),
		PlatformName = 0
	}
	local platformName

	if props.isConsole then
		if isLoading then
			platformName = React.createElement(Skeleton, {
				Size = UDim2.new(0.6, 0, 0, v.Typography.BodySmall.FontSize),
				radius = Radius.Small,
				LayoutOrder = 2
			})
		else
			platformName = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-x-left items-center gap-small size-full-0 auto-y",
				onActivated = props.onPlatformProfilePressed,
				selection = props.onPlatformProfilePressed and { Selectable = true } or nil,
				stateLayer = props.onPlatformProfilePressed and {
					affordance = StateLayerAffordance.Background
				} or nil
			}, {
				PlatformLogo = React.createElement(View, { tag = "auto-xy shrink", LayoutOrder = 1 }, {
					LogoImage = React.createElement(Icon, { name = name, size = IconSize.XSmall })
				}),
				PlatformNameLabel = React.createElement(Text, {
					Text = props.consolePlatformLabel,
					tag = "fill shrink auto-y text-body-small content-default text-no-wrap text-truncate-end text-align-x-left",
					LayoutOrder = 2
				})
			})
		end
	end

	v12.PlatformName = platformName
	local v13 = {
		GameInfoRow = createElement2(
			View,
			{ tag = "row gap-small items-center size-full-0 auto-y align-x-left", LayoutOrder = 1 },
			{ GameIcon = gameIcon, TextContainer = createElement3(View, v10, v12) }
		),
		CtaContext = 0,
		Actions = 0
	}
	local ctaContext

	if v8 and v7 ~= nil then
		local createElement5 = React.createElement

		local v14 = {
			CtaContextTitle = React.createElement(Text, {
				Text = v7.title,
				tag = "auto-xy text-body-medium text-align-x-left content-emphasis",
				LayoutOrder = 1
			}),
			CtaContextSubtitle = 0
		}
		local ctaContextSubtitle

		if v7.subtitle ~= nil then
			ctaContextSubtitle = React.createElement(Text, {
				Text = v7.subtitle,
				tag = "auto-xy text-label-small text-align-x-left content-muted",
				LayoutOrder = 2
			})
		end

		v14.CtaContextSubtitle = ctaContextSubtitle
		ctaContext = createElement5(
			View,
			{ tag = "col align-x-left items-start gap-xxsmall size-full-0 auto-y", LayoutOrder = 2 },
			v14
		)
	end

	v13.CtaContext = ctaContext
	local actions

	if not props.isConsole then
		local createElement5 = React.createElement

		if not FFlagJoinabilityCTARefactor and (not FFlagGameJoinCardContent or props.content == nil) then
			v6 = { JoinButton = 0, ChatButton = 0, ViewProfileButton = 0 }
			local joinButton

			if ageCheckRequired then
				joinButton = React.createElement(AgeCheckUpsellCTA, {
					onUnlockPressed = props.onAgeCheckPressed or function() end,
					LayoutOrder = 1,
					focusRef = primaryButtonFocusRef
				})
			else
				joinButton = React.createElement(Button, {
					ref = primaryButtonFocusRef,
					text = v3.joinButton,
					onActivated = props.onJoin,
					isLoading = isLoading,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					tag = "align-x-center fill size-full-0",
					width = UDim.new(1, 0),
					LayoutOrder = 1
				})
			end

			v6.JoinButton = joinButton
			local chatButton

			if props.onChat ~= nil then
				chatButton = React.createElement(Button, {
					text = v3.chat,
					onActivated = props.onChat,
					variant = ButtonVariant.Standard,
					size = InputSize.Medium,
					tag = "align-x-center fill size-full-0",
					width = UDim.new(1, 0),
					LayoutOrder = 2
				})
			end

			v6.ChatButton = chatButton
			local viewProfileButton

			if props.onViewProfile ~= nil then
				viewProfileButton = React.createElement(View, {
					Size = UDim2.new(1, 0, 0, v.Size.Size_600),
					tag = "row align-x-center align-y-center",
					onActivated = onActivated3,
					onStateChanged = onStateChanged,
					stateLayer = { affordance = StateLayerAffordance.None },
					LayoutOrder = 3
				}, {
					Label = React.createElement(Text, {
						Text = text,
						RichText = true,
						tag = "auto-xy text-title-medium text-align-x-center content-emphasis"
					})
				})
			end

			v6.ViewProfileButton = viewProfileButton
		end

		actions = createElement5(View, { tag = "col gap-small size-full-0 auto-y", LayoutOrder = 3 }, v6)
	end

	v13.Actions = actions
	local element = createElement(View, v9, v13)

	local createElement5 = React.createElement
	local root = Foundation.Popover.Root
	local v14 = { isOpen = props.isOpen }
	local v15 = {
		Anchor = React.createElement(Foundation.Popover.Anchor, { anchorRef = props.anchorRef }),
		Content = 0
	}

	local createElement6 = React.createElement
	local content = Foundation.Popover.Content
	local v16 = {
		align = Foundation.Enums.PopoverAlign.Center,
		side = 0,
		radius = 0,
		hasArrow = false,
		backgroundStyle = 0,
		onPressedOutside = 0
	}
	local side

	if props.isConsole then
		side = { position = Foundation.Enums.PopoverSide.Bottom, offset = v.Padding.Small }
	else
		side = Foundation.Enums.PopoverSide.Bottom
	end

	v16.side = side

	v16.radius = Foundation.Enums.Radius.Medium

	v16.backgroundStyle = v.Color.None
	v16.onPressedOutside = props.onClose
	v15.Content = createElement6(content, v16, { GameJoinCard = element })
	return createElement5(root, v14, v15)
end

return DesktopGameJoinCard
