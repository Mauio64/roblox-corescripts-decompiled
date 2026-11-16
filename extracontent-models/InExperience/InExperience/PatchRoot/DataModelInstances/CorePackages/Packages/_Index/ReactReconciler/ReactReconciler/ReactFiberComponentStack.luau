local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
require(parent.LuauPolyfill)

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

local Shared = require(parent.Shared)
local ReactComponentStackFrame = Shared.ReactComponentStackFrame

local describeBuiltInComponentFrame = ReactComponentStackFrame.describeBuiltInComponentFrame

local describeFunctionComponentFrame = ReactComponentStackFrame.describeFunctionComponentFrame
local describeClassComponentFrame = ReactComponentStackFrame.describeClassComponentFrame

local function describeFiber(data)
	local kind = nil

	if ReactGlobals.__DEV__ then
		local debugOwner = data._debugOwner

		if debugOwner then
			kind = debugOwner.type
		end
	end

	local debugSource

	if ReactGlobals.__DEV__ then
		debugSource = data._debugSource
	end

	if data.tag == HostComponent then
		return describeBuiltInComponentFrame(data.type, debugSource, kind)
	end

	if data.tag == LazyComponent then
		return describeBuiltInComponentFrame("Lazy", debugSource, kind)
	end

	if data.tag == SuspenseComponent then
		return describeBuiltInComponentFrame("Suspense", debugSource, kind)
	end

	if data.tag == SuspenseListComponent then
		return describeBuiltInComponentFrame("SuspenseList", debugSource, kind)
	end

	if data.tag == FunctionComponent or data.tag == IndeterminateComponent or data.tag == SimpleMemoComponent then
		return describeFunctionComponentFrame(data.type, debugSource, kind)
	end

	if data.tag == ForwardRef then
		return describeFunctionComponentFrame(data.type.render, debugSource, kind)
	end

	if data.tag == ClassComponent then
		return describeClassComponentFrame(data.type, debugSource, kind)
	end

	return ""
end

return {
	getStackByFiberInDevAndProd = function(p)
		local success, result = pcall(function()
			local v = p
			local v2 = ""

			repeat
				v2 ..= describeFiber(v)
				v = v.return_
			until v == nil

			return v2
		end)

		if success then
			return result
		end

		if typeof(result) == "table" and result.message and result.stack then
			return "\nError generating stack: " .. result.message .. "\n" .. tostring(result.stack)
		end

		return "\nError generating stack: " .. tostring(result)
	end
}
