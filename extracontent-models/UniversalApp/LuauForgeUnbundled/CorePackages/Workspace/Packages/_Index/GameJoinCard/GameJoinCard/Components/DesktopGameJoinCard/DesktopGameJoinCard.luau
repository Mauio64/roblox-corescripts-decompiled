local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local useComposedRef = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/ReactUtils").useComposedRef
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")

local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Localization").Hooks.useLocalization

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local icon = Foundation.Icon
local button = Foundation.Button
local skeleton = Foundation.Skeleton
local buttonVariant = Foundation.Enums.ButtonVariant
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local radius = Foundation.Enums.Radius
local getBuilderIconForCurrentPlatform = Foundation.Utility.getBuilderIconForCurrentPlatform
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local controlState = Foundation.Enums.ControlState

local AnalyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants")
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags")
local fFlagBlockEDPClickthrough = SharedFlags.FFlagBlockEDPClickthrough
local fFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor
local fFlagJoinabilityCTAContextCopy = SharedFlags.FFlagJoinabilityCTAContextCopy
local fFlagDesktopGameJoinCardGamepadSupport = SharedFlags.FFlagDesktopGameJoinCardGamepadSupport
local fFlagConsoleOpenGameJoinCard = SharedFlags.FFlagConsoleOpenGameJoinCard
local fFlagGameJoinCardContent = SharedFlags.FFlagGameJoinCardContent
local useGameJoinCardGamepadNavigation, assignPrimaryFocusRef

if fFlagDesktopGameJoinCardGamepadSupport or fFlagConsoleOpenGameJoinCard then
	local module5 = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Hooks/useGameJoinCardGamepadNavigation")
	useGameJoinCardGamepadNavigation = module5.useGameJoinCardGamepadNavigation
	assignPrimaryFocusRef = module5.assignPrimaryFocusRef
else
	useGameJoinCardGamepadNavigation = nil
	assignPrimaryFocusRef = nil
end

local module5 = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/AgeCheckUpsellCTA")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local buildJoinCardActionsComponent = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/buildJoinCardActionsComponent")

local function DesktopGameJoinCard(props)
	local v5 = useTokens()
	local v6 = useScaledValue(260)
	local v7 = useLocalization({
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
	local v8 = if props.isConsole then v5.Size.Size_1500 else v5.Size.Size_1000
	local v9 = React.useMemo(function()
		return getBuilderIconForCurrentPlatform()
	end, {})

	local v10 = React.useCallback(function()
		props.onViewExperienceDetails(viewEDPsourceValues.Thumbnail)
	end, { props })

	local v11 = React.useCallback(function()
		props.onViewExperienceDetails(viewEDPsourceValues.Title)
	end, { props })

	local v12 = React.useCallback(function()
		if props.onViewProfile then
			props.onViewProfile(viewProfileSourceValues.ViewProfileButton)
		end
	end, { props })

	local state, setState = React.useState(false)
	local v13 = React.useCallback(function(p2)
		setState(p2 == controlState.Hover)
	end, {})
	local v14 = if state then `<u>{v7.viewProfile}</u>` else v7.viewProfile

	local isConsole = fFlagConsoleOpenGameJoinCard and props.isConsole
	local v15

	if fFlagDesktopGameJoinCardGamepadSupport or fFlagConsoleOpenGameJoinCard then
		v15 = useGameJoinCardGamepadNavigation(props.onClose, props.isOpen ~= false)
	end

	local primaryButtonFocusRef

	if not (v15 == nil or not fFlagDesktopGameJoinCardGamepadSupport or props.isConsole) then
		primaryButtonFocusRef = v15.primaryButtonFocusRef
	end

	local rootRef

	if v15 ~= nil then
		local v16 = if props.isConsole then isConsole else fFlagDesktopGameJoinCardGamepadSupport

		if v16 then
			rootRef = v15.rootRef
		end
	end

	local v16

	if fFlagDesktopGameJoinCardGamepadSupport or fFlagConsoleOpenGameJoinCard then
		v16 = useComposedRef(rootRef, props.focusRootRef)
	end

	local ageCheckRequired = props.ageCheckRequired == true
	local v17 = {}
	local v18 = nil

	if fFlagJoinabilityCTARefactor or fFlagGameJoinCardContent and props.content ~= nil then
		if props.areActionsLoading then
			v17.ActionsLoading = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, v5.Size.Size_600),
				radius = radius.Medium,
				LayoutOrder = 1
			})
		else
			local v19

			if primaryButtonFocusRef then
				v19 = assignPrimaryFocusRef(props.actions, primaryButtonFocusRef) or props.actions
			else
				v19 = props.actions
			end

			v17, v18 = buildJoinCardActionsComponent(
				v19,
				{
					playTogether = v7.playTogether,
					playTogetherSoon = v7.playTogetherSoon,
					differentServer = v7.differentServer
				},
				props.onClose,
				function(props2, p2)
					return React.createElement(button, {
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
						LayoutOrder = p2
					})
				end
			)
		end
	end

	local v19 = fFlagJoinabilityCTAContextCopy and not props.isConsole

	local createElement = React.createElement
	local v21 = {
		Size = UDim2.fromOffset(v6, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = layoutOrder,
		backgroundStyle = v5.Color.OverMedia.OverMedia_300,
		tag = "col gap-medium padding-large radius-medium stroke-thin stroke-muted",
		ref = 0,
		selectionGroup = 0
	}

	if rootRef == nil then
		v16 = props.focusRootRef
	end

	v21.ref = v16
	v21.selectionGroup = isConsole
		and {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
		or nil

	local createElement2 = React.createElement
	local v26

	if isLoading then
		v26 = React.createElement(skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v8, v8),
			radius = radius.Small
		})
	else
		local createElement3 = React.createElement
		local v28 = {
			Size = UDim2.fromOffset(v8, v8),
			LayoutOrder = 1,
			ClipsDescendants = true
		}

		local v30 = if fFlagGameJoinCardContent and props.content then props.content.media else nil
		local createElement4 = React.createElement
		local v32 = {
			Image = gameIconUrl,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Fit,
			tag = "radius-small",
			onActivated = 0,
			stateLayer = 0
		}

		if fFlagBlockEDPClickthrough or fFlagGameJoinCardContent and props.content ~= nil then
			v10 = nil
		end

		v32.onActivated = v10

		v32.stateLayer = not fFlagBlockEDPClickthrough
			and (not fFlagGameJoinCardContent or props.content == nil)
			and props.onViewExperienceDetails
			and { affordance = stateLayerAffordance.None }
			or nil
		v26 = createElement3(view, v28, {
			Media = v30,
			Thumbnail = createElement4(image, v32)
		})
	end

	local createElement3 = React.createElement
	local v28 = {
		tag = "col size-full-0 auto-y gap-xxsmall shrink align-x-left items-start",
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local createElement4 = React.createElement
	local v31 = {
		tag = "col size-full-0 auto-y shrink align-x-left items-start",
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v33

	if isLoading then
		v33 = React.createElement(skeleton, {
			Size = UDim2.new(0.7, 0, 0, v5.Typography.BodyMedium.FontSize),
			radius = radius.Small,
			LayoutOrder = 1
		})
	else
		local createElement5 = React.createElement

		local v36 = {
			PlayerName = React.createElement(text, {
				Text = playerName,
				tag = "shrink auto-xy text-body-medium content-default text-no-wrap text-truncate-end text-align-x-left",
				LayoutOrder = 1
			}),
			IsPlaying = 0
		}

		local createElement6 = React.createElement
		local v39 = if fFlagGameJoinCardContent and props.content then props.content.activityText else v7.isPlaying
		v36.IsPlaying = createElement6(text, {
			Text = v39,
			tag = "shrink-0 auto-xy text-body-medium content-default text-align-x-left",
			LayoutOrder = 2
		})
		v33 = createElement5(
			view,
			{
				tag = "row auto-y gap-xxsmall size-full-0 align-x-left align-y-center text-body-medium content-default text-align-x-left",
				LayoutOrder = 1
			},
			v36
		)
	end

	local v34

	if isLoading then
		v34 = React.createElement(skeleton, {
			Size = UDim2.new(0.5, 0, 0, v5.Typography.TitleMedium.FontSize),
			radius = radius.Small,
			LayoutOrder = 2
		})
	else
		local createElement5 = React.createElement

		if fFlagBlockEDPClickthrough or fFlagGameJoinCardContent and props.content ~= nil then
			v11 = nil
		end

		v34 = createElement5(view, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2,
			onActivated = v11,
			stateLayer = not fFlagBlockEDPClickthrough and (not fFlagGameJoinCardContent or props.content == nil) and {
				affordance = stateLayerAffordance.None
			} or nil
		}, {
			Label = React.createElement(text, {
				Text = experienceName,
				tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-split content-emphasis"
			})
		})
	end

	local v29 = {
		GameInfo = createElement4(view, v31, { GameTitle = v33, GameName = v34 }),
		PlatformName = 0
	}
	local v35

	if props.isConsole then
		if isLoading then
			v35 = React.createElement(skeleton, {
				Size = UDim2.new(0.6, 0, 0, v5.Typography.BodySmall.FontSize),
				radius = radius.Small,
				LayoutOrder = 2
			})
		else
			v35 = React.createElement(view, {
				LayoutOrder = 2,
				tag = "row align-x-left items-center gap-small size-full-0 auto-y",
				onActivated = props.onPlatformProfilePressed,
				selection = props.onPlatformProfilePressed and { Selectable = true } or nil,
				stateLayer = props.onPlatformProfilePressed and {
					affordance = stateLayerAffordance.Background
				} or nil
			}, {
				PlatformLogo = React.createElement(view, {
					tag = "auto-xy shrink",
					LayoutOrder = 1
				}, {
					LogoImage = React.createElement(icon, {
						name = v9,
						size = iconSize.XSmall
					})
				}),
				PlatformNameLabel = React.createElement(text, {
					Text = props.consolePlatformLabel,
					tag = "fill shrink auto-y text-body-small content-default text-no-wrap text-truncate-end text-align-x-left",
					LayoutOrder = 2
				})
			})
		end
	end

	v29.PlatformName = v35
	local v22 = {
		GameInfoRow = createElement2(
			view,
			{
				tag = "row gap-small items-center size-full-0 auto-y align-x-left",
				LayoutOrder = 1
			},
			{ GameIcon = v26, TextContainer = createElement3(view, v28, v29) }
		),
		CtaContext = 0,
		Actions = 0
	}
	local v36

	if v19 and v18 ~= nil then
		local createElement5 = React.createElement

		local v39 = {
			CtaContextTitle = React.createElement(text, {
				Text = v18.title,
				tag = "auto-xy text-body-medium text-align-x-left content-emphasis",
				LayoutOrder = 1
			}),
			CtaContextSubtitle = 0
		}

		local v40 = if v18.subtitle ~= nil then React.createElement(text, {
			Text = v18.subtitle,
			tag = "auto-xy text-label-small text-align-x-left content-muted",
			LayoutOrder = 2
		}) else nil
		v39.CtaContextSubtitle = v40
		v36 = createElement5(
			view,
			{
				tag = "col align-x-left items-start gap-xxsmall size-full-0 auto-y",
				LayoutOrder = 2
			},
			v39
		)
	end

	v22.CtaContext = v36
	local v37

	if not props.isConsole then
		local createElement5 = React.createElement

		if not fFlagJoinabilityCTARefactor and (not fFlagGameJoinCardContent or props.content == nil) then
			v17 = { JoinButton = 0, ChatButton = 0, ViewProfileButton = 0 }
			local v40

			if ageCheckRequired then
				v40 = React.createElement(module5, {
					onUnlockPressed = props.onAgeCheckPressed or function() end,
					LayoutOrder = 1,
					focusRef = primaryButtonFocusRef
				})
			else
				v40 = React.createElement(button, {
					ref = primaryButtonFocusRef,
					text = v7.joinButton,
					onActivated = props.onJoin,
					isLoading = isLoading,
					variant = buttonVariant.Emphasis,
					size = inputSize.Medium,
					tag = "align-x-center fill size-full-0",
					width = UDim.new(1, 0),
					LayoutOrder = 1
				})
			end

			v17.JoinButton = v40

			local v41 = if props.onChat ~= nil then React.createElement(button, {
				text = v7.chat,
				onActivated = props.onChat,
				variant = buttonVariant.Standard,
				size = inputSize.Medium,
				tag = "align-x-center fill size-full-0",
				width = UDim.new(1, 0),
				LayoutOrder = 2
			}) else nil
			v17.ChatButton = v41

			local v42 = if props.onViewProfile ~= nil then React.createElement(view, {
				Size = UDim2.new(1, 0, 0, v5.Size.Size_600),
				tag = "row align-x-center align-y-center",
				onActivated = v12,
				onStateChanged = v13,
				stateLayer = { affordance = stateLayerAffordance.None },
				LayoutOrder = 3
			}, {
				Label = React.createElement(text, {
					Text = v14,
					RichText = true,
					tag = "auto-xy text-title-medium text-align-x-center content-emphasis"
				})
			}) else nil
			v17.ViewProfileButton = v42
		end

		v37 = createElement5(view, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 3
		}, v17)
	end

	v22.Actions = v37
	local element = createElement(view, v21, v22)

	local createElement5 = React.createElement
	local root = Foundation.Popover.Root
	local v38 = { isOpen = props.isOpen }
	local v39 = {
		Anchor = React.createElement(Foundation.Popover.Anchor, {
			anchorRef = props.anchorRef
		}),
		Content = 0
	}

	local createElement6 = React.createElement
	local content = Foundation.Popover.Content
	local v40 = {
		align = Foundation.Enums.PopoverAlign.Center,
		side = 0,
		radius = 0,
		hasArrow = false,
		backgroundStyle = 0,
		onPressedOutside = 0
	}
	local v41 = if props.isConsole then {
		position = Foundation.Enums.PopoverSide.Bottom,
		offset = v5.Padding.Small
	} else Foundation.Enums.PopoverSide.Bottom
	v40.side = v41

	v40.radius = Foundation.Enums.Radius.Medium

	v40.backgroundStyle = v5.Color.None
	v40.onPressedOutside = props.onClose
	v39.Content = createElement6(content, v40, { GameJoinCard = element })
	return createElement5(root, v38, v39)
end

return DesktopGameJoinCard
