local TeleportService = game:GetService("TeleportService")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local Promise = require(CorePackages.Packages.Promise)
local Roact = require(CorePackages.Packages.Roact)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local httpRequest = require(RobloxGui.Modules.Common.httpRequest)
local v = httpRequest(HttpRbxApiService)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GameDetailRodux = require(CorePackages.Workspace.Packages.GameDetailRodux)
local GetGameNameAndDescription = GameDetailRodux.GetGameNameAndDescription
local engineFeature = game:GetEngineFeature("TeleportHistoryButtons")

local v2 = 0
local v3

if engineFeature then
	local _
	v3, _ = TeleportService:GetThirdPartyTeleportInfo(true)
else
	v3 = 0
end

if engineFeature and v3 > 0 then
	v2 = v3
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
			local v4 = p.Name

			if #v4 > 30 then
				v4 = string.sub(v4, 1, 27) .. "..."
			end

			placeName = v4
		end):await()
	end

	callback()
end)

local FrontButtonController = {}
function FrontButtonController.getTooltipText()
	if placeName == nil then
		return RobloxTranslator:FormatByKey("InGame.CommonUI.Label.ReturnFallback")
	end

	return RobloxTranslator:FormatByKey("InGame.CommonUI.Label.ReturnTo", { placeName = placeName })
end

function FrontButtonController.getTooltipTextTimeout()
	if placeName == nil then
		Promise.any({ v4, Promise.delay(1) }):await()
	end

	return FrontButtonController.getTooltipText()
end

function FrontButtonController.getMenuText()
	local binding, v5 = Roact.createBinding(FrontButtonController.getTooltipText())

	if placeName == nil then
		pcall(function()
			v4:andThen(function()
				v5(FrontButtonController.getTooltipText())
			end)
		end)
	end

	return binding
end

function FrontButtonController.initiateFrontButtonTeleport()
	if engineFeature then
		TeleportService:TeleportTrustedBackForth(true)
	end
end
function FrontButtonController.hasReturnUniverse(): boolean
	return v2 > 0
end

return FrontButtonController
