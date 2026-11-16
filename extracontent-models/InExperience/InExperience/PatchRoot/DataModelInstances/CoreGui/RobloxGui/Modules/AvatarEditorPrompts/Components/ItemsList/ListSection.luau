local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents

local ListEntry = require(script.Parent.ListEntry)

local extended = Roact.PureComponent:extend("ListSection")

extended.validateProps = t.strictInterface({
	headerText = t.string,
	items = t.array(t.string),
	layoutOrder = t.integer,
	isFirstSection = t.boolean,
	isLastSection = t.boolean,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	forwardRef = t.table
})

function extended:init()
	self.listRefCache = RoactGamepad.createRefCache()
end

function extended.render(props)
	local children = {}

	local createElement = Roact.createElement
	local v = RoactGamepad.Focusable[ListEntry]
	local v2 = {}
	v2.text = props.props.headerText
	v2.hasBullet = false
	v2.layoutOrder = 0
	local positionChangedCallback

	if props.props.isFirstSection then
		positionChangedCallback = props.firstEntryPositionChanged or nil
	end

	v2.positionChangedCallback = positionChangedCallback
	local nextSelectionDown

	if #props.props.items > 0 then
		nextSelectionDown = props.listRefCache[1] or nil
	end

	v2.NextSelectionDown = nextSelectionDown
	v2[Roact.Ref] = props.listRefCache[0]
	children[0] = createElement(v, v2)

	for i, item in ipairs(props.props.items) do
		local lastEntryPositionChanged

		if props.props.isLastSection and i == #props.props.items then
			lastEntryPositionChanged = props.lastEntryPositionChanged
		end

		local createElement2 = Roact.createElement
		local v3 = RoactGamepad.Focusable[ListEntry]
		local v4 = {
			["text"] = item,
			hasBullet = true,
			layoutOrder = i,
			positionChangedCallback = lastEntryPositionChanged,
			NextSelectionUp = props.listRefCache[i - 1]
		}
		local nextSelectionDown2

		if i ~= #props.props.items then
			nextSelectionDown2 = props.listRefCache[i + 1] or nil
		end

		v4.NextSelectionDown = nextSelectionDown2
		v4[Roact.Ref] = props.listRefCache[i]
		children[i] = createElement2(v3, v4)
	end

	local forwardRef = props.props.forwardRef

	return Roact.createElement(RoactGamepad.Focusable[RoactFitComponents.FitFrameVertical], {
		width = UDim.new(1, 0),
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		BackgroundTransparency = 1,
		LayoutOrder = props.props.layoutOrder,
		defaultChild = props.listRefCache[0],
		NextSelectionLeft = props.props.NextSelectionLeft,
		NextSelectionRight = props.props.NextSelectionRight,
		NextSelectionUp = props.props.NextSelectionUp,
		NextSelectionDown = props.props.NextSelectionDown,
		[Roact.Ref] = forwardRef
	}, children)
end

return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
