local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")
local MomentsDraftSerializer = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/MomentsDraftSerializer")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/getLocalUserId")
local FailureReason = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/FailureReason")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Loggers").Logger:new("Moments.DraftStorage")

local v6 = game:DefineFastInt("MomentDraftTTLDays", 14) * 24 * 60 * 60 * 1000

return {
	save = function(data)
		local v7 = getLocalUserId(Players)

		if v7 == nil then
			v5:debug("event=save_skipped reason=no_local_player")
			return false
		end

		local v8 = {
			userId = v7,
			captureRef = data.captureRef,
			description = data.description,
			commentsEnabled = data.commentsEnabled,
			edits = data.edits,
			lastSaveTime = DateTime.now().UnixTimestampMillis
		}

		local success, result = pcall(function()
			AppStorageService:SetItem("MomentsDraftStorage", HttpService:JSONEncode((MomentsDraftSerializer.serialize(v8))))
			AppStorageService:Flush()
		end)

		if not success then
			v5:error("event=save_failed reason=app_storage_write_error error={}", (tostring(result)))
		end

		return success
	end,
	load = function()
		local v7 = getLocalUserId(Players)

		if v7 == nil then
			v5:debug("event=load_failed reason=no_local_player")
			return nil, nil
		end

		local success, result = pcall(function()
			return AppStorageService:GetItem("MomentsDraftStorage")
		end)

		if not success then
			v5:debug("event=load_failed reason=app_storage_read_error")
			return nil, nil
		end

		if result == nil or result == "" then
			return nil, nil
		end

		local success2, result2 = pcall(function()
			return HttpService:JSONDecode(result)
		end)

		if not success2 or type(result2) ~= "table" then
			pcall(function()
				AppStorageService:SetItem("MomentsDraftStorage", "")
				AppStorageService:Flush()
			end)

			return nil, FailureReason.CorruptShape
		end

		local deserialized = MomentsDraftSerializer.deserialize(result2)

		if deserialized == nil then
			pcall(function()
				AppStorageService:SetItem("MomentsDraftStorage", "")
				AppStorageService:Flush()
			end)

			return nil, FailureReason.CorruptShape
		end

		if deserialized.userId ~= v7 then
			pcall(function()
				AppStorageService:SetItem("MomentsDraftStorage", "")
				AppStorageService:Flush()
			end)

			return nil, FailureReason.WrongUser
		end

		if v6 < DateTime.now().UnixTimestampMillis - deserialized.lastSaveTime then
			pcall(function()
				AppStorageService:SetItem("MomentsDraftStorage", "")
				AppStorageService:Flush()
			end)

			return nil, FailureReason.ExpiredDraft
		end

		return deserialized, nil
	end,
	clear = function()
		pcall(function()
			AppStorageService:SetItem("MomentsDraftStorage", "")
			AppStorageService:Flush()
		end)
	end
}
