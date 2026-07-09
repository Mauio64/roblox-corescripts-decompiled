local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Dash = require(ParentParentParent.Dash)
local CaptureType = require(ParentParent.Enums.CaptureType)

require(ParentParent.Types)

local t1 = {
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
local t2 = {
	{
		SourceUniverseId = 1,
		SourcePlaceId = 1,
		LocalId = "123",
		CaptureType = Enum.CaptureType.Screenshot,
		CaptureTime = DateTime.fromUnixTimestampMillis(1653030000000)
	},
	{
		SourceUniverseId = 2,
		SourcePlaceId = 2,
		LocalId = "321",
		TimeLength = 10,
		CaptureType = Enum.CaptureType.Video,
		CaptureTime = DateTime.fromUnixTimestampMillis(1653030000000)
	}
}

return function(n1: number, b1: boolean?) -- line: 52
	-- upvalues: Dash (copy), t2 (copy), t1 (copy)
	local t3 = {}

	if b1 then
		for i = 1, n1 do
			table.insert(t3, (Dash.joinDeep(t2[i % #t2 + 1], {})))
		end

		return t3
	end

	for i = 1, n1 do
		local v12 = Dash.joinDeep(t1[i % #t1 + 1], {})
		local v13 = string.sub(v12.contentId, 21)

		v12.contentId = "rbxasset://textures/" .. ("/./"):rep((math.floor(i / #t1))) .. v13
		table.insert(t3, v12)
	end

	return t3
end
