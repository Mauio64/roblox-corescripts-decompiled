local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local roact = dependencies.Roact

local extended = roact.PureComponent:extend("SortedList")
extended.defaultProps = {
	entries = {},
	renderEntry = nil,
	entryHeight = 48,
	sortComparator = function(_, _): boolean
		return true
	end,
	LayoutOrder = 0
}

function extended:sortEntries()
	local entries = {}

	for _, entry in pairs(self.props.entries) do
		table.insert(entries, entry)
	end

	table.sort(entries, self.props.sortComparator)

	return entries
end

function extended:render()
	local sortEntries = self:sortEntries()

	local children = {
		layout = roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for k, sortEntry in pairs(sortEntries) do
		local v = k == #sortEntries

		table.insert(
			children,
			roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, self.props.entryHeight),
					BackgroundTransparency = 1,
					LayoutOrder = k
				},
				{
					entry = self.props.renderEntry(sortEntry, v)
				}
			)
		)
	end

	return roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, #self.props.entries * self.props.entryHeight),
		BackgroundTransparency = 1,
		LayoutOrder = self.props.LayoutOrder
	}, children)
end

return extended
