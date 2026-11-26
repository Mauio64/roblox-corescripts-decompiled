local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Roact")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/RoactRodux")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/ArgCheck")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/t")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SharedFlags").FFlagUseNavigationSelectors
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/NavigationRodux").Selectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SharedFlags").FFlagSignalsNavP3gAvatarExperience

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SignalsReact").useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local extended = Roact.PureComponent:extend("AvatarExperienceImpressionsDetector")

local strictInterface = t.strictInterface
local v5 = {
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
	pageEligible = 0,
	pageFilter = 0,
	collectObjectsFunc = 0,
	filterImpressionFunc = 0,
	onImpressionsDetected = 0
}

local v6 = if fFlagSignalsNavP3gAvatarExperience then t.optional(t.boolean) else nil
v5.pageEligible = v6
v5.pageFilter = t.optional(t.callback)
v5.collectObjectsFunc = t.optional(t.callback)
v5.filterImpressionFunc = t.optional(t.callback)
v5.onImpressionsDetected = t.union(t.callback, t.table)
extended.validateProps = strictInterface(v5)

extended.defaultProps = { scanDebounceSeconds = 1, viewFillPercent = 0.25 }

function extended:init()
	self.isMounted = false
	self.lastImpressionTick = nil
	self.nextImpressionTick = nil
end

function extended:_isInstanceVisible(p3): boolean
	if not p3 then
		return false
	end

	local viewPortBounds = self.props.viewPortBounds
	ArgCheck.assert(viewPortBounds ~= nil)

	if not viewPortBounds then
		return false
	end

	local v7 = viewPortBounds.max - viewPortBounds.min
	ArgCheck.assert(v7.X > 0)
	ArgCheck.assert(v7.Y > 0)
	local v8 = v7 * self.props.viewFillPercent

	ArgCheck.assert(v8.X > 0 and v8.Y > 0)

	if v8.X <= 0 or v8.Y <= 0 or (p3.AbsoluteSize.X <= 0 or p3.AbsoluteSize.Y <= 0) then
		return false
	end

	local absolutePosition = p3.AbsolutePosition
	local v10 = absolutePosition + p3.AbsoluteSize / 2
	local v11 = absolutePosition + p3.AbsoluteSize

	local v12 = v10.X > viewPortBounds.min.X and v10.X < viewPortBounds.max.X
	local v13 = v10.Y > viewPortBounds.min.Y and v10.Y < viewPortBounds.max.Y

	if v12 and v13 then
		return true
	end

	local max = absolutePosition:Max(viewPortBounds.min)
	local v14 = v11:Min(viewPortBounds.max) - max

	local v15 = v14.X >= v8.X

	if v13 and v15 then
		return true
	end

	local v16 = v14.Y >= v8.Y

	if v12 and v16 or v15 and v16 then
		return true
	end

	return false
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
	elseif fFlagSignalsNavP3gAvatarExperience then
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
	local v7 = (self.props.collectObjectsFunc or self._defaultObjectCollector)(current)

	if v7 then
		for k, guiObject in v7 do
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

if fFlagSignalsNavP3gAvatarExperience then
	return function(p2)
		local v7 = useSignalState(getLegacyNavigationStore(false).getCurrentPageName)

		local v8 = p2.pageFilter and { currentPage = v7 } or {
			pageEligible = p2.appPage == v7
		}

		return React.createElement(extended, Cryo.Dictionary.union(p2, v8))
	end
end

return (RoactRodux.connect(function(p2, p3)
	local v8

	if fFlagUseNavigationSelectors then
		v8 = selectors.selectCurrentPageName(p2)
	else
		local history = p2.Navigation.history
		local v9 = history[#history]
		v8 = v9[#v9].name
	end

	return { currentPage = v8 }
end)(extended))
