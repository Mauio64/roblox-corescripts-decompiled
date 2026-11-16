local parent = script.Parent.Parent
require(parent.LuauPolyfill)

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)
local supportsTestSelectors = ReactFiberHostConfig.supportsTestSelectors

local v = {}
return {
	onCommitRoot = function()
		if supportsTestSelectors then
			for _, v2 in v do
				v2()
			end
		end
	end
}
