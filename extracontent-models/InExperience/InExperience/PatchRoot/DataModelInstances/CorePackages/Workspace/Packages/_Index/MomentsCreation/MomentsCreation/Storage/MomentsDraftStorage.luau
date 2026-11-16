local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")

local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

require(parent.MomentsTypes)
local MomentsDraftSerializer = require(MomentsCreation.Utils.MomentsDraftSerializer)
local getLocalUserId = require(MomentsCreation.Utils.getLocalUserId)
local FailureReason = require(MomentsCreation.Enums.FailureReason)

local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new("Moments.DraftStorage")

local v2 = game:DefineFastInt("MomentDraftTTLDays", 14) * 24 * 60 * 60 * 1000
local MomentsDraftStorage = {}

function MomentsDraftStorage.save(data)
	local localUserId = getLocalUserId(Players)

	if localUserId == nil then
		v:debug("event=save_skipped reason=no_local_player")
		return false
	end

	local v3 = {
		userId = localUserId,
		captureRef = data.captureRef,
		description = data.description,
		commentsEnabled = data.commentsEnabled,
		edits = data.edits,
		lastSaveTime = DateTime.now().UnixTimestampMillis
	}

	local success, result = pcall(function()
		AppStorageService:SetItem("MomentsDraftStorage", HttpService:JSONEncode((MomentsDraftSerializer.serialize(v3))))
		AppStorageService:Flush()
	end)

	if not success then
		v:error("event=save_failed reason=app_storage_write_error error={}", (tostring(result)))
	end

	return success
end

function MomentsDraftStorage.load()
	local localUserId = getLocalUserId(Players)

	if localUserId == nil then
		v:debug("event=load_failed reason=no_local_player")
		return nil, nil
	end

	local success, result = pcall(function()
		return AppStorageService:GetItem("MomentsDraftStorage")
	end)

	if not success then
		v:debug("event=load_failed reason=app_storage_read_error")
		return nil, nil
	end

	if result == nil or result == "" then
		return nil, nil
	end

	local success2, result2 = pcall(function()
		return HttpService:JSONDecode(result)
	end)

	local function fn()
		AppStorageService:SetItem("MomentsDraftStorage", "")
		AppStorageService:Flush()
	end

	if not success2 or type(result2) ~= "table" then
		pcall(fn)

		return nil, FailureReason.CorruptShape
	end

	local deserialized = MomentsDraftSerializer.deserialize(result2)

	if deserialized == nil then
		pcall(fn)

		return nil, FailureReason.CorruptShape
	end

	if deserialized.userId ~= localUserId then
		pcall(fn)

		return nil, FailureReason.WrongUser
	end

	if v2 < DateTime.now().UnixTimestampMillis - deserialized.lastSaveTime then
		pcall(fn)

		return nil, FailureReason.ExpiredDraft
	end

	return deserialized, nil
end

function MomentsDraftStorage.clear()
	pcall(function()
		AppStorageService:SetItem("MomentsDraftStorage", "")
		AppStorageService:Flush()
	end)
end

return MomentsDraftStorage
