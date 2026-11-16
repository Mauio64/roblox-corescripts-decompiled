local AdService = game:GetService("AdService")
local TeleportService = game:GetService("TeleportService")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local Promise = require(CorePackages.Packages.Promise)
local Roact = require(CorePackages.Packages.Roact)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local httpRequest = require(RobloxGui.Modules.Common.httpRequest)
local v = httpRequest(HttpRbxApiService)

local engineFeature = game:GetEngineFeature("TeleportHistoryButtons")

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GameDetailRodux = require(CorePackages.Workspace.Packages.GameDetailRodux)
local GetGameNameAndDescription = GameDetailRodux.GetGameNameAndDescription
local flag = false

local v2, v3 = AdService:GetAdTeleportInfo()

if v2 > 0 and (v3 == 0 or v3 == game.GameId) then
	if engineFeature then
		flag = true
	end
else
	v2 = 0
end

if engineFeature and v2 == 0 then
	local thirdPartyTeleportInfo, _ = TeleportService:GetThirdPartyTeleportInfo(false)

	if thirdPartyTeleportInfo > 0 then
		v2 = thirdPartyTeleportInfo
	end

	flag = false
end

local function truncateWithEllipsis(value, p)
	if p < #value then
		return string.sub(value, 1, p - 3) .. "..."
	end

	return value
end

local placeName = nil
local v4 = Promise.defer(function(callback)
	if v2 > 0 then
		GetGameNameAndDescription(v, v2):andThen(function(p)
			placeName = p.Name

			if engineFeature then
				local v4 = p.Name

				if #v4 > 30 then
					v4 = string.sub(v4, 1, 27) .. "..."
				end

				placeName = v4
			end
		end):await()
	end

	callback()
end)

local BackButtonController = {}

function BackButtonController.getTooltipText()
	if placeName == nil then
		return RobloxTranslator:FormatByKey("InGame.CommonUI.Label.ReturnFallback")
	end

	return RobloxTranslator:FormatByKey("InGame.CommonUI.Label.ReturnTo", { placeName = placeName })
end

function BackButtonController.getTooltipTextTimeout()
	if placeName == nil then
		Promise.any({ v4, Promise.delay(1) }):await()
	end

	return BackButtonController.getTooltipText()
end

function BackButtonController.getMenuText()
	local binding, v5 = Roact.createBinding(BackButtonController.getTooltipText())

	if placeName == nil then
		pcall(function()
			v4:andThen(function()
				v5(BackButtonController.getTooltipText())
			end)
		end)
	end

	return binding
end

function BackButtonController.initiateBackButtonTeleport(p)
	if engineFeature then
		if flag then
			AdService:ReturnToPublisherExperience(p)
		else
			TeleportService:TeleportTrustedBackForth(false)
		end
	end

	AdService:ReturnToPublisherExperience(p)
end

function BackButtonController.hasReturnUniverse(): boolean
	return v2 > 0
end

return BackButtonController
