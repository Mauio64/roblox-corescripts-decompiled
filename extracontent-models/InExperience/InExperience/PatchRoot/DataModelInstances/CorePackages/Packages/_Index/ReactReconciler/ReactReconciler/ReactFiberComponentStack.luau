local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)

require(ParentParent.LuauPolyfill)
require(script.Parent.ReactInternalTypes)

local ReactWorkTags = require(script.Parent.ReactWorkTags)
local HostComponent = ReactWorkTags.HostComponent
local LazyComponent = ReactWorkTags.LazyComponent
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local SuspenseListComponent = ReactWorkTags.SuspenseListComponent
local FunctionComponent = ReactWorkTags.FunctionComponent
local IndeterminateComponent = ReactWorkTags.IndeterminateComponent
local ForwardRef = ReactWorkTags.ForwardRef
local SimpleMemoComponent = ReactWorkTags.SimpleMemoComponent
local ClassComponent = ReactWorkTags.ClassComponent
local ReactComponentStackFrame = require(ParentParent.Shared).ReactComponentStackFrame
local describeBuiltInComponentFrame = ReactComponentStackFrame.describeBuiltInComponentFrame
local describeFunctionComponentFrame = ReactComponentStackFrame.describeFunctionComponentFrame
local describeClassComponentFrame = ReactComponentStackFrame.describeClassComponentFrame

local function describeFiber(p1) -- line: 39
	-- upvalues: ReactGlobals (copy), HostComponent (copy), describeBuiltInComponentFrame (copy), LazyComponent (copy), SuspenseComponent (copy), SuspenseListComponent (copy), FunctionComponent (copy), IndeterminateComponent (copy), SimpleMemoComponent (copy), describeFunctionComponentFrame (copy), ForwardRef (copy), ClassComponent (copy), describeClassComponentFrame (copy)
	local type = nil

	if ReactGlobals.__DEV__ then
		local _debugOwner = p1._debugOwner

		if _debugOwner then
			type = _debugOwner.type
		end
	end

	local _debugSource = nil

	if ReactGlobals.__DEV__ then
		_debugSource = p1._debugSource
	end

	if p1.tag == HostComponent then
		return describeBuiltInComponentFrame(p1.type, _debugSource, type)
	end

	if p1.tag == LazyComponent then
		return describeBuiltInComponentFrame("Lazy", _debugSource, type)
	end

	if p1.tag == SuspenseComponent then
		return describeBuiltInComponentFrame("Suspense", _debugSource, type)
	end

	if p1.tag == SuspenseListComponent then
		return describeBuiltInComponentFrame("SuspenseList", _debugSource, type)
	end

	if p1.tag == FunctionComponent or p1.tag == IndeterminateComponent or p1.tag == SimpleMemoComponent then
		return describeFunctionComponentFrame(p1.type, _debugSource, type)
	end

	if p1.tag == ForwardRef then
		return describeFunctionComponentFrame(p1.type.render, _debugSource, type)
	end

	if p1.tag == ClassComponent then
		return describeClassComponentFrame(p1.type, _debugSource, type)
	end

	return ""
end

return {
	getStackByFiberInDevAndProd = function(p2) -- line: 77
		-- upvalues: describeFiber (copy)
		local ok, result = pcall(function() -- line: 78
			-- upvalues: p2 (copy), describeFiber (copy)
			local s1 = ""
			local v26 = p2

			repeat
				s1 ..= describeFiber(v26)
				v26 = v26.return_
			until v26 == nil

			return s1
		end)

		if not ok then
			if typeof(result) == "table" and result.message and result.stack then
				return "\nError generating stack: " .. result.message .. "\n" .. tostring(result.stack)
			end

			return "\nError generating stack: " .. tostring(result)
		end

		return result
	end
}
