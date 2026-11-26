local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local UserTile = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/UserTile")
local userTile = UserTile.UserTile
local layoutMode = UserTile.LayoutMode

local overlayProvider = Foundation.OverlayProvider
local sheet = Foundation.Sheet
local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Localization").Hooks.useLocalization

local image = Foundation.Image
local skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local GuiService = game:GetService("GuiService")

local AnalyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants")
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local ctaType = AnalyticsConstants.CtaType
local useJoinCardCtaLoadTime = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useJoinCardCtaLoadTime")

require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/VideoUtils")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags")
local fFlagMobileGameJoinCardGamepadSupport = SharedFlags.FFlagMobileGameJoinCardGamepadSupport
local fFlagGameJoinCardOptionalActions = SharedFlags.FFlagGameJoinCardOptionalActions
local fFlagGameJoinCardContent = SharedFlags.FFlagGameJoinCardContent
local useGameJoinCardGamepadNavigation, assignPrimaryFocusRef

if fFlagMobileGameJoinCardGamepadSupport then
	local module7 = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Hooks/useGameJoinCardGamepadNavigation")
	useGameJoinCardGamepadNavigation = module7.useGameJoinCardGamepadNavigation
	assignPrimaryFocusRef = module7.assignPrimaryFocusRef
else
	useGameJoinCardGamepadNavigation = nil
	assignPrimaryFocusRef = nil
end

local module7 = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/AgeCheckUpsellCTA")
local JoinCardBannerVideoContainer = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/MobileGameJoinCard/JoinCardBannerVideo/JoinCardBannerVideoContainer")
local GameJoinCardTTI = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Telemetry/GameJoinCardTTI")
local FFlagMobileGameJoinCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardThumbnail")
local defineFastFlag = game:DefineFastFlag("MobileGameJoinCardHideUserAvatar", false)

local defineFastFlag2 = game:DefineFastFlag("MobileGameJoinCardShowExperienceNameOnly", false)
local FFlagMobileGameJoinCardEDPFromTitle = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardEDPFromTitle")
local FFlagMobileGameJoinCardTrapGamepadFocus = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardTrapGamepadFocus")

local v5 = FFlagMobileGameJoinCardTrapGamepadFocus
	and {
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	}
	or nil
local v6 = FFlagMobileGameJoinCardTrapGamepadFocus and "mobile-game-join-card-selection" or nil
local FFlagMobileGameJoinCardEDPFromThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardEDPFromThumbnail")
local fFlagMobileGameJoinCardVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagMobileGameJoinCardVideo
local defineFastFlag3 = game:DefineFastFlag("MobileGameCardDontShowChatWith", false)
local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagJoinabilityCTARefactor
local fFlagJoinabilityCTAContextCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagJoinabilityCTAContextCopy
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local buildJoinCardActionsComponent = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/buildJoinCardActionsComponent")
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction

local function MobileGameJoinCard(props)
	local v7 = useTokens()
	local state, setState = React.useState(false)
	local state2, setState2

	if FFlagMobileGameJoinCardThumbnail then
		state2, setState2 = React.useState(false)
	else
		setState2 = nil
	end

	local state3, setState3 = React.useState(nil)

	local v8 = Foundation.Hooks.useOverlay()
	local v9 = not v8 or v8.AbsoluteSize.X > v8.AbsoluteSize.Y
	local v11 = GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small or not not v9
	local thumbnailImageUrl = props.thumbnailImageUrl
	local content = if fFlagGameJoinCardContent then props.content else nil
	local v12

	if fFlagMobileGameJoinCardGamepadSupport then
		v12 = useGameJoinCardGamepadNavigation(props.onClose, props.isNavigationFocused ~= false)
	end

	local rootRef = if v12 then v12.rootRef else nil
	local primaryButtonFocusRef = if v12 then v12.primaryButtonFocusRef else nil

	local useCallback = React.useCallback
	local function fn(p2)
		if p2 == Enum.AssetFetchStatus.Success then
			setState(true)

			if content ~= nil or fFlagGameJoinCardOptionalActions and props.disableAppTelemetry then
				return
			end

			GameJoinCardTTI.trackBannerLoaded()
		end
	end

	local v14 = content ~= nil
	local v15 = if fFlagGameJoinCardOptionalActions then props.disableAppTelemetry else nil
	local v16 = useCallback(fn, { v14, v15 })
	local v17

	if FFlagMobileGameJoinCardThumbnail then
		v17 = React.useCallback(function(p2)
			if p2 == Enum.AssetFetchStatus.Success then
				setState2(true)
			end
		end, {})
	end

	local v18 = FFlagMobileGameJoinCardThumbnail

	if v18 then
		v18 = not (thumbnailImageUrl == nil) and not state
	end

	local v19 = content == nil and (if FFlagMobileGameJoinCardThumbnail then not (state or state2) else not state)

	local useEffect = React.useEffect
	local function fn2()
		if content ~= nil or fFlagGameJoinCardOptionalActions and props.disableAppTelemetry then
			return
		end

		GameJoinCardTTI.trackCardMounted()
	end

	local v21 = content ~= nil
	local v22 = if fFlagGameJoinCardOptionalActions then props.disableAppTelemetry else nil
	useEffect(fn2, { v21, v22 })

	local v23 = React.useCallback(function()
		if fFlagGameJoinCardOptionalActions and props.onViewProfile == nil then
			return
		end

		props.onViewProfile(viewProfileSourceValues.UserTile)
	end, { props })

	local v24 = React.useCallback(function()
		if fFlagGameJoinCardOptionalActions and props.onViewProfile == nil then
			return
		end

		props.onViewProfile(viewProfileSourceValues.ViewProfileButton)
	end, { props })
	local v25

	if FFlagMobileGameJoinCardEDPFromThumbnail then
		v25 = React.useCallback(function()
			if fFlagGameJoinCardOptionalActions and props.onViewExperienceDetails == nil then
				return
			end

			props.onViewExperienceDetails(viewEDPsourceValues.Thumbnail)
		end, { props.onViewExperienceDetails })
	end

	local v26

	if FFlagMobileGameJoinCardEDPFromTitle then
		v26 = React.useCallback(function()
			if fFlagGameJoinCardOptionalActions and props.onViewExperienceDetails == nil then
				return
			end

			props.onViewExperienceDetails(viewEDPsourceValues.Title)
		end, { props.onViewExperienceDetails })
	end

	local v27 = v7.Typography.TitleMedium.FontSize * v7.Typography.TitleMedium.LineHeight

	local v28 = v27 + v7.Typography.BodyMedium.FontSize * v7.Typography.BodyMedium.LineHeight + v7.Padding.Small
	local v29 = 88 + v28

	local v30 = false

	if fFlagJoinabilityCTARefactor then
		for k, action in props.actions do
			if action.id == userCtaAction.UnlockExperience then
				v30 = true
				break
			end
		end
	end

	if not fFlagJoinabilityCTARefactor then
		v30 = props.ageCheckRequired == true
	end

	local v32 = {
		isLoading = props.isLoading or fFlagJoinabilityCTARefactor and props.areActionsLoading == true,
		ctaType = 0,
		wasCached = 0,
		isDisabled = 0
	}
	local v33 = if v30 then ctaType.AgeCheckUnlock else ctaType.Join
	v32.ctaType = v33
	v32.wasCached = props.wasPlayabilityCached
	local v34

	if content == nil then
		if fFlagGameJoinCardOptionalActions then
			v34 = props.disableAppTelemetry
		end
	else
		v34 = true
	end

	v32.isDisabled = v34
	useJoinCardCtaLoadTime(v32)

	local v35 = useLocalization({
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

	local v36 = {}
	local v37 = nil

	if fFlagJoinabilityCTARefactor or content ~= nil then
		if props.areActionsLoading then
			v36.ActionsLoading = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, v7.Size.Size_600),
				LayoutOrder = 1
			})
		else
			local v38

			if primaryButtonFocusRef then
				v38 = assignPrimaryFocusRef(props.actions, primaryButtonFocusRef) or props.actions
			else
				v38 = props.actions
			end

			v36, v37 = buildJoinCardActionsComponent(
				v38,
				{
					playTogether = v35.playTogether,
					playTogetherSoon = v35.playTogetherSoon,
					differentServer = v35.differentServer
				},
				props.onClose,
				function(props2, p2)
					return React.createElement(button, {
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
						LayoutOrder = p2
					})
				end
			)
		end
	end

	local v38 = fFlagJoinabilityCTAContextCopy

	local createElement = React.createElement
	local v40 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ref = setState3
	}

	if state3 then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local root = sheet.Root
		local v45 = { preferCenterSheet = true, onClose = props.onClose, ref = 0 }

		if not fFlagMobileGameJoinCardGamepadSupport then
			rootRef = nil
		end

		v45.ref = rootRef

		local createElement4 = React.createElement
		local content2 = sheet.Content

		local v49 = if v11 then React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v7.Padding.Medium)
		}) else nil

		local createElement5 = React.createElement

		local createElement6 = React.createElement

		local v54 = if defineFastFlag then UDim2.new(1, 0, 0, 187 - v7.Padding.XLarge) else UDim2.new(1, 0, 0, 111)

		local createElement7 = React.createElement
		local v57 = {
			tag = "clip",
			Position = UDim2.new(0, -v7.Padding.XLarge, 0, -v7.Padding.XLarge),
			Size = UDim2.new(1, 40, 0, 187)
		}

		local createElement8 = React.createElement
		local v60 = {
			Size = UDim2.new(1, 0, 0, 202),
			BackgroundTransparency = 1,
			GroupTransparency = 0
		}

		local v61 = {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 15) }),
			BannerImage = 0,
			BannerThumbnail = 0,
			Media = 0,
			BannerSkeleton = 0
		}

		local createElement9 = React.createElement
		local v63 = {
			BackgroundTransparency = 1,
			Image = props.bannerImageUrl,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = FFlagMobileGameJoinCardThumbnail and 3 or 2,
			onLoaded = v16,
			onActivated = 0,
			stateLayer = 0
		}
		local v64

		if
			content == nil
			and (not fFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
			and FFlagMobileGameJoinCardEDPFromThumbnail
			and state
		then
			v64 = v25
		end

		v63.onActivated = v64

		v63.stateLayer = content == nil
			and (not fFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
			and FFlagMobileGameJoinCardEDPFromThumbnail
			and state
			and { affordance = stateLayerAffordance.None }
			or nil
		v61.BannerImage = createElement9(image, v63)

		local v65 = if v18 then React.createElement(image, {
			BackgroundTransparency = 1,
			Image = thumbnailImageUrl,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 2,
			onLoaded = v17
		}) else nil
		v61.BannerThumbnail = v65

		local v66 = if content then React.createElement(view, {
			tag = "size-full",
			ZIndex = 4
		}, {
			Content = content.media
		}) else nil
		v61.Media = v66

		local v67 = if v19 then React.createElement(skeleton, {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1
		}) else nil
		v61.BannerSkeleton = v67
		local v58 = {
			BannerImageCanvas = createElement8("CanvasGroup", v60, v61),
			BannerVideo = 0
		}
		local v68

		if fFlagMobileGameJoinCardVideo and props.bannerVideoId then
			local createElement10 = React.createElement
			local v70 = {
				videoId = props.bannerVideoId,
				videoPlaybackContext = props.bannerVideoPlaybackContext,
				universeId = props.universeId,
				Size = UDim2.new(1, 0, 0, 202),
				cornerRadius = 15,
				ZIndex = 2,
				onActivated = 0
			}

			if not FFlagMobileGameJoinCardEDPFromThumbnail then
				v25 = nil
			end

			v70.onActivated = v25
			v68 = createElement10(JoinCardBannerVideoContainer, v70)
		end

		v58.BannerVideo = v68
		local children = {
			BannerImageContainer = createElement6(
				view,
				{ tag = "size-full-0", Size = v54, LayoutOrder = 1 },
				{ BannerImageClipper = createElement7(view, v57, v58) }
			),
			UserTileWrapper = 0,
			CtaContext = 0,
			Buttons = 0
		}
		local v69

		if props.userId then
			local createElement10 = React.createElement
			local udim

			if defineFastFlag2 or content ~= nil then
				local newUDim2 = UDim2.new

				if content ~= nil then
					v27 = v28
				end

				udim = newUDim2(1, 0, 0, v27)
			else
				udim = if defineFastFlag then UDim2.new(1, 0, 0, v28) else UDim2.new(1, 0, 0, v29)
			end

			local v73

			if defineFastFlag2 or content ~= nil then
				local createElement11 = React.createElement
				local v75 = {
					tag = content == nil and "row align-x-center align-y-center size-full" or "col align-x-center align-y-center gap-small size-full",
					onActivated = 0,
					stateLayer = 0
				}

				if
					content == nil
					and (not fFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
				then
					if not FFlagMobileGameJoinCardEDPFromTitle then
						v26 = nil
					end
				else
					v26 = nil
				end

				v75.onActivated = v26

				v75.stateLayer = content == nil
					and (not fFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
					and FFlagMobileGameJoinCardEDPFromTitle
					and { affordance = stateLayerAffordance.None }
					or nil

				local createElement12 = React.createElement
				local v78 = {
					tag = "shrink auto-xy text-align-x-center content-emphasis",
					fontStyle = v7.Typography.TitleMedium,
					Text = 0,
					LayoutOrder = 1,
					RichText = true,
					TextTruncate = 0
				}
				local v79 = if content then content.title else props.experienceName
				v78.Text = v79

				v78.TextTruncate = Enum.TextTruncate.AtEnd
				local v76 = {
					ExperienceText = createElement12(text, v78),
					Subtitle = 0
				}

				local v80 = if content then React.createElement(text, {
					tag = "shrink auto-xy text-align-x-center content-default",
					fontStyle = v7.Typography.BodyMedium,
					Text = content.subtitle,
					LayoutOrder = 2,
					TextTruncate = Enum.TextTruncate.AtEnd
				}) else nil
				v76.Subtitle = v80
				v73 = createElement11(view, v75, v76)
			elseif defineFastFlag then
				v73 = React.createElement(view, {
					tag = "col align-x-center align-y-center size-full"
				}, {
					CombinedText = React.createElement(text, {
						tag = "shrink auto-xy text-wrap text-align-x-center content-default",
						fontStyle = v7.Typography.BodyMedium,
						Text = v35.userIsPlayingExperience,
						LayoutOrder = 1,
						RichText = true
					})
				})
			else
				local createElement11 = React.createElement
				local v75 = {
					userId = props.userId,
					title = props.playerName,
					subtitle = v35.playingExperience,
					layoutMode = layoutMode.compact,
					avatarSize = UDim2.fromOffset(88, 88),
					backplateStyle = v7.Color.Surface.Surface_100,
					onActivated = 0,
					selectable = 0
				}

				if fFlagGameJoinCardOptionalActions and props.onViewProfile == nil then
					v23 = nil
				end

				v75.onActivated = v23

				local v76 = if fFlagGameJoinCardOptionalActions and props.onViewProfile == nil then false else nil
				v75.selectable = v76
				v73 = createElement11(userTile, v75)
			end

			v69 = createElement10(view, { Size = udim, ZIndex = 2, LayoutOrder = 2 }, {
				Tile = v73
			})
		end

		children.UserTileWrapper = v69
		local v70

		if v38 and v37 ~= nil then
			local createElement10 = React.createElement

			local v73 = {
				CtaContextTitle = React.createElement(text, {
					Text = v37.title,
					tag = "auto-xy text-body-medium text-align-x-center content-emphasis",
					LayoutOrder = 1
				}),
				CtaContextSubtitle = 0
			}

			local v74 = if v37.subtitle ~= nil then React.createElement(text, {
				Text = v37.subtitle,
				tag = "auto-xy text-label-small text-align-x-center content-muted",
				LayoutOrder = 2
			}) else nil
			v73.CtaContextSubtitle = v74
			v70 = createElement10(
				view,
				{
					tag = "col align-x-center items-center gap-xxsmall size-full-0 auto-y",
					LayoutOrder = 3
				},
				v73
			)
		end

		children.CtaContext = v70

		local createElement10 = React.createElement

		local v72 = {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = v38 and v37 ~= nil and 4 or 3
		}

		if not fFlagJoinabilityCTARefactor and content == nil then
			v36 = { PrimaryButton = 0, ChatButton = 0, SecondaryButton = 0 }
			local v73

			if v30 then
				local createElement11 = React.createElement
				local v75 = {
					onUnlockPressed = props.onAgeCheckPressed or function() end,
					LayoutOrder = 1,
					focusRef = 0
				}

				if not fFlagMobileGameJoinCardGamepadSupport then
					primaryButtonFocusRef = nil
				end

				v75.focusRef = primaryButtonFocusRef
				v73 = createElement11(module7, v75)
			else
				local createElement11 = React.createElement

				if not fFlagMobileGameJoinCardGamepadSupport then
					primaryButtonFocusRef = nil
				end

				v73 = createElement11(button, {
					ref = primaryButtonFocusRef,
					text = v35.join,
					onActivated = props.onJoin,
					variant = buttonVariant.Emphasis,
					inputSize = inputSize.Medium,
					isLoading = props.isLoading,
					isDisabled = not props.isInExperience,
					width = UDim.new(1, 0),
					LayoutOrder = 1
				})
			end

			v36.PrimaryButton = v73
			local v74

			if props.canUsePlatformChat then
				local createElement11 = React.createElement

				local v77 = if defineFastFlag2 and not defineFastFlag3 then v35.chatWithName else v35.chat
				v74 = createElement11(button, {
					text = v77,
					onActivated = props.onChat,
					variant = buttonVariant.Standard,
					inputSize = inputSize.Medium,
					width = UDim.new(1, 0),
					LayoutOrder = 2
				})
			end

			v36.ChatButton = v74

			local v75 = if not fFlagGameJoinCardOptionalActions or props.onViewProfile ~= nil then React.createElement(button, {
				text = v35.viewProfile,
				onActivated = v24,
				variant = buttonVariant.Utility,
				inputSize = inputSize.Medium,
				width = UDim.new(1, 0),
				LayoutOrder = 3
			}) else nil
			v36.SecondaryButton = v75
		end

		children.Buttons = createElement10(view, v72, v36)
		state3 = createElement2(overlayProvider, { gui = state3 }, {
			SheetRoot = createElement3(root, v45, {
				Content = createElement4(content2, nil, {
					BottomPadding = v49,
					Layout = createElement5(
						view,
						{
							tag = "col gap-medium size-full-0 auto-y",
							testId = v6,
							selectionGroup = v5
						},
						children
					)
				})
			})
		})
	end

	return createElement("Frame", v40, { SheetProvider = state3 })
end

return MobileGameJoinCard
