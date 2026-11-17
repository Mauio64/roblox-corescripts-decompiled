local CollectionService = game:GetService("CollectionService")
local parent = script:FindFirstAncestor("Impressions").Parent

local Roact = require(parent.Roact)
local ArgCheck = require(parent.ArgCheck)
local t = require(parent.t)
local SharedFlags = require(parent.SharedFlags)
local Constants = require(script.Parent.Constants)

local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions

local FFlagLuaAppSduiGameDwell = SharedFlags.FFlagLuaAppSduiGameDwell

local extended = Roact.PureComponent:extend("ImpressionsDetectorWithoutNavigation")

local strictInterface = t.strictInterface
local v = {
	scanDebounceSeconds = t.optional(t.number),
	viewFillPercent = t.optional(t.number),
	parentRef = t.optional(t.table),
	impressionsTag = t.string,
	onRequestImpressionsSignal = t.table,
	viewPortBounds = t.strictInterface({ min = t.Vector2, max = t.Vector2 }),
	viewPortFillBounds = 0,
	filterImpressionFunc = 0,
	onImpressionsDetected = 0,
	skipZeroSizes = 0,
	visibilityObserver = 0,
	isFocused = 0,
	navigation = 0
}
local viewPortFillBounds

if FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
	viewPortFillBounds = t.optional(t.strictInterface({ min = t.Vector2, max = t.Vector2 }))
end

v.viewPortFillBounds = viewPortFillBounds

v.filterImpressionFunc = t.optional(t.callback)
v.onImpressionsDetected = t.union(t.callback, t.table)
v.skipZeroSizes = t.optional(t.boolean)
local visibilityObserver

if FFlagLuaAppSduiGameDwell then
	visibilityObserver = t.optional(t.table)
end

v.visibilityObserver = visibilityObserver

v.isFocused = t.optional(t.boolean)
v.navigation = t.optional(t.table)
extended.validateProps = strictInterface(v)

extended.defaultProps = { scanDebounceSeconds = 1, viewFillPercent = 0.25 }

function extended:init()
	self.isMounted = false
	self.lastImpressionTick = nil
	self.nextImpressionTick = nil

	if FFlagLuaAppSduiGameDwell then
		self.visibilityObserverCleanup = nil
	end
end

if FFlagLuaAppSduiGameDwell then
	function extended:_attachVisibilityObserver()
		if self.props.visibilityObserver then
			self.visibilityObserverCleanup = self.props.visibilityObserver.attach(function()
				self:_requestImpressions()
			end, self.props.scanDebounceSeconds)
		end
	end
end

function extended:_boundingBoxIntersectsView(p): boolean
	if not p then
		return false
	end

	local viewPortBounds = self.props.viewPortBounds
	ArgCheck.assert(viewPortBounds ~= nil)

	if not viewPortBounds then
		return false
	end

	local absoluteSize = p.AbsoluteSize
	local absolutePosition = p.AbsolutePosition
	local v2 = absolutePosition + absoluteSize
	local v3

	if v2.X > viewPortBounds.min.X then
		v3 = absolutePosition.X < viewPortBounds.max.X
	else
		v3 = false
	end

	local v4

	if v2.Y > viewPortBounds.min.Y then
		v4 = absolutePosition.Y < viewPortBounds.max.Y
	else
		v4 = false
	end

	return if v3 and v4 then true else false
end

function extended:_isInstanceVisible(p): boolean
	if not self:_boundingBoxIntersectsView(p) then
		return false
	end

	local viewPortBounds = self.props.viewPortBounds
	ArgCheck.assert(viewPortBounds ~= nil)
	local v2

	if FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		v2 = self.props.viewPortFillBounds or viewPortBounds
	else
		v2 = viewPortBounds
	end

	local v3 = v2.max - v2.min

	if v3.X <= 0 or v3.Y <= 0 then
		return false
	end

	local v4 = v3 * self.props.viewFillPercent

	ArgCheck.assert(v4.X > 0 and v4.Y > 0)

	if v4.X <= 0 or v4.Y <= 0 then
		return false
	end

	local absolutePosition = p.AbsolutePosition
	local absoluteSize = p.AbsoluteSize

	if self.props.skipZeroSizes and (absoluteSize.X == 0 or absoluteSize.Y == 0) then
		return false
	end

	local v5 = absolutePosition + absoluteSize / 2
	local v6 = absolutePosition + absoluteSize
	local v7

	if v5.X > viewPortBounds.min.X then
		v7 = v5.X < viewPortBounds.max.X
	else
		v7 = false
	end

	local v8

	if v5.Y > viewPortBounds.min.Y then
		v8 = v5.Y < viewPortBounds.max.Y
	else
		v8 = false
	end

	if v7 and v8 then
		return true
	end

	local max = absolutePosition:Max(viewPortBounds.min)
	local v9 = v6:Min(viewPortBounds.max) - max

	local v10 = v9.X >= v4.X

	if v8 and v10 then
		return true
	end

	local v11 = v9.Y >= v4.Y
	return if v7 and v11 or v10 and v11 then true else false
end

function extended:_calculateImpressions()
	if not (self.isMounted and self.props.isFocused ~= false) then
		return
	end

	self.lastImpressionTick = tick()

	if self.props.parentRef ~= nil then
		local current = self.props.parentRef.current

		if current == nil or not self:_boundingBoxIntersectsView(current) then
			if FFlagLuaAppSduiGameDwell and self.props.visibilityObserver then
				self.props.visibilityObserver.sample({}, current ~= nil)
			end

			return
		end
	end

	local impressionsTag = self.props.impressionsTag

	local attributes = FFlagLuaAppSduiGameDwell and self.props.visibilityObserver and {} or nil

	local tagged = CollectionService:GetTagged(impressionsTag)
	local attributes2 = {}

	for _, guiObject in ipairs(tagged) do
		local attribute = guiObject:GetAttribute(Constants.ItemIndex)

		if not (attribute and guiObject:IsA("GuiObject") and self:_isInstanceVisible(guiObject)) then
			continue
		end

		if FFlagLuaAppSduiGameDwell and attributes then
			table.insert(attributes, attribute)
		end

		if self.props.filterImpressionFunc == nil or self.props.filterImpressionFunc(attribute) then
			table.insert(attributes2, attribute)
		end
	end

	if FFlagLuaAppSduiGameDwell and attributes then
		self.props.visibilityObserver.sample(attributes, true)
	end

	if #attributes2 > 0 then
		ArgCheck.assert(self.props.onImpressionsDetected ~= nil)
		self.props.onImpressionsDetected(attributes2)
	end
end

function extended:_requestImpressions()
	if not (self.isMounted and self.props.isFocused ~= false and self.nextImpressionTick == nil and self.props.impressionsTag) then
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

	if FFlagLuaAppSduiGameDwell then
		self:_attachVisibilityObserver()
	end

	self:_requestImpressions()

	if self.props.onRequestImpressionsSignal then
		self.onRequestImpressionsConnection = self.props.onRequestImpressionsSignal:connect(function()
			self:_requestImpressions()
		end)
	end
end

function extended:willUnmount()
	self.isMounted = false

	if FFlagLuaAppSduiGameDwell and self.visibilityObserverCleanup then
		self.visibilityObserverCleanup("teardown")
		self.visibilityObserverCleanup = nil
	end

	if self.onRequestImpressionsConnection ~= nil then
		self.onRequestImpressionsConnection:disconnect()
		self.onRequestImpressionsConnection = nil
	end
end

function extended:didUpdate(p, _)
	if FFlagLuaAppSduiGameDwell then
		if p.visibilityObserver == self.props.visibilityObserver then
			if self.props.visibilityObserver and p.isFocused ~= self.props.isFocused then
				self.props.visibilityObserver.focusChanged(self.props.isFocused ~= false)
			end
		else
			if self.visibilityObserverCleanup then
				self.visibilityObserverCleanup("collectionReplaced")
				self.visibilityObserverCleanup = nil
			end

			self:_attachVisibilityObserver()
		end
	end

	self:_requestImpressions()
end

return extended
