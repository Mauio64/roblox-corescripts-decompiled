local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")

local Actions = ExpChat.Actions
local BubbleChatSettingsChanged = require(Actions.BubbleChatSettingsChanged)
local BubbleChatChildSettingChanged = require(Actions.BubbleChatChildSettingChanged)
local BubbleChatChildRemoved = require(Actions.BubbleChatChildRemoved)

local Config = require(ExpChat.Config)

local Flags = ExpChat.Flags
local getSetUpBubbleChatConfigurationChildProperties = require(Flags.getSetUpBubbleChatConfigurationChildProperties)

local DefaultBubbleChatChildrenCustomizationProperties = Config.DefaultBubbleChatChildrenCustomizationProperties
local v = { "ImageLabel", "UIGradient", "UICorner", "UIPadding" }

local function getSettingsFromInstance(instance)
	local defaultBubbleChatChildrenCustomizationProperty = DefaultBubbleChatChildrenCustomizationProperties[instance.ClassName]
	local settings = {}

	for k, _ in pairs(defaultBubbleChatChildrenCustomizationProperty) do
		if instance[k] ~= nil then
			settings[k] = instance[k]
		end
	end

	return settings
end

local function connectPropertyChangedSignalsToInstance(object, instance)
	local defaultBubbleChatChildrenCustomizationProperty = DefaultBubbleChatChildrenCustomizationProperties[instance.ClassName]
	local connections = {}

	for propertyName, _ in pairs(defaultBubbleChatChildrenCustomizationProperty) do
		if instance[propertyName] ~= nil then
			table.insert(connections, (instance:GetPropertyChangedSignal(propertyName):Connect(function()
				object:dispatch(BubbleChatChildSettingChanged(instance.ClassName, propertyName, instance[propertyName]))
			end)))
		end
	end

	return connections
end

local function disconnectPropertyChangedSignalsToInstance(list) -- 1 equivalent call inferred from this helper
	if list then
		for _, connection in ipairs(list) do
			connection:Disconnect()
		end
	end
end

local function isValidBubbleChatChild(child): boolean -- 2 equivalent calls inferred from this helper
	for _, v2 in ipairs(v) do
		if v2 == child.ClassName then
			return true
		end
	end

	return false
end

return function(object)
	local bubbleChatConfiguration = TextChatService:FindFirstChildOfClass("BubbleChatConfiguration")

	if bubbleChatConfiguration == nil or getSetUpBubbleChatConfigurationChildProperties() == false then
		return DefaultBubbleChatChildrenCustomizationProperties
	end

	assert(bubbleChatConfiguration ~= nil, "BubbleChatConfiguration cannot be nil.")
	local v2 = {
		bubbleChatConfiguration:FindFirstChildOfClass("ImageLabel"),
		bubbleChatConfiguration:FindFirstChildOfClass("UIGradient"),
		bubbleChatConfiguration:FindFirstChildOfClass("UICorner"),
		(bubbleChatConfiguration:FindFirstChildOfClass("UIPadding"))
	}
	local settingsFromInstancesByClassName = {}
	local v3 = {}

	for _, v4 in ipairs(v2) do
		if not v4 then
			continue
		end

		local settingsFromInstance = getSettingsFromInstance(v4)
		settingsFromInstancesByClassName[v4.ClassName] = settingsFromInstance

		local v5 = connectPropertyChangedSignalsToInstance(object, v4)
		v3[v4.ClassName] = v5
	end

	bubbleChatConfiguration.ChildRemoved:Connect(function(child)
		if isValidBubbleChatChild(child) then -- inferred equivalent call
			disconnectPropertyChangedSignalsToInstance(v3[child.ClassName]) -- inferred equivalent call
			v3[child.ClassName] = nil
			object:dispatch(BubbleChatChildRemoved(child.ClassName))

			local firstChildOfClass = bubbleChatConfiguration:FindFirstChildOfClass(child.ClassName)

			if firstChildOfClass then
				local settingsFromInstance = getSettingsFromInstance(firstChildOfClass)
				object:dispatch(BubbleChatSettingsChanged(child.ClassName, settingsFromInstance))

				local v4 = connectPropertyChangedSignalsToInstance(object, firstChildOfClass)
				v3[firstChildOfClass.ClassName] = v4
			end
		end
	end)

	bubbleChatConfiguration.ChildAdded:Connect(function(child)
		if isValidBubbleChatChild(child) and object:getState().BubbleChatSettings[child.ClassName] == nil then -- inferred equivalent call
			local settingsFromInstance = getSettingsFromInstance(child)
			object:dispatch(BubbleChatSettingsChanged(child.ClassName, settingsFromInstance))

			local v4 = connectPropertyChangedSignalsToInstance(object, child)
			v3[child.ClassName] = v4
		end
	end)

	return settingsFromInstancesByClassName
end
