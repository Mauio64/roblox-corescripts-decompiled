local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local Roact = require(Parent.Roact)
local RoactRodux = require(Parent.RoactRodux)
local ArgCheck = require(Parent.ArgCheck)
local t = require(Parent.t)
local FFlagUseNavigationSelectors = require(Parent.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(Parent.NavigationRodux).Selectors
local FFlagSignalsNavP3gAvatarExperience = require(Parent.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local FFlagAXSduiCatalogScrollImpressions = require(Parent.AvatarExperienceFlags).FFlagAXSduiCatalogScrollImpressions
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local useSignalState = require(Parent.SignalsReact).useSignalState
local v13 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(Parent.NavigationRodux).GetLegacyNavigationStore
local v14 = Roact.PureComponent:extend("AvatarExperienceImpressionsDetector")

v14.validateProps = t.strictInterface({
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
v14.defaultProps = {
	scanDebounceSeconds = 1,
	viewFillPercent = 0.25
}

function v14.init(p1) -- line: 65
	p1.isMounted = false
	p1.lastImpressionTick = nil
	p1.nextImpressionTick = nil
end
function v14._isInstanceVisible(p2, p3) -- line: 71
	-- upvalues: ArgCheck (copy), FFlagAXSduiCatalogScrollImpressions (copy)
	if not p3 then
		return false
	end

	local viewPortBounds = p2.props.viewPortBounds

	ArgCheck.assert(viewPortBounds ~= nil)

	if not viewPortBounds then
		return false
	end

	local v23 = viewPortBounds.max - viewPortBounds.min

	ArgCheck.assert(v23.X > 0)
	ArgCheck.assert(v23.Y > 0)

	local v24 = v23 * p2.props.viewFillPercent

	ArgCheck.assert(v24.X > 0 and v24.Y > 0)

	if v24.X <= 0 or v24.Y <= 0 then
		return false
	end

	if FFlagAXSduiCatalogScrollImpressions and (p3.AbsoluteSize.X <= 0 or p3.AbsoluteSize.Y <= 0) then
		return false
	end

	local AbsolutePosition = p3.AbsolutePosition
	local v26 = AbsolutePosition + p3.AbsoluteSize / 2
	local v27 = AbsolutePosition + p3.AbsoluteSize
	local v28 = v26.X > viewPortBounds.min.X and v26.X < viewPortBounds.max.X
	local v29 = v26.Y > viewPortBounds.min.Y and v26.Y < viewPortBounds.max.Y

	if v28 and v29 then
		return true
	end

	local v30 = AbsolutePosition:Max(viewPortBounds.min)
	local v31 = v27:Min(viewPortBounds.max) - v30
	local v32 = v31.X >= v24.X

	if v29 and v32 then
		return true
	end

	local v33 = v31.Y >= v24.Y

	if v28 and v33 then
		return true
	end

	if v32 and v33 then
		return true
	end

	return false
end
function v14._defaultObjectCollector(p4) -- line: 139
	return p4:GetChildren()
end
function v14._calculateImpressions(p5) -- line: 143
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

	local v36 = p5.props.parentRef and p5.props.parentRef.current

	if not v36 or not p5:_isInstanceVisible(v36) then
		return
	end

	p5.lastImpressionTick = tick()

	local t1 = {}
	local v38 = (p5.props.collectObjectsFunc or p5._defaultObjectCollector)(v36)

	if v38 then
		for _, v40 in v38 do
			if v40:IsA("GuiObject") and p5:_isInstanceVisible(v40) and (p5.props.filterImpressionFunc == nil or p5.props.filterImpressionFunc(v40)) then
				table.insert(t1, v40)
			end
		end
	end

	if #t1 > 0 then
		ArgCheck.assert(p5.props.onImpressionsDetected ~= nil)
		p5.props.onImpressionsDetected(t1)
	end
end
function v14._requestImpressions(p6) -- line: 183
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
		task.delay(n1, function() -- line: 202
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
function v14.render(_) -- line: 214
	return nil
end
function v14.didMount(p8) -- line: 218
	p8.isMounted = true
	p8:_requestImpressions()

	if p8.props.onRequestImpressionsSignal then
		p8.onRequestImpressionsConnection = p8.props.onRequestImpressionsSignal:connect(function() -- line: 222
			-- upvalues: p8 (copy)
			p8:_requestImpressions()
		end)
	end
end
function v14.willUnmount(p9) -- line: 228
	p9.isMounted = false

	if p9.onRequestImpressionsConnection ~= nil then
		p9.onRequestImpressionsConnection:disconnect()
		p9.onRequestImpressionsConnection = nil
	end
end
function v14.didUpdate(p10, _, _) -- line: 236
	p10:_requestImpressions()
end

if FFlagSignalsNavP3gAvatarExperience then
	local v15 = v14

	return function(p13) -- line: 242
		-- upvalues: v13 (copy), useSignalState (copy), React (copy), v15 (copy), Cryo (copy)
		local v50 = v13(false)
		local v51 = useSignalState(v50.getCurrentPageName)

		return React.createElement(v15, Cryo.Dictionary.union(p13, {
			currentPage = v51
		}))
	end
end

return (RoactRodux.connect(function(p14, _) -- line: 255
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	local t2 = {}
	local v55

	if FFlagUseNavigationSelectors then
		v55 = Selectors.selectCurrentPageName(p14)
	else
		local history = p14.Navigation.history
		local v57 = history[#history]

		v55 = v57[#v57].name
	end

	t2.currentPage = v55

	return t2
end)(v14))
