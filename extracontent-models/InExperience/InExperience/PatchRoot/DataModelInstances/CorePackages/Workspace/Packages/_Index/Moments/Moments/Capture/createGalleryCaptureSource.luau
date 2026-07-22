local Parent = script:FindFirstAncestor("Moments").Parent
local SharedFlags = require(Parent.SharedFlags)
local Signals = require(Parent.Signals)
local FFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector

local function isCaptureEligible(p1) -- line: 45
	if p1.CaptureType == Enum.CaptureType.Video and (p1.TimeLength ~= nil and p1.TimeLength < 1) then
		return false
	end

	return true
end
local function createGalleryCaptureSource(t1: {[any]: any}?, p2: ((...any) -> ...any)?, t2: {[any]: any}?) -- line: 60
	-- upvalues: Signals (copy), FFlagMyStatsMediaSelector (copy)
	local v11 = t1 or game:GetService("CaptureService")
	local v12 = t2 or {}
	local v13, v14 = Signals.createSignal({})
	local v15, v16 = Signals.createSignal(false)
	local u17 = nil

	local function appendCurrentPage() -- line: 76
		-- upvalues: v13 (copy), u17 (ref), v14 (copy), v16 (copy)
		local v20 = table.clone(v13(false))

		for _, v22 in u17:GetCurrentPage() do
			if v22.CaptureType ~= Enum.CaptureType.Video or (v22.TimeLength == nil or not (v22.TimeLength < 1)) then
				table.insert(v20, v22)
			end
		end

		v14(v20)
		v16(u17.IsFinished == true)
	end
	local function fetchInitial() -- line: 87
		-- upvalues: v11 (copy), FFlagMyStatsMediaSelector (copy), v12 (copy), u17 (ref), v16 (copy), p2 (copy), appendCurrentPage (copy), v13 (copy)
		task.spawn(function() -- line: 88
			-- upvalues: v11 (copy), FFlagMyStatsMediaSelector (copy), v12 (copy), u17 (ref), v16 (copy), p2 (copy), appendCurrentPage (copy), v13 (copy)
			local ok, result = pcall(function() -- line: 89
				-- upvalues: v11 (copy), FFlagMyStatsMediaSelector (copy), v12 (copy), u17 (ref)
				local v29, v30 = v11:ReadCapturesFromGalleryAsync(if not FFlagMyStatsMediaSelector then {} else v12, true)

				u17 = v30

				return v29
			end)

			if not ok or (u17 == nil or result ~= Enum.ReadCapturesFromGalleryResult.Success) then
				u17 = nil
				v16(true)

				if p2 ~= nil then
					p2({}, false)
				end

				return
			end

			appendCurrentPage()

			if p2 ~= nil then
				p2(v13(false), true)
			end
		end)
	end

	task.spawn(function() -- line: 88
		-- upvalues: v11 (copy), FFlagMyStatsMediaSelector (copy), v12 (copy), u17 (ref), v16 (copy), p2 (copy), appendCurrentPage (copy), v13 (copy)
		local ok, result = pcall(function() -- line: 89
			-- upvalues: v11 (copy), FFlagMyStatsMediaSelector (copy), v12 (copy), u17 (ref)
			local v27, v28 = v11:ReadCapturesFromGalleryAsync(if not FFlagMyStatsMediaSelector then {} else v12, true)

			u17 = v28

			return v27
		end)

		if not ok or (u17 == nil or result ~= Enum.ReadCapturesFromGalleryResult.Success) then
			u17 = nil
			v16(true)

			if p2 ~= nil then
				p2({}, false)
			end

			return
		end

		appendCurrentPage()

		if p2 ~= nil then
			p2(v13(false), true)
		end
	end)

	return {
		getCaptures = v13,
		getIsFinished = v15,
		fetchMore = function() -- line: 111
			-- upvalues: u17 (ref), appendCurrentPage (copy)
			if u17 == nil or u17.IsFinished == true then
				return
			end

			task.spawn(function() -- line: 115
				-- upvalues: u17 (ref), appendCurrentPage (copy)
				if not pcall(function() -- line: 116
					-- upvalues: u17 (ref)
					u17:AdvanceToNextPageAsync()
				end) then
					return
				end

				appendCurrentPage()
			end)
		end
	}
end

return createGalleryCaptureSource
