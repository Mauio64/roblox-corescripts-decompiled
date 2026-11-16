local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)

local FFlagMomentsCreationEntryOutcome = require(Moments.Flags.FFlagMomentsCreationEntryOutcome)

local FFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector

local function isCaptureEligible(p): boolean -- 1 equivalent call inferred from this helper
	return p.CaptureType ~= Enum.CaptureType.Video or p.TimeLength == nil or not (p.TimeLength < 1)
end

local function createGalleryCaptureSource(p, callback, options)
	local v = p or game:GetService("CaptureService")
	local v2 = options or {}

	local signal, v3 = Signals.createSignal({})
	local signal2, v4 = Signals.createSignal(false)

	local v5 = nil

	local function appendCurrentPage()
		local clone = table.clone(signal(false))

		for _, v6 in v5:GetCurrentPage() do
			if isCaptureEligible(v6) then -- inferred equivalent call
				table.insert(clone, v6)
			end
		end

		v3(clone)
		v4(v5.IsFinished == true)
	end

	local function fetchInitial() -- 1 equivalent call inferred from this helper
		task.spawn(function()
			local success, result = pcall(function()
				local capturesFromGalleryAsync, v6 = v:ReadCapturesFromGalleryAsync(
					not FFlagMyStatsMediaSelector and {} or v2,
					true
				)
				v5 = v6
				return capturesFromGalleryAsync
			end)

			if success and v5 ~= nil and result == Enum.ReadCapturesFromGalleryResult.Success then
				appendCurrentPage()

				if callback ~= nil then
					callback(signal(false), true)
				end
			else
				v5 = nil
				v4(true)

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
		if v5 == nil or v5.IsFinished == true then
			return
		end

		task.spawn(function()
			if not pcall(function()
				v5:AdvanceToNextPageAsync()
			end) then
				return
			end

			appendCurrentPage()
		end)
	end

	fetchInitial() -- inferred equivalent call
	return { getCaptures = signal, getIsFinished = signal2, fetchMore = fetchMore }
end

return createGalleryCaptureSource
