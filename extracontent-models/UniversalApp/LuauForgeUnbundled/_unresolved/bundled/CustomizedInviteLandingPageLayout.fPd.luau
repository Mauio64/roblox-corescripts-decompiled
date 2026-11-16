local CorePackages = game:GetService("CorePackages")

local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dYW")

local module2 = require("@luauforge/bundled/fPe")

local module3 = require("@luauforge/bundled/fPf")

local React = require(CorePackages.Packages.React)
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local fetchGameMedia = AuthCommon.Thunks.FetchGameMedia
local getUserById = AuthCommon.Thunks.GetUserById

local Foundation = require(CorePackages.Packages.Foundation)
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local landingPageConstants = require("@luauforge/bundled/fMZ").Constants.LandingPageConstants
local common = landingPageConstants.Common
local customizedLandingPage = landingPageConstants.CustomizedLandingPage

local getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/bundled/cgr").Utils.getStandardSizeAvatarHeadShotRbxthumb

local UIBlox = require(CorePackages.Packages.UIBlox)
local loadableImage = UIBlox.App.Loading.LoadableImage
local colors = UIBlox.App.Style.Colors

local module5 = require("@luauforge/bundled/fsz")
local eventStreamConstants = module5.EventStreamConstants
local authClientError = module5.Events.authClientError
local authPageload = module5.Events.authPageload
local authTimingUtil = module5.authTimingUtil

local getGameNameAndDescription = require("@luauforge/bundled/dyi").GetGameNameAndDescription

local gameMediaImageType = require("@luauforge/bundled/cyO").GameMediaImageType

local fFlagLuaEnableLandingPageTTIMeasurements = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaEnableLandingPageTTIMeasurements

local fFlagLuaEnableGenreLandingDeeplink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaEnableGenreLandingDeeplink

local defineFastFlag = game:DefineFastFlag("EnableFoundationLogoInCustomizedInviteLandingPage", false)

local function CustomizedInviteLandingPageLayout(props)
	local v5 = useRoactService(roactNetworking)

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(nil)
	local universeId

	if props.deepLinkData.universeId and props.deepLinkData.universeId ~= 0 then
		universeId = tostring(props.deepLinkData.universeId)
	else
		universeId = nil
	end

	local inviterId = if props.deepLinkData.inviterId then tostring(props.deepLinkData.inviterId) else nil

	local function fn(p2)
		if state ~= p2.AbsoluteSize.Y then
			setState(p2.AbsoluteSize.Y)
		end
	end

	local function fn2()
		if universeId then
			getGameNameAndDescription(v5, universeId):andThen(function(p2)
				setState3(p2.Name)
			end):catch(function(p2)
				authClientError(
					eventStreamConstants.Context.LandingScreenCustomizedInvite,
					eventStreamConstants.State.FetchGameInfoError,
					nil,
					universeId
				)
			end)
		end

		if inviterId then
			getUserById(v5, inviterId):andThen(function(p2)
				setState4(p2.displayName)
			end):catch(function(p2)
				authClientError(
					eventStreamConstants.Context.LandingScreenCustomizedInvite,
					eventStreamConstants.State.FetchUserInfoError,
					nil,
					inviterId
				)
			end)
		end
	end

	local function fn3(state5)
		return string.format(common.IMAGE_ASSET_URL_TEMPLATE, state5)
	end

	local function fn4()
		if state2 then
			return fn3(state2)
		end

		local v6 = fFlagLuaEnableGenreLandingDeeplink
			and common.GetGenreBackgroundAssetId(props.deepLinkData.genre)

		if v6 then
			return "rbxassetid://" .. v6
		end

		if
			props.deepLinkData.universeId and props.deepLinkData.universeId ~= 0
			or not props.deepLinkData.genre
		then
			return common.DefaultBackground.IMAGE
		end

		local genreBackgrounds = common.GenreBackgrounds
		local v7 = ({
			["trending-in-rpg"] = "RPG",
			["trending-in-simulation"] = "Simulation",
			["trending-in-shooter"] = "Shooter",
			["trending-in-sports-and-racing"] = "SportsAndRacing"
		})[props.deepLinkData.genre]

		if v7 and genreBackgrounds[v7] then
			return genreBackgrounds[v7].IMAGE
		end

		return common.DefaultBackground.IMAGE
	end

	React.useEffect(function()
		if universeId then
			fetchGameMedia(v5, universeId):andThen(function(list)
				for i, item in ipairs(list) do
					if item.assetTypeId == gameMediaImageType.Image then
						setState2(item.imageId)
						break
					end
				end
			end):catch(function(p2)
				authClientError(
					eventStreamConstants.Context.LandingScreenCustomizedInvite,
					eventStreamConstants.State.FetchGameMediaError,
					nil,
					universeId
				)
			end)
		end

		fn2()
	end, {})

	local contentFocusedStyle = landingPageConstants.ContentProps.ContentFocusedStyle

	local v6 = getSafeAreaSize(props.screenSize, props.globalGuiInset).Y.Offset - props.statusBarHeight
	local v7 = v6 * contentFocusedStyle.BodyPositionYScale
	local v8 = v6 * contentFocusedStyle.LogoPositionYScale

	local v9 = useLocalization({
		invitedBy = state4 and {
			"Feature.Landing.Label.InvitedBy",
			name = state4
		} or nil
	})

	local v10 = useTokens()
	local v12

	if defineFastFlag then
		v12 = React.createElement(Foundation.Image, {
			Position = UDim2.new(0.5, 0, 0, v8),
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Fit,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0.7, 0, 0.7, 0),
			Image = common.RobloxLogo.IMAGE,
			sizeConstraint = {
				MaxSize = Vector2.new(
					common.RobloxLogo.MAX_WIDTH_SMALL,
					common.RobloxLogo.MAX_WIDTH_SMALL / common.RobloxLogo.ASPECT_RATIO
				)
			},
			aspectRatio = common.RobloxLogo.ASPECT_RATIO,
			ZIndex = 1
		})
	else
		v12 = React.createElement("ImageLabel", {
			Position = UDim2.new(0.5, 0, 0, v8),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0.7, 0, 0.7, 0),
			Image = common.RobloxLogo.IMAGE,
			ZIndex = 1
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(
					common.RobloxLogo.MAX_WIDTH_SMALL,
					common.RobloxLogo.MAX_WIDTH_SMALL / common.RobloxLogo.ASPECT_RATIO
				)
			}),
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = common.RobloxLogo.ASPECT_RATIO,
				AspectType = Enum.AspectType.FitWithinMaxSize
			})
		})
	end

	local createElement = React.createElement
	local v14 = {
		Position = UDim2.new(0.5, 0, 0, v7),
		Size = UDim2.new(1, 0, 1, -v7),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		ZIndex = 2
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		GameIconFrame = 0,
		GameIconPadding = 0,
		GameTitleText = 0,
		GameTitlePadding = 0,
		InviterTextFrame = 0,
		InviterTextPadding = 0,
		Content = 0
	}

	local v15 = if universeId then React.createElement(
		"Frame",
		{
			Size = UDim2.fromOffset(
				customizedLandingPage.GameIcon.SIZE,
				customizedLandingPage.GameIcon.SIZE
			),
			BorderSizePixel = 0,
			BackgroundColor3 = colors.White,
			LayoutOrder = 1
		},
		{
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(customizedLandingPage.GameIcon.CORNER_RADIUS, 0)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			GameIcon = React.createElement(loadableImage, {
				Size = UDim2.fromOffset(
					customizedLandingPage.GameIcon.SIZE - customizedLandingPage.GameIcon.PADDING,
					customizedLandingPage.GameIcon.SIZE - customizedLandingPage.GameIcon.PADDING
				),
				BackgroundTransparency = 1,
				Image = string.format(customizedLandingPage.GameIcon.IMAGE_URI_TEMPLATE, universeId),
				useShimmerAnimationWhileLoading = true,
				showFailedStateWhenLoadingFailed = true,
				cornerRadius = UDim.new(customizedLandingPage.GameIcon.CORNER_RADIUS, 0),
				shouldHandleReloads = true,
				LayoutOrder = 1
			})
		}
	) else nil
	children.GameIconFrame = v15

	local v16 = if universeId then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}) else nil
	children.GameIconPadding = v16

	local v17 = if universeId and state3 then React.createElement(text, {
		Text = state3,
		textStyle = v10.Color.Content.Emphasis,
		fontStyle = v10.Typography.HeadingMedium,
		Size = UDim2.new(1, -40, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Bottom,
		LayoutOrder = 3
	}) else nil
	children.GameTitleText = v17

	local v18 = if universeId then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 6),
		BackgroundTransparency = 1,
		LayoutOrder = 4
	}) else nil
	children.GameTitlePadding = v18

	local v19 = if state4 and props.deepLinkData.inviterId then React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 5
		},
		{
			HorizontalLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			InviterThumbnail = React.createElement(loadableImage, {
				LayoutOrder = 1,
				Size = UDim2.new(0, 24, 0, 24),
				Image = getStandardSizeAvatarHeadShotRbxthumb((tostring(props.deepLinkData.inviterId))),
				useShimmerAnimationWhileLoading = true,
				cornerRadius = UDim.new(0.5, 0),
				shouldHandleReloads = true
			}),
			InviterText = React.createElement(text, {
				LayoutOrder = 2,
				Text = v9.invitedBy,
				textStyle = v10.Color.Content.Default,
				fontStyle = v10.Typography.BodyMedium,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Center
			})
		}
	) else nil
	children.InviterTextFrame = v19

	children.InviterTextPadding = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,
		LayoutOrder = 6
	})

	children.Content = React.createElement("Frame", {
		Position = contentFocusedStyle.Position,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AnchorPoint = contentFocusedStyle.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = 7,
		[React.Change.AbsoluteSize] = fn
	}, { props.children })
	local v11 = {
		Logo = v12,
		ContentContainer = createElement("Frame", v14, children)
	}

	local v21 = fFlagLuaEnableLandingPageTTIMeasurements and authTimingUtil.landingPageLoadFinish()

	if v21 then
		local v22 = {
			variant = eventStreamConstants.Context.LandingScreenCustomizedInvite,
			timing = v21
		}

		authPageload(eventStreamConstants.Context.LandingPageRender, HttpService:JSONEncode(v22))
	end

	return React.createElement(module, {
		includeStatusBar = true,
		buttonRef = props.containerRef,
		renderFullscreenBackground = function(p2)
			if
				fFlagLuaEnableGenreLandingDeeplink
				and common.GetGenreBackgroundAssetId(props.deepLinkData.genre) ~= nil
			then
				return React.createElement(module3, { backgroundImage = fn4() })
			end

			return React.createElement(module2, { backgroundImage = fn4() })
		end
	}, {
		Contents = React.createElement(
			"Frame",
			{
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 2
			},
			{ v11 }
		)
	})
end

return CustomizedInviteLandingPageLayout
