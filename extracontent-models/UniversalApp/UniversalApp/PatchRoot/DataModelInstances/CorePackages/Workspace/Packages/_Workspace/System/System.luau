local Lifecycle = require(script.Lifecycle)
local Features = require(script.Features)

return {
	Lifecycle = Lifecycle,
	Features = Features,
	["jest.config"] = script["jest.config"]
}
