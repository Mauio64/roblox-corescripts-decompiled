local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local console = require(script.Parent.console)

local v = 0
local log = nil
local info = nil
local Warn = nil
local err = nil
local group = nil
local groupCollapsed = nil
local groupEnd = nil

local function fn() end

local Roblox = {}
Roblox.disabledLog = fn

function Roblox.disableLogs()
	if ReactGlobals.__DEV__ then
		if v == 0 then
			log = console.log
			info = console.info
			Warn = console.warn
			err = console.error
			group = console.group
			groupCollapsed = console.groupCollapsed
			groupEnd = console.groupEnd

			console.info = fn
			console.log = fn
			console.warn = fn
			console.error = fn
			console.group = fn
			console.groupCollapsed = fn
			console.groupEnd = fn
		end

		v += 1
	end
end

function Roblox.reenableLogs()
	if ReactGlobals.__DEV__ then
		v -= 1

		if v == 0 then
			console.log = log
			console.info = info
			console.warn = Warn
			console.error = err
			console.group = group
			console.groupCollapsed = groupCollapsed
			console.groupEnd = groupEnd
		end

		if v < 0 then
			console.error("disabledDepth fell below zero. This is a bug in React. Please file an issue.")
		end
	end
end

return Roblox
