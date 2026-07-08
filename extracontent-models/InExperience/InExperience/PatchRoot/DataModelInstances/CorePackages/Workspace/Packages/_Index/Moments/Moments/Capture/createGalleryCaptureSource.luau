local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)

local function isCaptureEligible(p1) -- line: 38
	if p1.CaptureType == Enum.CaptureType.Video and (p1.TimeLength ~= nil and p1.TimeLength < 1) then
		return false
	end

	return true
end
local function createGalleryCaptureSource(t1: {[any]: any}?, p2: ((...any) -> ...any)?) -- line: 53
	-- upvalues: Signals (copy)
	local v8 = t1 or game:GetService("CaptureService")
	local v9, v10 = Signals.createSignal({})
	local v11, v12 = Signals.createSignal(false)
	local u13 = nil

	local function appendCurrentPage() -- line: 67
		-- upvalues: v9 (copy), u13 (ref), v10 (copy), v12 (copy)
		local v16 = table.clone(v9(false))

		for _, v18 in u13:GetCurrentPage() do
			if v18.CaptureType ~= Enum.CaptureType.Video or (v18.TimeLength == nil or not (v18.TimeLength < 1)) then
				table.insert(v16, v18)
			end
		end

		v10(v16)
		v12(u13.IsFinished == true)
	end
	local function fetchInitial() -- line: 78
		-- upvalues: v8 (copy), u13 (ref), v12 (copy), p2 (copy), appendCurrentPage (copy), v9 (copy)
		task.spawn(function() -- line: 79
			-- upvalues: v8 (copy), u13 (ref), v12 (copy), p2 (copy), appendCurrentPage (copy), v9 (copy)
			local ok, result = pcall(function() -- line: 80
				-- upvalues: v8 (copy), u13 (ref)
				local v25, v26 = v8:ReadCapturesFromGalleryAsync({}, true)

				u13 = v26

				return v25
			end)

			if not ok or (u13 == nil or result ~= Enum.ReadCapturesFromGalleryResult.Success) then
				u13 = nil
				v12(true)

				if p2 ~= nil then
					p2({}, false)
				end

				return
			end

			appendCurrentPage()

			if p2 ~= nil then
				p2(v9(false), true)
			end
		end)
	end

	task.spawn(function() -- line: 79
		-- upvalues: v8 (copy), u13 (ref), v12 (copy), p2 (copy), appendCurrentPage (copy), v9 (copy)
		local ok, result = pcall(function() -- line: 80
			-- upvalues: v8 (copy), u13 (ref)
			local v23, v24 = v8:ReadCapturesFromGalleryAsync({}, true)

			u13 = v24

			return v23
		end)

		if not ok or (u13 == nil or result ~= Enum.ReadCapturesFromGalleryResult.Success) then
			u13 = nil
			v12(true)

			if p2 ~= nil then
				p2({}, false)
			end

			return
		end

		appendCurrentPage()

		if p2 ~= nil then
			p2(v9(false), true)
		end
	end)

	return {
		getCaptures = v9,
		getIsFinished = v11,
		fetchMore = function() -- line: 101
			-- upvalues: u13 (ref), appendCurrentPage (copy)
			if u13 == nil or u13.IsFinished == true then
				return
			end

			task.spawn(function() -- line: 105
				-- upvalues: u13 (ref), appendCurrentPage (copy)
				if not pcall(function() -- line: 106
					-- upvalues: u13 (ref)
					u13:AdvanceToNextPageAsync()
				end) then
					return
				end

				appendCurrentPage()
			end)
		end
	}
end

return createGalleryCaptureSource
