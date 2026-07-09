local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
local CustomizedInviteLandingPageBackground = require(Modules.LuaApp.Components.Authentication.CustomizedInviteLandingPageBackground)
local CustomStaticLandingPageBackground = require(Modules.LuaApp.Components.Authentication.CustomStaticLandingPageBackground)
local React = require(CorePackages.Packages.React)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local FetchGameMedia = AuthCommon.Thunks.FetchGameMedia
local GetUserById = AuthCommon.Thunks.GetUserById
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local LandingPageConstants = require(CorePackages.Workspace.Packages.LandingPage).Constants.LandingPageConstants
local Common = LandingPageConstants.Common
local CustomizedLandingPage = LandingPageConstants.CustomizedLandingPage
local getStandardSizeAvatarHeadShotRbxthumb = require(CorePackages.Workspace.Packages.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local UIBlox = require(CorePackages.Packages.UIBlox)
local LoadableImage = UIBlox.App.Loading.LoadableImage
local Colors = UIBlox.App.Style.Colors
local AuthAnalytics = require(CorePackages.Workspace.Packages.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authClientError = AuthAnalytics.Events.authClientError
local authPageload = AuthAnalytics.Events.authPageload
local authTimingUtil = AuthAnalytics.authTimingUtil
local GetGameNameAndDescription = require(CorePackages.Workspace.Packages.GameDetailRodux).GetGameNameAndDescription
local GameMediaImageType = require(CorePackages.Workspace.Packages.DiscoveryTypes).GameMediaImageType
local FFlagLuaEnableLandingPageTTIMeasurements = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaEnableLandingPageTTIMeasurements
local FFlagLuaEnableGenreLandingDeeplink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaEnableGenreLandingDeeplink
local v34 = game:DefineFastFlag("EnableFoundationLogoInCustomizedInviteLandingPage", false)

local function CustomizedInviteLandingPageLayout(t1: {[any]: any}) -- line: 67
	-- upvalues: useRoactService (copy), RoactNetworking (copy), React (copy), GetGameNameAndDescription (copy), authClientError (copy), EventStreamConstants (copy), GetUserById (copy), Common (copy), FFlagLuaEnableGenreLandingDeeplink (copy), FetchGameMedia (copy), GameMediaImageType (copy), LandingPageConstants (copy), getSafeAreaSize (copy), useLocalization (copy), useTokens (copy), v34 (copy), Foundation (copy), CustomizedLandingPage (copy), Colors (copy), LoadableImage (copy), FoundationText (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), FFlagLuaEnableLandingPageTTIMeasurements (copy), authTimingUtil (copy), authPageload (copy), HttpService (copy), FullscreenPageWithSafeArea (copy), CustomStaticLandingPageBackground (copy), CustomizedInviteLandingPageBackground (copy)
	local v37 = useRoactService(RoactNetworking)
	local v38, v39 = React.useState(0)
	local v40, v41 = React.useState(nil)
	local v42, v43 = React.useState(nil)
	local v44, v45 = React.useState(nil)
	local v46 = if not t1.deepLinkData.universeId or t1.deepLinkData.universeId == 0 then nil else tostring(t1.deepLinkData.universeId)
	local v47 = if not t1.deepLinkData.inviterId then nil else tostring(t1.deepLinkData.inviterId)

	local function v48() -- line: 86
		-- upvalues: v46 (copy), GetGameNameAndDescription (copy), v37 (copy), v43 (copy), authClientError (copy), EventStreamConstants (copy), v47 (copy), GetUserById (copy), v45 (copy)
		if v46 then
			GetGameNameAndDescription(v37, v46):andThen(function(p1) -- line: 89
				-- upvalues: v43 (copy)
				v43(p1.Name)
			end):catch(function(_) -- line: 91
				-- upvalues: authClientError (copy), EventStreamConstants (copy), v46 (copy)
				authClientError(EventStreamConstants.Context.LandingScreenCustomizedInvite, EventStreamConstants.State.FetchGameInfoError, nil, v46)
			end)
		end

		if v47 then
			GetUserById(v37, v47):andThen(function(p3) -- line: 102
				-- upvalues: v45 (copy)
				v45(p3.displayName)
			end):catch(function(_) -- line: 104
				-- upvalues: authClientError (copy), EventStreamConstants (copy), v47 (copy)
				authClientError(EventStreamConstants.Context.LandingScreenCustomizedInvite, EventStreamConstants.State.FetchUserInfoError, nil, v47)
			end)
		end
	end
	local function v49(s1: string) -- line: 115
		-- upvalues: Common (copy)
		return string.format(Common.IMAGE_ASSET_URL_TEMPLATE, s1)
	end
	local function v50() -- line: 119
		-- upvalues: v40 (copy), v49 (copy), FFlagLuaEnableGenreLandingDeeplink (copy), Common (copy), t1 (copy)
		if v40 then
			return v49(v40)
		end

		if FFlagLuaEnableGenreLandingDeeplink then
			local v62 = Common.GetGenreBackgroundAssetId(t1.deepLinkData.genre)

			if v62 then
				return "rbxassetid://" .. v62
			end
		end

		if (not t1.deepLinkData.universeId or t1.deepLinkData.universeId == 0) and t1.deepLinkData.genre then
			local GenreBackgrounds = Common.GenreBackgrounds
			local genre = t1.deepLinkData.genre
			local v65 = ({
				["trending-in-rpg"] = "RPG",
				["trending-in-simulation"] = "Simulation",
				["trending-in-shooter"] = "Shooter",
				["trending-in-sports-and-racing"] = "SportsAndRacing"
			})[genre]

			if v65 and GenreBackgrounds[v65] then
				return GenreBackgrounds[v65].IMAGE
			end
		end

		return Common.DefaultBackground.IMAGE
	end

	React.useEffect(function() -- line: 153
		-- upvalues: v46 (copy), FetchGameMedia (copy), v37 (copy), GameMediaImageType (copy), v41 (copy), authClientError (copy), EventStreamConstants (copy), v48 (copy)
		if v46 then
			FetchGameMedia(v37, v46):andThen(function(p5) -- line: 156
				-- upvalues: GameMediaImageType (copy), v41 (copy)
				for _, v in ipairs(p5) do
					if v.assetTypeId == GameMediaImageType.Image then
						v41(v.imageId)

						return
					end
				end
			end):catch(function(_) -- line: 163
				-- upvalues: authClientError (copy), EventStreamConstants (copy), v46 (copy)
				authClientError(EventStreamConstants.Context.LandingScreenCustomizedInvite, EventStreamConstants.State.FetchGameMediaError, nil, v46)
			end)
		end

		v48()
	end, {})

	local ContentFocusedStyle = LandingPageConstants.ContentProps.ContentFocusedStyle
	local v52 = getSafeAreaSize(t1.screenSize, t1.globalGuiInset).Y.Offset - t1.statusBarHeight
	local v53 = v52 * ContentFocusedStyle.BodyPositionYScale
	local v54 = v52 * ContentFocusedStyle.LogoPositionYScale
	local v55 = useLocalization({
		invitedBy = if not v44 then nil else {
			"Feature.Landing.Label.InvitedBy",
			name = v44
		}
	})
	local v56 = useTokens()
	local t2 = {
		Logo = if not v34 then React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ZIndex = 1,
			Position = UDim2.new(0.5, 0, 0, v54),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0.7, 0, 0.7, 0),
			Image = Common.RobloxLogo.IMAGE
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(Common.RobloxLogo.MAX_WIDTH_SMALL, Common.RobloxLogo.MAX_WIDTH_SMALL / Common.RobloxLogo.ASPECT_RATIO)
			}),
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = Common.RobloxLogo.ASPECT_RATIO,
				AspectType = Enum.AspectType.FitWithinMaxSize
			})
		}) else React.createElement(Foundation.Image, {
			BackgroundTransparency = 1,
			ZIndex = 1,
			Position = UDim2.new(0.5, 0, 0, v54),
			ScaleType = Enum.ScaleType.Fit,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0.7, 0, 0.7, 0),
			Image = Common.RobloxLogo.IMAGE,
			sizeConstraint = {
				MaxSize = Vector2.new(Common.RobloxLogo.MAX_WIDTH_SMALL, Common.RobloxLogo.MAX_WIDTH_SMALL / Common.RobloxLogo.ASPECT_RATIO)
			},
			aspectRatio = Common.RobloxLogo.ASPECT_RATIO
		}),
		ContentContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = UDim2.new(0.5, 0, 0, v53),
			Size = UDim2.new(1, 0, 1, -v53),
			AnchorPoint = Vector2.new(0.5, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			GameIconFrame = if not v46 then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.fromOffset(CustomizedLandingPage.GameIcon.SIZE, CustomizedLandingPage.GameIcon.SIZE),
				BackgroundColor3 = Colors.White
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(CustomizedLandingPage.GameIcon.CORNER_RADIUS, 0)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				GameIcon = React.createElement(LoadableImage, {
					BackgroundTransparency = 1,
					useShimmerAnimationWhileLoading = true,
					showFailedStateWhenLoadingFailed = true,
					shouldHandleReloads = true,
					LayoutOrder = 1,
					Size = UDim2.fromOffset(CustomizedLandingPage.GameIcon.SIZE - CustomizedLandingPage.GameIcon.PADDING, CustomizedLandingPage.GameIcon.SIZE - CustomizedLandingPage.GameIcon.PADDING),
					Image = string.format(CustomizedLandingPage.GameIcon.IMAGE_URI_TEMPLATE, v46),
					cornerRadius = UDim.new(CustomizedLandingPage.GameIcon.CORNER_RADIUS, 0)
				})
			}),
			GameIconPadding = if not v46 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 20)
			}),
			GameTitleText = if not v46 or not v42 then nil else React.createElement(FoundationText, {
				TextWrapped = true,
				LayoutOrder = 3,
				Text = v42,
				textStyle = v56.Color.Content.Emphasis,
				fontStyle = v56.Typography.HeadingMedium,
				Size = UDim2.new(1, -40, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Bottom
			}),
			GameTitlePadding = if not v46 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 6)
			}),
			InviterTextFrame = if not v44 or not t1.deepLinkData.inviterId then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 5,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				HorizontalLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				InviterThumbnail = React.createElement(LoadableImage, {
					LayoutOrder = 1,
					useShimmerAnimationWhileLoading = true,
					shouldHandleReloads = true,
					Size = UDim2.new(0, 24, 0, 24),
					Image = getStandardSizeAvatarHeadShotRbxthumb((tostring(t1.deepLinkData.inviterId))),
					cornerRadius = UDim.new(0.5, 0)
				}),
				InviterText = React.createElement(FoundationText, {
					LayoutOrder = 2,
					TextWrapped = true,
					Text = v55.invitedBy,
					textStyle = v56.Color.Content.Default,
					fontStyle = v56.Typography.BodyMedium,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextXAlignment = Enum.TextXAlignment.Center
				})
			}),
			InviterTextPadding = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 6,
				Size = UDim2.new(1, 0, 0, 40)
			}),
			Content = React.createElement("Frame", {
				Position = ContentFocusedStyle.Position,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				AnchorPoint = ContentFocusedStyle.AnchorPoint,
				BackgroundTransparency = 1,
				LayoutOrder = 7,
				[React.Change.AbsoluteSize] = function(p7) -- line: 80
					-- upvalues: v38 (copy), v39 (copy)
					if v38 ~= p7.AbsoluteSize.Y then
						v39(p7.AbsoluteSize.Y)
					end
				end
			}, { t1.children })
		})
	}

	if FFlagLuaEnableLandingPageTTIMeasurements then
		local v58 = authTimingUtil.landingPageLoadFinish()

		if v58 then
			local t3 = {
				variant = EventStreamConstants.Context.LandingScreenCustomizedInvite,
				timing = v58
			}

			authPageload(EventStreamConstants.Context.LandingPageRender, HttpService:JSONEncode(t3))
		end
	end

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		buttonRef = t1.containerRef,
		renderFullscreenBackground = function(_) -- line: 371
			-- upvalues: FFlagLuaEnableGenreLandingDeeplink (copy), Common (copy), t1 (copy), React (copy), CustomStaticLandingPageBackground (copy), v50 (copy), CustomizedInviteLandingPageBackground (copy)
			if FFlagLuaEnableGenreLandingDeeplink and Common.GetGenreBackgroundAssetId(t1.deepLinkData.genre) ~= nil then
				return React.createElement(CustomStaticLandingPageBackground, {
					backgroundImage = v50()
				})
			end

			return React.createElement(CustomizedInviteLandingPageBackground, {
				backgroundImage = v50()
			})
		end
	}, {
		Contents = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 1, 0)
		}, { t2 })
	})
end

return CustomizedInviteLandingPageLayout
