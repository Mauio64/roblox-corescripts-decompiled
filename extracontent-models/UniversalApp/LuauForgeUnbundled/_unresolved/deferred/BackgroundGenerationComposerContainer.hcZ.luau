local module = require("@luauforge/deferred/hcS")

local module2 = require("@luauforge/deferred/hda")
local module3 = require("@luauforge/deferred/hdc")
local module4 = require("@luauforge/deferred/hde")

local function BackgroundGenerationComposerContentContainer(p2)
	local v5 = module3(p2)
	return module.createElement(module2, v5)
end

local function BackgroundGenerationComposerContainer(p2)
	return module.createElement(module4, nil, {
		Content = module.createElement(BackgroundGenerationComposerContentContainer, p2)
	})
end

return BackgroundGenerationComposerContainer
