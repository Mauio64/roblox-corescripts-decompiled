local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local LeaderboardRowShell = require(ParentParent.Components.Presentation.LeaderboardRowShell)
local PeopleCell = require(ParentParent.Components.Presentation.PeopleCell)
local LeaderboardTextCell = require(ParentParent.Components.Presentation.LeaderboardTextCell)

require(ParentParent.Common.computeStatColumns)

local GameTextTranslatorContext = require(ParentParent.Common.GameTextTranslatorContext)
local getPeopleHeaderLabel = require(ParentParent.Common.getPeopleHeaderLabel)
local FFlagPlayerListLocalizeGameText = require(ParentParent.Flags.FFlagPlayerListLocalizeGameText)

local function ColumnHeaderRow(t1: {[any]: any}) -- line: 18
	-- upvalues: FFlagPlayerListLocalizeGameText (copy), React (copy), GameTextTranslatorContext (copy), getPeopleHeaderLabel (copy), PeopleCell (copy), LeaderboardTextCell (copy), LeaderboardRowShell (copy)
	local v12 = if not FFlagPlayerListLocalizeGameText then nil else React.useContext(GameTextTranslatorContext)
	local v13 = not FFlagPlayerListLocalizeGameText and "People" or getPeopleHeaderLabel()
	local v14 = t1.statColumns or {}
	local t2 = {
		PeopleHeader = React.createElement(PeopleCell, {
			layoutOrder = 1,
			textTag = "size-full text-caption-small text-align-x-left content-emphasis",
			displayName = v13
		})
	}

	for i, v in ipairs(v14) do
		t2[`StatHeader_{ v.name }`] = React.createElement(LeaderboardTextCell, {
			textTag = "size-full text-caption-small text-align-x-left content-emphasis",
			text = if not v12 then v.name else v12(v.name),
			width = t1.statWidth,
			rowHeight = t1.headerHeight,
			layoutOrder = i + 1
		})
	end

	return React.createElement(LeaderboardRowShell, {
		rowHeight = t1.headerHeight,
		layoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(ColumnHeaderRow)
