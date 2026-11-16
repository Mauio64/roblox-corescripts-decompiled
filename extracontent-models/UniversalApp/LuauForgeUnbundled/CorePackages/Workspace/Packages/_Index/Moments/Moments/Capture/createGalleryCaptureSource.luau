local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local FFlagMomentsCreationEntryOutcome = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCreationEntryOutcome")

local fFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector

local function isCaptureEligible(p2): boolean
	return p2.CaptureType ~= Enum.CaptureType.Video or p2.TimeLength == nil or not (p2.TimeLength < 1)
end

local function createGalleryCaptureSource(p2, callback, options)
	local v5 = p2 or game:GetService("CaptureService")
	local v6 = options or {}

	local signal, v7 = Signals.createSignal({})
	local signal2, v8 = Signals.createSignal(false)

	local v9 = nil

	local function appendCurrentPage()
		local clone = table.clone(signal(false))

		for k, v10 in v9:GetCurrentPage() do
			if
				v10.CaptureType ~= Enum.CaptureType.Video
				or v10.TimeLength == nil
				or not (v10.TimeLength < 1)
			then
				table.insert(clone, v10)
			end
		end

		v7(clone)
		v8(v9.IsFinished == true)
	end

	local function fetchInitial()
		task.spawn(function()
			local success, result = pcall(function()
				local capturesFromGalleryAsync, v10 = v5:ReadCapturesFromGalleryAsync(
					not fFlagMyStatsMediaSelector and {} or v6,
					true
				)
				v9 = v10
				return capturesFromGalleryAsync
			end)

			if success and v9 ~= nil and result == Enum.ReadCapturesFromGalleryResult.Success then
				appendCurrentPage()

				if callback ~= nil then
					callback(signal(false), true)
				end
			else
				v9 = nil
				v8(true)

				if callback ~= nil then
					callback(
						{},
						false,
						FFlagMomentsCreationEntryOutcome and (success and result == Enum.ReadCapturesFromGalleryResult.NeedPermission and "permission_denied" or "read_error") or nil
					)
				end
			end
		end)
	end

	local function fetchMore()
		if v9 == nil or v9.IsFinished == true then
			return
		end

		task.spawn(function()
			if not pcall(function()
				v9:AdvanceToNextPageAsync()
			end) then
				return
			end

			appendCurrentPage()
		end)
	end

	task.spawn(function()
		local success, result = pcall(function()
			local capturesFromGalleryAsync, v10 = v5:ReadCapturesFromGalleryAsync(
				not fFlagMyStatsMediaSelector and {} or v6,
				true
			)
			v9 = v10
			return capturesFromGalleryAsync
		end)

		if success and v9 ~= nil and result == Enum.ReadCapturesFromGalleryResult.Success then
			appendCurrentPage()

			if callback ~= nil then
				callback(signal(false), true)
			end
		else
			v9 = nil
			v8(true)

			if callback ~= nil then
				callback(
					{},
					false,
					FFlagMomentsCreationEntryOutcome and (success and result == Enum.ReadCapturesFromGalleryResult.NeedPermission and "permission_denied" or "read_error") or nil
				)
			end
		end
	end)

	return { getCaptures = signal, getIsFinished = signal2, fetchMore = fetchMore }
end

return createGalleryCaptureSource
