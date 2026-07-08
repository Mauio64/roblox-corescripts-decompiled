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
local t1 = {
	"ImageLabel",
	"UIGradient",
	"UICorner",
	"UIPadding"
}

local function getSettingsFromInstance(p1) -- line: 17
	-- upvalues: DefaultBubbleChatChildrenCustomizationProperties (copy)
	local v17 = DefaultBubbleChatChildrenCustomizationProperties[p1.ClassName]
	local t2 = {}

	for k, _ in pairs(v17) do
		if p1[k] ~= nil then
			t2[k] = p1[k]
		end
	end

	return t2
end
local function connectPropertyChangedSignalsToInstance(p2, p3) -- line: 31
	-- upvalues: DefaultBubbleChatChildrenCustomizationProperties (copy), BubbleChatChildSettingChanged (copy)
	local v23 = DefaultBubbleChatChildrenCustomizationProperties[p3.ClassName]
	local t3 = {}

	for k, _ in pairs(v23) do
		if p3[k] ~= nil then
			table.insert(t3, (p3:GetPropertyChangedSignal(k):Connect(function() -- line: 37
				-- upvalues: p2 (copy), BubbleChatChildSettingChanged (copy), p3 (copy), k (copy)
				p2:dispatch(BubbleChatChildSettingChanged(p3.ClassName, k, p3[k]))
			end)))
		end
	end

	return t3
end
local function disconnectPropertyChangedSignalsToInstance(p4) -- line: 47
	if p4 then
		for _, v in ipairs(p4) do
			v:Disconnect()
		end
	end
end
local function isValidBubbleChatChild(p5) -- line: 55
	-- upvalues: t1 (copy)
	for _, v in ipairs(t1) do
		if v == p5.ClassName then
			return true
		end
	end

	return false
end

return function(p6) -- line: 65
	-- upvalues: TextChatService (copy), getSetUpBubbleChatConfigurationChildProperties (copy), DefaultBubbleChatChildrenCustomizationProperties (copy), getSettingsFromInstance (copy), connectPropertyChangedSignalsToInstance (copy), t1 (copy), BubbleChatChildRemoved (copy), BubbleChatSettingsChanged (copy)
	local BubbleChatConfiguration = TextChatService:FindFirstChildOfClass("BubbleChatConfiguration")

	if BubbleChatConfiguration == nil or getSetUpBubbleChatConfigurationChildProperties() == false then
		return DefaultBubbleChatChildrenCustomizationProperties
	end

	local t4 = {}
	local t5 = {}

	assert(BubbleChatConfiguration ~= nil, "BubbleChatConfiguration cannot be nil.")

	local ImageLabel = BubbleChatConfiguration:FindFirstChildOfClass("ImageLabel")
	local UIGradient = BubbleChatConfiguration:FindFirstChildOfClass("UIGradient")
	local UICorner = BubbleChatConfiguration:FindFirstChildOfClass("UICorner")
	local UIPadding = BubbleChatConfiguration:FindFirstChildOfClass("UIPadding")

	for _, v in ipairs({
		ImageLabel,
		UIGradient,
		UICorner,
		UIPadding
	}) do
		if v then
			local v43 = getSettingsFromInstance(v)

			t4[v.ClassName] = v43

			local v44 = connectPropertyChangedSignalsToInstance(p6, v)

			t5[v.ClassName] = v44
		end
	end

	BubbleChatConfiguration.ChildRemoved:Connect(function(child) -- line: 95
		-- upvalues: t1 (copy), t5 (copy), p6 (copy), BubbleChatChildRemoved (copy), BubbleChatConfiguration (copy), getSettingsFromInstance (copy), BubbleChatSettingsChanged (copy), connectPropertyChangedSignalsToInstance (copy)
		local g49 = nil
		local v48 = nil

		for _, v in ipairs(t1) do
			if v == child.ClassName then
				v48 = true
				g49 = true
			end

			if g49 then
				break
			end
		end

		if not g49 then
			v48 = false
		end

		g49 = false

		if v48 then
			local v50 = t5[child.ClassName]

			if v50 then
				for _, v in ipairs(v50) do
					v:Disconnect()
				end
			end

			t5[child.ClassName] = nil
			p6:dispatch(BubbleChatChildRemoved(child.ClassName))

			local childClassName = BubbleChatConfiguration:FindFirstChildOfClass(child.ClassName)

			if childClassName then
				local v54 = getSettingsFromInstance(childClassName)

				p6:dispatch(BubbleChatSettingsChanged(child.ClassName, v54))

				local v55 = connectPropertyChangedSignalsToInstance(p6, childClassName)

				t5[childClassName.ClassName] = v55
			end
		end
	end)
	BubbleChatConfiguration.ChildAdded:Connect(function(child) -- line: 112
		-- upvalues: t1 (copy), p6 (copy), getSettingsFromInstance (copy), BubbleChatSettingsChanged (copy), connectPropertyChangedSignalsToInstance (copy), t5 (copy)
		local g60 = nil
		local v59 = nil

		for _, v in ipairs(t1) do
			if v == child.ClassName then
				v59 = true
				g60 = true
			end

			if g60 then
				break
			end
		end

		if not g60 then
			v59 = false
		end

		g60 = false

		if v59 and p6:getState().BubbleChatSettings[child.ClassName] == nil then
			local v61 = getSettingsFromInstance(child)

			p6:dispatch(BubbleChatSettingsChanged(child.ClassName, v61))

			local v62 = connectPropertyChangedSignalsToInstance(p6, child)

			t5[child.ClassName] = v62
		end
	end)

	return t4
end
