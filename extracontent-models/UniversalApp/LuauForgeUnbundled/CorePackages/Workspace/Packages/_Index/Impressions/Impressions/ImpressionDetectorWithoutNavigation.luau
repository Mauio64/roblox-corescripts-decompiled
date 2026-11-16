local CollectionService = game:GetService("CollectionService")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/Roact")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/ArgCheck")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/t")
local fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/SharedFlags").FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/Constants")

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

v5.isFocused = t.optional(t.boolean)
v5.navigation = t.optional(t.table)
extended.validateProps = strictInterface(v5)

extended.defaultProps = { scanDebounceSeconds = 1, viewFillPercent = 0.25 }

function extended:init()
	self.isMounted = false
	self.lastImpressionTick = nil
	self.nextImpressionTick = nil
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
	local v7 = absolutePosition + absoluteSize

	local v8 = v7.X > viewPortBounds.min.X and absolutePosition.X < viewPortBounds.max.X
	local v9 = v7.Y > viewPortBounds.min.Y and absolutePosition.Y < viewPortBounds.max.Y

	if v8 and v9 then
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
	local v7

	if fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		v7 = self.props.viewPortFillBounds or viewPortBounds
	else
		v7 = viewPortBounds
	end

	local v8 = v7.max - v7.min

	if v8.X <= 0 or v8.Y <= 0 then
		return false
	end

	local v9 = v8 * self.props.viewFillPercent

	ArgCheck.assert(v9.X > 0 and v9.Y > 0)

	if v9.X <= 0 or v9.Y <= 0 then
		return false
	end

	local absolutePosition = p2.AbsolutePosition
	local absoluteSize = p2.AbsoluteSize

	if self.props.skipZeroSizes and (absoluteSize.X == 0 or absoluteSize.Y == 0) then
		return false
	end

	local v11 = absolutePosition + absoluteSize / 2
	local v12 = absolutePosition + absoluteSize

	local v13 = v11.X > viewPortBounds.min.X and v11.X < viewPortBounds.max.X
	local v14 = v11.Y > viewPortBounds.min.Y and v11.Y < viewPortBounds.max.Y

	if v13 and v14 then
		return true
	end

	local max = absolutePosition:Max(viewPortBounds.min)
	local v15 = v12:Min(viewPortBounds.max) - max

	local v16 = v15.X >= v9.X

	if v14 and v16 then
		return true
	end

	local v17 = v15.Y >= v9.Y

	if v13 and v17 or v16 and v17 then
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
			return
		end
	end

	local tagged = CollectionService:GetTagged(self.props.impressionsTag)
	local attributes = {}

	for i, guiObject in ipairs(tagged) do
		local attribute = guiObject:GetAttribute(Constants.ItemIndex)

		if not (attribute and guiObject:IsA("GuiObject") and self:_isInstanceVisible(guiObject)) then
			continue
		end

		if not (self.props.filterImpressionFunc == nil or self.props.filterImpressionFunc(attribute)) then
			continue
		end

		table.insert(attributes, attribute)
	end

	if #attributes > 0 then
		ArgCheck.assert(self.props.onImpressionsDetected ~= nil)
		self.props.onImpressionsDetected(attributes)
	end
end

function extended:_requestImpressions()
	if not (self.isMounted and self.props.isFocused ~= false and self.nextImpressionTick == nil and self.props.impressionsTag) then
		return
	end

	local v7

	if self.lastImpressionTick == nil then
		v7 = 0
	else
		self.nextImpressionTick = self.lastImpressionTick + self.props.scanDebounceSeconds
		v7 = self.nextImpressionTick - tick()
	end

	if v7 > 0 then
		task.delay(v7, function()
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

function extended:didUpdate(p2, p3)
	self:_requestImpressions()
end

return extended
