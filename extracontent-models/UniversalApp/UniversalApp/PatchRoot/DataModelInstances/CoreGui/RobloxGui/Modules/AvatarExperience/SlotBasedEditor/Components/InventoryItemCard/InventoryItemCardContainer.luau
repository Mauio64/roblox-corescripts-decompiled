local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local tutils = require(CorePackages.Packages.tutils)
local InventoryItemCard = require(script.Parent.InventoryItemCard)
local useInventoryItemCardProps = require(script.Parent.useInventoryItemCardProps)
local v6 = game:DefineFastFlag("AXInventoryItemCardPerf", false)

local function InventoryItemCardContainer(p1) -- line: 15
	-- upvalues: useInventoryItemCardProps (copy), React (copy), InventoryItemCard (copy)
	local v9 = useInventoryItemCardProps(p1)

	return React.createElement(InventoryItemCard, v9)
end

return React.memo(InventoryItemCardContainer, if not v6 then nil else tutils.deepEqual)
