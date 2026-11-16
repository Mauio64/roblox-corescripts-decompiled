local CoreGui = game:GetService("CoreGui")

local parent = script.Parent.Parent
local Roact = require(parent.Roact)

local AdsEuDsaPromptHandler = require(script.Parent.AdsEuDsaPromptHandler)

local function starterScript()
	Roact.mount(Roact.createElement(AdsEuDsaPromptHandler), CoreGui, "AdsEuDsaPromptHandler")
end

return starterScript
