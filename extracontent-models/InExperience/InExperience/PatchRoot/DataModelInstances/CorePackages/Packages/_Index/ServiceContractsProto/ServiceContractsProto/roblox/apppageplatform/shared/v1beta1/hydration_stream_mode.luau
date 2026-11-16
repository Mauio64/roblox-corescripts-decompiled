require(script.Parent.Parent.Parent.Parent.Parent.proto)
require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

v.HydrationStreamMode = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "HYDRATION_STREAM_MODE_INVALID"
		elseif p == 1 then
			return "HYDRATION_STREAM_MODE_SINGLE"
		elseif p == 2 then
			return "HYDRATION_STREAM_MODE_STRUCTURE_THEN_HYDRATION"
		elseif p == 3 then
			return "HYDRATION_STREAM_MODE_ABOVE_FOLD"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "HYDRATION_STREAM_MODE_INVALID" then
			return 0
		elseif p == "HYDRATION_STREAM_MODE_SINGLE" then
			return 1
		elseif p == "HYDRATION_STREAM_MODE_STRUCTURE_THEN_HYDRATION" then
			return 2
		elseif p == "HYDRATION_STREAM_MODE_ABOVE_FOLD" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "HYDRATION_STREAM_MODE_INVALID" then
			return "HYDRATION_STREAM_MODE_INVALID"
		elseif p == "HYDRATION_STREAM_MODE_SINGLE" then
			return "HYDRATION_STREAM_MODE_SINGLE"
		elseif p == "HYDRATION_STREAM_MODE_STRUCTURE_THEN_HYDRATION" then
			return "HYDRATION_STREAM_MODE_STRUCTURE_THEN_HYDRATION"
		elseif p == "HYDRATION_STREAM_MODE_ABOVE_FOLD" then
			return "HYDRATION_STREAM_MODE_ABOVE_FOLD"
		end

		return nil
	end
}

return { HydrationStreamMode = v.HydrationStreamMode }
