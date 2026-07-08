require(script.Parent.Parent.Parent.Parent.Parent.proto)
require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

return {
	HydrationStreamMode = ({
		HydrationStreamMode = {
			fromNumber = function(n1: number) -- line: 23
				if n1 == 0 then
					return "HYDRATION_STREAM_MODE_INVALID"
				end

				if n1 == 1 then
					return "HYDRATION_STREAM_MODE_SINGLE"
				end

				if n1 == 2 then
					return "HYDRATION_STREAM_MODE_STRUCTURE_THEN_HYDRATION"
				end

				if n1 == 3 then
					return "HYDRATION_STREAM_MODE_ABOVE_FOLD"
				end

				return nil
			end,
			toNumber = function(p1) -- line: 37
				if p1 == "HYDRATION_STREAM_MODE_INVALID" then
					return 0
				end

				if p1 == "HYDRATION_STREAM_MODE_SINGLE" then
					return 1
				end

				if p1 == "HYDRATION_STREAM_MODE_STRUCTURE_THEN_HYDRATION" then
					return 2
				end

				if p1 == "HYDRATION_STREAM_MODE_ABOVE_FOLD" then
					return 3
				end

				return p1
			end,
			fromName = function(s1: string) -- line: 51
				if s1 == "HYDRATION_STREAM_MODE_INVALID" then
					return "HYDRATION_STREAM_MODE_INVALID"
				end

				if s1 == "HYDRATION_STREAM_MODE_SINGLE" then
					return "HYDRATION_STREAM_MODE_SINGLE"
				end

				if s1 == "HYDRATION_STREAM_MODE_STRUCTURE_THEN_HYDRATION" then
					return "HYDRATION_STREAM_MODE_STRUCTURE_THEN_HYDRATION"
				end

				if s1 == "HYDRATION_STREAM_MODE_ABOVE_FOLD" then
					return "HYDRATION_STREAM_MODE_ABOVE_FOLD"
				end

				return nil
			end
		}
	}).HydrationStreamMode
}
