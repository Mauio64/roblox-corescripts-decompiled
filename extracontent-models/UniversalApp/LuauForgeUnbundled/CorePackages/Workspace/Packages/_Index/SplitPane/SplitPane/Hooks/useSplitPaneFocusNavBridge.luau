local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SignalsReact")
local SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useRegistryEntry = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useRegistryEntry

local function getSelectionGroupRowContainer(p2)
	local parent = p2.Parent

	while parent ~= nil do
		if parent:IsA("ScrollingFrame") then
			return parent
		end

		if parent:IsA("GuiObject") and parent.SelectionGroup then
			return parent
		end

		parent = parent.Parent
	end

	return nil
end

local function getRowBandContainer(data, p2)
	local y = data.AbsolutePosition.Y
	local v5 = y + data.AbsoluteSize.Y
	local y2 = data.AbsoluteSize.Y

	local guiObject = data.Parent
	local rowBandContainer = nil

	while guiObject ~= nil and guiObject ~= p2 and guiObject:IsA("GuiObject") do
		local y3 = guiObject.AbsolutePosition.Y
		local v6 = y3 + guiObject.AbsoluteSize.Y

		if y3 < y - y2 or v5 + y2 < v6 then
			break
		end

		rowBandContainer = guiObject
		guiObject = guiObject.Parent
	end

	return rowBandContainer
end

local function getFocusRowContainer(instance, ancestor, p2)
	if ancestor ~= nil and instance:IsDescendantOf(ancestor) then
		return ancestor
	end

	if instance:FindFirstAncestorWhichIsA("ScrollingFrame") == nil then
		return getRowBandContainer(instance, p2)
	end

	return getSelectionGroupRowContainer(instance)
end

local function hasSelectableToTheRight(selectedCoreObject, folder): boolean
	local x = selectedCoreObject.AbsolutePosition.X
	local y = selectedCoreObject.AbsolutePosition.Y
	local v5 = y + selectedCoreObject.AbsoluteSize.Y

	for i, guiObject in folder:GetDescendants() do
		if not (guiObject ~= selectedCoreObject and guiObject:IsA("GuiObject") and guiObject.Selectable and guiObject.Visible) then
			continue
		end

		local x2 = guiObject.AbsolutePosition.X
		local y2 = guiObject.AbsolutePosition.Y
		local v6 = y < y2 + guiObject.AbsoluteSize.Y and y2 < v5

		if v6 and x + 2 < x2 then
			return true
		end
	end

	return false
end

local function useSplitPaneFocusNavBridge(p2)
	local store = SplitPaneStore.getStore()
	local v5 = SignalsReact.useSignalState(store.getSupportPaneEntryTarget)

	local v6 = useRegistryEntry(focusNavigableSurfaceIdentifierEnum.HeaderView)

	local ref = React.useRef(nil)

	React.useEffect(function()
		local function clearOverride()
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
			local current = p2.current
			local selectedCoreObject = GuiService.SelectedCoreObject

			if
				isSplitEnabled
				and selectedCoreObject ~= nil
				and current ~= nil
				and v5 ~= nil
				and selectedCoreObject:IsDescendantOf(current)
			then
				local v7 = v6

				if v7 == nil or not selectedCoreObject:IsDescendantOf(v7) then
					if selectedCoreObject:FindFirstAncestorWhichIsA("ScrollingFrame") == nil then
						v7 = getRowBandContainer(selectedCoreObject, current)
					else
						v7 = getSelectionGroupRowContainer(selectedCoreObject)
					end
				end

				local v8 = not (v7 == nil) and not hasSelectableToTheRight(selectedCoreObject, v7)

				if v8 then
					local current2 = ref.current

					if current2 ~= nil and current2.object ~= selectedCoreObject then
						local current3 = ref.current

						if current3 ~= nil then
							if current3.object.NextSelectionRight == current3.target then
								current3.object.NextSelectionRight = nil
							end

							ref.current = nil
						end
					end

					if selectedCoreObject.NextSelectionRight == nil then
						selectedCoreObject.NextSelectionRight = v5
						ref.current = { object = selectedCoreObject, target = v5 }
					end
				else
					local current2 = ref.current

					if current2 ~= nil then
						if current2.object.NextSelectionRight == current2.target then
							current2.object.NextSelectionRight = nil
						end

						ref.current = nil
					end
				end
			else
				local current2 = ref.current

				if current2 ~= nil then
					if current2.object.NextSelectionRight == current2.target then
						current2.object.NextSelectionRight = nil
					end

					ref.current = nil
				end
			end
		end

		onSelectedCoreObjectChanged()
		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(onSelectedCoreObjectChanged)

		return function()
			selectedCoreObjectChangedConnection:Disconnect()
			local current = ref.current

			if current ~= nil then
				if current.object.NextSelectionRight == current.target then
					current.object.NextSelectionRight = nil
				end

				ref.current = nil
			end
		end
	end, { v6, v5, p2 })
end

return useSplitPaneFocusNavBridge
