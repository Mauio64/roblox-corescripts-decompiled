local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)

require(Foundation.Components.Types)

local Flags = require(Foundation.Utility.Flags)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)
local indexBindable = require(Foundation.Utility.indexBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local v9 = Flags.FoundationGuiObjectInputSinkProperty and pcall(game.GetEngineFeature, game, "GuiObjectInputSink")

local function withGuiObjectProps(p1, p2) -- line: 52
	-- upvalues: indexBindable (copy), v9 (copy), ReactIs (copy), withCommonProps (copy), React (copy), getTestIdTag (copy)
	if type(p2) == "table" then
		p2.AutoLocalize = p1.AutoLocalize
		p2.AutomaticSize = p1.AutomaticSize
		p2.BackgroundColor3 = if not p1.backgroundStyle then nil else indexBindable(p1.backgroundStyle, "Color3")
		p2.BackgroundTransparency = if not p1.backgroundStyle then nil else indexBindable(p1.backgroundStyle, "Transparency")
		p2.BorderSizePixel = p1.BorderSizePixel
		p2.BorderColor3 = p1.BorderColor3
		p2.BorderMode = p1.BorderMode
		p2.ClipsDescendants = p1.ClipsDescendants

		if v9 then
			p2.InputSink = p1.InputSink
		end

		p2.Rotation = p1.Rotation
		p2.SizeConstraint = p1.SizeConstraint

		if p1.selection then
			p2.Selectable = p1.selection.Selectable
			p2.SelectionImageObject = p1.selection.SelectionImageObject
			p2.SelectionOrder = p1.selection.SelectionOrder
			p2.NextSelectionDown = p1.selection.NextSelectionDown
			p2.NextSelectionLeft = p1.selection.NextSelectionLeft
			p2.NextSelectionRight = p1.selection.NextSelectionRight
			p2.NextSelectionUp = p1.selection.NextSelectionUp
		end

		if p1.selectionGroup ~= nil then
			if type(p1.selectionGroup) == "boolean" or ReactIs.isBinding(p1.selectionGroup) then
				p2.SelectionGroup = p1.selectionGroup
			else
				local selectionGroup = p1.selectionGroup

				p2.SelectionGroup = true
				p2.SelectionBehaviorUp = selectionGroup.SelectionBehaviorUp
				p2.SelectionBehaviorDown = selectionGroup.SelectionBehaviorDown
				p2.SelectionBehaviorLeft = selectionGroup.SelectionBehaviorLeft
				p2.SelectionBehaviorRight = selectionGroup.SelectionBehaviorRight
			end
		end

		p2.Size = p1.Size
	end

	local v14 = withCommonProps(p1, p2)

	v14[React.Change.AbsoluteSize] = p1.onAbsoluteSizeChanged
	v14.onAbsoluteSizeChanged = nil
	v14[React.Change.AbsolutePosition] = p1.onAbsolutePositionChanged
	v14.onAbsolutePositionChanged = nil

	local v15 = getTestIdTag(v14.testId)

	if v14[React.Tag] and v15 then
		local Tag = React.Tag

		v14[Tag] = v14[Tag] .. " " .. v15
	else
		v14[React.Tag] = v14[React.Tag] or v15
	end

	v14.testId = nil

	return v14
end

return withGuiObjectProps
