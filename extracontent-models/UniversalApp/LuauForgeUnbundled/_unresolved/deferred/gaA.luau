local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local Localization = require("@game/CorePackages/Workspace/Packages/Localization")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local module3 = require("@luauforge/bundled/eeH")
local module4 = require("@luauforge/deferred/gaB")
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local UIBlox = require(CorePackages.Packages.UIBlox)
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module6 = require("@luauforge/bundled/dYU")
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddUniverseIdToGameDetailsEvents

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local module7 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local module8 = require("@luauforge/bundled/ftp")
local module9 = require("@luauforge/bundled/fvl")

local fFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbirdPageCloseCallback

local listTable = UIBlox.App.Table.ListTable
local module10 = require("@luauforge/deferred/gaE")
local module11 = require("@luauforge/deferred/fYY")
local module12 = require("@luauforge/deferred/fYc")

local fFlagLuaAppEdpNonSduiBuildAttribution = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpNonSduiBuildAttribution

return React.forwardRef(function(props, p2)
	local universeId = props.universeId
	local v6 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then props.shouldHydrateLegacyIxp else nil
	local v7 = module4(universeId, v6, props.hideCloseButton)

	local v8 = module3(module6)
	local v9 = useDispatch()
	local v10 = React.useCallback(function(p3)
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(p3))
		else
			v9(module7(p3))
		end
	end)

	local v11 = module3(appLinking)

	local v12 = React.useCallback(function(p3)
		v9(module8(p3))
	end, { v9 })

	local v13 = React.useCallback(function()
		v9(module9())
	end, { v9 })

	local v14 = useAppPolicy(function(p3)
		return p3.enableExperienceDetailsPanel()
	end)

	local v15 = useLocalization({
		StatsInfoTitle = "Feature.ExperienceDetails.Body.StatsInfoTitle"
	})

	local v16 = useUiModeInfo().uiMode == uiMode.TenFoot

	local v17 = useTokens()

	local medium = if not v14 then v17.Padding.Medium else nil

	local v18 = fFlagLuaAppEdpNonSduiBuildAttribution and v7.isBuildContent and not v14

	local v19 = React.createElement(listTable, {
		cells = Dash.map(v7.rows, function(props2)
			local createElement = React.createElement
			local v21 = {
				horizontalPadding = medium,
				infoName = props2.infoName,
				infoData = props2.infoData or "",
				infoIcon = props2.infoIcon,
				renderTextOverride = props2.infoDataOverride and props.renderTextOverride and function()
					return props2.infoDataOverride(props.renderTextOverride)
				end or nil,
				linkProps = 0,
				externalLinkProps = 0,
				universeId = 0,
				testId = 0
			}
			local v22

			if (props2.linkPage or props2.navigateOverride) and not v16 then
				v22 = {
					eventIngest = v8,
					rootPlaceId = v7.rootPlaceId,
					linkPage = props2.linkPage,
					linkUrl = props2.linkUrl,
					navigate = props2.navigateOverride or v10,
					analyticsSubPage = props2.analyticsSubPage,
					onClose = 0
				}
				local v23 = if fFlagEnableBlackbirdPageCloseCallback then props2.onClose else nil
				v22.onClose = v23
			end

			v21.linkProps = v22

			v21.externalLinkProps = props2.linkUrl and not v16 and {
				linkUrl = props2.linkUrl,
				openLeaveRobloxAlert = v12,
				closeAlert = v13,
				linking = v11,
				clickCallback = props2.linkClickCallback
			} or nil

			local v23 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
			v21.universeId = v23
			v21.testId = props2.testId
			return createElement(module10, v21)
		end),
		automaticSize = Enum.AutomaticSize.Y,
		dividerStartOffset = not v14 and 0 or nil,
		layoutOrder = v18 and 1 or nil
	})
	local v20

	if v18 then
		v20 = React.createElement(module12, {
			layoutOrder = 2,
			horizontalPadding = medium
		})
	end

	if v18 then
		v19 = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0)
			},
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				Table = v19,
				Disclaimer = v20
			}
		)
	end

	if v14 then
		return React.createElement(
			module11,
			{ ref = p2, title = v15.StatsInfoTitle, roundContentCorners = true },
			v19
		)
	end

	return v19
end)
