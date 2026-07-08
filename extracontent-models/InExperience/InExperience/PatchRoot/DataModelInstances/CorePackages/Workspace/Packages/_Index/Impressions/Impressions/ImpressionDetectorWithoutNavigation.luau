local CollectionService = game:GetService("CollectionService")
local Parent = script:FindFirstAncestor("Impressions").Parent
local Roact = require(Parent.Roact)
local ArgCheck = require(Parent.ArgCheck)
local t = require(Parent.t)
local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = require(Parent.SharedFlags).FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local Constants = require(script.Parent.Constants)
local v8 = Roact.PureComponent:extend("ImpressionsDetectorWithoutNavigation")

v8.validateProps = t.strictInterface({
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
	isFocused = t.optional(t.boolean),
	navigation = t.optional(t.table)
})
v8.defaultProps = {
	scanDebounceSeconds = 1,
	viewFillPercent = 0.25
}

function v8.init(p1) -- line: 53
	p1.isMounted = false
	p1.lastImpressionTick = nil
	p1.nextImpressionTick = nil
end
function v8._boundingBoxIntersectsView(p2, p3) -- line: 59
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
	local v15 = AbsolutePosition + AbsoluteSize
	local v16 = v15.X > viewPortBounds.min.X and AbsolutePosition.X < viewPortBounds.max.X
	local v17 = v15.Y > viewPortBounds.min.Y and AbsolutePosition.Y < viewPortBounds.max.Y

	if v16 and v17 then
		return true
	end

	return false
end
function v8._isInstanceVisible(p4, p5) -- line: 84
	-- upvalues: ArgCheck (copy), FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions (copy)
	if not p4:_boundingBoxIntersectsView(p5) then
		return false
	end

	local viewPortBounds = p4.props.viewPortBounds

	ArgCheck.assert(viewPortBounds ~= nil)

	local v21 = if not FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then viewPortBounds else p4.props.viewPortFillBounds or viewPortBounds
	local v22 = v21.max - v21.min

	if v22.X <= 0 or v22.Y <= 0 then
		return false
	end

	local v23 = v22 * p4.props.viewFillPercent

	ArgCheck.assert(v23.X > 0 and v23.Y > 0)

	if v23.X <= 0 or v23.Y <= 0 then
		return false
	end

	local AbsolutePosition = p5.AbsolutePosition
	local AbsoluteSize = p5.AbsoluteSize

	if p4.props.skipZeroSizes and (AbsoluteSize.X == 0 or AbsoluteSize.Y == 0) then
		return false
	end

	local v26 = AbsolutePosition + AbsoluteSize / 2
	local v27 = AbsolutePosition + AbsoluteSize
	local v28 = v26.X > viewPortBounds.min.X and v26.X < viewPortBounds.max.X
	local v29 = v26.Y > viewPortBounds.min.Y and v26.Y < viewPortBounds.max.Y

	if v28 and v29 then
		return true
	end

	local v30 = AbsolutePosition:Max(viewPortBounds.min)
	local v31 = v27:Min(viewPortBounds.max) - v30
	local v32 = v31.X >= v23.X

	if v29 and v32 then
		return true
	end

	local v33 = v31.Y >= v23.Y

	if v28 and v33 then
		return true
	end

	if v32 and v33 then
		return true
	end

	return false
end
function v8._calculateImpressions(p6) -- line: 157
	-- upvalues: CollectionService (copy), Constants (copy), ArgCheck (copy)
	if not p6.isMounted then
		return
	end

	if p6.props.isFocused == false then
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
function v8._requestImpressions(p7) -- line: 195
	-- upvalues: ArgCheck (copy)
	if not p7.isMounted then
		return
	end

	if p7.props.isFocused == false then
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
		task.delay(n1, function() -- line: 217
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
function v8.render(_) -- line: 229
	return nil
end
function v8.didMount(p9) -- line: 233
	p9.isMounted = true
	p9:_requestImpressions()

	if p9.props.onRequestImpressionsSignal then
		p9.onRequestImpressionsConnection = p9.props.onRequestImpressionsSignal:connect(function() -- line: 237
			-- upvalues: p9 (copy)
			p9:_requestImpressions()
		end)
	end
end
function v8.willUnmount(p10) -- line: 243
	p10.isMounted = false

	if p10.onRequestImpressionsConnection ~= nil then
		p10.onRequestImpressionsConnection:disconnect()
		p10.onRequestImpressionsConnection = nil
	end
end
function v8.didUpdate(p11, _, _) -- line: 251
	p11:_requestImpressions()
end

return v8
