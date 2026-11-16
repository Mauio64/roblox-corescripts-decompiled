local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/gNX")

local module2 = require("@luauforge/bundled/gNY")
local module3 = require("@luauforge/bundled/dMx")

local function getContentToHyderate(p2, p3, p4)
	local contentToHyderate = {}

	if p2 and p2.content and not Cryo.isEmpty(p2.content) then
		for i = 1, p4 or math.min(#p2.content, module) do
			local v5 = p2.content[i]

			if not v5 then
				continue
			end

			if not (module2() and v5.type == module3.ItemType.Look or not (p3[v5.type] and p3[v5.type][tostring(v5.id)])) then
				continue
			end

			table.insert(contentToHyderate, v5)
		end
	end

	return contentToHyderate
end

return getContentToHyderate
