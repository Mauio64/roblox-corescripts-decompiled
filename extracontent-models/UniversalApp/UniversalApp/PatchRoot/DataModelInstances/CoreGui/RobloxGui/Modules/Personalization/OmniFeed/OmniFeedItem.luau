local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local ImpressionsTagUtility = require(CorePackages.Workspace.Packages.Impressions).ImpressionsTagUtility
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local OmniFeedService = require(CorePackages.Workspace.Packages.OmniFeedService).OmniFeedService
local OmniFeedConstants = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniFeedConstants
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local v15 = Roact.PureComponent:extend("OmniFeedItem")

v15.validateProps = t.strictInterface({
	omniFeedItemType = t.string,
	layoutOrder = t.optional(t.number),
	zIndex = t.optional(t.number),
	impressionsTag = t.string,
	itemIndex = t.number,
	feedItemNameId = t.string,
	itemProps = t.optional(t.table),
	onAbsoluteSizeChanged = t.optional(t.callback),
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback),
	navBarPlacement = t.valueOf(AppNavBar.Placement),
	eventIngest = t.any
})

function v15.init(p1) -- line: 40
	-- upvalues: Roact (copy), FFlagLuaAppsDefaultSelection (copy), HttpService (copy), OmniFeedConstants (copy), mutedError (copy)
	p1.feedItemRef = Roact.createRef()
	p1.containerRef = if not FFlagLuaAppsDefaultSelection then nil else function(p2) -- line: 43
		-- upvalues: p1 (copy)
		if p1.props.defaultFocusRef then
			p1.props.defaultFocusRef(p2)
		end

		p1.feedItemRef.current = p2
	end
	p1.descendantGuiButtons = {}

	function p1.addDescendantGuiButton(p3) -- line: 53
		-- upvalues: HttpService (copy), p1 (copy), OmniFeedConstants (copy)
		local GUID = p3:GetAttribute("GUID")

		if GUID == nil then
			GUID = HttpService:GenerateGUID()
			p3:SetAttribute("GUID", GUID)
		end

		if p1.descendantGuiButtons[GUID] then
			p1.descendantGuiButtons[GUID].connection:Disconnect()
			p1.descendantGuiButtons[GUID] = nil
		end

		local connection = p3.Activated:Connect(function(_) -- line: 66
			-- upvalues: p1 (copy), OmniFeedConstants (copy), p3 (copy)
			if not p1.isMounted then
				return
			end

			p1.props.eventIngest:setRBXEventStream(OmniFeedConstants.EventContext, "feedItemClicked", {
				fullPath = p3:GetFullName(),
				treatmentType = p1.props.omniFeedItemType,
				feedItemPos = p1.props.layoutOrder,
				feedItemNameId = p1.props.feedItemNameId
			})
		end)

		p1.descendantGuiButtons[GUID] = {
			name = p3.Name,
			connection = connection
		}
	end
	function p1.removeDescendantGuiButton(p5) -- line: 86
		-- upvalues: p1 (copy), mutedError (copy)
		if p5 ~= nil and p1.descendantGuiButtons[p5] then
			p1.descendantGuiButtons[p5].connection:Disconnect()
			p1.descendantGuiButtons[p5] = nil

			return
		end

		if p1.isMounted and not p1.descendantGuiButtonError then
			p1.descendantGuiButtonError = true
			mutedError(`OmniFeedItem: Expecting descendant button for guid: { p5 }, feedItemNameId: { p1.props.feedItemNameId }`)
		end
	end
	function p1.descendantAdded(p6) -- line: 102
		-- upvalues: p1 (copy)
		if not p6 or not p6:IsA("GuiButton") then
			return
		end

		p1.addDescendantGuiButton(p6)
	end
	function p1.descendantRemoving(p7) -- line: 110
		-- upvalues: p1 (copy)
		if not p7 or not p7:IsA("GuiButton") then
			return
		end

		local GUID = p7:GetAttribute("GUID")

		p1.removeDescendantGuiButton(GUID)
	end
	function p1.addAllDescendantGuiButtons() -- line: 119
		-- upvalues: p1 (copy)
		local v37 = p1.feedItemRef and p1.feedItemRef.current

		if v37 then
			local descendants = v37:GetDescendants()

			if descendants then
				for _, v in pairs(descendants) do
					p1.descendantAdded(v)
				end
			end
		end
	end
	function p1.removeAllDescendantGuiButtons() -- line: 131
		-- upvalues: p1 (copy)
		for k, _ in pairs(p1.descendantGuiButtons) do
			p1.removeDescendantGuiButton(k)
		end

		p1.descendantGuiButtons = {}
	end
end
function v15.render(p8) -- line: 139
	-- upvalues: OmniFeedService (copy), Roact (copy), AppNavBar (copy), FFlagLuaAppsDefaultSelection (copy), mutedError (copy)
	local omniFeedItemType = p8.props.omniFeedItemType
	local layoutOrder = p8.props.layoutOrder
	local v21 = OmniFeedService.get():getOmniFeedItemMap().getComponent(omniFeedItemType)

	if omniFeedItemType ~= nil and v21 ~= nil then
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			SelectionGroup = true,
			SelectionBehaviorLeft = if p8.props.navBarPlacement ~= AppNavBar.Placement.Left then Enum.SelectionBehavior.Stop else Enum.SelectionBehavior.Escape,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			LayoutOrder = layoutOrder,
			ZIndex = p8.props.zIndex,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[Roact.Ref] = if not FFlagLuaAppsDefaultSelection then p8.feedItemRef else p8.containerRef,
			[Roact.Event.DescendantAdded] = function(_, p10) -- line: 159
				-- upvalues: p8 (copy)
				p8.descendantAdded(p10)
			end,
			[Roact.Event.DescendantRemoving] = function(_, p12) -- line: 162
				-- upvalues: p8 (copy)
				p8.descendantRemoving(p12)
			end,
			[Roact.Change.AbsoluteSize] = function(p13) -- line: 165
				-- upvalues: p8 (copy)
				if p13 then
					local onAbsoluteSizeChanged = p8.props.onAbsoluteSizeChanged

					if onAbsoluteSizeChanged then
						onAbsoluteSizeChanged(p13)
					end
				end
			end
		}, {
			FeedItem = Roact.createElement(v21, p8.props.itemProps)
		})
	end

	mutedError("OmniFeedItem: Unknown omni feed item type: " .. tostring(omniFeedItemType) .. ", should have already been filtered out.")

	return nil
end
function v15.didMount(p14) -- line: 186
	-- upvalues: ImpressionsTagUtility (copy)
	p14.isMounted = true
	ImpressionsTagUtility.AddTag(p14.feedItemRef, p14.props.impressionsTag, p14.props.itemIndex)
	p14.addAllDescendantGuiButtons()
end
function v15.willUnmount(p15) -- line: 193
	-- upvalues: ImpressionsTagUtility (copy)
	p15.isMounted = false
	p15.removeAllDescendantGuiButtons()
	ImpressionsTagUtility.RemoveTag(p15.feedItemRef, p15.props.impressionsTag, p15.props.itemIndex)
end
function v15.didUpdate(p16, p17) -- line: 200
	-- upvalues: ImpressionsTagUtility (copy)
	if p17.impressionsTag ~= p16.props.impressionsTag or p17.itemIndex ~= p16.props.itemIndex then
		ImpressionsTagUtility.RemoveTag(p16.feedItemRef, p17.impressionsTag, p17.itemIndex)
		ImpressionsTagUtility.AddTag(p16.feedItemRef, p16.props.impressionsTag, p16.props.itemIndex)
	end

	if p17.feedItemNameId ~= p16.props.feedItemNameId then
		p16.removeAllDescendantGuiButtons()
		p16.addAllDescendantGuiButtons()
	end
end

local v16 = v15

return RoactServices.connect({
	eventIngest = AppEventIngestService
})(function(p18) -- line: 213
	-- upvalues: useNavBarPlacement (copy), Cryo (copy), Roact (copy), v16 (copy)
	local v27 = useNavBarPlacement()
	local v28 = Cryo.Dictionary.join(p18, {
		navBarPlacement = v27
	})

	return Roact.createElement(v16, v28)
end)
