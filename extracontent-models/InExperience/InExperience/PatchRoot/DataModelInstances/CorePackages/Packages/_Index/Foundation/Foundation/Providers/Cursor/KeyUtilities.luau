local Foundation = script:FindFirstAncestor("Foundation")

local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local CursorType = require(Foundation.Enums.CursorType)

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

local function encodeCursorTypeKey(p, p2) -- 2 equivalent calls inferred from this helper
	return p .. " " .. (p2 or ColorNamespace.Color)
end

local function migrateCursorType(value) -- 1 equivalent call inferred from this helper
	local v = tostring(value)
	return CursorType[string.gsub(v, v:find("Kind") and "CursorKind%." or "CursorType%.", "")]
end

local KeyUtilities = {}

function KeyUtilities.encodeKey(p, udim: UDim?, p2: number?, p3: number?, p4)
	local v = udim or UDim.new(0, 0)
	local thicker = p.Stroke.Thicker
	local v2 = p3 or thicker
	local v3 = (p2 or p.Size.Size_150) - v2
	local v4 = p4 or ColorNamespace.Color

	return v.Scale .. " " .. v.Offset .. " " .. v3 .. " " .. v2 .. " " .. v4
end

function KeyUtilities.decodeKey(value)
	if typeof(value) == "string" then
		value = string.split(value, " ")
	end

	local v = tonumber(value[1])
	local v2 = tonumber(value[2])
	local v3 = tonumber(value[3])
	local v4 = tonumber(value[4])
	local v5 = value[5]

	return UDim.new(v, (math.max(0, v2 + v3))), v3, v4, v5
end

KeyUtilities.encodeCursorTypeKey = encodeCursorTypeKey

function KeyUtilities.decodeCursorTypeKey(value)
	if typeof(value) == "string" then
		value = string.split(value, " ")
	end

	return value[1], value[2]
end

KeyUtilities.migrateCursorType = migrateCursorType

function KeyUtilities.mapCursorToKey(value, p)
	if typeof(value) == "table" then
		local radius = value.radius
		local offset = value.offset
		local borderWidth = value.borderWidth
		local v = radius or UDim.new(0, 0)
		local thicker = p.Stroke.Thicker
		local v2 = borderWidth or thicker
		local v3 = (offset or p.Size.Size_150) - v2
		local color = ColorNamespace.Color

		return v.Scale .. " " .. v.Offset .. " " .. v3 .. " " .. v2 .. " " .. color
	elseif value == nil then
		local udim = UDim.new(0, 0)
		local thicker = p.Stroke.Thicker

		local v = p.Size.Size_150 - thicker
		local color = ColorNamespace.Color

		return udim.Scale .. " " .. udim.Offset .. " " .. v .. " " .. thicker .. " " .. color
	else
		if typeof(value) ~= "userdata" then
			return encodeCursorTypeKey(value) -- inferred equivalent call
		end

		return encodeCursorTypeKey(migrateCursorType(value), nil) -- inferred equivalent call
	end
end

return KeyUtilities
