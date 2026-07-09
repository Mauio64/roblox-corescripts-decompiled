local CoreGui = game:GetService("CoreGui")
local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local AdsEuDsaPromptHandler = require(script.Parent.AdsEuDsaPromptHandler)

local function starterScript() -- line: 9
	-- upvalues: Roact (copy), AdsEuDsaPromptHandler (copy), CoreGui (copy)
	Roact.mount(Roact.createElement(AdsEuDsaPromptHandler), CoreGui, "AdsEuDsaPromptHandler")
end

return starterScript
