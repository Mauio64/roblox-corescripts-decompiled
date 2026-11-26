local module = require("@luauforge/bundled/dva")
local module2 = require("@luauforge/bundled/dtf")
local module3 = require("@luauforge/bundled/dtG")
local collectionHeader = require("@luauforge/bundled/dvt").CollectionHeader
local searchSourceEvent = require("@luauforge/bundled/dtp").SearchSourceEvent

local module4 = require("@luauforge/bundled/dwf")

local function SearchSelectionTypeHeader(p2)
	local v5 = module.useContext(module4)

	module3.assert(v5 ~= nil, "Using selection header component outside of SearchTypeSelection context")

	if not v5 then
		return nil
	end

	local selections = v5.selections or {}

	local v6 = module2.List.filter(selections, function(p3)
		return p3 and p3.name == p2.selectionType
	end)[1]

	module3.assert(v6 ~= nil, "Trying to navigate to non existing selection")

	if v6 then
		return module.createElement(collectionHeader, {
			LayoutOrder = p2.LayoutOrder,
			title = v6.text,
			onActivate = function()
				if v6.onActivated then
					v6.onActivated(searchSourceEvent.SeeAll)
				end
			end
		})
	end

	return nil
end

return SearchSelectionTypeHeader
