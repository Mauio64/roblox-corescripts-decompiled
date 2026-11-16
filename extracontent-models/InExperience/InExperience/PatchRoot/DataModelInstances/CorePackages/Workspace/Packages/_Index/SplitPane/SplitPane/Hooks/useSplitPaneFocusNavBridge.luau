local parent = script:FindFirstAncestor("SplitPane").Parent

local GuiService = game:GetService("GuiService")

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useRegistryEntry = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useRegistryEntry

local function getSelectionGroupRowContainer(instance)
	local parent2 = instance.Parent

	while parent2 ~= nil do
		if parent2:IsA("ScrollingFrame") then
			return parent2
		end

		if parent2:IsA("GuiObject") and parent2.SelectionGroup then
			return parent2
		end

		parent2 = parent2.Parent
	end

	return nil
end

local function getRowBandContainer(instance, p)
	local y = instance.AbsolutePosition.Y
	local v = y + instance.AbsoluteSize.Y
	local y2 = instance.AbsoluteSize.Y

	local guiObject = instance.Parent
	local rowBandContainer = nil

	while guiObject ~= nil and guiObject ~= p and guiObject:IsA("GuiObject") do
		local y3 = guiObject.AbsolutePosition.Y
		local v2 = y3 + guiObject.AbsoluteSize.Y

		if y3 < y - y2 or v + y2 < v2 then
			break
		end

		rowBandContainer = guiObject
		guiObject = guiObject.Parent
	end

	return rowBandContainer
end

local function getFocusRowContainer(selectedCoreObject, ancestor, current) -- 1 equivalent call inferred from this helper
	if ancestor ~= nil and selectedCoreObject:IsDescendantOf(ancestor) then
		return ancestor
	end

	if selectedCoreObject:FindFirstAncestorWhichIsA("ScrollingFrame") == nil then
		return getRowBandContainer(selectedCoreObject, current)
	end

	return getSelectionGroupRowContainer(selectedCoreObject)
end

local function hasSelectableToTheRight(selectedCoreObject, folder): boolean
	local x = selectedCoreObject.AbsolutePosition.X
	local y = selectedCoreObject.AbsolutePosition.Y
	local v = y + selectedCoreObject.AbsoluteSize.Y

	for _, guiObject in folder:GetDescendants() do
		if not (guiObject ~= selectedCoreObject and guiObject:IsA("GuiObject") and guiObject.Selectable and guiObject.Visible) then
			continue
		end

		local x2 = guiObject.AbsolutePosition.X
		local y2 = guiObject.AbsolutePosition.Y
		local v2

		if y < y2 + guiObject.AbsoluteSize.Y then
			v2 = y2 < v
		else
			v2 = false
		end

		if v2 and x + 2 < x2 then
			return true
		end
	end

	return false
end

local function useSplitPaneFocusNavBridge(p)
	local store = SplitPaneStore.getStore()
	local v = SignalsReact.useSignalState(store.getSupportPaneEntryTarget)

	local v2 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.HeaderView)

	local ref = React.useRef(nil)

	React.useEffect(function()
		local function clearOverride() -- 4 equivalent calls inferred from this helper
			local current = ref.current

			if current ~= nil then
				if current.object.NextSelectionRight == current.target then
					current.object.NextSelectionRight = nil
				end

				ref.current = nil
			end
		end

		local function onSelectedCoreObjectChanged()
			local isSplitEnabled = store.getIsSplitEnabled(false)
			local current = p.current
			local selectedCoreObject = GuiService.SelectedCoreObject

			if
				isSplitEnabled
				and selectedCoreObject ~= nil
				and current ~= nil
				and v ~= nil
				and selectedCoreObject:IsDescendantOf(current)
			then
				local focusRowContainer = getFocusRowContainer(selectedCoreObject, v2, current) -- inferred equivalent call
				local v3

				if focusRowContainer == nil then
					v3 = false
				else
					v3 = not hasSelectableToTheRight(selectedCoreObject, focusRowContainer)
				end

				if v3 then
					local current2 = ref.current

					if current2 ~= nil and current2.object ~= selectedCoreObject then
						clearOverride() -- inferred equivalent call
					end

					if selectedCoreObject.NextSelectionRight == nil then
						selectedCoreObject.NextSelectionRight = v
						ref.current = { object = selectedCoreObject, target = v }
					end
				else
					clearOverride() -- inferred equivalent call
				end
			else
				clearOverride() -- inferred equivalent call
			end
		end

		onSelectedCoreObjectChanged()
		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(onSelectedCoreObjectChanged)

		return function()
			selectedCoreObjectChangedConnection:Disconnect()
			clearOverride() -- inferred equivalent call
		end
	end, { v2, v, p })
end

return useSplitPaneFocusNavBridge
