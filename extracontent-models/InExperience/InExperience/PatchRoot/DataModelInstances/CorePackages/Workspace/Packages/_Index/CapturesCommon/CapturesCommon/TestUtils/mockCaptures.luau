local parent = script.Parent.Parent
local parent2 = parent.Parent

local Dash = require(parent2.Dash)

local CaptureType = require(parent.Enums.CaptureType)
require(parent.Types)

local v = {
	{
		contentId = "rbxasset://textures/AvatarEditorImages/AvatarEditor.png",
		filePath = "c://some/path/to/2231221_1818_1234598400000.png",
		type = CaptureType.Screenshot
	},
	{
		contentId = "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png",
		filePath = "c://some/path/to/2231221_14375697_1653030000000.png",
		type = CaptureType.Screenshot
	}
}
local v2 = {
	{
		CaptureType = Enum.CaptureType.Screenshot,
		SourceUniverseId = 1,
		SourcePlaceId = 1,
		LocalId = "123",
		CaptureTime = DateTime.fromUnixTimestampMillis(1653030000000)
	},
	{
		CaptureType = Enum.CaptureType.Video,
		SourceUniverseId = 2,
		SourcePlaceId = 2,
		LocalId = "321",
		CaptureTime = DateTime.fromUnixTimestampMillis(1653030000000),
		TimeLength = 10
	}
}

return function(p: number, flag: boolean?)
	local result = {}

	if flag then
		for i = 1, p do
			table.insert(result, (Dash.joinDeep(v2[i % #v2 + 1], {})))
		end
	else
		for i = 1, p do
			local joinDeep = Dash.joinDeep(v[i % #v + 1], {})
			local v3 = string.sub(joinDeep.contentId, 21)
			joinDeep.contentId = "rbxasset://textures/" .. ("/./"):rep((math.floor(i / #v))) .. v3
			table.insert(result, joinDeep)
		end
	end

	return result
end
