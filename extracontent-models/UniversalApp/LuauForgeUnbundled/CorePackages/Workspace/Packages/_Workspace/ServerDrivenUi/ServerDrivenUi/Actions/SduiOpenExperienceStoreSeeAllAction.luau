local IXPService = game:GetService("IXPService")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/NavigationRodux").Thunks.NavigateDown
local navigateToDevStoreSeeAll = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ExperienceStoreServerDrivenUi").navigateToDevStoreSeeAll
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Display")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Responsive")

local openSduiWebLink = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/openSduiWebLink")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local fFlagLuaAppDevStoreSeeAllSduiEnabled = SharedFlags.FFlagLuaAppDevStoreSeeAllSduiEnabled
local fFlagLuaAppDevStoreSeeAllSduiLogExposure = SharedFlags.FFlagLuaAppDevStoreSeeAllSduiLogExposure
local fStringLuaAppDevStoreSeeAllSduiIxpLayer = SharedFlags.FStringLuaAppDevStoreSeeAllSduiIxpLayer
local fFlagSduiCapabilityDevStoreSeeAllWebviewFallback = SharedFlags.FFlagSduiCapabilityDevStoreSeeAllWebviewFallback
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local function getIsCompactTouch()
	local viewportSize = Display.GetDisplayStore(false).getViewportSize(false)
	local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)
	return Responsive.getIsCompactTouch(viewportSize, preferredInputType)
end

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenExperienceStoreSeeAll,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenExperienceStoreSeeAll,
				message = `Invalid or missing universeId: {tostring(universeId)}`,
				propName = "universeId"
			},
			p4.appPage
		)
		return
	end

	if fFlagLuaAppDevStoreSeeAllSduiLogExposure then
		IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppDevStoreSeeAllSduiIxpLayer)
	end

	if fFlagLuaAppDevStoreSeeAllSduiEnabled then
		navigateToDevStoreSeeAll(p4.dependencies.getNavigation(), universeId)
		return
	end

	if fFlagSduiCapabilityDevStoreSeeAllWebviewFallback then
		local viewportSize = Display.GetDisplayStore(false).getViewportSize(false)
		local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)

		if not Responsive.getIsCompactTouch(viewportSize, preferredInputType) then
			openSduiWebLink(
				p4,
				string.format("https://www.roblox.com/games/store-section/%s", universeId),
				"Feature.GameDetails.Label.Store"
			)
			return
		end
	end

	local v5 = { name = appPage.PassesPage, detail = universeId }

	if fFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v5))
	else
		p4.dependencies.dispatch(navigateDown(v5))
	end
end
