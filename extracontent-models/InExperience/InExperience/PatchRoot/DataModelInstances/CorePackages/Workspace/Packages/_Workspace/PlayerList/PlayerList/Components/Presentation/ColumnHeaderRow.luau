local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local Text = Foundation.Text

local LeaderboardRowShell = require(parent.Components.Presentation.LeaderboardRowShell)
local PeopleCell = require(parent.Components.Presentation.PeopleCell)
local LeaderboardTextCell = require(parent.Components.Presentation.LeaderboardTextCell)
local FFlagPlayerListContrastingTeamText = require(parent.Flags.FFlagPlayerListContrastingTeamText)

require(parent.Common.computeStatColumns)

local GameTextTranslatorContext = require(parent.Common.GameTextTranslatorContext)
local getPeopleHeaderLabel = require(parent.Common.getPeopleHeaderLabel)
local FFlagPlayerListLocalizeGameText = require(parent.Flags.FFlagPlayerListLocalizeGameText)

local function ColumnHeaderRow(props)
	local v

	if FFlagPlayerListLocalizeGameText then
		v = React.useContext(GameTextTranslatorContext)
	end

	local displayName = not FFlagPlayerListLocalizeGameText and "People" or getPeopleHeaderLabel()
	local statColumns = props.statColumns or {}

	local children = {
		PeopleHeader = React.createElement(PeopleCell, {
			displayName = displayName,
			layoutOrder = 1,
			textTag = "size-full text-caption-small text-align-x-left content-emphasis"
		})
	}

	for i, statColumn in ipairs(statColumns) do
		if FFlagPlayerListContrastingTeamText then
			local formatted = `StatHeader_{statColumn.name}`
			local createElement = React.createElement
			local text

			if v then
				text = v(statColumn.name)
			else
				text = statColumn.name
			end

			children[formatted] = createElement(Text, {
				Text = text,
				Size = UDim2.fromOffset(props.statWidth, props.headerHeight),
				LayoutOrder = i + 1,
				tag = "text-caption-small text-align-x-left clip content-emphasis"
			})
		else
			local formatted = `StatHeader_{statColumn.name}`
			local createElement = React.createElement
			local text

			if v then
				text = v(statColumn.name)
			else
				text = statColumn.name
			end

			children[formatted] = createElement(LeaderboardTextCell, {
				text = text,
				width = props.statWidth,
				rowHeight = props.headerHeight,
				layoutOrder = i + 1,
				textTag = "size-full text-caption-small text-align-x-left content-emphasis"
			})
		end
	end

	return React.createElement(
		LeaderboardRowShell,
		{ rowHeight = props.headerHeight, layoutOrder = props.layoutOrder },
		children
	)
end

return React.memo(ColumnHeaderRow)
