local TeleportService = game:GetService("TeleportService")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local Promise = require(CorePackages.Packages.Promise)
local Roact = require(CorePackages.Packages.Roact)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local v8 = require(RobloxGui.Modules.Common.httpRequest)(HttpRbxApiService)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GetGameNameAndDescription = require(CorePackages.Workspace.Packages.GameDetailRodux).GetGameNameAndDescription
local EngineFeature = game:GetEngineFeature("TeleportHistoryButtons")
local n1 = 0
local n2 = 0

if EngineFeature then
	local v14

	n2, v14 = TeleportService:GetThirdPartyTeleportInfo(true)
end

if EngineFeature and n2 > 0 then
	n1 = n2
end

local function truncateWithEllipsis(p1, p2) -- line: 30
	if p2 < #p1 then
		return string.sub(p1, 1, p2 - 3) .. "..."
	end

	return p1
end

local u16 = nil
local v17 = Promise.defer(function(p3) -- line: 39
	-- upvalues: n1 (ref), GetGameNameAndDescription (copy), v8 (copy), u16 (ref)
	if n1 > 0 then
		GetGameNameAndDescription(v8, n1):andThen(function(p4) -- line: 41
			-- upvalues: u16 (ref)
			local p4Name = p4.Name

			u16 = if not (#p4Name > 30) then p4Name else string.sub(p4Name, 1, 27) .. "..."
		end):await()
		p3()

		return
	end

	p3()
end)
local t1 = {
	getTooltipText = function() -- line: 51
		-- upvalues: u16 (ref), RobloxTranslator (copy)
		if u16 == nil then
			return RobloxTranslator:FormatByKey("InGame.CommonUI.Label.ReturnFallback")
		end

		return RobloxTranslator:FormatByKey("InGame.CommonUI.Label.ReturnTo", {
			placeName = u16
		})
	end
}

function t1.getTooltipTextTimeout() -- line: 61
	-- upvalues: u16 (ref), Promise (copy), v17 (copy), t1 (copy)
	if u16 == nil then
		Promise.any({
			v17,
			Promise.delay(1)
		}):await()
	end

	return t1.getTooltipText()
end
function t1.getMenuText() -- line: 67
	-- upvalues: Roact (copy), t1 (copy), u16 (ref), v17 (copy)
	local v22, v23 = Roact.createBinding(t1.getTooltipText())

	if u16 == nil then
		pcall(function() -- line: 70
			-- upvalues: v17 (copy), v23 (copy), t1 (copy)
			v17:andThen(function() -- line: 71
				-- upvalues: v23 (copy), t1 (copy)
				v23(t1.getTooltipText())
			end)
		end)
	end

	return v22
end
function t1.initiateFrontButtonTeleport() -- line: 78
	-- upvalues: EngineFeature (copy), TeleportService (copy)
	if EngineFeature then
		TeleportService:TeleportTrustedBackForth(true)
	end
end
function t1.hasReturnUniverse() -- line: 83
	-- upvalues: n1 (ref)
	return n1 > 0
end

return t1
