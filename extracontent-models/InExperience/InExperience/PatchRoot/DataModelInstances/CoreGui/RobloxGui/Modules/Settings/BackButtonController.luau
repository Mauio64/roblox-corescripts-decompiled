local AdService = game:GetService("AdService")
local TeleportService = game:GetService("TeleportService")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local Promise = require(CorePackages.Packages.Promise)
local Roact = require(CorePackages.Packages.Roact)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local v9 = require(RobloxGui.Modules.Common.httpRequest)(HttpRbxApiService)
local EngineFeature = game:GetEngineFeature("TeleportHistoryButtons")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GetGameNameAndDescription = require(CorePackages.Workspace.Packages.GameDetailRodux).GetGameNameAndDescription
local u13 = false
local n1 = 0
local v15, v16 = AdService:GetAdTeleportInfo()

if v15 > 0 and (v16 == 0 or v16 == game.GameId) then
	n1 = v15

	if EngineFeature then
		u13 = true
	end
end

if EngineFeature and n1 == 0 then
	local v17, _ = TeleportService:GetThirdPartyTeleportInfo(false)

	if v17 > 0 then
		n1 = v17
	end

	u13 = false
end

local function truncateWithEllipsis(p1, p2) -- line: 37
	if p2 < #p1 then
		return string.sub(p1, 1, p2 - 3) .. "..."
	end

	return p1
end

local p4Name = nil
local v21 = Promise.defer(function(p3) -- line: 46
	-- upvalues: n1 (ref), GetGameNameAndDescription (copy), v9 (copy), p4Name (ref), EngineFeature (copy)
	if n1 > 0 then
		GetGameNameAndDescription(v9, n1):andThen(function(p4) -- line: 48
			-- upvalues: p4Name (ref), EngineFeature (copy)
			p4Name = p4.Name

			if EngineFeature then
				local p4Name2 = p4.Name

				p4Name = if not (#p4Name2 > 30) then p4Name2 else string.sub(p4Name2, 1, 27) .. "..."
			end
		end):await()
		p3()

		return
	end

	p3()
end)
local t1 = {
	getTooltipText = function() -- line: 62
		-- upvalues: p4Name (ref), RobloxTranslator (copy)
		if p4Name == nil then
			return RobloxTranslator:FormatByKey("InGame.CommonUI.Label.ReturnFallback")
		end

		return RobloxTranslator:FormatByKey("InGame.CommonUI.Label.ReturnTo", {
			placeName = p4Name
		})
	end
}

function t1.getTooltipTextTimeout() -- line: 72
	-- upvalues: p4Name (ref), Promise (copy), v21 (copy), t1 (copy)
	if p4Name == nil then
		Promise.any({
			v21,
			Promise.delay(1)
		}):await()
	end

	return t1.getTooltipText()
end
function t1.getMenuText() -- line: 79
	-- upvalues: Roact (copy), t1 (copy), p4Name (ref), v21 (copy)
	local v26, v27 = Roact.createBinding(t1.getTooltipText())

	if p4Name == nil then
		pcall(function() -- line: 82
			-- upvalues: v21 (copy), v27 (copy), t1 (copy)
			v21:andThen(function() -- line: 83
				-- upvalues: v27 (copy), t1 (copy)
				v27(t1.getTooltipText())
			end)
		end)
	end

	return v26
end
function t1.initiateBackButtonTeleport(p5) -- line: 91
	-- upvalues: EngineFeature (copy), u13 (ref), AdService (copy), TeleportService (copy)
	if EngineFeature then
		if u13 then
			AdService:ReturnToPublisherExperience(p5)
		else
			TeleportService:TeleportTrustedBackForth(false)
		end
	end

	AdService:ReturnToPublisherExperience(p5)
end
function t1.hasReturnUniverse() -- line: 102
	-- upvalues: n1 (ref)
	return n1 > 0
end

return t1
