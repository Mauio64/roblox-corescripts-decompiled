local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createUploadStore = require(script.createUploadStore)

return Signals.createComputed(function(_) -- line: 7
	-- upvalues: createUploadStore (copy)
	return createUploadStore()
end)
