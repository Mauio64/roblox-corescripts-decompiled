local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createUploadStore = require(script.createUploadStore)

return Signals.createComputed(function(_)
	return createUploadStore()
end)
