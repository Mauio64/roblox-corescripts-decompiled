local IXPService = game:GetService("IXPService")

local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local ExperienceStoreServerDrivenUi = require(parent.ExperienceStoreServerDrivenUi)
local navigateToDevStoreSeeAll = ExperienceStoreServerDrivenUi.navigateToDevStoreSeeAll
local Display = require(parent.Display)
local Responsive = require(parent.Responsive)

local openSduiWebLink = require(ServerDrivenUi.Actions.openSduiWebLink)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDevStoreSeeAllSduiEnabled = SharedFlags.FFlagLuaAppDevStoreSeeAllSduiEnabled
local FFlagLuaAppDevStoreSeeAllSduiLogExposure = SharedFlags.FFlagLuaAppDevStoreSeeAllSduiLogExposure
local FStringLuaAppDevStoreSeeAllSduiIxpLayer = SharedFlags.FStringLuaAppDevStoreSeeAllSduiIxpLayer
local FFlagSduiCapabilityDevStoreSeeAllWebviewFallback = SharedFlags.FFlagSduiCapabilityDevStoreSeeAllWebviewFallback
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function getIsCompactTouch() -- 1 equivalent call inferred from this helper
	local viewportSize = Display.GetDisplayStore(false).getViewportSize(false)
	local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)
	return Responsive.getIsCompactTouch(viewportSize, preferredInputType)
end

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenExperienceStoreSeeAll, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenExperienceStoreSeeAll,
				message = `Invalid or missing universeId: {tostring(universeId)}`,
				propName = "universeId"
			},
			p2.appPage
		)
		return
	end

	if FFlagLuaAppDevStoreSeeAllSduiLogExposure then
		IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppDevStoreSeeAllSduiIxpLayer)
	end

	if FFlagLuaAppDevStoreSeeAllSduiEnabled then
		navigateToDevStoreSeeAll(p2.dependencies.getNavigation(), universeId)
		return
	end

	if FFlagSduiCapabilityDevStoreSeeAllWebviewFallback and not getIsCompactTouch() then -- inferred equivalent call
		openSduiWebLink(
			p2,
			string.format("https://www.roblox.com/games/store-section/%s", universeId),
			"Feature.GameDetails.Label.Store"
		)
		return
	end

	local v = { name = AppPage.PassesPage, detail = universeId }

	if FFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v))
	else
		p2.dependencies.dispatch(NavigateDown(v))
	end
end
