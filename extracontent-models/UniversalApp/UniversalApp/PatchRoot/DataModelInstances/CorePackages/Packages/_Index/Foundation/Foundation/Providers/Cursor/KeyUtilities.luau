local Foundation = script:FindFirstAncestor("Foundation")
local ColorMode = require(Foundation.Enums.ColorMode)
local CursorType = require(Foundation.Enums.CursorType)

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

return {
	encodeKey = function(p1, uDim: UDim?, n1: number?, n2: number?, p2) -- line: 11
		-- upvalues: ColorMode (copy)
		local v9 = uDim or UDim.new(0, 0)
		local Thicker = p1.Stroke.Thicker
		local v11 = n2 or Thicker
		local v12 = (n1 or p1.Size.Size_150) - v11
		local v13 = p2 or ColorMode.Color

		return v9.Scale .. " " .. v9.Offset .. " " .. v12 .. " " .. v11 .. " " .. v13
	end,
	decodeKey = function(p3) -- line: 27
		local v15 = if typeof(p3) ~= "string" then p3 else string.split(p3, " ")
		local num = tonumber(v15[1])
		local num2 = tonumber(v15[2])
		local num3 = tonumber(v15[3])
		local num4 = tonumber(v15[4])
		local v20 = v15[5]

		return UDim.new(num, (math.max(0, num2 + num3))), num3, num4, v20
	end,
	encodeCursorTypeKey = function(p4, p5) -- line: 40
		-- upvalues: ColorMode (copy)
		return p4 .. " " .. (p5 or ColorMode.Color)
	end,
	decodeCursorTypeKey = function(p6) -- line: 45
		local v24 = if typeof(p6) ~= "string" then p6 else string.split(p6, " ")

		return v24[1], v24[2]
	end,
	migrateCursorType = function(p7) -- line: 52
		-- upvalues: CursorType (copy)
		local str = tostring(p7)

		return CursorType[string.gsub(str, not str:find("Kind") and "CursorType%." or "CursorKind%.", "")]
	end,
	mapCursorToKey = function(p8, p9) -- line: 58
		-- upvalues: ColorMode (copy), CursorType (copy)
		if typeof(p8) == "table" then
			local radius = p8.radius
			local offset = p8.offset
			local borderWidth = p8.borderWidth
			local v32 = radius or UDim.new(0, 0)
			local Thicker = p9.Stroke.Thicker
			local v34 = borderWidth or Thicker
			local v35 = (offset or p9.Size.Size_150) - v34
			local ColorModeColor = ColorMode.Color

			return v32.Scale .. " " .. v32.Offset .. " " .. v35 .. " " .. v34 .. " " .. ColorModeColor
		end

		if p8 == nil then
			local uDim = UDim.new(0, 0)
			local Thicker = p9.Stroke.Thicker
			local v39 = p9.Size.Size_150 - Thicker
			local ColorModeColor = ColorMode.Color

			return uDim.Scale .. " " .. uDim.Offset .. " " .. v39 .. " " .. Thicker .. " " .. ColorModeColor
		end

		if typeof(p8) == "userdata" then
			local str = tostring(p8)

			return CursorType[string.gsub(str, not str:find("Kind") and "CursorType%." or "CursorKind%.", "")] .. " " .. ColorMode.Color
		end

		return p8 .. " " .. ColorMode.Color
	end
}
