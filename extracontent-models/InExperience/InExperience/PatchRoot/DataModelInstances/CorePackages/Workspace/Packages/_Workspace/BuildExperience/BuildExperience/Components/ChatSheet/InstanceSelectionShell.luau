local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local clientDataModelCollector = require(BuildExperience.Chat.clientDataModelCollector)
local InGameBuildShell = require(script.Parent.InGameBuildShell)
local InstanceSelectionProtocol = require(script.Parent.InstanceSelectionProtocol)

local function noop() end

local function finishWithInstance(instance) -- 2 equivalent calls inferred from this helper
	InstanceSelectionProtocol.finishSelection({
		status = "selected",
		path = clientDataModelCollector.getInstancePath(instance),
		displayName = instance.Name,
		className = instance.ClassName
	})
end

local function cancelSelection()
	InstanceSelectionProtocol.finishSelection({ status = "cancelled" })
end

local function InstanceSelectionShell(p)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		local itemSelectedConnection = p.itemSelected:Connect(function(instance)
			if p.isTouchInput() then
				setState(instance)
			elseif instance ~= nil then
				finishWithInstance(instance) -- inferred equivalent call
			end
		end)
		return function()
			itemSelectedConnection:Disconnect()
		end
	end, { p.itemSelected, p.isTouchInput })

	return React.createElement(InGameBuildShell, {
		isSelecting = true,
		onActivated = noop,
		onSelectionCancelled = cancelSelection,
		onSelectionConfirmed = state ~= nil and function()
			finishWithInstance(state) -- inferred equivalent call
		end or nil
	})
end

return InstanceSelectionShell
