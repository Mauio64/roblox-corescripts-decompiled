local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local Roact = require(SocialLibraries.dependencies).Roact
local v3 = Roact.PureComponent:extend("SortedList")

v3.defaultProps = {
	renderEntry = nil,
	entryHeight = 48,
	LayoutOrder = 0,
	entries = {},
	sortComparator = function(_, _) -- line: 12
		return true
	end
}

function v3.sortEntries(p3) -- line: 19
	local t1 = {}

	for _, v in pairs(p3.props.entries) do
		table.insert(t1, v)
	end

	table.sort(t1, p3.props.sortComparator)

	return t1
end
function v3.render(p4) -- line: 31
	-- upvalues: Roact (copy)
	local v11 = p4:sortEntries()
	local t2 = {
		layout = Roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for k, v in pairs(v11) do
		local v15 = k == #v11

		table.insert(t2, Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, p4.props.entryHeight),
			LayoutOrder = k
		}, {
			entry = p4.props.renderEntry(v, v15)
		}))
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, #p4.props.entries * p4.props.entryHeight),
		LayoutOrder = p4.props.LayoutOrder
	}, t2)
end

return v3
