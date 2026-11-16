local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Error = LuauPolyfill.Error
local inspect = LuauPolyfill.util.inspect
local getComponentName = require(script.Parent.getComponentName)

local __DEV__ = ReactGlobals.__DEV__
local SafeFlags = require(parent.SafeFlags)

local v = SafeFlags.createGetFFlag("ReactInstanceMapDisableErrorChecking")()

local function isValidFiber(data): boolean -- 4 equivalent calls inferred from this helper
	return data.tag ~= nil and data.subtreeFlags ~= nil and data.lanes ~= nil and data.childLanes ~= nil
end

local ReactInstanceMap = {}

function ReactInstanceMap:remove()
	self._reactInternals = nil
end

if v and not __DEV__ then
	function ReactInstanceMap:get()
		return self._reactInternals
	end
else
	function ReactInstanceMap:get()
		local reactInternals = self._reactInternals

		if not isValidFiber(reactInternals) then -- inferred equivalent call
			error(Error.new("invalid fiber in " .. (getComponentName(self) or "UNNAMED Component") .. " during get from ReactInstanceMap! " .. inspect(reactInternals)))
			return reactInternals
		end

		if reactInternals.alternate ~= nil and not isValidFiber(reactInternals.alternate) then -- inferred equivalent call
			error(Error.new("invalid alternate fiber (" .. (getComponentName(self) or "UNNAMED alternate") .. ") in " .. (getComponentName(self) or "UNNAMED Component") .. " during get from ReactInstanceMap! " .. inspect(reactInternals.alternate)))
		end

		return reactInternals
	end
end

function ReactInstanceMap:has(): boolean
	return self._reactInternals ~= nil
end

if v and not __DEV__ then
	function ReactInstanceMap:set(reactInternals)
		self._reactInternals = reactInternals
	end

	return ReactInstanceMap
end

function ReactInstanceMap:set(reactInternals)
	local v2 = reactInternals

	while v2 ~= nil do
		if isValidFiber(v2) then -- inferred equivalent call
			if v2.alternate ~= nil and not isValidFiber(v2.alternate) then -- inferred equivalent call
				local v3 = "invalid alternate fiber (" .. (getComponentName(self) or "UNNAMED alternate") .. ") in " .. (getComponentName(self) or "UNNAMED Component") .. " being set in ReactInstanceMap! " .. inspect(v2.alternate) .. "\n"

				if reactInternals ~= v2 then
					v3 ..= " (from original fiber " .. (getComponentName(self) or "UNNAMED Component") .. ")"
				end

				error(Error.new(v3))
			end
		else
			local v3 = "invalid fiber in " .. (getComponentName(self) or "UNNAMED Component") .. " being set in ReactInstanceMap! " .. inspect(v2) .. "\n"

			if reactInternals ~= v2 then
				v3 ..= " (from original fiber " .. (getComponentName(self) or "UNNAMED Component") .. ")"
			end

			error(Error.new(v3))
		end

		v2 = v2.return_
	end

	self._reactInternals = reactInternals
end

return ReactInstanceMap
