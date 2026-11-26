local CollectionService = game:GetService("CollectionService")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/Roact")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/ArgCheck")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/t")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/SharedFlags")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/Constants")

local fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions

local fFlagLuaAppSduiGameDwell = SharedFlags.FFlagLuaAppSduiGameDwell

local extended = Roact.PureComponent:extend("ImpressionsDetectorWithoutNavigation")

local strictInterface = t.strictInterface
local v5 = {
	scanDebounceSeconds = t.optional(t.number),
	viewFillPercent = t.optional(t.number),
	parentRef = t.optional(t.table),
	impressionsTag = t.string,
	onRequestImpressionsSignal = t.table,
	viewPortBounds = t.strictInterface({
		min = t.Vector2,
		max = t.Vector2
	}),
	viewPortFillBounds = 0,
	filterImpressionFunc = 0,
	onImpressionsDetected = 0,
	skipZeroSizes = 0,
	visibilityObserver = 0,
	isFocused = 0,
	navigation = 0
}

local v6 = if fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then t.optional(t.strictInterface({
	min = t.Vector2,
	max = t.Vector2
})) else nil
v5.viewPortFillBounds = v6

v5.filterImpressionFunc = t.optional(t.callback)
v5.onImpressionsDetected = t.union(t.callback, t.table)
v5.skipZeroSizes = t.optional(t.boolean)
local v7 = if fFlagLuaAppSduiGameDwell then t.optional(t.table) else nil
v5.visibilityObserver = v7

v5.isFocused = t.optional(t.boolean)
v5.navigation = t.optional(t.table)
extended.validateProps = strictInterface(v5)

extended.defaultProps = { scanDebounceSeconds = 1, viewFillPercent = 0.25 }

function extended:init()
	self.isMounted = false
	self.lastImpressionTick = nil
	self.nextImpressionTick = nil

	if fFlagLuaAppSduiGameDwell then
		self.visibilityObserverCleanup = nil
	end
end

if fFlagLuaAppSduiGameDwell then
	function extended:_attachVisibilityObserver()
		if self.props.visibilityObserver then
			self.visibilityObserverCleanup = self.props.visibilityObserver.attach(function()
				self:_requestImpressions()
			end, self.props.scanDebounceSeconds)
		end
	end
end

function extended:_boundingBoxIntersectsView(p3): boolean
	if not p3 then
		return false
	end

	local viewPortBounds = self.props.viewPortBounds
	ArgCheck.assert(viewPortBounds ~= nil)

	if not viewPortBounds then
		return false
	end

	local absoluteSize = p3.AbsoluteSize
	local absolutePosition = p3.AbsolutePosition
	local v8 = absolutePosition + absoluteSize

	local v9 = v8.X > viewPortBounds.min.X and absolutePosition.X < viewPortBounds.max.X
	local v10 = v8.Y > viewPortBounds.min.Y and absolutePosition.Y < viewPortBounds.max.Y

	if v9 and v10 then
		return true
	end

	return false
end

function extended:_isInstanceVisible(p2): boolean
	if not self:_boundingBoxIntersectsView(p2) then
		return false
	end

	local viewPortBounds = self.props.viewPortBounds
	ArgCheck.assert(viewPortBounds ~= nil)
	local v8

	if fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		v8 = self.props.viewPortFillBounds or viewPortBounds
	else
		v8 = viewPortBounds
	end

	local v9 = v8.max - v8.min

	if v9.X <= 0 or v9.Y <= 0 then
		return false
	end

	local v10 = v9 * self.props.viewFillPercent

	ArgCheck.assert(v10.X > 0 and v10.Y > 0)

	if v10.X <= 0 or v10.Y <= 0 then
		return false
	end

	local absolutePosition = p2.AbsolutePosition
	local absoluteSize = p2.AbsoluteSize

	if self.props.skipZeroSizes and (absoluteSize.X == 0 or absoluteSize.Y == 0) then
		return false
	end

	local v12 = absolutePosition + absoluteSize / 2
	local v13 = absolutePosition + absoluteSize

	local v14 = v12.X > viewPortBounds.min.X and v12.X < viewPortBounds.max.X
	local v15 = v12.Y > viewPortBounds.min.Y and v12.Y < viewPortBounds.max.Y

	if v14 and v15 then
		return true
	end

	local max = absolutePosition:Max(viewPortBounds.min)
	local v16 = v13:Min(viewPortBounds.max) - max

	local v17 = v16.X >= v10.X

	if v15 and v17 then
		return true
	end

	local v18 = v16.Y >= v10.Y

	if v14 and v18 or v17 and v18 then
		return true
	end

	return false
end

function extended:_calculateImpressions()
	if not (self.isMounted and self.props.isFocused ~= false) then
		return
	end

	self.lastImpressionTick = tick()

	if self.props.parentRef ~= nil then
		local current = self.props.parentRef.current

		if current == nil or not self:_boundingBoxIntersectsView(current) then
			if fFlagLuaAppSduiGameDwell and self.props.visibilityObserver then
				self.props.visibilityObserver.sample({}, current ~= nil)
			end

			return
		end
	end

	local impressionsTag = self.props.impressionsTag

	local attributes = fFlagLuaAppSduiGameDwell and self.props.visibilityObserver and {} or nil

	local tagged = CollectionService:GetTagged(impressionsTag)
	local attributes2 = {}

	for i, guiObject in ipairs(tagged) do
		local attribute = guiObject:GetAttribute(Constants.ItemIndex)

		if not (attribute and guiObject:IsA("GuiObject") and self:_isInstanceVisible(guiObject)) then
			continue
		end

		if fFlagLuaAppSduiGameDwell and attributes then
			table.insert(attributes, attribute)
		end

		if self.props.filterImpressionFunc == nil or self.props.filterImpressionFunc(attribute) then
			table.insert(attributes2, attribute)
		end
	end

	if fFlagLuaAppSduiGameDwell and attributes then
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

	local v8

	if self.lastImpressionTick == nil then
		v8 = 0
	else
		self.nextImpressionTick = self.lastImpressionTick + self.props.scanDebounceSeconds
		v8 = self.nextImpressionTick - tick()
	end

	if v8 > 0 then
		task.delay(v8, function()
			ArgCheck.assert(self.nextImpressionTick ~= nil and tick() > self.nextImpressionTick)
			self.nextImpressionTick = nil
			self:_calculateImpressions()
		end)
		return
	end

	self.nextImpressionTick = nil
	self:_calculateImpressions()
end

function extended.render(p2): nil
	return nil
end

function extended:didMount()
	self.isMounted = true

	if fFlagLuaAppSduiGameDwell then
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

	if fFlagLuaAppSduiGameDwell and self.visibilityObserverCleanup then
		self.visibilityObserverCleanup("teardown")
		self.visibilityObserverCleanup = nil
	end

	if self.onRequestImpressionsConnection ~= nil then
		self.onRequestImpressionsConnection:disconnect()
		self.onRequestImpressionsConnection = nil
	end
end

function extended:didUpdate(p2, p3)
	if fFlagLuaAppSduiGameDwell then
		if p2.visibilityObserver == self.props.visibilityObserver then
			if self.props.visibilityObserver and p2.isFocused ~= self.props.isFocused then
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
