local module = require("@luauforge/bundled/hHu")

local LibraryLeavingOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryLeavingOverlay")
local module3 = require("@luauforge/bundled/hIp")

local function PurchaseSpinnerContainer(p2)
	local v5 = module3(p2)
	return module.createElement(LibraryLeavingOverlay, v5)
end

return PurchaseSpinnerContainer
