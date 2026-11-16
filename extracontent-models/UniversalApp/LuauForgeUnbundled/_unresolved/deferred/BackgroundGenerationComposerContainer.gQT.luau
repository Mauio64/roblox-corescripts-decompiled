local module = require("@luauforge/deferred/gQM")

local module2 = require("@luauforge/deferred/gQU")
local module3 = require("@luauforge/deferred/gQW")
local module4 = require("@luauforge/deferred/gQY")

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
