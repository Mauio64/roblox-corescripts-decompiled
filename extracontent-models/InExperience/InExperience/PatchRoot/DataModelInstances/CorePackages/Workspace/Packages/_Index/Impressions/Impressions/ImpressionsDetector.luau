local CollectionService = game:GetService("CollectionService")
local Parent = script:FindFirstAncestor("Impressions").Parent
local Roact = require(Parent.Roact)
local ArgCheck = require(Parent.ArgCheck)
local t = require(Parent.t)
local withNavigationFocus = require(Parent.RoactNavigation).withNavigationFocus
local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = require(Parent.SharedFlags).FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local Constants = require(script.Parent.Constants)
local ImpressionDetectorWithoutNavigation = require(script.Parent.ImpressionDetectorWithoutNavigation)
local v10 = Roact.PureComponent:extend("ImpressionsDetector")

v10.validateProps = t.strictInterface({
	scanDebounceSeconds = t.optional(t.number),
	viewFillPercent = t.optional(t.number),
	parentRef = t.optional(t.table),
	impressionsTag = t.string,
	onRequestImpressionsSignal = t.table,
	viewPortBounds = t.strictInterface({
		min = t.Vector2,
		max = t.Vector2
	}),
	viewPortFillBounds = if not FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then nil else t.optional(t.strictInterface({
		min = t.Vector2,
		max = t.Vector2
	})),
	filterImpressionFunc = t.optional(t.callback),
	onImpressionsDetected = t.union(t.callback, t.table),
	skipZeroSizes = t.optional(t.boolean),
	isFocused = t.boolean,
	navigation = t.table
})
v10.defaultProps = {
	scanDebounceSeconds = 1,
	viewFillPercent = 0.25
}

function v10.init(p1) -- line: 55
	p1.isMounted = false
	p1.lastImpressionTick = nil
	p1.nextImpressionTick = nil
end
function v10._boundingBoxIntersectsView(p2, p3) -- line: 61
	-- upvalues: ArgCheck (copy)
	if not p3 then
		return false
	end

	local viewPortBounds = p2.props.viewPortBounds

	ArgCheck.assert(viewPortBounds ~= nil)

	if not viewPortBounds then
		return false
	end

	local AbsoluteSize = p3.AbsoluteSize
	local AbsolutePosition = p3.AbsolutePosition
	local v17 = AbsolutePosition + AbsoluteSize
	local v18 = v17.X > viewPortBounds.min.X and AbsolutePosition.X < viewPortBounds.max.X
	local v19 = v17.Y > viewPortBounds.min.Y and AbsolutePosition.Y < viewPortBounds.max.Y

	if v18 and v19 then
		return true
	end

	return false
end
function v10._isInstanceVisible(p4, p5) -- line: 86
	-- upvalues: ArgCheck (copy), FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions (copy)
	if not p4:_boundingBoxIntersectsView(p5) then
		return false
	end

	local viewPortBounds = p4.props.viewPortBounds

	ArgCheck.assert(viewPortBounds ~= nil)

	local v23 = if not FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then viewPortBounds else p4.props.viewPortFillBounds or viewPortBounds
	local v24 = v23.max - v23.min

	if v24.X <= 0 or v24.Y <= 0 then
		return false
	end

	local v25 = v24 * p4.props.viewFillPercent

	ArgCheck.assert(v25.X > 0 and v25.Y > 0)

	if v25.X <= 0 or v25.Y <= 0 then
		return false
	end

	local AbsolutePosition = p5.AbsolutePosition
	local AbsoluteSize = p5.AbsoluteSize

	if p4.props.skipZeroSizes and (AbsoluteSize.X == 0 or AbsoluteSize.Y == 0) then
		return false
	end

	local v28 = AbsolutePosition + AbsoluteSize / 2
	local v29 = AbsolutePosition + AbsoluteSize
	local v30 = v28.X > viewPortBounds.min.X and v28.X < viewPortBounds.max.X
	local v31 = v28.Y > viewPortBounds.min.Y and v28.Y < viewPortBounds.max.Y

	if v30 and v31 then
		return true
	end

	local v32 = AbsolutePosition:Max(viewPortBounds.min)
	local v33 = v29:Min(viewPortBounds.max) - v32
	local v34 = v33.X >= v25.X

	if v31 and v34 then
		return true
	end

	local v35 = v33.Y >= v25.Y

	if v30 and v35 then
		return true
	end

	if v34 and v35 then
		return true
	end

	return false
end
function v10._calculateImpressions(p6) -- line: 159
	-- upvalues: CollectionService (copy), Constants (copy), ArgCheck (copy)
	if not p6.isMounted then
		return
	end

	if not p6.props.isFocused then
		return
	end

	p6.lastImpressionTick = tick()

	if p6.props.parentRef ~= nil then
		local current = p6.props.parentRef.current

		if current == nil or not p6:_boundingBoxIntersectsView(current) then
			return
		end
	end

	local impressionsTag = p6.props.impressionsTag
	local t1 = {}
	local impressionsTag2 = CollectionService:GetTagged(impressionsTag)

	for _, v in ipairs(impressionsTag2) do
		local ConstantsItemIndex = v:GetAttribute(Constants.ItemIndex)

		if ConstantsItemIndex and v:IsA("GuiObject") and p6:_isInstanceVisible(v) and (p6.props.filterImpressionFunc == nil or p6.props.filterImpressionFunc(ConstantsItemIndex)) then
			table.insert(t1, ConstantsItemIndex)
		end
	end

	if #t1 > 0 then
		ArgCheck.assert(p6.props.onImpressionsDetected ~= nil)
		p6.props.onImpressionsDetected(t1)
	end
end
function v10._requestImpressions(p7) -- line: 198
	-- upvalues: ArgCheck (copy)
	if not p7.isMounted then
		return
	end

	if not p7.props.isFocused then
		return
	end

	if p7.nextImpressionTick ~= nil then
		return
	end

	if not p7.props.impressionsTag then
		return
	end

	local n1 = 0

	if p7.lastImpressionTick ~= nil then
		p7.nextImpressionTick = p7.lastImpressionTick + p7.props.scanDebounceSeconds
		n1 = p7.nextImpressionTick - tick()
	end

	if n1 > 0 then
		task.delay(n1, function() -- line: 221
			-- upvalues: ArgCheck (copy), p7 (copy)
			ArgCheck.assert(p7.nextImpressionTick ~= nil and tick() > p7.nextImpressionTick)
			p7.nextImpressionTick = nil
			p7:_calculateImpressions()
		end)

		return
	end

	p7.nextImpressionTick = nil
	p7:_calculateImpressions()
end
function v10.render(_) -- line: 233
	return nil
end
function v10.didMount(p9) -- line: 237
	p9.isMounted = true
	p9:_requestImpressions()

	if p9.props.onRequestImpressionsSignal then
		p9.onRequestImpressionsConnection = p9.props.onRequestImpressionsSignal:connect(function() -- line: 241
			-- upvalues: p9 (copy)
			p9:_requestImpressions()
		end)
	end
end
function v10.willUnmount(p10) -- line: 247
	p10.isMounted = false

	if p10.onRequestImpressionsConnection ~= nil then
		p10.onRequestImpressionsConnection:disconnect()
		p10.onRequestImpressionsConnection = nil
	end
end
function v10.didUpdate(p11, _, _) -- line: 255
	p11:_requestImpressions()
end

return (withNavigationFocus(ImpressionDetectorWithoutNavigation))
