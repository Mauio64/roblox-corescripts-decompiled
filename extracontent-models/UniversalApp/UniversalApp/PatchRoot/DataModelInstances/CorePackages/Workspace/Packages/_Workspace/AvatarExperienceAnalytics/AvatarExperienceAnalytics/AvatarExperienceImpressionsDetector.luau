local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local Roact = require(Parent.Roact)
local RoactRodux = require(Parent.RoactRodux)
local ArgCheck = require(Parent.ArgCheck)
local t = require(Parent.t)
local FFlagUseNavigationSelectors = require(Parent.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(Parent.NavigationRodux).Selectors
local FFlagSignalsNavP3gAvatarExperience = require(Parent.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local useSignalState = require(Parent.SignalsReact).useSignalState
local v12 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(Parent.NavigationRodux).GetLegacyNavigationStore
local v13 = Roact.PureComponent:extend("AvatarExperienceImpressionsDetector")

v13.validateProps = t.strictInterface({
	scanDebounceSeconds = t.optional(t.number),
	viewFillPercent = t.optional(t.number),
	parentRef = t.optional(t.table),
	onRequestImpressionsSignal = t.table,
	viewPortBounds = t.strictInterface({
		min = t.Vector2,
		max = t.Vector2
	}),
	appPage = t.optional(t.string),
	currentPage = t.optional(t.string),
	pageFilter = t.optional(t.callback),
	collectObjectsFunc = t.optional(t.callback),
	filterImpressionFunc = t.optional(t.callback),
	onImpressionsDetected = t.union(t.callback, t.table)
})
v13.defaultProps = {
	scanDebounceSeconds = 1,
	viewFillPercent = 0.25
}

function v13.init(p1) -- line: 62
	p1.isMounted = false
	p1.lastImpressionTick = nil
	p1.nextImpressionTick = nil
end
function v13._isInstanceVisible(p2, p3) -- line: 68
	-- upvalues: ArgCheck (copy)
	if not p3 then
		return false
	end

	local viewPortBounds = p2.props.viewPortBounds

	ArgCheck.assert(viewPortBounds ~= nil)

	if not viewPortBounds then
		return false
	end

	local v22 = viewPortBounds.max - viewPortBounds.min

	ArgCheck.assert(v22.X > 0)
	ArgCheck.assert(v22.Y > 0)

	local v23 = v22 * p2.props.viewFillPercent

	ArgCheck.assert(v23.X > 0 and v23.Y > 0)

	if v23.X <= 0 or v23.Y <= 0 then
		return false
	end

	local AbsolutePosition = p3.AbsolutePosition
	local v25 = AbsolutePosition + p3.AbsoluteSize / 2
	local v26 = AbsolutePosition + p3.AbsoluteSize
	local v27 = v25.X > viewPortBounds.min.X and v25.X < viewPortBounds.max.X
	local v28 = v25.Y > viewPortBounds.min.Y and v25.Y < viewPortBounds.max.Y

	if v27 and v28 then
		return true
	end

	local v29 = AbsolutePosition:Max(viewPortBounds.min)
	local v30 = v26:Min(viewPortBounds.max) - v29
	local v31 = v30.X >= v23.X

	if v28 and v31 then
		return true
	end

	local v32 = v30.Y >= v23.Y

	if v27 and v32 then
		return true
	end

	if v31 and v32 then
		return true
	end

	return false
end
function v13._defaultObjectCollector(p4) -- line: 132
	return p4:GetChildren()
end
function v13._calculateImpressions(p5) -- line: 136
	-- upvalues: ArgCheck (copy)
	if not p5.isMounted then
		return
	end

	if p5.props.pageFilter then
		if not p5.props.pageFilter(p5.props.currentPage) then
			return
		end
	elseif p5.props.appPage ~= p5.props.currentPage then
		return
	end

	local v35 = p5.props.parentRef and p5.props.parentRef.current

	if not v35 or not p5:_isInstanceVisible(v35) then
		return
	end

	p5.lastImpressionTick = tick()

	local t1 = {}
	local v37 = (p5.props.collectObjectsFunc or p5._defaultObjectCollector)(v35)

	if v37 then
		for _, v39 in v37 do
			if v39:IsA("GuiObject") and p5:_isInstanceVisible(v39) and (p5.props.filterImpressionFunc == nil or p5.props.filterImpressionFunc(v39)) then
				table.insert(t1, v39)
			end
		end
	end

	if #t1 > 0 then
		ArgCheck.assert(p5.props.onImpressionsDetected ~= nil)
		p5.props.onImpressionsDetected(t1)
	end
end
function v13._requestImpressions(p6) -- line: 176
	-- upvalues: ArgCheck (copy)
	if not p6.isMounted then
		return
	end

	if p6.nextImpressionTick ~= nil then
		return
	end

	if not p6.props.parentRef or not p6.props.parentRef.current then
		return
	end

	local n1 = 0

	if p6.lastImpressionTick ~= nil then
		p6.nextImpressionTick = p6.lastImpressionTick + p6.props.scanDebounceSeconds
		n1 = p6.nextImpressionTick - tick()
	end

	if n1 > 0 then
		task.delay(n1, function() -- line: 195
			-- upvalues: ArgCheck (copy), p6 (copy)
			ArgCheck.assert(p6.nextImpressionTick ~= nil and tick() > p6.nextImpressionTick)
			p6.nextImpressionTick = nil
			p6:_calculateImpressions()
		end)

		return
	end

	p6.nextImpressionTick = nil
	p6:_calculateImpressions()
end
function v13.render(_) -- line: 207
	return nil
end
function v13.didMount(p8) -- line: 211
	p8.isMounted = true
	p8:_requestImpressions()

	if p8.props.onRequestImpressionsSignal then
		p8.onRequestImpressionsConnection = p8.props.onRequestImpressionsSignal:connect(function() -- line: 215
			-- upvalues: p8 (copy)
			p8:_requestImpressions()
		end)
	end
end
function v13.willUnmount(p9) -- line: 221
	p9.isMounted = false

	if p9.onRequestImpressionsConnection ~= nil then
		p9.onRequestImpressionsConnection:disconnect()
		p9.onRequestImpressionsConnection = nil
	end
end
function v13.didUpdate(p10, _, _) -- line: 229
	p10:_requestImpressions()
end

if FFlagSignalsNavP3gAvatarExperience then
	local v14 = v13

	return function(p13) -- line: 235
		-- upvalues: v12 (copy), useSignalState (copy), React (copy), v14 (copy), Cryo (copy)
		local v49 = v12(false)
		local v50 = useSignalState(v49.getCurrentLegacyRoute)

		if not v50 then
			return React.createElement(v14, p13)
		end

		local v51 = v50[#v50]
		local v52 = v51 and v51.name or nil

		return React.createElement(v14, Cryo.Dictionary.union(p13, {
			currentPage = v52
		}))
	end
end

return (RoactRodux.connect(function(p14, _) -- line: 252
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	local t2 = {}
	local v56

	if FFlagUseNavigationSelectors then
		v56 = Selectors.selectCurrentPageName(p14)
	else
		local history = p14.Navigation.history
		local v58 = history[#history]

		v56 = v58[#v58].name
	end

	t2.currentPage = v56

	return t2
end)(v13))
