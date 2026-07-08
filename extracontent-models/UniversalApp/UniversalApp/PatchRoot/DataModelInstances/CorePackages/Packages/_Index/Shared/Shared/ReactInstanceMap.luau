local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Error = LuauPolyfill.Error
local inspect = LuauPolyfill.util.inspect
local getComponentName = require(script.Parent.getComponentName)

script:FindFirstAncestor("ReactUtils")

local __DEV__ = ReactGlobals.__DEV__
local v8 = require(ParentParent.SafeFlags).createGetFFlag("ReactInstanceMapDisableErrorChecking")()
local t1 = {}

local function isValidFiber(p1) -- line: 44
	return p1.tag ~= nil and (p1.subtreeFlags ~= nil and (p1.lanes ~= nil and p1.childLanes ~= nil))
end

function t1.remove(p2) -- line: 51
	p2._reactInternals = nil
end

if not v8 or __DEV__ then
	function t1.get(p3) -- line: 56
		-- upvalues: Error (copy), getComponentName (copy), inspect (copy)
		local _reactInternals = p3._reactInternals

		if _reactInternals.tag == nil or (_reactInternals.subtreeFlags == nil or (_reactInternals.lanes == nil or _reactInternals.childLanes == nil)) then
			error(Error.new("invalid fiber in " .. (getComponentName(p3) or "UNNAMED Component") .. " during get from ReactInstanceMap! " .. inspect(_reactInternals)))

			return _reactInternals
		end

		if _reactInternals.alternate ~= nil then
			local alternate = _reactInternals.alternate

			if alternate.tag == nil or (alternate.subtreeFlags == nil or (alternate.lanes == nil or alternate.childLanes == nil)) then
				error(Error.new("invalid alternate fiber (" .. (getComponentName(p3) or "UNNAMED alternate") .. ") in " .. (getComponentName(p3) or "UNNAMED Component") .. " during get from ReactInstanceMap! " .. inspect(_reactInternals.alternate)))
			end
		end

		return _reactInternals
	end
else
	function t1.get(p4) -- line: 82
		return p4._reactInternals
	end
end

function t1.has(p5) -- line: 87
	return p5._reactInternals ~= nil
end

if not v8 or __DEV__ then
	function t1.set(p6, p7) -- line: 92
		-- upvalues: getComponentName (copy), inspect (copy), Error (copy)
		local v20 = p7

		while v20 ~= nil do
			if v20.tag == nil or (v20.subtreeFlags == nil or (v20.lanes == nil or v20.childLanes == nil)) then
				local v21 = "invalid fiber in " .. (getComponentName(p6) or "UNNAMED Component") .. " being set in ReactInstanceMap! " .. inspect(v20) .. "\n"

				if p7 ~= v20 then
					v21 ..= " (from original fiber " .. (getComponentName(p6) or "UNNAMED Component") .. ")"
				end

				error(Error.new(v21))
			elseif v20.alternate ~= nil then
				local alternate = v20.alternate

				if alternate.tag == nil or (alternate.subtreeFlags == nil or (alternate.lanes == nil or alternate.childLanes == nil)) then
					local v23 = "invalid alternate fiber (" .. (getComponentName(p6) or "UNNAMED alternate") .. ") in " .. (getComponentName(p6) or "UNNAMED Component") .. " being set in ReactInstanceMap! " .. inspect(v20.alternate) .. "\n"

					if p7 ~= v20 then
						v23 ..= " (from original fiber " .. (getComponentName(p6) or "UNNAMED Component") .. ")"
					end

					error(Error.new(v23))
				end
			end

			v20 = v20.return_
		end

		p6._reactInternals = p7
	end

	return t1
end

function t1.set(p8, p9) -- line: 129
	p8._reactInternals = p9
end

return t1
