local TextChatService = game:GetService("TextChatService")
local GameSettings = UserSettings().GameSettings
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)

require(ExpChat.Stores.GetPresetChatStore.createPresetChatStore)

local v6 = ExpChatShared.Logger:new("ExpChat/PresetChat/initializePresetChat")

local function fetchPresets(p1, b1: boolean?) -- line: 16
	-- upvalues: TextChatService (copy), v6 (copy)
	task.spawn(function() -- line: 17
		-- upvalues: TextChatService (copy), b1 (copy), v6 (copy), p1 (copy)
		local ok, result = pcall(function() -- line: 18
			-- upvalues: TextChatService (copy)
			return TextChatService:GetPresetsAsync()
		end)

		if b1 then
			if not ok then
				v6:warning("GetPresetsAsync failed: {}", (tostring(result)))
			end

			return
		end

		if not ok then
			v6:warning("GetPresetsAsync failed: {}", (tostring(result)))
			p1.setIsLoading(false)

			return
		end

		if not result then
			p1.setIsLoading(false)

			return
		end

		local v15 = result.accessLevel or "Disabled"

		p1.setAccessLevel(v15)

		if v15 ~= "Disabled" then
			local version = result.version

			if not version or version == "" then
				v6:warning("Missing version in GetPresetsAsync response, treating as disabled")
				p1.setAccessLevel("Disabled")
				p1.setIsLoading(false)

				return
			end

			local categoryGroups = result.categoryGroups

			if categoryGroups and #categoryGroups > 0 then
				p1.setCategoryGroups(categoryGroups)
				p1.setVersion(version)
				p1.setIsEnabled(true)
			end
		end

		p1.setIsLoading(false)
	end)
end
local function initializePresetChat(p2, b2: boolean?) -- line: 64
	-- upvalues: TextChatService (copy), v6 (copy), GameSettings (copy)
	task.spawn(function() -- line: 17
		-- upvalues: TextChatService (copy), b2 (copy), v6 (copy), p2 (copy)
		local ok, result = pcall(function() -- line: 18
			-- upvalues: TextChatService (copy)
			return TextChatService:GetPresetsAsync()
		end)

		if b2 then
			if not ok then
				v6:warning("GetPresetsAsync failed: {}", (tostring(result)))
			end

			return
		end

		if not ok then
			v6:warning("GetPresetsAsync failed: {}", (tostring(result)))
			p2.setIsLoading(false)

			return
		end

		if not result then
			p2.setIsLoading(false)

			return
		end

		local v20 = result.accessLevel or "Disabled"

		p2.setAccessLevel(v20)

		if v20 ~= "Disabled" then
			local version = result.version

			if not version or version == "" then
				v6:warning("Missing version in GetPresetsAsync response, treating as disabled")
				p2.setAccessLevel("Disabled")
				p2.setIsLoading(false)

				return
			end

			local categoryGroups = result.categoryGroups

			if categoryGroups and #categoryGroups > 0 then
				p2.setCategoryGroups(categoryGroups)
				p2.setVersion(version)
				p2.setIsEnabled(true)
			end
		end

		p2.setIsLoading(false)
	end)
	GameSettings:GetPropertyChangedSignal("ChatTranslationLocale"):Connect(function() -- line: 67
		-- upvalues: b2 (copy), p2 (copy), TextChatService (copy), v6 (copy)
		if not b2 then
			p2.setIsLoading(true)
		end

		local v23 = p2
		local v24 = b2

		task.spawn(function() -- line: 17
			-- upvalues: TextChatService (copy), v24 (copy), v6 (copy), v23 (copy)
			local ok, result = pcall(function() -- line: 18
				-- upvalues: TextChatService (copy)
				return TextChatService:GetPresetsAsync()
			end)

			if v24 then
				if not ok then
					v6:warning("GetPresetsAsync failed: {}", (tostring(result)))
				end

				return
			end

			if not ok then
				v6:warning("GetPresetsAsync failed: {}", (tostring(result)))
				v23.setIsLoading(false)

				return
			end

			if not result then
				v23.setIsLoading(false)

				return
			end

			local v29 = result.accessLevel or "Disabled"

			v23.setAccessLevel(v29)

			if v29 ~= "Disabled" then
				local version = result.version

				if not version or version == "" then
					v6:warning("Missing version in GetPresetsAsync response, treating as disabled")
					v23.setAccessLevel("Disabled")
					v23.setIsLoading(false)

					return
				end

				local categoryGroups = result.categoryGroups

				if categoryGroups and #categoryGroups > 0 then
					v23.setCategoryGroups(categoryGroups)
					v23.setVersion(version)
					v23.setIsEnabled(true)
				end
			end

			v23.setIsLoading(false)
		end)
	end)
	GameSettings:GetPropertyChangedSignal("ChatTranslationEnabled"):Connect(function() -- line: 74
		-- upvalues: b2 (copy), p2 (copy), TextChatService (copy), v6 (copy)
		if not b2 then
			p2.setIsLoading(true)
		end

		local v25 = p2
		local v26 = b2

		task.spawn(function() -- line: 17
			-- upvalues: TextChatService (copy), v26 (copy), v6 (copy), v25 (copy)
			local ok, result = pcall(function() -- line: 18
				-- upvalues: TextChatService (copy)
				return TextChatService:GetPresetsAsync()
			end)

			if v26 then
				if not ok then
					v6:warning("GetPresetsAsync failed: {}", (tostring(result)))
				end

				return
			end

			if not ok then
				v6:warning("GetPresetsAsync failed: {}", (tostring(result)))
				v25.setIsLoading(false)

				return
			end

			if not result then
				v25.setIsLoading(false)

				return
			end

			local v34 = result.accessLevel or "Disabled"

			v25.setAccessLevel(v34)

			if v34 ~= "Disabled" then
				local version = result.version

				if not version or version == "" then
					v6:warning("Missing version in GetPresetsAsync response, treating as disabled")
					v25.setAccessLevel("Disabled")
					v25.setIsLoading(false)

					return
				end

				local categoryGroups = result.categoryGroups

				if categoryGroups and #categoryGroups > 0 then
					v25.setCategoryGroups(categoryGroups)
					v25.setVersion(version)
					v25.setIsEnabled(true)
				end
			end

			v25.setIsLoading(false)
		end)
	end)
end

return initializePresetChat
