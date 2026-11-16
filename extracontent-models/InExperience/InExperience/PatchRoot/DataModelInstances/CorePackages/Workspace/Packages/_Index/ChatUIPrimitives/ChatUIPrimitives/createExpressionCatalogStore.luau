local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local Signals = require(parent.Signals)
local FFlagExpChatUseExpressionCatalogNormalizer = require(ChatUIPrimitives.Flags.FFlagExpChatUseExpressionCatalogNormalizer)
local normalizeExpressionCatalog = require(ChatUIPrimitives.PresetChat.normalizeExpressionCatalog)
local normalizePresetCatalog = require(ChatUIPrimitives.PresetChat.normalizePresetCatalog)
local presetCatalogToExpressionCatalog = require(ChatUIPrimitives.PresetChat.presetCatalogToExpressionCatalog)
require(ChatUIPrimitives.UniversalMessage.Types)

local createSignal = Signals.createSignal

local function createExpressionCatalogStore(callback)
	local gameSettings = UserSettings().GameSettings

	local signal, v = createSignal("disabled")

	local signal2, v2 = createSignal({})
	local signal3, v3 = createSignal(false)

	local v4 = 0
	local connections = {}

	local count = 0

	local function refresh() -- 1 equivalent call inferred from this helper
		count += 1
		local v5 = count
		v3(true)
		task.spawn(function()
			local v6 = callback()

			if v5 ~= count then
				return
			end

			v3(false)

			if FFlagExpChatUseExpressionCatalogNormalizer then
				local v7

				if v6 ~= nil then
					v7 = normalizeExpressionCatalog(v6)
				end

				if v7 == nil then
					return
				end

				v(v7.status)
				v2(v7.categoryGroups)
			else
				local v7

				if v6 ~= nil then
					v7 = normalizePresetCatalog(v6)
				end

				if v7 == nil then
					return
				end

				local v8 = presetCatalogToExpressionCatalog(v7)
				v(v8.status)
				v2(v8.categoryGroups)
			end
		end)
	end

	local function acquire()
		v4 += 1

		if v4 == 1 then
			refresh() -- inferred equivalent call
			table.insert(connections, gameSettings:GetPropertyChangedSignal("ChatTranslationLocale"):Connect(refresh))

			table.insert(connections, gameSettings:GetPropertyChangedSignal("ChatTranslationEnabled"):Connect(refresh))
		end
	end

	local function release()
		v4 -= 1

		if v4 <= 0 then
			v4 = 0

			for _, connection in connections do
				connection:Disconnect()
			end

			table.clear(connections)

			count += 1

			v3(false)
		end
	end

	local function _resetForTesting()
		for _, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
		v4 = 0
		count += 1
		v("disabled")
		v2({})
		v3(false)
	end

	return {
		getStatus = signal,
		getCategoryGroups = signal2,
		getIsLoading = signal3,
		acquire = acquire,
		release = release,
		_resetForTesting = _resetForTesting
	}
end

return createExpressionCatalogStore
