local Players = game:GetService("Players")

local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local BindingConfigs = require(parent.Configs.BindingConfigs)
require(parent.Configs.ConfigTypes)
local Constants = require(parent.Constants)

local function getStaticCharacterMovementControlCount()
	local count = 0

	for _, control in BindingConfigs.Controls do
		if
			control.keyboardInput ~= nil
			and control.keyboardInput.group.id == BindingConfigs.ControlGroups.CharacterMovement.id
		then
			count += 1
		end
	end

	return count
end

local staticCharacterMovementControlCount = getStaticCharacterMovementControlCount()

local function getAbilityLayoutOrder(name: string) -- 1 equivalent call inferred from this helper
	if string.match(name, "^AbilityAction%d+$") == nil then
		return nil
	end

	local v = tonumber((string.sub(name, 14)))

	if v == nil then
		return nil
	end

	return staticCharacterMovementControlCount + v
end

local function getCharacterContext(instance) -- 3 equivalent calls inferred from this helper
	if instance == nil then
		return nil
	end

	local inputContexts = instance:FindFirstChild("InputContexts")

	if inputContexts == nil then
		return nil
	end

	local characterContext = inputContexts:FindFirstChild("CharacterContext")

	if characterContext == nil or not characterContext:IsA("InputContext") then
		return nil
	end

	return characterContext
end

local function getKeyboardCombo(inputBinding)
	local v = {}
	local primaryModifier = inputBinding.PrimaryModifier
	local secondaryModifier = inputBinding.SecondaryModifier
	local keyCode = inputBinding.KeyCode

	if primaryModifier ~= Enum.KeyCode.None then
		table.insert(v, primaryModifier)
	end

	if secondaryModifier ~= Enum.KeyCode.None then
		table.insert(v, secondaryModifier)
	end

	if keyCode ~= Enum.KeyCode.None then
		table.insert(v, keyCode)
	end

	return if #v ~= 0 then v else nil
end

local function getAssetAttribute(instance, attributeName: string) -- 1 equivalent call inferred from this helper
	local attribute = instance:GetAttribute(attributeName)

	if type(attribute) == "string" and attribute ~= "" then
		return attribute
	end

	return nil
end

local function readAction(inputAction)
	local abilityLayoutOrder = getAbilityLayoutOrder(inputAction.Name) -- inferred equivalent call

	if abilityLayoutOrder == nil then
		return nil
	end

	local keyboardCombos = {}
	local keyCodes = {}

	for _, inputBinding in inputAction:GetChildren() do
		if not inputBinding:IsA("InputBinding") then
			continue
		end

		local keyCode = inputBinding.KeyCode

		if keyCode == nil then
			continue
		end

		if Constants.HELP_PAGE.GAMEPAD_LAYOUT_ORDER[keyCode] == nil then
			local keyboardCombo = getKeyboardCombo(inputBinding)

			if keyboardCombo ~= nil then
				table.insert(keyboardCombos, keyboardCombo)
			end
		else
			table.insert(keyCodes, keyCode)
		end
	end

	local v = {
		label = inputAction.DisplayName,
		disabled = not inputAction.Enabled,
		actionAssetId = getAssetAttribute(inputAction, "ButtonPressedAssetId") -- inferred equivalent call
	}

	if #keyboardCombos > 0 then
		v.keyboardInput = {
			input = keyboardCombos,
			group = BindingConfigs.ControlGroups.CharacterMovement,
			layoutOrder = abilityLayoutOrder
		}
	end

	if #keyCodes > 0 then
		v.gamepadInput = { input = keyCodes }
	end

	return v
end

local function readAbilities(instance)
	local characterContext = getCharacterContext(instance) -- inferred equivalent call

	if characterContext == nil or not characterContext.Enabled then
		return nil
	end

	local result = {}

	for _, inputAction in characterContext:GetChildren() do
		if not inputAction:IsA("InputAction") then
			continue
		end

		local v = readAction(inputAction)

		if v ~= nil then
			result[inputAction.Name] = v
		end
	end

	return result
end

local function disconnectAll(connections) -- 8 equivalent calls inferred from this helper
	for _, connection in connections do
		connection:Disconnect()
	end

	table.clear(connections)
end

local function useAbilities(p)
	local v = p or Players.LocalPlayer
	local state, setState = React.useState(readAbilities(v))

	React.useEffect(function()
		if v == nil then
			return
		end

		local connections = {}
		local connections2 = {}
		local connections3 = {}
		local connections4 = {}

		local function refresh() -- 8 equivalent calls inferred from this helper
			setState(readAbilities(v))
		end

		local function fn()
			disconnectAll(connections4) -- inferred equivalent call
			local characterContext = getCharacterContext(v) -- inferred equivalent call

			if characterContext == nil then
				return
			end

			for _, inputAction in characterContext:GetChildren() do
				if not (inputAction:IsA("InputAction") and string.match(inputAction.Name, "^AbilityAction%d+$")) then
					continue
				end

				table.insert(connections4, inputAction.Changed:Connect(refresh))
				table.insert(
					connections4,
					inputAction:GetAttributeChangedSignal("ButtonPressedAssetId"):Connect(refresh)
				)

				table.insert(connections4, inputAction.ChildAdded:Connect(function()
					fn()
					refresh() -- inferred equivalent call
				end))

				table.insert(connections4, inputAction.ChildRemoved:Connect(function()
					fn()
					refresh() -- inferred equivalent call
				end))

				for _, inputBinding in inputAction:GetChildren() do
					if inputBinding:IsA("InputBinding") then
						table.insert(connections4, inputBinding.Changed:Connect(refresh))
					end
				end
			end
		end

		local function fn2()
			disconnectAll(connections2) -- inferred equivalent call
			disconnectAll(connections3) -- inferred equivalent call
			disconnectAll(connections4) -- inferred equivalent call
			local inputContexts = v:FindFirstChild("InputContexts")

			if inputContexts == nil then
				return
			end

			table.insert(connections2, inputContexts.ChildAdded:Connect(function()
				fn2()
				refresh() -- inferred equivalent call
			end))

			table.insert(connections2, inputContexts.ChildRemoved:Connect(function()
				fn2()
				refresh() -- inferred equivalent call
			end))
			local characterContext = getCharacterContext(v) -- inferred equivalent call

			if characterContext == nil then
				return
			end

			table.insert(connections3, characterContext.Changed:Connect(refresh))
			table.insert(connections3, characterContext.ChildAdded:Connect(function()
				fn()
				refresh() -- inferred equivalent call
			end))

			table.insert(connections3, characterContext.ChildRemoved:Connect(function()
				fn()
				refresh() -- inferred equivalent call
			end))

			fn()
		end

		table.insert(connections, v.ChildAdded:Connect(function(child)
			if child.Name == "InputContexts" then
				fn2()
				refresh() -- inferred equivalent call
			end
		end))

		table.insert(connections, v.ChildRemoved:Connect(function(child)
			if child.Name == "InputContexts" then
				fn2()
				refresh() -- inferred equivalent call
			end
		end))

		fn2()
		setState(readAbilities(v))

		return function()
			disconnectAll(connections) -- inferred equivalent call
			disconnectAll(connections2) -- inferred equivalent call
			disconnectAll(connections3) -- inferred equivalent call
			disconnectAll(connections4) -- inferred equivalent call
		end
	end, { v })

	return state
end

return useAbilities
