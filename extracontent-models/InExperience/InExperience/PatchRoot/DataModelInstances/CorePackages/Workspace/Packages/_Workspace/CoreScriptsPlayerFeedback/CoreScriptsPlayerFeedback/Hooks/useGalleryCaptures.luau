local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)

require(CoreScriptsPlayerFeedback.CaptureTypes)
local fetchGalleryCaptures = require(CoreScriptsPlayerFeedback.Utils.fetchGalleryCaptures)

local function useGalleryCaptures()
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(false)
	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef({})
	local state3, setState3 = React.useState(true)

	local v = React.useCallback(function()
		local current = ref3.current

		if #current == 0 then
			return
		end

		local v = {}

		for i = 1, math.min(30, #current) do
			table.insert(v, current[i])
		end

		local current2 = {}

		for i = 31, #current do
			table.insert(current2, current[i])
		end

		ref3.current = current2
		setState(function(p)
			local clone = table.clone(p)

			for _, v2 in v do
				table.insert(clone, v2)
			end

			return clone
		end)
	end, {})

	local v2 = React.useCallback(function()
		local current = ref2.current

		if current == nil or current.IsFinished then
			setState3(false)
			setState2(false)
		else
			setState2(true)
			task.spawn(function()
				local gameId = game.GameId

				while #ref3.current == 0 do
					if pcall(function()
						current:AdvanceToNextPageAsync()
					end) then
						local currentPage = current:GetCurrentPage()

						for _, v2 in currentPage do
							if gameId == 0 or v2.SourceUniverseId == gameId then
								table.insert(ref3.current, v2)
							end
						end

						if current.IsFinished then
							break
						end
					else
						setState2(false)
						setState3(false)
						return
					end
				end

				v()
				setState3(#ref3.current > 0 or not current.IsFinished)
				setState2(false)
			end)
		end
	end, { v })

	return {
		captures = state,
		isLoading = state2,
		hasMore = state3,
		load = React.useCallback(function()
			if ref.current or state2 then
				return
			end

			ref.current = true
			setState2(true)
			task.spawn(function()
				local current = fetchGalleryCaptures()

				if current == nil then
					setState2(false)
					setState3(false)
				else
					ref2.current = current
					local gameId = game.GameId

					while true do
						local currentPage = current:GetCurrentPage()

						for _, v3 in currentPage do
							if gameId == 0 or v3.SourceUniverseId == gameId then
								table.insert(ref3.current, v3)
							end
						end

						if #ref3.current >= 30 or current.IsFinished or not pcall(function()
							current:AdvanceToNextPageAsync()
						end) then
							v()
							setState3(#ref3.current > 0 or not current.IsFinished)
							setState2(false)
							return
						end
					end
				end
			end)
		end, { state2, v }),
		loadMore = React.useCallback(function()
			if state2 then
				return
			end

			if not (#ref3.current > 0) then
				v2()
				return
			end

			v()
			local current = ref2.current
			local v3

			if #ref3.current > 0 then
				v3 = true
			elseif current == nil then
				v3 = false
			else
				v3 = not current.IsFinished
			end

			setState3(v3)
		end, { state2, v, v2 })
	}
end

return useGalleryCaptures
