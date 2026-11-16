local parent = script.Parent.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local ReactDebugCurrentFrame = {}

local v = nil

function ReactDebugCurrentFrame.setExtraStackFrame(p: string?)
	if ReactGlobals.__DEV__ then
		v = p
	end
end

if ReactGlobals.__DEV__ then
	ReactDebugCurrentFrame.getCurrentStack = nil

	function ReactDebugCurrentFrame.getStackAddendum()
		local stackAddendum = ""

		if v then
			stackAddendum ..= v
		end

		local getCurrentStack = ReactDebugCurrentFrame.getCurrentStack

		if getCurrentStack then
			stackAddendum ..= getCurrentStack() or ""
		end

		return stackAddendum
	end
end

return ReactDebugCurrentFrame
