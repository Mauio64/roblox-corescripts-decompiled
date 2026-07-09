local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local safeCall = require(Modules.LuaApp.Util.safeCall)
local toStringLimited = require(Modules.LuaApp.Util.toStringLimited)
local StringReplaceAll = require(Modules.Common.StringUtilities.StringReplaceAll)
local v10 = game:DefineFastFlag("LuaAppEnableLumberyakLogBound", false)
local v11 = game:DefineFastInt("LuaAppLumberyakLogBound", 10000)
local t1 = {
	_store = nil,
	_lumberyakLog = ""
}

if v10 then
	t1._lumberyakBuffer = table.create(v11)
	t1._currentBufferIndex = 1
end

t1.addLumberyakLog = nil

local v13 = game:DefineFastString("LuaAppBacktraceLogLevel", "Info")

Logger:addSink({
	maxLevel = Logger.Levels.fromString(v13),
	log = function(_, p2, _) -- line: 37
		-- upvalues: t1 (copy)
		t1:addLumberyakLog(p2)
	end
})

function t1.connectToStore(p4, p5) -- line: 42
	-- upvalues: Rodux (copy)
	if getmetatable(p5) == Rodux.Store then
		p4._store = p5
	end
end
function t1.addLumberyakLog(p6, p7) -- line: 48
	-- upvalues: v10 (copy), v11 (copy)
	if type(p7) == "string" then
		if v10 then
			p6._lumberyakBuffer[p6._currentBufferIndex] = p7
			p6._currentBufferIndex = p6._currentBufferIndex + 1

			if p6._currentBufferIndex > v11 then
				p6._currentBufferIndex = 1

				return
			end
		else
			p6._lumberyakLog = p6._lumberyakLog .. p7 .. "\n"
		end
	end
end
function t1.generateAppLog(p8) -- line: 62
	-- upvalues: safeCall (copy), v10 (copy), toStringLimited (copy), Players (copy), StringReplaceAll (copy)
	return (safeCall(function() -- line: 63
		-- upvalues: v10 (copy), p8 (copy), toStringLimited (copy), Players (copy), StringReplaceAll (copy)
		local s1 = ""

		if v10 then
			if #p8._lumberyakBuffer > 0 then
				s1 = ((s1 .. "============ LumberYak Logs ============\n") .. table.concat(p8._lumberyakBuffer, "\n", p8._currentBufferIndex)) .. "\n" .. table.concat(p8._lumberyakBuffer, "\n", 1, p8._currentBufferIndex - 1)
			end
		elseif #p8._lumberyakLog > 0 then
			s1 = (s1 .. "============ LumberYak Logs ============\n") .. p8._lumberyakLog
		end

		if p8._store ~= nil then
			local v23 = toStringLimited(p8._store:getState(), nil, 5, function(p9) -- line: 82
				if p9 == 1 then
					return -1
				end

				return 20
			end)

			if #v23 > 0 then
				s1 = (s1 .. "============ Rodux Store ============\n") .. v23
			end
		end

		local t2 = {}
		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer ~= nil then
			if LocalPlayer.UserId and LocalPlayer.UserId > 0 then
				t2[tostring(LocalPlayer.UserId)] = "UserId"
			end

			if LocalPlayer.Name and LocalPlayer.Name ~= "" then
				t2[tostring(LocalPlayer.Name)] = "UserName"
			end
		end

		return (StringReplaceAll(s1, t2))
	end, ""))
end

return t1
