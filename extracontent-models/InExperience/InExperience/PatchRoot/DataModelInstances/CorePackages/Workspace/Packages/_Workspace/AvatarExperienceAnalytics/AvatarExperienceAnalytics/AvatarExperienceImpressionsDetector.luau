local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local ArgCheck = require(parent.ArgCheck)
local t = require(parent.t)
local SharedFlags = require(parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local NavigationRodux = require(parent.NavigationRodux)
local Selectors = NavigationRodux.Selectors

local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3gAvatarExperience = SharedFlags2.FFlagSignalsNavP3gAvatarExperience

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if FFlagSignalsNavP3gAvatarExperience then
	local NavigationRodux2 = require(parent.NavigationRodux)
	getLegacyNavigationStore = NavigationRodux2.GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local extended = Roact.PureComponent:extend("AvatarExperienceImpressionsDetector")

local strictInterface = t.strictInterface
local v = {
	scanDebounceSeconds = t.optional(t.number),
	viewFillPercent = t.optional(t.number),
	parentRef = t.optional(t.table),
	onRequestImpressionsSignal = t.table,
	viewPortBounds = t.strictInterface({ min = t.Vector2, max = t.Vector2 }),
	appPage = t.optional(t.string),
	currentPage = t.optional(t.string),
	pageEligible = 0,
	pageFilter = 0,
	collectObjectsFunc = 0,
	filterImpressionFunc = 0,
	onImpressionsDetected = 0
}
local pageEligible

if FFlagSignalsNavP3gAvatarExperience then
	pageEligible = t.optional(t.boolean)
end

v.pageEligible = pageEligible
v.pageFilter = t.optional(t.callback)
v.collectObjectsFunc = t.optional(t.callback)
v.filterImpressionFunc = t.optional(t.callback)
v.onImpressionsDetected = t.union(t.callback, t.table)
extended.validateProps = strictInterface(v)

extended.defaultProps = { scanDebounceSeconds = 1, viewFillPercent = 0.25 }

function extended:init()
	self.isMounted = false
	self.lastImpressionTick = nil
	self.nextImpressionTick = nil
end

function extended:_isInstanceVisible(p): boolean
	if not p then
		return false
	end

	local viewPortBounds = self.props.viewPortBounds
	ArgCheck.assert(viewPortBounds ~= nil)

	if not viewPortBounds then
		return false
	end

	local v2 = viewPortBounds.max - viewPortBounds.min
	ArgCheck.assert(v2.X > 0)
	ArgCheck.assert(v2.Y > 0)
	local v3 = v2 * self.props.viewFillPercent

	ArgCheck.assert(v3.X > 0 and v3.Y > 0)

	if v3.X <= 0 or v3.Y <= 0 or (p.AbsoluteSize.X <= 0 or p.AbsoluteSize.Y <= 0) then
		return false
	end

	local absolutePosition = p.AbsolutePosition
	local v4 = absolutePosition + p.AbsoluteSize / 2
	local v5 = absolutePosition + p.AbsoluteSize
	local v6

	if v4.X > viewPortBounds.min.X then
		v6 = v4.X < viewPortBounds.max.X
	else
		v6 = false
	end

	local v7

	if v4.Y > viewPortBounds.min.Y then
		v7 = v4.Y < viewPortBounds.max.Y
	else
		v7 = false
	end

	if v6 and v7 then
		return true
	end

	local max = absolutePosition:Max(viewPortBounds.min)
	local v8 = v5:Min(viewPortBounds.max) - max

	local v9 = v8.X >= v3.X

	if v7 and v9 then
		return true
	end

	local v10 = v8.Y >= v3.Y
	return if v6 and v10 or v9 and v10 then true else false
end

function extended._defaultObjectCollector(instance)
	return instance:GetChildren()
end

function extended:_calculateImpressions()
	if not self.isMounted then
		return
	end

	if self.props.pageFilter then
		if not self.props.pageFilter(self.props.currentPage) then
			return
		end
	elseif FFlagSignalsNavP3gAvatarExperience then
		if not self.props.pageEligible then
			return
		end
	elseif self.props.appPage ~= self.props.currentPage then
		return
	end

	local current = self.props.parentRef and self.props.parentRef.current

	if not (current and self:_isInstanceVisible(current)) then
		return
	end

	self.lastImpressionTick = tick()
	local guiObjects = {}
	local v2 = (self.props.collectObjectsFunc or self._defaultObjectCollector)(current)

	if v2 then
		for _, guiObject in v2 do
			if not (guiObject:IsA("GuiObject") and self:_isInstanceVisible(guiObject) and (self.props.filterImpressionFunc == nil or self.props.filterImpressionFunc(guiObject))) then
				continue
			end

			table.insert(guiObjects, guiObject)
		end
	end

	if #guiObjects > 0 then
		ArgCheck.assert(self.props.onImpressionsDetected ~= nil)
		self.props.onImpressionsDetected(guiObjects)
	end
end

function extended:_requestImpressions()
	if not (self.isMounted and self.nextImpressionTick == nil and (self.props.parentRef and self.props.parentRef.current)) then
		return
	end

	local v2

	if self.lastImpressionTick == nil then
		v2 = 0
	else
		self.nextImpressionTick = self.lastImpressionTick + self.props.scanDebounceSeconds
		v2 = self.nextImpressionTick - tick()
	end

	if v2 > 0 then
		task.delay(v2, function()
			ArgCheck.assert(self.nextImpressionTick ~= nil and tick() > self.nextImpressionTick)
			self.nextImpressionTick = nil
			self:_calculateImpressions()
		end)
		return
	end

	self.nextImpressionTick = nil
	self:_calculateImpressions()
end

function extended.render(_): nil
	return nil
end

function extended:didMount()
	self.isMounted = true
	self:_requestImpressions()

	if self.props.onRequestImpressionsSignal then
		self.onRequestImpressionsConnection = self.props.onRequestImpressionsSignal:connect(function()
			self:_requestImpressions()
		end)
	end
end

function extended:willUnmount()
	self.isMounted = false

	if self.onRequestImpressionsConnection ~= nil then
		self.onRequestImpressionsConnection:disconnect()
		self.onRequestImpressionsConnection = nil
	end
end

function extended:didUpdate(_, _)
	self:_requestImpressions()
end

if FFlagSignalsNavP3gAvatarExperience then
	return function(p)
		local currentPage = useSignalState(getLegacyNavigationStore(false).getCurrentPageName)

		local v2 = p.pageFilter and { currentPage = currentPage } or {
			pageEligible = p.appPage == currentPage
		}

		return React.createElement(extended, Cryo.Dictionary.union(p, v2))
	end
end

local function fn(p) -- 1 equivalent call inferred from this helper
	if FFlagUseNavigationSelectors then
		return Selectors.selectCurrentPageName(p)
	end

	local history = p.Navigation.history
	local v2 = history[#history]
	return v2[#v2].name
end

return (RoactRodux.connect(function(p, _)
	return { currentPage = fn(p) } -- inferred equivalent call
end)(extended))
