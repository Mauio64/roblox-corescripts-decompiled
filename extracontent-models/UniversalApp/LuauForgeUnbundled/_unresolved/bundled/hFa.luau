local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError
local impressionsTagUtility = require("@luauforge/bundled/edd").ImpressionsTagUtility
local module = require("@luauforge/bundled/dHu")
local useNavBarPlacement = module.useNavBarPlacement
local omniFeedService = require("@luauforge/bundled/dAZ").OmniFeedService
local omniFeedConstants = require("@luauforge/bundled/cyO").OmniFeedConstants

local extended = Roact.PureComponent:extend("OmniFeedItem")

extended.validateProps = t.strictInterface({
	omniFeedItemType = t.string,
	layoutOrder = t.optional(t.number),
	zIndex = t.optional(t.number),
	impressionsTag = t.string,
	itemIndex = t.number,
	feedItemNameId = t.string,
	itemProps = t.optional(t.table),
	onAbsoluteSizeChanged = t.optional(t.callback),
	defaultFocusRef = t.optional(t.callback),
	navBarPlacement = t.valueOf(module.Placement),
	eventIngest = t.any
})

function extended:init()
	self.feedItemRef = Roact.createRef()
	function self.containerRef(current)
		if self.props.defaultFocusRef then
			self.props.defaultFocusRef(current)
		end

		self.feedItemRef.current = current
	end

	self.descendantGuiButtons = {}

	function self.addDescendantGuiButton(instance)
		local v5 = instance:GetAttribute("GUID")

		if v5 == nil then
			v5 = HttpService:GenerateGUID()
			instance:SetAttribute("GUID", v5)
		end

		if self.descendantGuiButtons[v5] then
			self.descendantGuiButtons[v5].connection:Disconnect()
			self.descendantGuiButtons[v5] = nil
		end

		local activatedConnection = instance.Activated:Connect(function(p2)
			if not self.isMounted then
				return
			end

			self.props.eventIngest:setRBXEventStream(omniFeedConstants.EventContext, "feedItemClicked", {
				fullPath = instance:GetFullName(),
				treatmentType = self.props.omniFeedItemType,
				feedItemPos = self.props.layoutOrder,
				feedItemNameId = self.props.feedItemNameId
			})
		end)

		self.descendantGuiButtons[v5] = {
			name = instance.Name,
			connection = activatedConnection
		}
	end

	function self.removeDescendantGuiButton(p2)
		if p2 == nil or not self.descendantGuiButtons[p2] then
			if self.isMounted and not self.descendantGuiButtonError then
				self.descendantGuiButtonError = true
				mutedError(`OmniFeedItem: Expecting descendant button for guid: {p2}, feedItemNameId: {self.props.feedItemNameId}`)
			end
		else
			self.descendantGuiButtons[p2].connection:Disconnect()
			self.descendantGuiButtons[p2] = nil
		end
	end

	function self.descendantAdded(button)
		if button and button:IsA("GuiButton") then
			self.addDescendantGuiButton(button)
		end
	end

	function self.descendantRemoving(button)
		if button and button:IsA("GuiButton") then
			local guid = button:GetAttribute("GUID")
			self.removeDescendantGuiButton(guid)
		end
	end

	function self.addAllDescendantGuiButtons()
		local current = self.feedItemRef and self.feedItemRef.current

		local descendants = current and current:GetDescendants()

		if descendants then
			for k, descendant in pairs(descendants) do
				self.descendantAdded(descendant)
			end
		end
	end

	function self.removeAllDescendantGuiButtons()
		for k, descendantGuiButton in pairs(self.descendantGuiButtons) do
			self.removeDescendantGuiButton(k)
		end

		self.descendantGuiButtons = {}
	end
end

function extended.render(props)
	local omniFeedItemType = props.props.omniFeedItemType
	local layoutOrder = props.props.layoutOrder
	local component = omniFeedService.get():getOmniFeedItemMap().getComponent(omniFeedItemType)

	if omniFeedItemType == nil or component == nil then
		mutedError("OmniFeedItem: Unknown omni feed item type: " .. tostring(omniFeedItemType) .. ", should have already been filtered out.")

		return nil
	end

	local createElement = Roact.createElement
	local v6 = {}
	v6.Size = UDim2.new(1, 0, 0, 0)
	v6.AutomaticSize = Enum.AutomaticSize.Y
	v6.SelectionGroup = true
	local v7 = if props.props.navBarPlacement == module.Placement.Left then Enum.SelectionBehavior.Escape else Enum.SelectionBehavior.Stop
	v6.SelectionBehaviorLeft = v7

	v6.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	v6.LayoutOrder = layoutOrder
	v6.ZIndex = props.props.zIndex
	v6.BackgroundTransparency = 1
	v6.BorderSizePixel = 0
	v6[Roact.Ref] = props.containerRef
	v6[Roact.Event.DescendantAdded] = function(p2, p3)
		props.descendantAdded(p3)
	end
	v6[Roact.Event.DescendantRemoving] = function(p2, p3)
		props.descendantRemoving(p3)
	end
	v6[Roact.Change.AbsoluteSize] = function(p2)
		local onAbsoluteSizeChanged = p2 and props.props.onAbsoluteSizeChanged

		if onAbsoluteSizeChanged then
			onAbsoluteSizeChanged(p2)
		end
	end

	return createElement("Frame", v6, {
		FeedItem = Roact.createElement(component, props.props.itemProps)
	})
end

function extended:didMount()
	self.isMounted = true

	impressionsTagUtility.AddTag(self.feedItemRef, self.props.impressionsTag, self.props.itemIndex)
	self.addAllDescendantGuiButtons()
end

function extended:willUnmount()
	self.isMounted = false

	self.removeAllDescendantGuiButtons()
	impressionsTagUtility.RemoveTag(self.feedItemRef, self.props.impressionsTag, self.props.itemIndex)
end

function extended.didUpdate(data, data2)
	if data2.impressionsTag ~= data.props.impressionsTag or data2.itemIndex ~= data.props.itemIndex then
		impressionsTagUtility.RemoveTag(data.feedItemRef, data2.impressionsTag, data2.itemIndex)
		impressionsTagUtility.AddTag(data.feedItemRef, data.props.impressionsTag, data.props.itemIndex)
	end

	if data2.feedItemNameId ~= data.props.feedItemNameId then
		data.removeAllDescendantGuiButtons()
		data.addAllDescendantGuiButtons()
	end
end

return roactServices.connect({ eventIngest = appEventIngestService })(function(p2)
	local v5 = useNavBarPlacement()
	local joined = Cryo.Dictionary.join(p2, { navBarPlacement = v5 })

	return Roact.createElement(extended, joined)
end)
