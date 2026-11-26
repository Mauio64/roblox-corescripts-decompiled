local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local tutils = require(CorePackages.Packages.tutils)

local module = require("@luauforge/deferred/hen")
local module2 = require("@luauforge/deferred/heo")
local defineFastFlag = game:DefineFastFlag("AXInventoryItemCardPerf", false)

local function InventoryItemCardContainer(p2)
	local v5 = module2(p2)
	return React.createElement(module, v5)
end

local memo = React.memo
local v5 = if defineFastFlag then tutils.deepEqual else nil
return memo(InventoryItemCardContainer, v5)
