local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

require(Foundation.Components.Types)

local Flags = require(Foundation.Utility.Flags)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)
local indexBindable = require(Foundation.Utility.indexBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local v = Flags.FoundationGuiObjectInputSinkProperty and pcall(game.GetEngineFeature, game, "GuiObjectInputSink")

local function withGuiObjectProps(data, p)
	if type(p) == "table" then
		p.AutoLocalize = data.AutoLocalize
		p.AutomaticSize = data.AutomaticSize
		local backgroundColor

		if data.backgroundStyle then
			backgroundColor = indexBindable(data.backgroundStyle, "Color3")
		end

		p.BackgroundColor3 = backgroundColor
		local backgroundTransparency

		if data.backgroundStyle then
			backgroundTransparency = indexBindable(data.backgroundStyle, "Transparency")
		end

		p.BackgroundTransparency = backgroundTransparency

		p.BorderSizePixel = data.BorderSizePixel
		p.BorderColor3 = data.BorderColor3
		p.BorderMode = data.BorderMode
		p.ClipsDescendants = data.ClipsDescendants

		if v then
			p.InputSink = data.InputSink
		end

		p.Rotation = data.Rotation
		p.SizeConstraint = data.SizeConstraint

		if data.selection then
			p.Selectable = data.selection.Selectable
			p.SelectionImageObject = data.selection.SelectionImageObject
			p.SelectionOrder = data.selection.SelectionOrder
			p.NextSelectionDown = data.selection.NextSelectionDown
			p.NextSelectionLeft = data.selection.NextSelectionLeft
			p.NextSelectionRight = data.selection.NextSelectionRight
			p.NextSelectionUp = data.selection.NextSelectionUp
		end

		if data.selectionGroup ~= nil then
			if type(data.selectionGroup) == "boolean" or ReactIs.isBinding(data.selectionGroup) then
				p.SelectionGroup = data.selectionGroup
			else
				local selectionGroup = data.selectionGroup
				p.SelectionGroup = true
				p.SelectionBehaviorUp = selectionGroup.SelectionBehaviorUp
				p.SelectionBehaviorDown = selectionGroup.SelectionBehaviorDown
				p.SelectionBehaviorLeft = selectionGroup.SelectionBehaviorLeft
				p.SelectionBehaviorRight = selectionGroup.SelectionBehaviorRight
			end
		end

		p.Size = data.Size
	end

	local v2 = withCommonProps(data, p)

	v2[React.Change.AbsoluteSize] = data.onAbsoluteSizeChanged
	v2.onAbsoluteSizeChanged = nil
	v2[React.Change.AbsolutePosition] = data.onAbsolutePositionChanged
	v2.onAbsolutePositionChanged = nil

	local testIdTag = getTestIdTag(v2.testId)

	if v2[React.Tag] and testIdTag then
		local tag = React.Tag
		v2[tag] ..= " " .. testIdTag
	else
		v2[React.Tag] = v2[React.Tag] or testIdTag
	end

	v2.testId = nil

	return v2
end

return withGuiObjectProps
