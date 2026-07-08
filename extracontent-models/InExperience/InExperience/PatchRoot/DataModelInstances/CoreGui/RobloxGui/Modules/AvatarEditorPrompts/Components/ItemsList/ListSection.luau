local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local RoactFitComponents = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents
local ListEntry = require(script.Parent.ListEntry)
local v8 = Roact.PureComponent:extend("ListSection")

v8.validateProps = t.strictInterface({
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

function v8.init(p1) -- line: 29
	-- upvalues: RoactGamepad (copy)
	p1.listRefCache = RoactGamepad.createRefCache()
end
function v8.render(p2) -- line: 33
	-- upvalues: Roact (copy), RoactGamepad (copy), ListEntry (copy), RoactFitComponents (copy)
	local t1 = {
		[0] = Roact.createElement(RoactGamepad.Focusable[ListEntry], {
			text = p2.props.headerText,
			hasBullet = false,
			layoutOrder = 0,
			positionChangedCallback = p2.props.isFirstSection and p2.firstEntryPositionChanged or nil,
			NextSelectionDown = #p2.props.items > 0 and p2.listRefCache[1] or nil,
			[Roact.Ref] = p2.listRefCache[0]
		})
	}

	for i, v in ipairs(p2.props.items) do
		local lastEntryPositionChanged = nil

		if p2.props.isLastSection and i == #p2.props.items then
			lastEntryPositionChanged = p2.lastEntryPositionChanged
		end

		t1[i] = Roact.createElement(RoactGamepad.Focusable[ListEntry], {
			text = v,
			hasBullet = true,
			layoutOrder = i,
			positionChangedCallback = lastEntryPositionChanged,
			NextSelectionUp = p2.listRefCache[i - 1],
			NextSelectionDown = i ~= #p2.props.items and p2.listRefCache[i + 1] or nil,
			[Roact.Ref] = p2.listRefCache[i]
		})
	end

	local forwardRef = p2.props.forwardRef

	return Roact.createElement(RoactGamepad.Focusable[RoactFitComponents.FitFrameVertical], {
		width = UDim.new(1, 0),
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		BackgroundTransparency = 1,
		LayoutOrder = p2.props.layoutOrder,
		defaultChild = p2.listRefCache[0],
		NextSelectionLeft = p2.props.NextSelectionLeft,
		NextSelectionRight = p2.props.NextSelectionRight,
		NextSelectionUp = p2.props.NextSelectionUp,
		NextSelectionDown = p2.props.NextSelectionDown,
		[Roact.Ref] = forwardRef
	}, t1)
end

return Roact.forwardRef(function(p3, p4) -- line: 84
	-- upvalues: Roact (copy), v8 (copy), Cryo (copy)
	return Roact.createElement(v8, Cryo.Dictionary.join(p3, {
		forwardRef = p4
	}))
end)
