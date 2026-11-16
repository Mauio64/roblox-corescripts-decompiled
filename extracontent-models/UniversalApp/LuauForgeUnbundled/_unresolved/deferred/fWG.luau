local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local module = require("@luauforge/bundled/fWH")
local legacyPlayButtonContainer = module.LegacyPlayButtonContainer
local playButton = module.PlayButton
local usePlayButtonState = module.usePlayButtonState
local usePlayButtonContextualMessage = module.usePlayButtonContextualMessage
local playButtonContextualMessageImpressionsDetector = module.PlayButtonContextualMessageImpressionsDetector
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local Foundation = require(CorePackages.Packages.Foundation)

local buttonSize = Foundation.Enums.ButtonSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local module2 = require("@luauforge/bundled/cyO")
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment

local module3 = require("@luauforge/deferred/fWI")
local module4 = require("@luauforge/deferred/fWK")
local module5 = require("@luauforge/deferred/fWY")

local fFlagLuaAppUnifyPlayButtonMobileEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUnifyPlayButtonMobileEdp

local fFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUnifyPlayButtonAllSurfacesIxp

local getFFlagUIBloxUseFoundationButton = require("@game/CorePackages/Workspace/Packages/SharedFlags").UIBlox.GetFFlagUIBloxUseFoundationButton

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppLogExposurePlayButtonUX = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppLogExposurePlayButtonUX

local fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP

local GAME_DETAILS_ACTION_BAR_HEIGHT = module2.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT

local extended = Roact.PureComponent:extend("ActionBar")

extended.defaultProps = { bottomPadding = 0, showMorePage = true }

local strictInterface = t.strictInterface
local v5 = {
	leftPadding = t.number,
	rightPadding = t.number,
	bottomPadding = t.number,
	universeId = t.string,
	referralSource = t.optional(t.string),
	experienceJoinData = t.optional(t.table),
	placeIdOverride = t.optional(t.string),
	containerRef = t.optional(t.table),
	shouldHydrateLegacyIxp = 0,
	playButtonExperimentalContainer = 0,
	playButtonExperimentalView = 0,
	showMorePage = 0,
	shouldShowPlayWithFriendsPolicy = 0,
	contextualMessage = 0,
	playabilityStatus = 0,
	hasUnifiedPlayButtonIxp = 0,
	unifyToUIBloxIxp = 0
}
local v6 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then t.optional(t.boolean) else nil
v5.shouldHydrateLegacyIxp = v6

local v7 = if fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP then t.optional(t.string) else nil
v5.playButtonExperimentalContainer = v7

local v8 = if fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP then t.optional(t.string) else nil
v5.playButtonExperimentalView = v8

v5.showMorePage = t.optional(t.boolean)
v5.shouldShowPlayWithFriendsPolicy = t.optional(t.boolean)

v5.contextualMessage = t.optional(t.string)
v5.playabilityStatus = t.optional(t.table)
local v9 = if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then t.optional(t.boolean) else nil
v5.hasUnifiedPlayButtonIxp = v9
local v10 = if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then t.optional(t.boolean) else nil
v5.unifyToUIBloxIxp = v10
extended.validateProps = strictInterface(v5)

function extended:init()
	self.contextLabelRef = Roact.createRef()
end

function extended.willUnmount(p2) end

function extended.render(p2)
	local leftPadding = p2.props.leftPadding
	local rightPadding = p2.props.rightPadding
	local bottomPadding = p2.props.bottomPadding
	local universeId = p2.props.universeId
	local experienceJoinData = p2.props.experienceJoinData
	local showMorePage = p2.props.showMorePage

	local shouldShowPlayWithFriendsPolicy = p2.props.shouldShowPlayWithFriendsPolicy
	local v11 = showMorePage and 10 or 0
	local v12 = -(showMorePage and GAME_DETAILS_ACTION_BAR_HEIGHT or 0) - v11

	if shouldShowPlayWithFriendsPolicy then
		v12 = 2 * v12
	end

	local v13

	if
		fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP
		and p2.props.playButtonExperimentalContainer == "moduleLegacy"
	then
		v13 = legacyPlayButtonContainer
	else
		v13 = module3
	end

	local v14 = fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP
		and p2.props.playButtonExperimentalContainer == "unified"
		and true
		or fFlagLuaAppUnifyPlayButtonMobileEdp
		and (not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp or p2.props.hasUnifiedPlayButtonIxp)

	return withStyle(function(p3)
		local createElement = Roact.createElement
		local containerRefsByRef = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = 1,
			[Roact.Ref] = p2.props.containerRef
		}
		local v16 = {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Gradient = Roact.createElement("ImageLabel", {
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/LuaApp/graphic/gradient_0_100.png",
				ImageColor3 = p3.Theme.BackgroundDefault.Color,
				LayoutOrder = 1,
				ZIndex = (fFlagLuaAppUnifyPlayButtonMobileEdp or getFFlagUIBloxUseFoundationButton()) and 1 or nil
			}),
			ContentFrame = 0
		}

		local createElement2 = Roact.createElement
		local v18 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ZIndex = (fFlagLuaAppUnifyPlayButtonMobileEdp or getFFlagUIBloxUseFoundationButton()) and 2 or nil
		}
		local v19 = {
			ContentListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, p3.Tokens.Size.Size_300)
			}),
			ContentPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, leftPadding),
				PaddingRight = UDim.new(0, rightPadding),
				PaddingBottom = UDim.new(0, bottomPadding)
			}),
			ActionBar = 0,
			ContextLabel = 0,
			ContextLabelImpressionsDetector = 0
		}

		local createElement3 = Roact.createElement
		local v21 = {
			Size = UDim2.new(1, 0, 0, GAME_DETAILS_ACTION_BAR_HEIGHT),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local createElement4 = Roact.createElement
		local v24 = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = 0,
			SortOrder = 0,
			Padding = 0
		}

		local v25 = if fFlagLuaAppUnifyPlayButtonMobileEdp or getFFlagUIBloxUseFoundationButton() then Enum.VerticalAlignment.Center else nil
		v24.VerticalAlignment = v25

		v24.SortOrder = Enum.SortOrder.LayoutOrder
		v24.Padding = UDim.new(0, v11)
		local v22 = {
			ActionListLayout = createElement4("UIListLayout", v24),
			MoreButton = 0,
			PlayWithFriendsButton = 0,
			PlayButtonContainer = 0,
			PlayButton = 0
		}

		local v26 = showMorePage

		if v26 then
			local createElement5 = Roact.createElement
			local v28 = {
				universeId = universeId,
				leftPadding = leftPadding,
				shouldHydrateLegacyIxp = 0,
				testId = "--experience-details--more-button"
			}

			local v29 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p2.props.shouldHydrateLegacyIxp else nil
			v28.shouldHydrateLegacyIxp = v29
			v26 = createElement5(module4, v28)
		end

		v22.MoreButton = v26
		local v27

		if shouldShowPlayWithFriendsPolicy then
			local createElement5 = Roact.createElement
			local v29 = {
				universeId = universeId,
				leftPadding = leftPadding,
				shouldHydrateLegacyIxp = 0
			}

			local v30 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p2.props.shouldHydrateLegacyIxp else nil
			v29.shouldHydrateLegacyIxp = v30
			v27 = createElement5(module5, v29) or nil
		end

		v22.PlayWithFriendsButton = v27
		local v28

		if not v14 then
			local createElement5 = Roact.createElement
			local v30 = {
				Size = UDim2.new(
					1,
					v12,
					getFFlagUIBloxUseFoundationButton() and 0 or 1,
					not getFFlagUIBloxUseFoundationButton() and 0 or GAME_DETAILS_ACTION_BAR_HEIGHT
				),
				LayoutOrder = 4,
				universeId = universeId,
				referralSource = p2.props.referralSource,
				experienceJoinData = experienceJoinData,
				placeId = p2.props.placeIdOverride,
				testId = "--experience-details--play-button",
				shouldUseUnifiedPlayButtonView = 0
			}

			local v31 = if fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP then p2.props.playButtonExperimentalView == "unified" else nil
			v30.shouldUseUnifiedPlayButtonView = v31
			v28 = createElement5(v13, v30)
		end

		v22.PlayButtonContainer = v28
		local v29

		if v14 then
			local createElement5 = Roact.createElement
			local v31 = {
				universeId = universeId,
				referralSource = p2.props.referralSource,
				launchSource = "LuaGameCard",
				experienceJoinData = experienceJoinData,
				placeId = p2.props.placeIdOverride,
				buttonSize = buttonSize.Large,
				width = UDim.new(1, v12),
				useUIBloxButton = fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP and p2.props.playButtonExperimentalView == "unified" and true or p2.props.unifyToUIBloxIxp,
				shouldUseModuleLegacyPlayButtonView = 0,
				LayoutOrder = 4,
				testId = "--experience-details--play-button"
			}

			local v32 = if fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP then p2.props.playButtonExperimentalView == "moduleLegacy" else nil
			v31.shouldUseModuleLegacyPlayButtonView = v32
			v29 = createElement5(playButton, v31)
		end

		v22.PlayButton = v29
		v19.ActionBar = createElement3("Frame", v21, v22)
		local v30

		if p2.props.contextualMessage then
			local createElement5 = Roact.createElement
			local contextLabelRefsByRef = {}
			contextLabelRefsByRef.Size = UDim2.new(1, 0, 0, 0)
			contextLabelRefsByRef.AutomaticSize = Enum.AutomaticSize.Y
			contextLabelRefsByRef.Text = p2.props.contextualMessage
			contextLabelRefsByRef.TextXAlignment = Enum.TextXAlignment.Left
			contextLabelRefsByRef.TextWrapped = true
			contextLabelRefsByRef.BackgroundTransparency = 1
			local v32 = if not foundationFontFaceMigration then p3.Tokens.Typography.BodyLarge.Font else nil
			contextLabelRefsByRef.Font = v32

			local v33 = if foundationFontFaceMigration then normalizeFontFace(p3.Tokens.Typography.BodyLarge.Font) else nil
			contextLabelRefsByRef.FontFace = v33

			contextLabelRefsByRef.TextSize = p3.Tokens.FontSize.FontSize_350
			contextLabelRefsByRef.TextColor3 = p3.Tokens.Color.Content.Emphasis.Color3
			contextLabelRefsByRef.TextTransparency = p3.Tokens.Color.Content.Emphasis.Transparency
			contextLabelRefsByRef.LayoutOrder = 2
			contextLabelRefsByRef[Roact.Ref] = p2.contextLabelRef
			v30 = createElement5("TextLabel", contextLabelRefsByRef)
		end

		v19.ContextLabel = v30

		local v31 = if p2.props.contextualMessage then Roact.createElement(
			playButtonContextualMessageImpressionsDetector,
			{
				containerRef = p2.contextLabelRef,
				universeId = p2.props.universeId,
				playabilityStatus = p2.props.playabilityStatus,
				contextualMessage = p2.props.contextualMessage,
				pageContext = appPage.GameDetail
			}
		) else nil
		v19.ContextLabelImpressionsDetector = v31
		v16.ContentFrame = createElement2("Frame", v18, v19)
		return createElement("Frame", containerRefsByRef, v16)
	end)
end

local v11 = roactAppPolicy.connect(function(p2, p3)
	return {
		showMorePage = p2.getGameDetailsMorePage(),
		shouldShowPlayWithFriendsPolicy = p2.getGameDetailsPlayWithFriends()
	}
end)(extended)

return function(p2)
	local v13 = usePlayButtonState(useRoactService(roactNetworking), p2.universeId, nil)

	local v14 = usePlayButtonContextualMessage(p2.universeId, v13.playButtonState, v13.playabilityStatus)
	local v15, v16

	if fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP then
		v15, v16 = useUserExperiment({ appUserLayers.ExperienceDetailsPageExposureLayer }, function(p3)
			local v17 = p3[appUserLayers.ExperienceDetailsPageExposureLayer] or {}
			return v17.playButtonExperimentalContainer, v17.playButtonExperimentalView
		end, true)
	end

	local v17, v18

	if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v17, v18 = useUserExperiment({ appUserLayers.PlayButtonUXExposureLayer }, function(p3)
			local v19 = p3[appUserLayers.PlayButtonUXExposureLayer] or {}
			return v19.HasUnifiedPlayButton, v19.UnifyToUIBlox
		end, true)
	end

	if fFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function()
			IXPService:LogUserLayerExposure(appUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	local join = Cryo.Dictionary.join
	local v19 = {
		contextualMessage = v14,
		playabilityStatus = v13.playabilityStatus,
		hasUnifiedPlayButtonIxp = 0,
		unifyToUIBloxIxp = 0,
		playButtonExperimentalContainer = 0,
		playButtonExperimentalView = 0
	}

	if not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v17 = nil
	end

	v19.hasUnifiedPlayButtonIxp = v17

	if not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v18 = nil
	end

	v19.unifyToUIBloxIxp = v18

	if not fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP then
		v15 = nil
	end

	v19.playButtonExperimentalContainer = v15

	if not fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP then
		v16 = nil
	end

	v19.playButtonExperimentalView = v16
	local v20 = join(p2, v19)

	return Roact.createElement(v11, v20)
end
