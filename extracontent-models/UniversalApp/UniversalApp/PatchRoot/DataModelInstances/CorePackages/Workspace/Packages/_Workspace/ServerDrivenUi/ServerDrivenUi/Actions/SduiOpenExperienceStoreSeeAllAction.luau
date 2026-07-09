local IXPService = game:GetService("IXPService")
local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local AppPage = require(ServerDrivenUiParent.RobloxAppEnums).AppPage
local NavigateDown = require(ServerDrivenUiParent.NavigationRodux).Thunks.NavigateDown
local navigateToDevStoreSeeAll = require(ServerDrivenUiParent.DevStore).navigateToDevStoreSeeAll
local Display = require(ServerDrivenUiParent.Display)
local Responsive = require(ServerDrivenUiParent.Responsive)
local openSduiWebLink = require(ServerDrivenUi.Actions.openSduiWebLink)
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SharedFlags = require(ServerDrivenUiParent.SharedFlags)
local FFlagLuaAppDevStoreSeeAllSduiEnabled = SharedFlags.FFlagLuaAppDevStoreSeeAllSduiEnabled
local FFlagLuaAppDevStoreSeeAllSduiLogExposure = SharedFlags.FFlagLuaAppDevStoreSeeAllSduiLogExposure
local FStringLuaAppDevStoreSeeAllSduiIxpLayer = SharedFlags.FStringLuaAppDevStoreSeeAllSduiIxpLayer
local FFlagSduiCapabilityDevStoreSeeAllWebviewFallback = SharedFlags.FFlagSduiCapabilityDevStoreSeeAllWebviewFallback
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v19 = if not FFlagSignalsNavP3Dispatch then nil else require(ServerDrivenUiParent.RobloxAppNavigation).NavigationCommands

local function getIsCompactTouch() -- line: 38
	-- upvalues: Display (copy), Responsive (copy)
	local v21 = Display.GetDisplayStore(false).getViewportSize(false)
	local v22 = Responsive.GetInputModeStore(false).getPreferredInputType(false)

	return Responsive.getIsCompactTouch(v21, v22)
end

return function(p1, _, p3, _) -- line: 51
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), FFlagLuaAppDevStoreSeeAllSduiLogExposure (copy), IXPService (copy), FStringLuaAppDevStoreSeeAllSduiIxpLayer (copy), FFlagLuaAppDevStoreSeeAllSduiEnabled (copy), navigateToDevStoreSeeAll (copy), FFlagSduiCapabilityDevStoreSeeAllWebviewFallback (copy), Display (copy), Responsive (copy), openSduiWebLink (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateDown (copy)
	local v27 = p1 and p1.actionParams or nil

	if v27 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenExperienceStoreSeeAll
		}, p3.appPage)

		return
	end

	local universeId = v27.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "universeId",
			name = SduiActionType.OpenExperienceStoreSeeAll,
			message = `Invalid or missing universeId: { tostring(universeId) }`
		}, p3.appPage)

		return
	end

	if FFlagLuaAppDevStoreSeeAllSduiLogExposure then
		IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppDevStoreSeeAllSduiIxpLayer)
	end

	if FFlagLuaAppDevStoreSeeAllSduiEnabled then
		navigateToDevStoreSeeAll(p3.dependencies.getNavigation(), universeId)

		return
	end

	if FFlagSduiCapabilityDevStoreSeeAllWebviewFallback then
		local v29 = Display.GetDisplayStore(false).getViewportSize(false)
		local v30 = Responsive.GetInputModeStore(false).getPreferredInputType(false)

		if not Responsive.getIsCompactTouch(v29, v30) then
			openSduiWebLink(p3, string.format("https://www.roblox.com/games/store-section/%s", universeId), "Feature.GameDetails.Label.Store")

			return
		end
	end

	local t1 = {
		name = AppPage.PassesPage,
		detail = universeId
	}

	if FFlagSignalsNavP3Dispatch then
		v19.down(v19.fromLegacyPage(t1))

		return
	end

	p3.dependencies.dispatch(NavigateDown(t1))
end
