local CorePackages = game:GetService("CorePackages")

local Players = game:GetService("Players")

local Rodux = require(CorePackages.Packages.Rodux)

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module = require("@luauforge/bundled/vN")
local toString = require("@game/CorePackages/Packages/_Index/tutils/tutils/toString")

local module3 = require("@luauforge/bundled/vP")

local defineFastFlag = game:DefineFastFlag("LuaAppEnableLumberyakLogBound", false)
local defineFastInt = game:DefineFastInt("LuaAppLumberyakLogBound", 10000)

local v5 = {}
v5._store = nil
v5._lumberyakLog = ""

if defineFastFlag then
	v5._lumberyakBuffer = table.create(defineFastInt)
	v5._currentBufferIndex = 1
end

v5.addLumberyakLog = nil

local defineFastString = game:DefineFastString("LuaAppBacktraceLogLevel", "Info")
logger:addSink({
	maxLevel = logger.Levels.fromString(defineFastString),
	log = function(p2, p3, p4)
		v5:addLumberyakLog(p3)
	end
})

function v5:connectToStore(store)
	if getmetatable(store) == Rodux.Store then
		self._store = store
	end
end

function v5:addLumberyakLog(value)
	if type(value) == "string" then
		if defineFastFlag then
			self._lumberyakBuffer[self._currentBufferIndex] = value
			self._currentBufferIndex += 1

			if defineFastInt < self._currentBufferIndex then
				self._currentBufferIndex = 1
			end
		else
			self._lumberyakLog ..= value .. "\n"
		end
	end
end

function v5:generateAppLog()
	return (module(function()
		local v6 = ""

		if defineFastFlag then
			if #self._lumberyakBuffer > 0 then
				v6 = ((v6 .. "============ LumberYak Logs ============\n") .. table.concat(
					self._lumberyakBuffer,
					"\n",
					self._currentBufferIndex
				)) .. "\n" .. table.concat(self._lumberyakBuffer, "\n", 1, self._currentBufferIndex - 1)
			end
		elseif #self._lumberyakLog > 0 then
			v6 = (v6 .. "============ LumberYak Logs ============\n") .. self._lumberyakLog
		end

		if self._store ~= nil then
			local v7 = toString(self._store:getState(), nil, 5, function(p2): number
				if p2 == 1 then
					return -1
				end

				return 20
			end)

			if #v7 > 0 then
				v6 = (v6 .. "============ Rodux Store ============\n") .. v7
			end
		end

		local v7 = {}
		local localPlayer = Players.LocalPlayer

		if localPlayer ~= nil then
			if localPlayer.UserId and localPlayer.UserId > 0 then
				v7[tostring(localPlayer.UserId)] = "UserId"
			end

			if localPlayer.Name and localPlayer.Name ~= "" then
				v7[tostring(localPlayer.Name)] = "UserName"
			end
		end

		return (module3(v6, v7))
	end, ""))
end

return v5
