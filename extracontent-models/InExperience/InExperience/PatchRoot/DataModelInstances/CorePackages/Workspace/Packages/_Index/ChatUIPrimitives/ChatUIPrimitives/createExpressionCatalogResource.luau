local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local Signals = require(parent.Signals)
require(ChatUIPrimitives.UniversalMessage.Types)

local createSignal = Signals.createSignal

local refreshes = {}

local function notifySettingsChangedForTesting()
	local clone = table.clone(refreshes)

	for _, v in clone do
		v()
	end
end

local function createExpressionCatalogResource(callback)
	local gameSettings = UserSettings().GameSettings

	local signal, v = createSignal(nil)

	local v2 = 0
	local connections = {}

	local count = 0

	local function refresh() -- 1 equivalent call inferred from this helper
		count += 1
		local v3 = count
		task.spawn(function()
			local success, result = pcall(callback)

			if v3 ~= count or not success then
				return
			end

			v(result)
		end)
	end

	local function acquire()
		v2 += 1

		if v2 > 1 then
			return
		end

		refresh() -- inferred equivalent call
		table.insert(refreshes, refresh)
		table.insert(connections, gameSettings:GetPropertyChangedSignal("ChatTranslationLocale"):Connect(refresh))
		table.insert(connections, gameSettings:GetPropertyChangedSignal("ChatTranslationEnabled"):Connect(refresh))
	end

	local function release()
		if v2 == 0 then
			return
		end

		v2 -= 1

		if v2 > 0 then
			return
		end

		for _, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
		local index = table.find(refreshes, refresh)

		if index ~= nil then
			table.remove(refreshes, index)
		end

		count += 1
	end

	return { getCatalog = signal, acquire = acquire, release = release }
end

return (setmetatable({ _notifySettingsChangedForTesting = notifySettingsChangedForTesting }, {
	__call = function(_, callback)
		return createExpressionCatalogResource(callback)
	end
}))
