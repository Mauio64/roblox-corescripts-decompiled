local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local ArgCheck = require(Parent.ArgCheck)
local CollectionHeader = require(Parent.CollectionViews).CollectionHeader
local SearchSourceEvent = require(Parent.DiscoveryTypes).SearchSourceEvent
local Context = require(script.Parent.Context)

local function SearchSelectionTypeHeader(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), Context (copy), ArgCheck (copy), Cryo (copy), CollectionHeader (copy), SearchSourceEvent (copy)
	local v10 = React.useContext(Context)

	ArgCheck.assert(v10 ~= nil, "Using selection header component outside of SearchTypeSelection context")

	if not v10 then
		return nil
	end

	local v11 = v10.selections or {}
	local v12 = Cryo.List.filter(v11, function(p1) -- line: 30
		-- upvalues: t1 (copy)
		return p1 and p1.name == t1.selectionType
	end)[1]

	ArgCheck.assert(v12 ~= nil, "Trying to navigate to non existing selection")

	if not v12 then
		return nil
	end

	return React.createElement(CollectionHeader, {
		LayoutOrder = t1.LayoutOrder,
		title = v12.text,
		onActivate = function() -- line: 42
			-- upvalues: v12 (copy), SearchSourceEvent (copy)
			if v12.onActivated then
				v12.onActivated(SearchSourceEvent.SeeAll)
			end
		end
	})
end

return SearchSelectionTypeHeader
