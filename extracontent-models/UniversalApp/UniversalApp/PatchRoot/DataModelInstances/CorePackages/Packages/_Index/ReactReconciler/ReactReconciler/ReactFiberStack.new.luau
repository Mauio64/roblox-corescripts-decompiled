local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console

require(script.Parent.ReactInternalTypes)

local v = {}

local v2 = {}

local v3 = ReactGlobals.__DEV__ and {} or nil

local v4 = 0
local New = {}

function New.createCursor(current)
	return { current = current }
end

function New.isEmpty(): boolean
	return v4 == 0
end

function New.pop(p, p2)
	if v4 < 1 then
		if ReactGlobals.__DEV__ then
			console.error("Unexpected pop.")
		end
	else
		if ReactGlobals.__DEV__ and p2 ~= v3[v4] then
			console.error("Unexpected Fiber popped.")
		end

		local current = v2[v4]

		if current == v then
			p.current = nil
		else
			p.current = current
		end

		v2[v4] = nil

		if ReactGlobals.__DEV__ then
			v3[v4] = nil
		end

		v4 -= 1
	end
end

function New.push(p, current, p2)
	v4 += 1

	local current2 = p.current

	if current2 == nil then
		v2[v4] = v
	else
		v2[v4] = current2
	end

	if ReactGlobals.__DEV__ then
		v3[v4] = p2
	end

	p.current = current
end

function New.checkThatStackIsEmpty()
	if ReactGlobals.__DEV__ and v4 ~= 0 then
		console.error("Expected an empty stack. Something was not reset properly.")
	end
end

function New.resetStackAfterFatalErrorInDev()
	if ReactGlobals.__DEV__ then
		v4 = 0

		table.clear(v2)
		table.clear(v3)
	end
end

return New
