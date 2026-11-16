local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local ScrollAlignment = require(ViewRecycler.Core.Enums.ScrollAlignment)

local function getInitialOffset(p: number, p2, callback) -- 3 equivalent calls inferred from this helper
	if p2 == nil or p2 == ScrollAlignment.Start or p == 0 then
		return nil
	end

	return callback(p, p2)
end

local function createInitialScrollPosition()
	local flag = false

	return {
		onDataSourceChange = function(p, p2, callback)
			if flag then
				return nil
			end

			local initialOffset = getInitialOffset(p, p2, callback) -- inferred equivalent call

			if initialOffset ~= nil then
				flag = true
			end

			return initialOffset
		end,
		onDataSourceReplaced = function(p, p2, callback)
			flag = true
			return getInitialOffset(p, p2, callback) or 0 -- inferred equivalent call
		end,
		onViewportChanged = function(p, p2, callback)
			if flag then
				return nil
			end

			local initialOffset = getInitialOffset(p, p2, callback) -- inferred equivalent call

			if initialOffset ~= nil or p2 == nil or p2 == ScrollAlignment.Start then
				flag = true
			end

			return initialOffset
		end
	}
end

return createInitialScrollPosition
