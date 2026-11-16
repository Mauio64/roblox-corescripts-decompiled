local parent = script.Parent.Parent.Parent
local Constants = require(parent.App.Style.Constants)

local family = Font.fromEnum(Enum.Font.Cartoon).Family
local ComicNeueFontFamily = Constants.ComicNeueFontFamily

local function getFaceKey(data) -- 2 equivalent calls inferred from this helper
	return `{data.Family}|{data.Weight.Value}|{data.Style.Value}`
end

local v = {}

for _, v2 in Enum.Font:GetEnumItems() do
	if v2 == Enum.Font.Unknown then
		continue
	end

	local success, result = pcall(Font.fromEnum, v2)

	if success then
		v[getFaceKey(result)] = v2 -- inferred equivalent call
	end
end

local function getBuilderSansFallback(weight)
	if weight.Value >= Enum.FontWeight.ExtraBold.Value then
		return Enum.Font.BuilderSansExtraBold
	end

	if weight.Value >= Enum.FontWeight.SemiBold.Value then
		return Enum.Font.BuilderSansBold
	end

	if weight.Value >= Enum.FontWeight.Medium.Value then
		return Enum.Font.BuilderSansMedium
	end

	return Enum.Font.BuilderSans
end

local function getComicNeueFallback(data) -- 1 equivalent call inferred from this helper
	if data.Family == ComicNeueFontFamily or data.Family == family then
		return Enum.Font.Cartoon
	end

	return nil
end

local function getLegacyFont(data)
	if typeof(data) == "EnumItem" then
		if data == Enum.Font.Unknown then
			return nil, false
		end

		return data, false
	else
		local v2 = v[getFaceKey(data)] -- inferred equivalent call

		if v2 then
			return v2, false
		end

		local comicNeueFallback = getComicNeueFallback(data) -- inferred equivalent call

		if comicNeueFallback then
			return comicNeueFallback, true
		end

		return getBuilderSansFallback(data.Weight), true
	end
end

return getLegacyFont
