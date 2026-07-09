local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useExperienceInfoData = require(Modules.LuaApp.Components.ExperienceDetails.Hooks.useExperienceInfoData)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local UIBlox = require(CorePackages.Packages.UIBlox)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddUniverseIdToGameDetailsEvents
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v22 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local FFlagEnableBlackbirdPageCloseCallback = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdPageCloseCallback
local ListTable = UIBlox.App.Table.ListTable
local ExperienceInfoTableRow = require(script.Parent.ExperienceInfoTableRow)
local ExperienceDetailsPanel = require(script.Parent.ExperienceDetailsPanel)

return React.forwardRef(function(t1: {[any]: any}, p1) -- line: 51
	-- upvalues: useExperienceInfoData (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), useRoactService (copy), AppEventIngestService (copy), useDispatch (copy), React (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateDown (copy), AppLinking (copy), OpenCentralOverlayForLeaveRobloxAlert (copy), CloseCentralOverlay (copy), useAppPolicy (copy), useLocalization (copy), useUiModeInfo (copy), UiMode (copy), useTokens (copy), ListTable (copy), Dash (copy), ExperienceInfoTableRow (copy), FFlagEnableBlackbirdPageCloseCallback (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), ExperienceDetailsPanel (copy)
	local v31 = useExperienceInfoData(t1.universeId, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else t1.shouldHydrateLegacyIxp, t1.hideCloseButton)
	local v32 = useRoactService(AppEventIngestService)
	local v33 = useDispatch()
	local v34 = React.useCallback(function(p2) -- line: 59
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v22 (copy), v33 (copy), NavigateDown (copy)
		if FFlagSignalsNavP3Dispatch then
			v22.down(v22.fromLegacyPage(p2))

			return
		end

		v33(NavigateDown(p2))
	end)
	local v35 = useRoactService(AppLinking)
	local v36 = React.useCallback(function(p3) -- line: 69
		-- upvalues: v33 (copy), OpenCentralOverlayForLeaveRobloxAlert (copy)
		v33(OpenCentralOverlayForLeaveRobloxAlert(p3))
	end, { v33 })
	local v37 = React.useCallback(function() -- line: 73
		-- upvalues: v33 (copy), CloseCentralOverlay (copy)
		v33(CloseCentralOverlay())
	end, { v33 })
	local v38 = useAppPolicy(function(p4) -- line: 77
		return p4.enableExperienceDetailsPanel()
	end)
	local v39 = useLocalization({
		StatsInfoTitle = "Feature.ExperienceDetails.Body.StatsInfoTitle"
	})
	local v40 = useUiModeInfo().uiMode == UiMode.TenFoot
	local v41 = useTokens()
	local v42 = React.createElement(ListTable, {
		cells = Dash.map(v31.rows, function(p5) -- line: 91
			-- upvalues: React (copy), ExperienceInfoTableRow (copy), v38 (copy), v41 (copy), t1 (copy), v40 (copy), v32 (copy), v31 (copy), v34 (copy), FFlagEnableBlackbirdPageCloseCallback (copy), v36 (copy), v37 (copy), v35 (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy)
			return React.createElement(ExperienceInfoTableRow, {
				horizontalPadding = if v38 then nil else v41.Padding.Medium,
				infoName = p5.infoName,
				infoData = p5.infoData or "",
				infoIcon = p5.infoIcon,
				renderTextOverride = if not p5.infoDataOverride or not t1.renderTextOverride then nil else function() -- line: 98
					-- upvalues: p5 (copy), t1 (copy)
					return p5.infoDataOverride(t1.renderTextOverride)
				end,
				linkProps = if not p5.linkPage and not p5.navigateOverride or v40 then nil else {
					eventIngest = v32,
					rootPlaceId = v31.rootPlaceId,
					linkPage = p5.linkPage,
					linkUrl = p5.linkUrl,
					navigate = p5.navigateOverride or v34,
					analyticsSubPage = p5.analyticsSubPage,
					onClose = if not FFlagEnableBlackbirdPageCloseCallback then nil else p5.onClose
				},
				externalLinkProps = if not p5.linkUrl or v40 then nil else {
					linkUrl = p5.linkUrl,
					openLeaveRobloxAlert = v36,
					closeAlert = v37,
					linking = v35,
					clickCallback = p5.linkClickCallback
				},
				universeId = if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId,
				testId = p5.testId
			})
		end),
		automaticSize = Enum.AutomaticSize.Y,
		dividerStartOffset = if v38 then nil else 0
	})

	if v38 then
		return React.createElement(ExperienceDetailsPanel, {
			roundContentCorners = true,
			ref = p1,
			title = v39.StatsInfoTitle
		}, v42)
	end

	return v42
end)
