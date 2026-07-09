local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local GamePlayButton = require(CorePackages.Workspace.Packages.GamePlayButton)
local PlayButton = GamePlayButton.PlayButton
local usePlayButtonState = GamePlayButton.usePlayButtonState
local usePlayButtonContextualMessage = GamePlayButton.usePlayButtonContextualMessage
local PlayButtonContextualMessageImpressionsDetector = GamePlayButton.PlayButtonContextualMessageImpressionsDetector
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local ButtonSize = Foundation.Enums.ButtonSize
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PlayButtonContainer = require(Modules.LuaApp.Components.Games.PlayButtonContainer)
local GameDetailMoreButton = require(Modules.LuaApp.Components.GameDetails.GameDetailMoreButton)
local GameDetailsPlayWithFriendsButton = require(Modules.LuaApp.Components.GameDetails.GameDetailsPlayWithFriendsButton)
local FFlagLuaAppUnifyPlayButtonMobileEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUnifyPlayButtonMobileEdp
local FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local GetFFlagUIBloxUseFoundationButton = require(CorePackages.Workspace.Packages.SharedFlags).UIBlox.GetFFlagUIBloxUseFoundationButton
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppPlayabilityMessageUpdate = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPlayabilityMessageUpdate
local FFlagLuaAppLogExposurePlayButtonUX = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppLogExposurePlayButtonUX
local GAME_DETAILS_ACTION_BAR_HEIGHT = DiscoveryTypes.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT
local v34 = Roact.PureComponent:extend("ActionBar")

v34.defaultProps = {
	bottomPadding = 0,
	showMorePage = true
}
v34.validateProps = t.strictInterface({
	leftPadding = t.number,
	rightPadding = t.number,
	bottomPadding = t.number,
	universeId = t.string,
	referralSource = t.optional(t.string),
	experienceJoinData = t.optional(t.table),
	placeIdOverride = t.optional(t.string),
	containerRef = t.optional(t.table),
	shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else t.optional(t.boolean),
	showMorePage = t.optional(t.boolean),
	shouldShowPlayWithFriendsPolicy = t.optional(t.boolean),
	contextualMessage = t.optional(t.string),
	playabilityStatus = t.optional(t.table),
	hasUnifiedPlayButtonIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else t.optional(t.boolean),
	unifyToUIBloxIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else t.optional(t.boolean)
})

function v34.init(p1) -- line: 81
	-- upvalues: Roact (copy)
	p1.contextLabelRef = Roact.createRef()
end
function v34.willUnmount(_) -- line: 85
end
function v34.render(p3) -- line: 87
	-- upvalues: GAME_DETAILS_ACTION_BAR_HEIGHT (copy), withStyle (copy), Roact (copy), FFlagLuaAppUnifyPlayButtonMobileEdp (copy), GetFFlagUIBloxUseFoundationButton (copy), FFlagRenameDeprecatedUIBloxTokens (copy), GAME_DETAILS_ACTION_BAR_HEIGHT (copy), GameDetailMoreButton (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), GameDetailsPlayWithFriendsButton (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), PlayButtonContainer (copy), PlayButton (copy), ButtonSize (copy), FFlagLuaAppPlayabilityMessageUpdate (copy), PlayButtonContextualMessageImpressionsDetector (copy), AppPage (copy)
	local leftPadding = p3.props.leftPadding
	local rightPadding = p3.props.rightPadding
	local bottomPadding = p3.props.bottomPadding
	local universeId = p3.props.universeId
	local experienceJoinData = p3.props.experienceJoinData
	local showMorePage = p3.props.showMorePage
	local shouldShowPlayWithFriendsPolicy = p3.props.shouldShowPlayWithFriendsPolicy
	local v46 = showMorePage and GAME_DETAILS_ACTION_BAR_HEIGHT or 0
	local v47 = not showMorePage and 0 or 10
	local u48 = -v46 - v47

	if shouldShowPlayWithFriendsPolicy then
		u48 = 2 * u48
	end

	return withStyle(function(p4) -- line: 107
		-- upvalues: Roact (copy), p3 (copy), FFlagLuaAppUnifyPlayButtonMobileEdp (copy), GetFFlagUIBloxUseFoundationButton (copy), FFlagRenameDeprecatedUIBloxTokens (copy), leftPadding (copy), rightPadding (copy), bottomPadding (copy), GAME_DETAILS_ACTION_BAR_HEIGHT (copy), v47 (copy), showMorePage (copy), GameDetailMoreButton (copy), universeId (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), shouldShowPlayWithFriendsPolicy (copy), GameDetailsPlayWithFriendsButton (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), PlayButtonContainer (copy), u48 (ref), experienceJoinData (copy), PlayButton (copy), ButtonSize (copy), FFlagLuaAppPlayabilityMessageUpdate (copy), PlayButtonContextualMessageImpressionsDetector (copy), AppPage (copy)
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = 1,
			[Roact.Ref] = p3.props.containerRef
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Gradient = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/LuaApp/graphic/gradient_0_100.png",
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 40),
				ImageColor3 = p4.Theme.BackgroundDefault.Color,
				ZIndex = if not FFlagLuaAppUnifyPlayButtonMobileEdp and not GetFFlagUIBloxUseFoundationButton() then nil else 1
			}),
			ContentFrame = Roact.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = p4.Theme.BackgroundDefault.Color,
				ZIndex = if not FFlagLuaAppUnifyPlayButtonMobileEdp and not GetFFlagUIBloxUseFoundationButton() then nil else 2
			}, {
				ContentListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Global.Space_150 else p4.Tokens.Size.Size_300)
				}),
				ContentPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, leftPadding),
					PaddingRight = UDim.new(0, rightPadding),
					PaddingBottom = UDim.new(0, bottomPadding)
				}),
				ActionBar = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, GAME_DETAILS_ACTION_BAR_HEIGHT)
				}, {
					ActionListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = if not FFlagLuaAppUnifyPlayButtonMobileEdp and not GetFFlagUIBloxUseFoundationButton() then nil else Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, v47)
					}),
					MoreButton = showMorePage and Roact.createElement(GameDetailMoreButton, {
						testId = "--experience-details--more-button",
						universeId = universeId,
						leftPadding = leftPadding,
						shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p3.props.shouldHydrateLegacyIxp
					}),
					PlayWithFriendsButton = shouldShowPlayWithFriendsPolicy and Roact.createElement(GameDetailsPlayWithFriendsButton, {
						universeId = universeId,
						leftPadding = leftPadding,
						shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p3.props.shouldHydrateLegacyIxp
					}) or nil,
					PlayButtonContainer = if not FFlagLuaAppUnifyPlayButtonMobileEdp or not not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp and not p3.props.hasUnifiedPlayButtonIxp then Roact.createElement(PlayButtonContainer, {
						LayoutOrder = 4,
						testId = "--experience-details--play-button",
						Size = UDim2.new(1, u48, not GetFFlagUIBloxUseFoundationButton() and 1 or 0, not GetFFlagUIBloxUseFoundationButton() and 0 or GAME_DETAILS_ACTION_BAR_HEIGHT),
						universeId = universeId,
						referralSource = p3.props.referralSource,
						experienceJoinData = experienceJoinData,
						placeId = p3.props.placeIdOverride
					}) else nil,
					PlayButton = if not FFlagLuaAppUnifyPlayButtonMobileEdp or not not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp and not p3.props.hasUnifiedPlayButtonIxp then nil else Roact.createElement(PlayButton, {
						launchSource = "LuaGameCard",
						LayoutOrder = 4,
						testId = "--experience-details--play-button",
						universeId = universeId,
						referralSource = p3.props.referralSource,
						experienceJoinData = experienceJoinData,
						placeId = p3.props.placeIdOverride,
						buttonSize = ButtonSize.Large,
						width = UDim.new(1, u48),
						useUIBloxButton = p3.props.unifyToUIBloxIxp
					})
				}),
				ContextLabel = if not p3.props.contextualMessage then nil else Roact.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Text = p3.props.contextualMessage,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					BackgroundTransparency = 1,
					Font = if not FFlagLuaAppPlayabilityMessageUpdate then if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Semantic.Typography.CaptionHeader.Font else p4.Tokens.Typography.CaptionLarge.Font else if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Semantic.Typography.Body.Font else p4.Tokens.Typography.BodyLarge.Font,
					TextSize = if not FFlagLuaAppPlayabilityMessageUpdate then if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Semantic.Typography.CaptionHeader.FontSize else p4.Tokens.FontSize.FontSize_300 else if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Global.FontSize_75 else p4.Tokens.FontSize.FontSize_350,
					TextColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Semantic.Color.Text.Emphasis else p4.Tokens.Color.Content.Emphasis)).Color3,
					TextTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Semantic.Color.Text.Emphasis else p4.Tokens.Color.Content.Emphasis)).Transparency,
					LayoutOrder = 2,
					[Roact.Ref] = p3.contextLabelRef
				}),
				ContextLabelImpressionsDetector = if not p3.props.contextualMessage then nil else Roact.createElement(PlayButtonContextualMessageImpressionsDetector, {
					containerRef = p3.contextLabelRef,
					universeId = p3.props.universeId,
					playabilityStatus = p3.props.playabilityStatus,
					contextualMessage = p3.props.contextualMessage,
					pageContext = AppPage.GameDetail
				})
			})
		})
	end)
end

local v35 = RoactAppPolicy.connect(function(p5, _) -- line: 268
	return {
		showMorePage = p5.getGameDetailsMorePage(),
		shouldShowPlayWithFriendsPolicy = p5.getGameDetailsPlayWithFriends()
	}
end)(v34)

return function(p7) -- line: 276
	-- upvalues: useRoactService (copy), RoactNetworking (copy), usePlayButtonState (copy), usePlayButtonContextualMessage (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), useUserExperiment (copy), AppUserLayers (copy), FFlagLuaAppLogExposurePlayButtonUX (copy), React (copy), IXPService (copy), Cryo (copy), Roact (copy), v35 (copy)
	local v52 = useRoactService(RoactNetworking)
	local v53 = usePlayButtonState(v52, p7.universeId, nil)
	local v54 = usePlayButtonContextualMessage(p7.universeId, v53.playButtonState, v53.playabilityStatus)
	local v55 = nil
	local v56 = nil

	if FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v55, v56 = useUserExperiment({ AppUserLayers.PlayButtonUXExposureLayer }, function(p8) -- line: 290
			-- upvalues: AppUserLayers (copy)
			local v60 = p8[AppUserLayers.PlayButtonUXExposureLayer] or {}

			return v60.HasUnifiedPlayButton, v60.UnifyToUIBlox
		end, true)
	end

	if FFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function() -- line: 299
			-- upvalues: IXPService (copy), AppUserLayers (copy)
			IXPService:LogUserLayerExposure(AppUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	local v57 = Cryo.Dictionary.join(p7, {
		contextualMessage = v54,
		playabilityStatus = v53.playabilityStatus,
		hasUnifiedPlayButtonIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else v55,
		unifyToUIBloxIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else v56
	})

	return Roact.createElement(v35, v57)
end
