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
local GameJoinCardTTI = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Telemetry/GameJoinCardTTI")
local FFlagMobileGameJoinCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardThumbnail")
local defineFastFlag = game:DefineFastFlag("MobileGameJoinCardHideUserAvatar", false)

local defineFastFlag2 = game:DefineFastFlag("MobileGameJoinCardShowExperienceNameOnly", false)
local FFlagMobileGameJoinCardEDPFromTitle = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardEDPFromTitle")
local FFlagMobileGameJoinCardEDPFromThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardEDPFromThumbnail")
local defineFastFlag3 = game:DefineFastFlag("MobileGameCardDontShowChatWith", false)
local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagJoinabilityCTARefactor
local fFlagJoinabilityCTAContextCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagJoinabilityCTAContextCopy
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local buildJoinCardActionsComponent = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/buildJoinCardActionsComponent")
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction

local function MobileGameJoinCard(props)
	local v5 = useTokens()
	local state, setState = React.useState(false)
	local state2, setState2

	if FFlagMobileGameJoinCardThumbnail then
		state2, setState2 = React.useState(false)
	else
		setState2 = nil
	end

	local state3, setState3 = React.useState(nil)

	local v6 = Foundation.Hooks.useOverlay()
	local v7 = not v6 or v6.AbsoluteSize.X > v6.AbsoluteSize.Y
	local v9 = GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small or not not v7
	local thumbnailImageUrl = props.thumbnailImageUrl
	local content = if fFlagGameJoinCardContent then props.content else nil
	local v10

	if fFlagMobileGameJoinCardGamepadSupport then
		v10 = useGameJoinCardGamepadNavigation(props.onClose, props.isNavigationFocused ~= false)
	end

	local rootRef = if v10 then v10.rootRef else nil
	local primaryButtonFocusRef = if v10 then v10.primaryButtonFocusRef else nil

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

	local v12 = content ~= nil
	local v13 = if fFlagGameJoinCardOptionalActions then props.disableAppTelemetry else nil
	local v14 = useCallback(fn, { v12, v13 })
	local v15

	if FFlagMobileGameJoinCardThumbnail then
		v15 = React.useCallback(function(p2)
			if p2 == Enum.AssetFetchStatus.Success then
				setState2(true)
			end
		end, {})
	end

	local v16 = FFlagMobileGameJoinCardThumbnail

	if v16 then
		v16 = not (thumbnailImageUrl == nil) and not state
	end

	local v17 = content == nil and (if FFlagMobileGameJoinCardThumbnail then not (state or state2) else not state)

	local useEffect = React.useEffect
	local function fn2()
		if content ~= nil or fFlagGameJoinCardOptionalActions and props.disableAppTelemetry then
			return
		end

		GameJoinCardTTI.trackCardMounted()
	end

	local v19 = content ~= nil
	local v20 = if fFlagGameJoinCardOptionalActions then props.disableAppTelemetry else nil
	useEffect(fn2, { v19, v20 })

	local v21 = React.useCallback(function()
		if fFlagGameJoinCardOptionalActions and props.onViewProfile == nil then
			return
		end

		props.onViewProfile(viewProfileSourceValues.UserTile)
	end, { props })

	local v22 = React.useCallback(function()
		if fFlagGameJoinCardOptionalActions and props.onViewProfile == nil then
			return
		end

		props.onViewProfile(viewProfileSourceValues.ViewProfileButton)
	end, { props })
	local v23

	if FFlagMobileGameJoinCardEDPFromThumbnail then
		v23 = React.useCallback(function()
			if fFlagGameJoinCardOptionalActions and props.onViewExperienceDetails == nil then
				return
			end

			props.onViewExperienceDetails(viewEDPsourceValues.Thumbnail)
		end, { props.onViewExperienceDetails })
	end

	local v24

	if FFlagMobileGameJoinCardEDPFromTitle then
		v24 = React.useCallback(function()
			if fFlagGameJoinCardOptionalActions and props.onViewExperienceDetails == nil then
				return
			end

			props.onViewExperienceDetails(viewEDPsourceValues.Title)
		end, { props.onViewExperienceDetails })
	end

	local v25 = v5.Typography.TitleMedium.FontSize * v5.Typography.TitleMedium.LineHeight

	local v26 = v25 + v5.Typography.BodyMedium.FontSize * v5.Typography.BodyMedium.LineHeight + v5.Padding.Small
	local v27 = 88 + v26

	local v28 = false

	if fFlagJoinabilityCTARefactor then
		for k, action in props.actions do
			if action.id == userCtaAction.UnlockExperience then
				v28 = true
				break
			end
		end
	end

	if not fFlagJoinabilityCTARefactor then
		v28 = props.ageCheckRequired == true
	end

	local v30 = {
		isLoading = props.isLoading or fFlagJoinabilityCTARefactor and props.areActionsLoading == true,
		ctaType = 0,
		wasCached = 0,
		isDisabled = 0
	}
	local v31 = if v28 then ctaType.AgeCheckUnlock else ctaType.Join
	v30.ctaType = v31
	v30.wasCached = props.wasPlayabilityCached
	local v32

	if content == nil then
		if fFlagGameJoinCardOptionalActions then
			v32 = props.disableAppTelemetry
		end
	else
		v32 = true
	end

	v30.isDisabled = v32
	useJoinCardCtaLoadTime(v30)

	local v33 = useLocalization({
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

	local v34 = {}
	local v35 = nil

	if fFlagJoinabilityCTARefactor or content ~= nil then
		if props.areActionsLoading then
			v34.ActionsLoading = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, v5.Size.Size_600),
				LayoutOrder = 1
			})
		else
			local v36

			if primaryButtonFocusRef then
				v36 = assignPrimaryFocusRef(props.actions, primaryButtonFocusRef) or props.actions
			else
				v36 = props.actions
			end

			v34, v35 = buildJoinCardActionsComponent(
				v36,
				{
					playTogether = v33.playTogether,
					playTogetherSoon = v33.playTogetherSoon,
					differentServer = v33.differentServer
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

	local v36 = fFlagJoinabilityCTAContextCopy

	local createElement = React.createElement
	local v38 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ref = setState3
	}

	if state3 then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local root = sheet.Root
		local v43 = { preferCenterSheet = true, onClose = props.onClose, ref = 0 }

		if not fFlagMobileGameJoinCardGamepadSupport then
			rootRef = nil
		end

		v43.ref = rootRef

		local createElement4 = React.createElement
		local content2 = sheet.Content

		local v47 = if v9 then React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v5.Padding.Medium)
		}) else nil

		local createElement5 = React.createElement

		local createElement6 = React.createElement

		local v52 = if defineFastFlag then UDim2.new(1, 0, 0, 187 - v5.Padding.XLarge) else UDim2.new(1, 0, 0, 111)

		local createElement7 = React.createElement
		local v55 = {
			tag = "clip",
			Position = UDim2.new(0, -v5.Padding.XLarge, 0, -v5.Padding.XLarge),
			Size = UDim2.new(1, 40, 0, 187)
		}

		local createElement8 = React.createElement
		local v58 = {
			Size = UDim2.new(1, 0, 0, 202),
			BackgroundTransparency = 1,
			GroupTransparency = 0
		}

		local v59 = {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 15) }),
			BannerImage = 0,
			BannerThumbnail = 0,
			Media = 0,
			BannerSkeleton = 0
		}

		local createElement9 = React.createElement
		local v61 = {
			BackgroundTransparency = 1,
			Image = props.bannerImageUrl,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = FFlagMobileGameJoinCardThumbnail and 3 or 2,
			onLoaded = v14,
			onActivated = 0,
			stateLayer = 0
		}

		if
			content == nil
			and (not fFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
		then
			if not (FFlagMobileGameJoinCardEDPFromThumbnail and state) then
				v23 = nil
			end
		else
			v23 = nil
		end

		v61.onActivated = v23

		v61.stateLayer = content == nil
			and (not fFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
			and FFlagMobileGameJoinCardEDPFromThumbnail
			and state
			and { affordance = stateLayerAffordance.None }
			or nil
		v59.BannerImage = createElement9(image, v61)

		local v62 = if v16 then React.createElement(image, {
			BackgroundTransparency = 1,
			Image = thumbnailImageUrl,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 2,
			onLoaded = v15
		}) else nil
		v59.BannerThumbnail = v62

		local v63 = if content then React.createElement(view, {
			tag = "size-full",
			ZIndex = 4
		}, {
			Content = content.media
		}) else nil
		v59.Media = v63

		local v64 = if v17 then React.createElement(skeleton, {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1
		}) else nil
		v59.BannerSkeleton = v64
		local children = {
			BannerImageContainer = createElement6(
				view,
				{ tag = "size-full-0", Size = v52, LayoutOrder = 1 },
				{
					BannerImageClipper = createElement7(view, v55, {
						BannerImageCanvas = createElement8("CanvasGroup", v58, v59)
					})
				}
			),
			UserTileWrapper = 0,
			CtaContext = 0,
			Buttons = 0
		}
		local v65

		if props.userId then
			local createElement10 = React.createElement
			local udim

			if defineFastFlag2 or content ~= nil then
				local newUDim2 = UDim2.new

				if content ~= nil then
					v25 = v26
				end

				udim = newUDim2(1, 0, 0, v25)
			else
				udim = if defineFastFlag then UDim2.new(1, 0, 0, v26) else UDim2.new(1, 0, 0, v27)
			end

			local v69

			if defineFastFlag2 or content ~= nil then
				local createElement11 = React.createElement
				local v71 = {
					tag = content == nil and "row align-x-center align-y-center size-full" or "col align-x-center align-y-center gap-small size-full",
					onActivated = 0,
					stateLayer = 0
				}

				if
					content == nil
					and (not fFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
				then
					if not FFlagMobileGameJoinCardEDPFromTitle then
						v24 = nil
					end
				else
					v24 = nil
				end

				v71.onActivated = v24

				v71.stateLayer = content == nil
					and (not fFlagGameJoinCardOptionalActions or props.onViewExperienceDetails ~= nil)
					and FFlagMobileGameJoinCardEDPFromTitle
					and { affordance = stateLayerAffordance.None }
					or nil

				local createElement12 = React.createElement
				local v74 = {
					tag = "shrink auto-xy text-align-x-center content-emphasis",
					fontStyle = v5.Typography.TitleMedium,
					Text = 0,
					LayoutOrder = 1,
					RichText = true,
					TextTruncate = 0
				}
				local v75 = if content then content.title else props.experienceName
				v74.Text = v75

				v74.TextTruncate = Enum.TextTruncate.AtEnd
				local v72 = {
					ExperienceText = createElement12(text, v74),
					Subtitle = 0
				}

				local v76 = if content then React.createElement(text, {
					tag = "shrink auto-xy text-align-x-center content-default",
					fontStyle = v5.Typography.BodyMedium,
					Text = content.subtitle,
					LayoutOrder = 2,
					TextTruncate = Enum.TextTruncate.AtEnd
				}) else nil
				v72.Subtitle = v76
				v69 = createElement11(view, v71, v72)
			elseif defineFastFlag then
				v69 = React.createElement(view, {
					tag = "col align-x-center align-y-center size-full"
				}, {
					CombinedText = React.createElement(text, {
						tag = "shrink auto-xy text-wrap text-align-x-center content-default",
						fontStyle = v5.Typography.BodyMedium,
						Text = v33.userIsPlayingExperience,
						LayoutOrder = 1,
						RichText = true
					})
				})
			else
				local createElement11 = React.createElement
				local v71 = {
					userId = props.userId,
					title = props.playerName,
					subtitle = v33.playingExperience,
					layoutMode = layoutMode.compact,
					avatarSize = UDim2.fromOffset(88, 88),
					backplateStyle = v5.Color.Surface.Surface_100,
					onActivated = 0,
					selectable = 0
				}

				if fFlagGameJoinCardOptionalActions and props.onViewProfile == nil then
					v21 = nil
				end

				v71.onActivated = v21

				local v72 = if fFlagGameJoinCardOptionalActions and props.onViewProfile == nil then false else nil
				v71.selectable = v72
				v69 = createElement11(userTile, v71)
			end

			v65 = createElement10(view, { Size = udim, ZIndex = 2, LayoutOrder = 2 }, {
				Tile = v69
			})
		end

		children.UserTileWrapper = v65
		local v66

		if v36 and v35 ~= nil then
			local createElement10 = React.createElement

			local v69 = {
				CtaContextTitle = React.createElement(text, {
					Text = v35.title,
					tag = "auto-xy text-body-medium text-align-x-center content-emphasis",
					LayoutOrder = 1
				}),
				CtaContextSubtitle = 0
			}

			local v70 = if v35.subtitle ~= nil then React.createElement(text, {
				Text = v35.subtitle,
				tag = "auto-xy text-label-small text-align-x-center content-muted",
				LayoutOrder = 2
			}) else nil
			v69.CtaContextSubtitle = v70
			v66 = createElement10(
				view,
				{
					tag = "col align-x-center items-center gap-xxsmall size-full-0 auto-y",
					LayoutOrder = 3
				},
				v69
			)
		end

		children.CtaContext = v66

		local createElement10 = React.createElement

		local v68 = {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = v36 and v35 ~= nil and 4 or 3
		}

		if not fFlagJoinabilityCTARefactor and content == nil then
			v34 = { PrimaryButton = 0, ChatButton = 0, SecondaryButton = 0 }
			local v69

			if v28 then
				local createElement11 = React.createElement
				local v71 = {
					onUnlockPressed = props.onAgeCheckPressed or function() end,
					LayoutOrder = 1,
					focusRef = 0
				}

				if not fFlagMobileGameJoinCardGamepadSupport then
					primaryButtonFocusRef = nil
				end

				v71.focusRef = primaryButtonFocusRef
				v69 = createElement11(module7, v71)
			else
				local createElement11 = React.createElement

				if not fFlagMobileGameJoinCardGamepadSupport then
					primaryButtonFocusRef = nil
				end

				v69 = createElement11(button, {
					ref = primaryButtonFocusRef,
					text = v33.join,
					onActivated = props.onJoin,
					variant = buttonVariant.Emphasis,
					inputSize = inputSize.Medium,
					isLoading = props.isLoading,
					isDisabled = not props.isInExperience,
					width = UDim.new(1, 0),
					LayoutOrder = 1
				})
			end

			v34.PrimaryButton = v69
			local v70

			if props.canUsePlatformChat then
				local createElement11 = React.createElement

				local v73 = if defineFastFlag2 and not defineFastFlag3 then v33.chatWithName else v33.chat
				v70 = createElement11(button, {
					text = v73,
					onActivated = props.onChat,
					variant = buttonVariant.Standard,
					inputSize = inputSize.Medium,
					width = UDim.new(1, 0),
					LayoutOrder = 2
				})
			end

			v34.ChatButton = v70

			local v71 = if not fFlagGameJoinCardOptionalActions or props.onViewProfile ~= nil then React.createElement(button, {
				text = v33.viewProfile,
				onActivated = v22,
				variant = buttonVariant.Utility,
				inputSize = inputSize.Medium,
				width = UDim.new(1, 0),
				LayoutOrder = 3
			}) else nil
			v34.SecondaryButton = v71
		end

		children.Buttons = createElement10(view, v68, v34)
		state3 = createElement2(overlayProvider, { gui = state3 }, {
			SheetRoot = createElement3(root, v43, {
				Content = createElement4(content2, nil, {
					BottomPadding = v47,
					Layout = createElement5(view, {
						tag = "col gap-medium size-full-0 auto-y"
					}, children)
				})
			})
		})
	end

	return createElement("Frame", v38, { SheetProvider = state3 })
end

return MobileGameJoinCard
