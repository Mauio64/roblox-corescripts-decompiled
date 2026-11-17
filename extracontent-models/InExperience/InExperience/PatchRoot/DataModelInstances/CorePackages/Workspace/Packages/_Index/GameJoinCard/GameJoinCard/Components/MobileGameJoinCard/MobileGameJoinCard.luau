local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local LayoutMode = UserTile.LayoutMode

local OverlayProvider = Foundation.OverlayProvider
local Sheet = Foundation.Sheet
local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local GuiService = game:GetService("GuiService")

local AnalyticsConstants = require(script.Parent.Parent.Parent.Analytics.AnalyticsConstants)
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local CtaType = AnalyticsConstants.CtaType
local useJoinCardCtaLoadTime = require(script.Parent.Parent.Parent.Analytics.useJoinCardCtaLoadTime)

require(parent.VideoUtils)

local SharedFlags = require(parent.SharedFlags)
local FFlagMobileGameJoinCardGamepadSupport = SharedFlags.FFlagMobileGameJoinCardGamepadSupport
local FFlagGameJoinCardOptionalActions = SharedFlags.FFlagGameJoinCardOptionalActions
local FFlagGameJoinCardContent = SharedFlags.FFlagGameJoinCardContent
local useGameJoinCardGamepadNavigation, assignPrimaryFocusRef

if FFlagMobileGameJoinCardGamepadSupport then
	local useGameJoinCardGamepadNavigation2 = require(GameJoinCard.Hooks.useGameJoinCardGamepadNavigation)
	useGameJoinCardGamepadNavigation = useGameJoinCardGamepadNavigation2.useGameJoinCardGamepadNavigation
	assignPrimaryFocusRef = useGameJoinCardGamepadNavigation2.assignPrimaryFocusRef
else
	useGameJoinCardGamepadNavigation = nil
	assignPrimaryFocusRef = nil
end

local AgeCheckUpsellCTA = require(script.Parent.Parent.AgeCheckUpsellCTA)
local JoinCardBannerVideoContainer = require(script.Parent.JoinCardBannerVideo.JoinCardBannerVideoContainer)
local GameJoinCardTTI = require(script.Parent.Parent.Parent.Telemetry.GameJoinCardTTI)
local FFlagMobileGameJoinCardThumbnail = require(script.Parent.Parent.Parent.Flags.FFlagMobileGameJoinCardThumbnail)
local defineFastFlag = game:DefineFastFlag("MobileGameJoinCardHideUserAvatar", false)

local defineFastFlag2 = game:DefineFastFlag("MobileGameJoinCardShowExperienceNameOnly", false)
local FFlagMobileGameJoinCardEDPFromTitle = require(GameJoinCard.Flags.FFlagMobileGameJoinCardEDPFromTitle)
local FFlagMobileGameJoinCardTrapGamepadFocus = require(GameJoinCard.Flags.FFlagMobileGameJoinCardTrapGamepadFocus)

local selectionGroup = FFlagMobileGameJoinCardTrapGamepadFocus
	and {
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	}
	or nil
local testId = FFlagMobileGameJoinCardTrapGamepadFocus and "mobile-game-join-card-selection" or nil
local FFlagMobileGameJoinCardEDPFromThumbnail = require(GameJoinCard.Flags.FFlagMobileGameJoinCardEDPFromThumbnail)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMobileGameJoinCardVideo = SharedFlags2.FFlagMobileGameJoinCardVideo
local defineFastFlag3 = game:DefineFastFlag("MobileGameCardDontShowChatWith", false)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagJoinabilityCTARefactor = SharedFlags3.FFlagJoinabilityCTARefactor
local SharedFlags4 = require(parent.SharedFlags)
local FFlagJoinabilityCTAContextCopy = SharedFlags4.FFlagJoinabilityCTAContextCopy
require(GameJoinCard.Components.Actions.Types)
local buildJoinCardActionsComponent = require(GameJoinCard.Components.Actions.buildJoinCardActionsComponent)
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction

local function MobileGameJoinCard(props)
	local v = useTokens()
	local state, setState = React.useState(false)
	local state2, setState2

	if FFlagMobileGameJoinCardThumbnail then
		state2, setState2 = React.useState(false)
	else
		setState2 = nil
	end

	local state3, setState3 = React.useState(nil)

	local v2 = Foundation.Hooks.useOverlay()
	local v3 = not v2 or v2.AbsoluteSize.X > v2.AbsoluteSize.Y
	local v4 = GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small or not not v3
	local thumbnailImageUrl = props.thumbnailImageUrl
	local content

	if FFlagGameJoinCardContent then
		content = props.content
	else
		content = nil
	end

	local v5

	if FFlagMobileGameJoinCardGamepadSupport then
		v5 = useGameJoinCardGamepadNavigation(props.onClose, props.isNavigationFocused ~= false)
	end

	local rootRef

	if v5 then
		rootRef = v5.rootRef
	end

	local primaryButtonFocusRef

	if v5 then
		primaryButtonFocusRef = v5.primaryButtonFocusRef
	end

	local useCallback = React.useCallback
	local function fn(p)
		if p == Enum.AssetFetchStatus.Success then
			setState(true)

			if content ~= nil or FFlagGameJoinCardOptionalActions and props.disableAppTelemetry then
				return
			end

			GameJoinCardTTI.trackBannerLoaded()
		end
	end

	local v6 = content ~= nil
	local v7

	if FFlagGameJoinCardOptionalActions then
		v7 = props.disableAppTelemetry
	end

	local onLoaded = useCallback(fn, { v6, v7 })
	local onLoaded2

	if FFlagMobileGameJoinCardThumbnail then
		onLoaded2 = React.useCallback(function(p)
			if p == Enum.AssetFetchStatus.Success then
				setState2(true)
			end
		end, {})
	end

	local v8 = FFlagMobileGameJoinCardThumbnail

	if v8 then
		if thumbnailImageUrl == nil then
			v8 = false
		else
			v8 = not state
		end
	end

	local v9

	if content == nil then
		if FFlagMobileGameJoinCardThumbnail then
			v9 = not (state or state2)
		else
			v9 = not state
		end
	else
		v9 = false
	end

	local useEffect = React.useEffect
	local function fn2()
		if content ~= nil or FFlagGameJoinCardOptionalActions and props.disableAppTelemetry then
			return
		end

		GameJoinCardTTI.trackCardMounted()
	end

	local v10 = content ~= nil
	local v11

	if FFlagGameJoinCardOptionalActions then
		v11 = props.disableAppTelemetry
	end

	useEffect(fn2, { v10, v11 })

	local onActivated = React.useCallback(function()
		if FFlagGameJoinCardOptionalActions and props.onViewProfile == nil then
			return
		end

		props.onViewProfile(viewProfileSourceValues.UserTile)
	end, { props })

	local onActivated2 = React.useCallback(function()
		if FFlagGameJoinCardOptionalActions and props.onViewProfile == nil then
			return
		end

		props.onViewProfile(viewProfileSourceValues.ViewProfileButton)
	end, { props })
	local onActivated3

	if FFlagMobileGameJoinCardEDPFromThumbnail then
		onActivated3 = React.useCallback(function()
			if FFlagGameJoinCardOptionalActions and props.onViewExperienceDetails == nil then
				return
			end

			props.onViewExperienceDetails(viewEDPsourceValues.Thumbnail)
		end, { props.onViewExperienceDetails })
	end

	local onActivated4

	if FFlagMobileGameJoinCardEDPFromTitle then
		onActivated4 = React.useCallback(function()
			if FFlagGameJoinCardOptionalActions and props.onViewExperienceDetails == nil then
				return
			end

			props.onViewExperienceDetails(viewEDPsourceValues.Title)
		end, { props.onViewExperienceDetails })
	end

	local v12 = v.Typography.TitleMedium.FontSize * v.Typography.TitleMedium.LineHeight

	local v13 = v12 + v.Typography.BodyMedium.FontSize * v.Typography.BodyMedium.LineHeight + v.Padding.Small
	local v14 = 88 + v13

	local v15 = false

	if FFlagJoinabilityCTARefactor then
		for _, action in props.actions do
			if action.id == UserCtaAction.UnlockExperience then
				v15 = true
				break
			end
		end
	end

	if not FFlagJoinabilityCTARefactor then
		v15 = props.ageCheckRequired == true
	end

	local v16 = {
		isLoading = props.isLoading or FFlagJoinabilityCTARefactor and props.areActionsLoading == true,
		ctaType = 0,
		wasCached = 0,
		isDisabled = 0
	}
	local ctaType = if v15 then CtaType.AgeCheckUnlock else CtaType.Join
	v16.ctaType = ctaType
	v16.wasCached = props.wasPlayabilityCached
	local isDisabled

	if content == nil then
		if FFlagGameJoinCardOptionalActions then
			isDisabled = props.disableAppTelemetry
		end
	else
		isDisabled = true
	end

	v16.isDisabled = isDisabled
	useJoinCardCtaLoadTime(v16)

	local v17 = useLocalization({
		playingExperience = {
			"Feature.Profile.Label.PlayingExperience",
			experienceName = props.experienceName
		},
		userIsPlayingExperience = {
			"Feature.Profile.Label.UserIsPlayingExperience",
			userName = props.playerName,
			experienceName = props.experienceName
		},
		join = "Feature.Profile.Action.JoinGame",
		viewProfile = "Feature.Profile.Action.ViewProfile",
		chat = "Feature.Profile.Action.Chat",
		chatWithName = {
			"Feature.Home.PeopleList.ChatWith",
			username = props.playerName
		},
		playTogether = "Feature.GameJoin.Label.PlayTogether",
		playTogetherSoon = "Feature.GameJoin.Label.PlayTogetherSoon",
		differentServer = "Feature.GameJoin.Description.DifferentServer"
	})

	local v18 = {}
	local v19 = nil

	if FFlagJoinabilityCTARefactor or content ~= nil then
		if props.areActionsLoading then
			v18.ActionsLoading = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v.Size.Size_600),
				LayoutOrder = 1
			})
		else
			local v20

			if primaryButtonFocusRef then
				v20 = assignPrimaryFocusRef(props.actions, primaryButtonFocusRef) or props.actions
			else
				v20 = props.actions
			end

			v18, v19 = buildJoinCardActionsComponent(
				v20,
				{
					playTogether = v17.playTogether,
					playTogetherSoon = v17.playTogetherSoon,
					differentServer = v17.differentServer
				},
				props.onClose,
				function(props2, layoutOrder)
					return React.createElement(Button, {
						ref = props2.focusRef,
						text = props2.text,
						onActivated = function()
							props2.onActivated()
						end,
						variant = props2.variant,
						size = props2.inputSize,
						isLoading = props2.isLoading,
						isDisabled = props2.isDisabled,
						width = props2.width,
						LayoutOrder = layoutOrder
					})
				end
			)
		end
	end

	local fFlagJoinabilityCTAContextCopy = FFlagJoinabilityCTAContextCopy

	local createElement = React.createElement
	local v20 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ref = setState3 }

	if state3 then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local root = Sheet.Root
		local v21 = { preferCenterSheet = true, onClose = props.onClose, ref = 0 }

		if not FFlagMobileGameJoinCardGamepadSupport then
			rootRef = nil
		end

		v21.ref = rootRef

		local createElement4 = React.createElement
		local content2 = Sheet.Content
		local bottomPadding

		if v4 then
			bottomPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v.Padding.Medium)
			})
		end

		local createElement5 = React.createElement

		local createElement6 = React.createElement
		local size

		if defineFastFlag then
			size = UDim2.new(1, 0, 0, 187 - v.Padding.XLarge)
		else
			size = UDim2.new(1, 0, 0, 111)
		end

		local createElement7 = React.createElement
		local v22 = {
			tag = "clip",
			Position = UDim2.new(0, -v.Padding.XLarge, 0, -v.Padding.XLarge),
			Size = UDim2.new(1, 40, 0, 187)
		}

		local createElement8 = React.createElement
		local v23 = {
			Size = UDim2.new(1, 0, 0, 202),
			BackgroundTransparency = 1,
			GroupTransparency = 0
		}

		local v24 = {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 15) }),
			BannerImage = 0,
			BannerThumbnail = 0,
			Media = 0,
			BannerSkeleton = 0
		}

		local createElement9 = React.createElement
		local v25 = {
			BackgroundTransparency = 1,
			Image = props.bannerImageUrl,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = FFlagMobileGameJoinCardThumbnail and 3 or 2,
			onLoaded = onLoaded,
			onActivated = 0,
			stateLayer = 0
		}
		local onActivated5

		if
			content == nil
			and (not FFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
			and FFlagMobileGameJoinCardEDPFromThumbnail
			and state
		then
			onActivated5 = onActivated3
		end

		v25.onActivated = onActivated5

		v25.stateLayer = content == nil
			and (not FFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
			and FFlagMobileGameJoinCardEDPFromThumbnail
			and state
			and { affordance = StateLayerAffordance.None }
			or nil
		v24.BannerImage = createElement9(Image, v25)
		local bannerThumbnail

		if v8 then
			bannerThumbnail = React.createElement(Image, {
				BackgroundTransparency = 1,
				Image = thumbnailImageUrl,
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 2,
				onLoaded = onLoaded2
			})
		end

		v24.BannerThumbnail = bannerThumbnail
		local media

		if content then
			media = React.createElement(View, { tag = "size-full", ZIndex = 4 }, {
				Content = content.media
			})
		end

		v24.Media = media
		local bannerSkeleton

		if v9 then
			bannerSkeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				ZIndex = 1
			})
		end

		v24.BannerSkeleton = bannerSkeleton
		local v26 = {
			BannerImageCanvas = createElement8("CanvasGroup", v23, v24),
			BannerVideo = 0
		}
		local bannerVideo

		if FFlagMobileGameJoinCardVideo and props.bannerVideoId then
			local createElement10 = React.createElement
			local v27 = {
				videoId = props.bannerVideoId,
				videoPlaybackContext = props.bannerVideoPlaybackContext,
				universeId = props.universeId,
				Size = UDim2.new(1, 0, 0, 202),
				cornerRadius = 15,
				ZIndex = 2,
				onActivated = 0
			}

			if not FFlagMobileGameJoinCardEDPFromThumbnail then
				onActivated3 = nil
			end

			v27.onActivated = onActivated3
			bannerVideo = createElement10(JoinCardBannerVideoContainer, v27)
		end

		v26.BannerVideo = bannerVideo
		local children = {
			BannerImageContainer = createElement6(View, {
				tag = "size-full-0",
				Size = size,
				LayoutOrder = 1
			}, {
				BannerImageClipper = createElement7(View, v22, v26)
			}),
			UserTileWrapper = 0,
			CtaContext = 0,
			Buttons = 0
		}
		local userTileWrapper

		if props.userId then
			local createElement10 = React.createElement
			local udim

			if defineFastFlag2 or content ~= nil then
				if content ~= nil then
					v12 = v13
				end

				udim = UDim2.new(1, 0, 0, v12)
			elseif defineFastFlag then
				udim = UDim2.new(1, 0, 0, v13)
			else
				udim = UDim2.new(1, 0, 0, v14)
			end

			local tile

			if defineFastFlag2 or content ~= nil then
				local createElement11 = React.createElement
				local v27 = {
					tag = content == nil and "row align-x-center align-y-center size-full" or "col align-x-center align-y-center gap-small size-full",
					onActivated = 0,
					stateLayer = 0
				}

				if
					content == nil
					and (not FFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
				then
					if not FFlagMobileGameJoinCardEDPFromTitle then
						onActivated4 = nil
					end
				else
					onActivated4 = nil
				end

				v27.onActivated = onActivated4

				v27.stateLayer = content == nil
					and (not FFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
					and FFlagMobileGameJoinCardEDPFromTitle
					and { affordance = StateLayerAffordance.None }
					or nil

				local createElement12 = React.createElement
				local v28 = {
					tag = "shrink auto-xy text-align-x-center content-emphasis",
					fontStyle = v.Typography.TitleMedium,
					Text = 0,
					LayoutOrder = 1,
					RichText = true,
					TextTruncate = 0
				}
				local text

				if content then
					text = content.title
				else
					text = props.experienceName
				end

				v28.Text = text

				v28.TextTruncate = Enum.TextTruncate.AtEnd
				local v29 = { ExperienceText = createElement12(Text, v28), Subtitle = 0 }
				local subtitle

				if content then
					subtitle = React.createElement(Text, {
						tag = "shrink auto-xy text-align-x-center content-default",
						fontStyle = v.Typography.BodyMedium,
						Text = content.subtitle,
						LayoutOrder = 2,
						TextTruncate = Enum.TextTruncate.AtEnd
					})
				end

				v29.Subtitle = subtitle
				tile = createElement11(View, v27, v29)
			elseif defineFastFlag then
				tile = React.createElement(View, {
					tag = "col align-x-center align-y-center size-full"
				}, {
					CombinedText = React.createElement(Text, {
						tag = "shrink auto-xy text-wrap text-align-x-center content-default",
						fontStyle = v.Typography.BodyMedium,
						Text = v17.userIsPlayingExperience,
						LayoutOrder = 1,
						RichText = true
					})
				})
			else
				local createElement11 = React.createElement
				local v27 = {
					userId = props.userId,
					title = props.playerName,
					subtitle = v17.playingExperience,
					layoutMode = LayoutMode.compact,
					avatarSize = UDim2.fromOffset(88, 88),
					backplateStyle = v.Color.Surface.Surface_100,
					onActivated = 0,
					selectable = 0
				}

				if FFlagGameJoinCardOptionalActions and props.onViewProfile == nil then
					onActivated = nil
				end

				v27.onActivated = onActivated

				v27.selectable = (not FFlagGameJoinCardOptionalActions or props.onViewProfile ~= nil) and nil
				tile = createElement11(userTile, v27)
			end

			userTileWrapper = createElement10(View, { Size = udim, ZIndex = 2, LayoutOrder = 2 }, {
				Tile = tile
			})
		end

		children.UserTileWrapper = userTileWrapper
		local ctaContext

		if fFlagJoinabilityCTAContextCopy and v19 ~= nil then
			local createElement10 = React.createElement

			local v27 = {
				CtaContextTitle = React.createElement(Text, {
					Text = v19.title,
					tag = "auto-xy text-body-medium text-align-x-center content-emphasis",
					LayoutOrder = 1
				}),
				CtaContextSubtitle = 0
			}
			local ctaContextSubtitle

			if v19.subtitle ~= nil then
				ctaContextSubtitle = React.createElement(Text, {
					Text = v19.subtitle,
					tag = "auto-xy text-label-small text-align-x-center content-muted",
					LayoutOrder = 2
				})
			end

			v27.CtaContextSubtitle = ctaContextSubtitle
			ctaContext = createElement10(
				View,
				{
					tag = "col align-x-center items-center gap-xxsmall size-full-0 auto-y",
					LayoutOrder = 3
				},
				v27
			)
		end

		children.CtaContext = ctaContext

		local createElement10 = React.createElement

		local v27 = {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = fFlagJoinabilityCTAContextCopy and v19 ~= nil and 4 or 3
		}

		if not FFlagJoinabilityCTARefactor and content == nil then
			v18 = { PrimaryButton = 0, ChatButton = 0, SecondaryButton = 0 }
			local primaryButton

			if v15 then
				local createElement11 = React.createElement
				local v28 = {
					onUnlockPressed = props.onAgeCheckPressed or function() end,
					LayoutOrder = 1,
					focusRef = 0
				}

				if not FFlagMobileGameJoinCardGamepadSupport then
					primaryButtonFocusRef = nil
				end

				v28.focusRef = primaryButtonFocusRef
				primaryButton = createElement11(AgeCheckUpsellCTA, v28)
			else
				local createElement11 = React.createElement

				if not FFlagMobileGameJoinCardGamepadSupport then
					primaryButtonFocusRef = nil
				end

				primaryButton = createElement11(Button, {
					ref = primaryButtonFocusRef,
					text = v17.join,
					onActivated = props.onJoin,
					variant = ButtonVariant.Emphasis,
					inputSize = InputSize.Medium,
					isLoading = props.isLoading,
					isDisabled = not props.isInExperience,
					width = UDim.new(1, 0),
					LayoutOrder = 1
				})
			end

			v18.PrimaryButton = primaryButton
			local chatButton

			if props.canUsePlatformChat then
				local createElement11 = React.createElement
				local text

				if defineFastFlag2 and not defineFastFlag3 then
					text = v17.chatWithName
				else
					text = v17.chat
				end

				chatButton = createElement11(Button, {
					text = text,
					onActivated = props.onChat,
					variant = ButtonVariant.Standard,
					inputSize = InputSize.Medium,
					width = UDim.new(1, 0),
					LayoutOrder = 2
				})
			end

			v18.ChatButton = chatButton
			local secondaryButton

			if not (FFlagGameJoinCardOptionalActions and props.onViewProfile == nil) then
				secondaryButton = React.createElement(Button, {
					text = v17.viewProfile,
					onActivated = onActivated2,
					variant = ButtonVariant.Utility,
					inputSize = InputSize.Medium,
					width = UDim.new(1, 0),
					LayoutOrder = 3
				})
			end

			v18.SecondaryButton = secondaryButton
		end

		children.Buttons = createElement10(View, v27, v18)
		state3 = createElement2(OverlayProvider, { gui = state3 }, {
			SheetRoot = createElement3(root, v21, {
				Content = createElement4(content2, nil, {
					BottomPadding = bottomPadding,
					Layout = createElement5(
						View,
						{
							tag = "col gap-medium size-full-0 auto-y",
							testId = testId,
							selectionGroup = selectionGroup
						},
						children
					)
				})
			})
		})
	end

	return createElement("Frame", v20, { SheetProvider = state3 })
end

return MobileGameJoinCard
